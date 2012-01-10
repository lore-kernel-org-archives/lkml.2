Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab2AJTlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 14:41:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38838 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689Ab2AJTla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 14:41:30 -0500
Date: Tue, 10 Jan 2012 20:41:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
        stable@vger.kernel.org, len.brown@intel.com, anhua.xu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86,sched: Fix sched_smt_power_savings totally broken
Message-ID: <20120110194108.GA28488@elte.hu>
References: <1326099367-4166-1-git-send-email-youquan.song@intel.com>
 <1326103578.2442.50.camel@twins>
 <20120110001445.GA20542@linux-youquan.bj.intel.com>
 <1326107156.2442.59.camel@twins>
 <20120110055856.GA23741@linux-youquan.bj.intel.com>
 <1326153163.2366.7.camel@sbsiddha-mobl2>
 <20120110091805.GA28024@elte.hu>
 <4F0C4BF0.9090809@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0C4BF0.9090809@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> On 1/10/2012 1:18 AM, Ingo Molnar wrote:
> > 
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> >> On Tue, 2012-01-10 at 00:58 -0500, Youquan Song wrote:
> >>> Thanks Peter! Here is the patch. 
> >>
> >> Youquan, As far as I know both the
> >> sched_smt_power_savings/sched_mc_power_savings are broken for atleast an
> >> year.
> > 
> > We want a single knob, sched_power_savings - with the mc_ and 
> > smt_ ones still kept and aliased to sched_power_savings, for 
> > compatibility reasons.
> > 
> > As Peter said, the other reasonable option is to have no knob at 
> > all and restart this code from scratch.
> > 
> > The other thing we should do is to add sane defaults: to turn on 
> > sched_power_savings *AUTOMATICALLY* when a system is obviously 
> > battery driven and turn it off when the system is obviously AC 
> > driven. User-space can still implement policy and override the 
> > kernel's default, but there's absolutely no excuse to not offer 
> > this default ourselves.
> 
> a very good default would be to keep all tasks on one package 
> until half the cores in the package are busy, and then start 
> spreading out.
> 
> I suspect that'll be the 90% case coverage.

Maybe - but there's no reason to connect all the dots within the 
kernel and actually *discover* nd use the very, very likely 
performance preference of the hardware in question.

Like a good resource management system (==kernel) should do.

We can do that with a 99% confidence factor or so - maybe better 
- and leave all the weird cases that the kernel cannot (or 
should not) know about to 'user space policy' knobs.

Thanks,

	Ingo
