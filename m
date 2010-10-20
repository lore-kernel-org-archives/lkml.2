Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab0JTC5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 22:57:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34541 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0JTC5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 22:57:00 -0400
Date: Wed, 20 Oct 2010 04:56:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
Message-ID: <20101020025652.GB26822@elte.hu>
References: <1287479765.9920.9.camel@marge.simson.net>
 <1287487757.24189.40.camel@marge.simson.net>
 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
 <1287511983.7417.45.camel@marge.simson.net>
 <1287514410.7368.10.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287514410.7368.10.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > On Tue, 2010-10-19 at 08:28 -0700, Linus Torvalds wrote:
> > >
> > >  If people compare with a non-CGROUP_SCHED
> > > kernel, will a desktop-optimized kernel suddenly have horrible pipe
> > > latency due to much higher scheduling cost? Right now that whole
> > > feature is hidden by EXPERIMENTAL, I don't know how much it hurts, and
> > > I never timed it when I tried it out long ago..
> 
> Q/D test of kernels w/wo, with same .config using pipe-test (pure sched) gives on 
> my box ~590khz with tty_sched active, 620khz without cgroups acitve in same 
> kernel/config without patch.  last time I measured stripped down config (not long 
> ago, but not yesterday either) gave max ctx rate ~690khz on this box.
> 
> (note: very Q, very D numbers, no variance testing, ballpark)

That's 5% overhead in context switches. Definitely not in the 'horrible' category.

This would be a rather tempting item for 2.6.37 ... especially as it really mainly 
reuses existing group scheduling functionality, in a clever way.

Mind doing more of the tty->desktop renames/generalizations as Linus suggested, and 
resend the patch?

I'd also suggest to move it out of EXPERIMENTAL - we dont really do that for core 
kernel features as most distros enable CONFIG_EXPERIMENTAL so it's a rather 
meaningless distinction. Since the feature is default-n, people will get the old 
scheduler by default but can also choose this desktop-centric scheduling mode.

I'd even argue to make it default-y, because this patch clearly cures a form of 
kbuild cancer.

Thanks,

	Ingo
