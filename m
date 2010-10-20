Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0JTTUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:20:24 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55442 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab0JTTUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:20:23 -0400
Date: Thu, 21 Oct 2010 00:49:41 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, peterz@infradead.org,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup
 pm_idle pointer
Message-ID: <20101020191941.GA706@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com>
 <4CBDE5AB.4040401@linux.intel.com>
 <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com>
 <4CBDEB14.2030304@linux.vnet.ibm.com>
 <4CBF06D5.7020508@linux.vnet.ibm.com>
 <4CBF0854.6080903@linux.intel.com>
 <4CBF0C04.5070705@linux.intel.com>
 <4CBF12CB.9050604@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4CBF12CB.9050604@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@linux.intel.com> [2010-10-20 09:03:23]:

>  On 10/20/2010 8:34 AM, Andi Kleen wrote:
> >
> >>but now you're duplicating this functionality adding code for everyone.
> >>
> >>99.999% of the people today run cpuidle... (especially embedded
> >>x86 where they really care about power)
> >>all x86 going forward also has > 1 idle option anyway.
> >>
> >>and you're adding and extra layer in the middle that just
> >>duplicates the layer that's in use in practice above it.
> >>
> >>seriously, this sounds like the wrong tradeoff to make.
> >
> >I think the right option is still to put cpuidle on a diet.
> >There's no reason an idle handler needs to be that bloated.
> >
> >If it was 2K or so just including it into the core would be fine.
> >
> >Ignoring code size completely is generally a wrong trade off imho.
> 
> I'm not ignoring code size.
> I'm saying that a 7Kb component that everyone on this architecture
> uses in practice versus adding 0.5Kb in ADDITION to that for
> everyone for the theoretical case
> of someone NOT using cpuidle is the wrong tradeoff.

Hi Arjan,

I agree with you that we need not add 0.5K extra code to x86 cpuidle
framework that is in use by most systems.  However, this is only an
intermediate step (RFC) before we move/merge registration parts of
cpuidle into the kernel and leave only the governors as pluggable.

> having it go on a diet? I'm all for it. Killing off the ladder
> governor for example is a step.
> But really. 7Kb. There's lots of lower hanging fruit as well. 7Kb is
> not a reason to make such a bad tradeoff.

I see this RFC as an incremental step to move all idle routine
registration functionality into the kernel and keep governors and low
level drivers as modules.  This will allow non x86 archs with just one
idle routine to keep minimal overhead.  (Though this is becoming very
rare).

As stated in the goal the solution should satisfy the following
requirements:

4. Minimal overhead for arch with following use cases
        a) Single compile time defined idle routine, no need for
           runtime/boot time selection
        b) Single idle routine, but selectable during boot/runtime.
           No need for cpuidle governors
        c) Runtime selection of single or multi-idle routines and
           demand loading/usage of governors to select one among the
           set of idle routines.  (Current x86 model)

Making current cpuidle as default in kernel and make everybody else
register into cpuidle will satisfy (c), but we will need to slim down
the framework and keep parts of it as module to satisfy (b).

I think we agree on the goal, but need some discussion on what should
be the steps to reach the goal with incremental code changes and
without breaking multiple architectures at the same time.

--Vaidy

