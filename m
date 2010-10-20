Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0JTToV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:44:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:45368 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab0JTToU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:44:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,356,1283756400"; 
   d="scan'208";a="849250192"
Message-ID: <4CBF4693.1070802@linux.intel.com>
Date: Wed, 20 Oct 2010 12:44:19 -0700
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
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com> <4CBDE5AB.4040401@linux.intel.com> <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com> <4CBDEB14.2030304@linux.vnet.ibm.com> <4CBF06D5.7020508@linux.vnet.ibm.com> <4CBF0854.6080903@linux.intel.com> <4CBF0C04.5070705@linux.intel.com> <4CBF12CB.9050604@linux.intel.com> <20101020191941.GA706@dirshya.in.ibm.com> <4CBF4243.4040104@linux.intel.com> <20101020194045.GB706@dirshya.in.ibm.com>
In-Reply-To: <20101020194045.GB706@dirshya.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/20/2010 12:40 PM, Vaid
>> you ALWAYS have at least 2 idle handling states. The platform idle
>> one and the generic busy waiting one.
>> the later is needed for "I want absolutely 0 latency" cases.
> Some special overrides like idle=poll should handle this case even if
> cpuidle and related registration mechanism is compiled out. The point
> is that we need some flexibility even if the full framework is not
> included.

this is not idle=poll

this is an (privileged) app or driver, at runtime, requesting a 0 usec 
max latency for a short or long period of time.


>>> Making current cpuidle as default in kernel
>> not "in the kernel" but "for x86".
>> You're solving an x86 problem here, right?
>> (the pm_idle is an x86 only problem. other architectures should be
>> able to keep doing what they are doing)
>> For x86, lets solve it by going to cpuidle period... and if Andi can
>> find some bloat in cpuidle, lets see if the fat can be trimmed.
> Ok, you are suggesting that for x86 lets move cpuidle in kernel
> always, while it can be an optional module for other archs as it
> stands today.  We can slim down the cpuidle from current 7K or atleast
> split some parts like governors as modules if needed.

governors as modules is a total pain. modules don't solve the problem. 
really. it's still code you need.
we have two governors today, menu and ladder
menu is best on anything that is tickless
ladder is useless on any tickless kernel, and likely not better than 
menu on non-tickless.
that's it.
It will be good to have other archs also follow the same cpuidle
> framework and call it from their kernel/idle routines so that we need
> not have a hierarchy of idle routines there.

yes. but we don't have to force that to happen at the exact same time.

