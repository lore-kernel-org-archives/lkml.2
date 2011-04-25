Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1DYVqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:46:48 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:59190 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1DYVqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:46:47 -0400
Date: Mon, 25 Apr 2011 17:46:22 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
In-Reply-To: <20110425175444.GC28239@elte.hu>
Message-ID: <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org> <1303407662-15564-2-git-send-email-acme@infradead.org> <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu> <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Ingo Molnar wrote:

> 
> * Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> 
> > [...] The kernel has no business telling users which perf events are 
> > interesting, or limiting them! [...]
> 
> The policy is very simple and common-sense: if a given piece of PMU 
> functionality is useful enough to be exposed via a raw interface, then
> it must be useful enough to be generalized as well.

what does that even mean?  How do you "generalize" a functionality like 
writing a value to an auxiliary MSR register?

The PAPI tool was using the perf_events interface in the 2.6.39-git 
kernels to collect offcore response results by properly setting the 
config1 register on Nehalem and Westmere machines.

Now it has been disabled for unclear reasons.

Could you at least have some sort of relevant errno value set in this 
case?  It's a real pain in userspace code to try to sort out the 
perf_event return values to find out if a feature is supported,
unsupported (lack of hardware), unsupported (not implemented yet),
unsupported (disabled due to whim of kernel developer), unsupported
(because you have some sort of configuration conflict).

> > [...]  What is this, windows?
> 
> FYI, this is how the Linux kernel has operated from day 1 on: we support 
> hardware features to abstract useful highlevel functionality out of it.
> I would not expect this to change anytime soon.

I started using Linux because it actually let me use my hardware without 
interfering with what I was trying to do.  Not because it disabled access 
to the hardware due to some perceived lack of generalization in an extra 
unncessary software translation layer.

Vince
vweaver1@eecs.utk.edu
