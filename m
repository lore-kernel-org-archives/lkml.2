Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2DCKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 06:16:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47021 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2DCKQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 06:16:28 -0400
Date: Tue, 3 Apr 2012 12:16:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
Message-ID: <20120403101623.GA16889@gmail.com>
References: <20120402213440.49e9de74@neptune>
 <1333401898.2960.78.camel@laptop>
 <1333403193.2960.80.camel@laptop>
 <20120403060252.GA27084@gmail.com>
 <20120403081735.78ca3bb3@pluto.restena.lu>
 <m1d37pgugy.fsf@fess.ebiederm.org>
 <20120403071543.GA17502@gmail.com>
 <m1r4w5dzjq.fsf@fess.ebiederm.org>
 <20120403080410.GF26826@gmail.com>
 <m1sjgl9ozd.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sjgl9ozd.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ingo Molnar <mingo@kernel.org> writes:
> 
> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> >> > Huh, so put repeated, duplicated, inconsistently applied sanity 
> >> > checks into dozens of sysfs attribute using kernel subsystems?
> >>
> >> [...]
> >>
> >> No.  I was not talking about every usage site.
> >
> > Note, I'm not arguing that this isn't a bug in the P4 PMU driver 
> > - it is clearly a bug and I've applied the fix for it. I'm 
> > arguing about the escallation vector that this bug takes - that 
> > is unnecessarily disruptive:
> >
> > You were talking about:
> >
> >> >> FIX perf to include sanity checks.
> >
> > and what the PMU drivers do here is not uncommon at all, and the 
> > bug (for which I applied the fix and will push to Linus ASAP) is 
> > not uncommon either:
> 
> > Bugs happen and indirections happen too. perf uses a generic 
> > PMU driver layer where the lower level layers register 
> > themselves. There's at least a dozen similar constructs in 
> > the kernel and you suggest that the right solution is to put 
> > checks in every one of them, while the nice patch from Bruno 
> > could catch it too, in one central place?
> 
> What is uncommon is that perf_pmu_register is called from an 
> early initcall, and then later a device_init call is used to 
> register the pmu subsystem with sysfs.

This has no relevance to the bug and crash pattern itself 
whatsoever, so stop blathering about unrelated things.

Not filling out a sysfs object attribute is an *easy* driver 
level mistake, I've seen it happen on numerous occasions. Not 
crashing on it in the sysfs layer is an *obvious* debugging 
helper, and I don't understand why you are even arguing about 
this.

Thanks,

	Ingo
