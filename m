Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab1DZHjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:39:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49029 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758444Ab1DZHjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:39:08 -0400
Date: Tue, 26 Apr 2011 09:38:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110426073847.GB30630@elte.hu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu>
 <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
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


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Mon, 25 Apr 2011, Ingo Molnar wrote:
> 
> > 
> > * Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> > 
> > > [...] The kernel has no business telling users which perf events are 
> > > interesting, or limiting them! [...]
> > 
> > The policy is very simple and common-sense: if a given piece of PMU 
> > functionality is useful enough to be exposed via a raw interface, then
> > it must be useful enough to be generalized as well.
> 
> what does that even mean?  How do you "generalize" a functionality like 
> writing a value to an auxiliary MSR register?

Here are a few examples:

 - the pure act of task switching sometimes involves writing to MSRs. How is it
   generalized? The concept of 'processes/threads' is offered to user-space and
   thus this functionality is generalized - the raw MSRs are not just passed
   through to user-space.

 - a wide range of VMX (virtualization) functionality on Intel CPUs operates via 
   writing special values to specific MSR registers. How is it 'generalized'? A 
   meaningful, structured ABI is provided to user-space in form of the KVM 
   device and associated semantics. The raw MSRs are not just passed through to
   user-space.

 - the ability of CPUs to change frequency is offered via writing special
   values to special MSRs. How is this generalized? The cpufreq subsystem 
   offers a frequency/cpu API and associated abstractions - the raw MSRs are 
   not just passed through to user-space.

 - in the context of perf events we generalize the concept of an 'event' and
   we abstract out common, CPU model neutral CPU hardware concepts like 
   'cycles', 'instructions', 'branches' and a simplified cache hierarchy - and 
   offer those events as generic events to user-space. We do not just pass the 
   raw MSRs through to user-space.

 - [ etc. - a lot of useful CPU functionality is MSR driven, the PMU is nothing
     special there. ]

The kernel development process is in essence an abstraction engine, and if you 
expect something else you'll probably be facing a lot of frustrating episodes 
in the future as well where others try to abstract out meaningful 
generalizations.

Thanks,

	Ingo
