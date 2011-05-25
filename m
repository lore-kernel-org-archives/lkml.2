Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1EYK5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 06:57:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:37986 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1EYK5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 06:57:36 -0400
Date: Wed, 25 May 2011 12:57:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yong Zhang <yong.zhang0@gmail.com>
cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] timers: consider slack value in mod_timer()
In-Reply-To: <alpine.LFD.2.02.1105251126590.3078@ionos>
Message-ID: <alpine.LFD.2.02.1105251256270.3078@ionos>
References: <20110521105828.GA29442@Chamillionaire.breakpoint.cc> <BANLkTinGZ0L4oQkBYo9H=R==X5Z+efjRaQ@mail.gmail.com> <20110524121343.GA17312@Chamillionaire.breakpoint.cc> <BANLkTikNSa9otE_cFKRcThUZ5ZCtE7Kyxw@mail.gmail.com>
 <alpine.LFD.2.02.1105251126590.3078@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Thomas Gleixner wrote:
> On Wed, 25 May 2011, Yong Zhang wrote:
>  	} else {
> -		unsigned long now = jiffies;
> +		long delta = expires - jiffies;
> +
> +		if (delta < 256)
> +			return expires;
>  
> -		/* No slack, if already expired else auto slack 0.4% */
> -		if (time_after(expires, now))
> -			expires_limit = expires + (expires - now)/256;
> +		expires_limit = expires + (expires - now)/256;

That should be

+		expires_limit = expires + delta / 256;

of course.

