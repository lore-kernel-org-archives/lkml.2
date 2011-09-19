Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab1ISVqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:46:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54394 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab1ISVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:46:38 -0400
Date: Mon, 19 Sep 2011 23:46:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] posix-timers: move global timer id management to signal_struct v2
Message-ID: <20110919214636.GN7761@one.firstfloor.org>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <alpine.LFD.2.02.1109021104140.2723@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109021104140.2723@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
> >  	.rlim		= INIT_RLIMITS,					\
> >  	.cputimer	= { 						\
> > @@ -46,6 +48,7 @@ extern struct fs_struct init_fs;
> >  	},								\
> >  	.cred_guard_mutex =						\
> >  		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
> > +	.posix_timers_id = IDR_INIT(posix_timer_id),			\
> 
>   sig.posix_timer_id

I don't understand this comment. This is already the signal_struct.
Do you want double nesting?

-Andi
