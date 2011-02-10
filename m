Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1BJWOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:14:51 -0500
Received: from www.tglx.de ([62.245.132.106]:48827 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab1BJWOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:14:50 -0500
Date: Thu, 10 Feb 2011 23:13:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, anton@samba.org,
        Mike Travis <travis@sgi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PULL] cpumask offstack finalization
In-Reply-To: <201102110802.17453.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1102102310491.31804@localhost6.localdomain6>
References: <201102091608.59448.rusty@rustcorp.com.au> <20110210124416.GE26094@elte.hu> <201102110802.17453.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Feb 2011, Rusty Russell wrote:

> On Thu, 10 Feb 2011 11:14:16 pm Ingo Molnar wrote:
> > 
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > 
> > > Hi Ingo,
> > > 
> > >    A few more obsolete uses of cpumask has crept into the tree; all easily
> > > fixed.  This is rebased onto your -tip tree and re-tested; it finally means
> > > that we can detect obsolescent (and hence dangerous) cpumask usage when 
> > > CONFIG_CPUMASK_OFFSTACK=y.  It finally reduces the actual allocation of
> > > cpumask_var_t to the number of cpus we actually have.
> > 
> > Hm, could we get rid of the obsolete percpu APIs once and for all? The fact that 
> > they are still around cause the leakage into new code to begin with.
> 
> Yes; it'll be a fair bit of arch churn, but it can be done in stages easily.
> I thought about marking them all __deprecated but that just annoys people.

Wrong. __deprecated is not annoying enough. See __do_IRQ().  The
__deprecated warning was ignored for years. It might work if it pops
up in every file compiled :)

Thanks,

	tglx

