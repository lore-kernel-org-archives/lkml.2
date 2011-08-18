Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab1HRQX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:23:57 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2120 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab1HRQX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:23:56 -0400
Message-ID: <4E4D3C8D.1040707@cavium.com>
Date: Thu, 18 Aug 2011 09:23:41 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Yong Zhang <yong.zhang@windriver.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: use 32-bit wrapper for compat_sys_futex
References: <1313546094-11882-1-git-send-email-yong.zhang@windriver.com> <4E4BF7C0.80703@cavium.com> <20110818023247.GA3750@windriver.com>
In-Reply-To: <20110818023247.GA3750@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Aug 2011 16:23:55.0628 (UTC) FILETIME=[39C772C0:01CC5DC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 07:32 PM, Yong Zhang wrote:
> On Wed, Aug 17, 2011 at 10:17:52AM -0700, David Daney wrote:
>>> diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
>>> index 46c4763..f48b18e 100644
>>> --- a/arch/mips/kernel/scall64-o32.S
>>> +++ b/arch/mips/kernel/scall64-o32.S
>>> @@ -441,7 +441,7 @@ sys_call_table:
>>>   	PTR	sys_fremovexattr		/* 4235 */
>>>   	PTR	sys_tkill
>>>   	PTR	sys_sendfile64
>>> -	PTR	compat_sys_futex
>>> +	PTR	sys_32_futex
>>
>> This change is redundant, scall64-o32.S already does the right thing
>
> My first virsion(not sent out) doesn't include scall64-o32.S either.
>
>> so additional zero extending is not needed and is just extra
>> instructions to execute for no reason.
>
> Why I'm adding it here is for:
> 1)code consistent, otherwise we must move SYSCALL_DEFINE6(32_futex,...)
>    under CONFIG_MIPS32_N32;

No, you don't have to move it.  Just don't call it.


> 2)I'm afraid there may be some other way to touch the high 32-bit of a
>    register, so touching scall64-o32.S is also for safety(due to unknown
>    reason, fix me if I'm wrong).

OK: You are mistaken.  You claim you don't understand what the code 
does.  That is really a poor justification for modifying it.

David Daney
