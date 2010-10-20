Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0JTTl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:41:29 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57132 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0JTTl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:41:28 -0400
Date: Thu, 21 Oct 2010 01:10:45 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, peterz@infradead.org,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup
 pm_idle pointer
Message-ID: <20101020194045.GB706@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com>
 <4CBDE5AB.4040401@linux.intel.com>
 <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com>
 <4CBDEB14.2030304@linux.vnet.ibm.com>
 <4CBF06D5.7020508@linux.vnet.ibm.com>
 <4CBF0854.6080903@linux.intel.com>
 <4CBF0C04.5070705@linux.intel.com>
 <4CBF12CB.9050604@linux.intel.com>
 <20101020191941.GA706@dirshya.in.ibm.com>
 <4CBF4243.4040104@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4CBF4243.4040104@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@linux.intel.com> [2010-10-20 12:25:55]:

>  On 10/20/2010 12:19 PM, Vaidyanathan Srinivasan wrote:
> >* Arjan van de Ven<arj
> >I see this RFC as an incremental step to move all idle routine
> >registration functionality into the kernel and keep governors and low
> >level drivers as modules.  This will allow non x86 archs with just one
> >idle routine to keep minimal overhead.  (Though this is becoming very
> >rare).
> 
> yes pretty much all embedded really has more idle states, esp arm and co
> 
> >As stated in the goal the solution should satisfy the following
> >requirements:
> >
> >4. Minimal overhead for arch with following use cases
> >         a) Single compile time defined idle routine, no need for
> >            runtime/boot time selection
> 
> you ALWAYS have at least 2 idle handling states. The platform idle
> one and the generic busy waiting one.
> the later is needed for "I want absolutely 0 latency" cases.

Some special overrides like idle=poll should handle this case even if
cpuidle and related registration mechanism is compiled out. The point
is that we need some flexibility even if the full framework is not
included.

> > Making current cpuidle as default in kernel
> 
> not "in the kernel" but "for x86".
> You're solving an x86 problem here, right?
> (the pm_idle is an x86 only problem. other architectures should be
> able to keep doing what they are doing)
> For x86, lets solve it by going to cpuidle period... and if Andi can
> find some bloat in cpuidle, lets see if the fat can be trimmed.

Ok, you are suggesting that for x86 lets move cpuidle in kernel
always, while it can be an optional module for other archs as it
stands today.  We can slim down the cpuidle from current 7K or atleast
split some parts like governors as modules if needed.

> other architectures can either follow, or if they have nothing
> special and only one idle routine, can do whatever they want.

It will be good to have other archs also follow the same cpuidle
framework and call it from their kernel/idle routines so that we need
not have a hierarchy of idle routines there.

--Vaidy

