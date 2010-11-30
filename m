Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0K3PLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:11:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49204 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab0K3PLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:11:52 -0500
Date: Tue, 30 Nov 2010 16:11:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101130151129.GA5901@elte.hu>
References: <20101128201851.GA20555@elte.hu>
 <1291031593.32004.19.camel@laptop>
 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
 <1291052268.32004.171.camel@laptop>
 <1291057565.20709.2.camel@marge.simson.net>
 <20101129192033.GA18372@elte.hu>
 <1291103647.24405.5.camel@marge.simson.net>
 <20101130141804.GB22588@elte.hu>
 <20101130145323.GA3291@elte.hu>
 <1291129287.32004.880.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291129287.32004.880.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2010-11-30 at 15:53 +0100, Ingo Molnar wrote:
> > another detail is that i needed this fix:
> > 
> > --- linux.orig/init/Kconfig
> > +++ linux/init/Kconfig
> > @@ -790,6 +790,7 @@ endif # NAMESPACES
> >  
> >  config SCHED_AUTOGROUP
> >  	bool "Automatic process group scheduling"
> > +	select EVENTFD
> >  	select CGROUPS
> >  	select CGROUP_SCHED
> >  	select FAIR_GROUP_SCHED
> > 
> > Because CGROUPS depends on eventfd infrastructure.
> 
> Shouldn't then cgroups select that?

It depends on it so selecting it is fine. !EVENTFD is a CONFIG_EMBEDDED-only thing 
anyway.

Thanks,

	Ingo
