Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0JTT0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:26:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:35067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0JTT0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,356,1283756400"; 
   d="scan'208";a="669249168"
Message-ID: <4CBF4243.4040104@linux.intel.com>
Date: Wed, 20 Oct 2010 12:25:55 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: svaidy@linux.vnet.ibm.com
CC: Andi Kleen <ak@linux.intel.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, peterz@infradead.org,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup pm_idle
 pointer
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com> <4CBDE5AB.4040401@linux.intel.com> <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com> <4CBDEB14.2030304@linux.vnet.ibm.com> <4CBF06D5.7020508@linux.vnet.ibm.com> <4CBF0854.6080903@linux.intel.com> <4CBF0C04.5070705@linux.intel.com> <4CBF12CB.9050604@linux.intel.com> <20101020191941.GA706@dirshya.in.ibm.com>
In-Reply-To: <20101020191941.GA706@dirshya.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/20/2010 12:19 PM, Vaidyanathan Srinivasan wrote:
> * Arjan van de Ven<arj
> I see this RFC as an incremental step to move all idle routine
> registration functionality into the kernel and keep governors and low
> level drivers as modules.  This will allow non x86 archs with just one
> idle routine to keep minimal overhead.  (Though this is becoming very
> rare).

yes pretty much all embedded really has more idle states, esp arm and co

> As stated in the goal the solution should satisfy the following
> requirements:
>
> 4. Minimal overhead for arch with following use cases
>          a) Single compile time defined idle routine, no need for
>             runtime/boot time selection

you ALWAYS have at least 2 idle handling states. The platform idle one 
and the generic busy waiting one.
the later is needed for "I want absolutely 0 latency" cases.

 > Making current cpuidle as default in kernel

not "in the kernel" but "for x86".
You're solving an x86 problem here, right?
(the pm_idle is an x86 only problem. other architectures should be able 
to keep doing what they are doing)
For x86, lets solve it by going to cpuidle period... and if Andi can 
find some bloat in cpuidle, lets see if the fat can be trimmed.

other architectures can either follow, or if they have nothing special 
and only one idle routine, can do whatever they want.

