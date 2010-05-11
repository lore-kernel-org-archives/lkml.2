Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0EKWZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:25:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:33671 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab0EKWZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:25:08 -0400
Subject: Re: [PATCH 05/25] lmb: Factor the lowest level alloc function
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
In-Reply-To: <alpine.LFD.2.00.1005111428470.3401@localhost.localdomain>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-2-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-3-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-4-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-5-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-6-git-send-email-benh@kernel.crashing.org>
	 <alpine.LFD.2.00.1005111428470.3401@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 08:24:09 +1000
Message-ID: <1273616649.21352.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 14:30 +0200, Thomas Gleixner wrote:
> > @@ -396,33 +406,24 @@ u64 __init __lmb_alloc_base(u64 size, u64
> align, u64 max_addr)
> >       if (max_addr == LMB_ALLOC_ANYWHERE)
> >               max_addr = LMB_REAL_LIMIT;
> >  
> > +     /* Pump up max_addr */
> > +     if (max_addr == LMB_ALLOC_ANYWHERE)
> > +             max_addr = ~(u64)0;
> > +     
> 
>   That if is pretty useless as you set max_addr to LMB_REAL_LIMIT
>   right above.

This is a mismerge/mis-rebase of one of my patches actually. I'll dbl
check what's up but I think the first hunk should go along with
LMB_REAL_LIMIT in favor of the new default limit thing. But we first
need to make sure the default is set sensibly and I haven't fixed all
archs yet.

I'll dbl check what's up there.

Cheers,
Benm.


