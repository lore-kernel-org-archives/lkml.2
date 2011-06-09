Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab1FIOUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:20:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1FIOUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:20:06 -0400
Date: Thu, 9 Jun 2011 16:19:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 3/3] printk: Avoid all wakeups from printk
Message-ID: <20110609141959.GF21100@elte.hu>
References: <20110609130647.937204592@chello.nl>
 <20110609131307.590149293@chello.nl>
 <20110609133228.GB21100@elte.hu>
 <1307626856.3941.80.camel@twins>
 <20110609135542.GD21100@elte.hu>
 <1307628393.3941.87.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307628393.3941.87.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2011-06-09 at 15:55 +0200, Ingo Molnar wrote:
> 
> > > @@ -943,19 +939,14 @@ asmlinkage int vprintk(const char *fmt, 
> > >  		if (*p == '\n')
> > >  			new_text_line = 1;
> > >  	}
> > > +	printk_cpu = UINT_MAX;
> > > +	spin_unlock(&logbuf_lock);
> > 
> > Hm, is that printk_cpu setting inside the critical section safe? What 
> > happens if we get an NMI on this CPU in that window?
> 
> That's what the old code did, also NMI really shouldn't printk(), but
> yeah, can flip those two lines, but in that same vein I should also flip
> the setting of that variable with acquiring the lock.

Flipping it won't be enough - we could override another CPU's 
protection ...

Thanks,

	Ingo
