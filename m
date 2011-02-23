Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1BWPwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:52:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:54263 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab1BWPwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:52:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,212,1297065600"; 
   d="scan'208";a="712272392"
Message-ID: <4D652D42.4040801@linux.intel.com>
Date: Wed, 23 Feb 2011 07:52:34 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        richard.purdie@linuxfoundation.org
Subject: Re: [PATCH 2/2] sched: allow users with rtprio rlimit to change from
 SCHED_IDLE policy
References: <1298408674-3130-1-git-send-email-dvhart@linux.intel.com>	 <1298408674-3130-3-git-send-email-dvhart@linux.intel.com>	 <1298458989.2217.361.camel@twins>  <20110223111354.GB7448@elte.hu> <1298459826.2217.363.camel@twins>
In-Reply-To: <1298459826.2217.363.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 03:17 AM, Peter Zijlstra wrote:
> On Wed, 2011-02-23 at 12:13 +0100, Ingo Molnar wrote:
>> * Peter Zijlstra<peterz@infradead.org>  wrote:
>>
>>> On Tue, 2011-02-22 at 13:04 -0800, Darren Hart wrote:
>>>> As it stands, users with rtprio rlimit permissions can change their policy from
>>>> SCHED_OTHER to SCHED_FIFO and back. They can change to SCHED_IDLE, but not back
>>>> to SCHED_FIFO. If they have the rtprio permission, they should be able to. Once
>>>> in SCHED_FIFO, they could go back to SCHED_OTHER. This patch allows users with
>>>> rtprio permission to change out of SCHED_IDLE.
>>>>
>>>
>>> Ingo, can you remember the rationale for this?
>>>
>>> The fact is that SCHED_IDLE is very near nice-20, and we can do:
>>>
>>> peterz@twins:~$ renice 5 -p $$
>>> 1867: old priority 0, new priority 5
>>> peterz@twins:~$ renice 0 -p $$
>>> 1867: old priority 5, new priority 0
>>>
>>> Which would suggest that we should be able to return to SCHED_OTHER
>>> RLIMIT_NICE-20.
>>
>> I dont remember anything subtle there - most likely we just forgot about that spot
>> when adding RLIMIT_RTPRIO support.
>
> Ah, I was arguing we should allow it regardless of RLIMIT_RTPRIO, based
> on RLIMIT_NICE, it is after all a change to SCHED_OTHER, not
> SCHED_FIFO/RR.

So we need an OR test of RLIMIT_NICE | RLIMIT_RTPRIO ? The reason I keep 
coming back to RTPRIO is it allows the user to change to 
SCHED_(FIFO|RR), and from there they can change to anything they want - 
so why force two steps? Perhaps the argument is to keep the meaning of 
the RLIMITs precise, and if you want to go from IDLE->OTHER you had 
better properly set RLIMIT_NICE - maybe I just convinced myself.

Shall I respin the patch to reflect that?


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
