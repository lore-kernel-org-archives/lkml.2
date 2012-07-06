Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab2GFVEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:04:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18644 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab2GFVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:04:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6764"; a="208156478"
Message-ID: <4FF752DE.7000104@codeaurora.org>
Date: Fri, 06 Jul 2012 14:04:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: smp: Fix suspicious RCU originating from cpu_die()
References: <1341531958-31721-1-git-send-email-sboyd@codeaurora.org> <20120706002404.GJ2522@linux.vnet.ibm.com> <4FF730CD.7050907@codeaurora.org> <20120706203005.GF31508@n2100.arm.linux.org.uk>
In-Reply-To: <20120706203005.GF31508@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/12 13:30, Russell King - ARM Linux wrote:
> On Fri, Jul 06, 2012 at 11:39:09AM -0700, Stephen Boyd wrote:
>> On 07/05/12 17:24, Paul E. McKenney wrote:
>>> On Thu, Jul 05, 2012 at 04:45:58PM -0700, Stephen Boyd wrote:
>>>> @@ -179,7 +184,7 @@ void __ref cpu_die(void)
>>>>  	mb();
>>>>
>>>>  	/* Tell __cpu_die() that this CPU is now safe to dispose of */
>>>> -	complete(&cpu_died);
>>>> +	__this_cpu_write(cpu_state, CPU_DEAD);
>>> Or you could do something like:
>>>
>>> 	RCU_NONIDLE(complete(&cpu_died));
>>>
>>> This would tell RCU that it needed to pay attention to this CPU for
>>> the duration of the "complete()" function call despite the CPU's being
>>> idle.  And might allow you to dispense with the rest of the patch.
>> Great! I like that more since we get to keep the completion mechanism
>> instead of a busy wait.
>>
>> Russell, which one would you prefer? Here's the other version
> I think I prefer the version below.
>

Ok. I put it in the patch tracker.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

