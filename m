Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1GHT3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 15:29:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51579 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1GHT3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 15:29:18 -0400
Message-ID: <4E175A8B.2040007@zankel.net>
Date: Fri, 08 Jul 2011 12:29:15 -0700
From: Chris Zankel <qvadiz@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH] xtensa: prevent arbitrary read in ptrace
References: <1310083434.2139.4.camel@anubis> <20110708112706.9014d306.akpm@linux-foundation.org> <20110708184250.GA31307@redhat.com>
In-Reply-To: <20110708184250.GA31307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'll try to run a build this weekend and will look if that code builds 
at all.

Thanks,
-Chris


On 7/8/11 11:42 AM, Oleg Nesterov wrote:
> On 07/08, Andrew Morton wrote:
>>
>> On Thu, 07 Jul 2011 20:03:54 -0400
>> Dan Rosenberg<drosenberg@vsecurity.com>  wrote:
>>
>>> Prevent an arbitrary kernel read. Check the user pointer with
>>> access_ok() before copying data in.
>>>
>>> Signed-off-by: Dan Rosenberg<drosenberg@vsecurity.com>
>>> Cc: stable@kernel.org
>>> ---
>>>   arch/xtensa/kernel/ptrace.c |    3 +++
>>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
>>> index c72c947..ddce75e 100644
>>> --- a/arch/xtensa/kernel/ptrace.c
>>> +++ b/arch/xtensa/kernel/ptrace.c
>>> @@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *child, void __user *uregs)
>>>   	elf_xtregs_t *xtregs = uregs;
>>>   	int ret = 0;
>>>
>>> +	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
>>> +		return -EIO;
>>
>> This should be -EFAULT, methinks?
>
> Also, it seems that ptrace_setxregs/ptrace_getxregs could be static?
>
> The patch looks "obviously correct" but I don't understand this code.
>
> Hmm. We don't read/write the XTENSA_HAVE_COPROCESSORS data, but use
> sizeof(elf_xtregs_t) anyway. This looks a bit strange but I guess
> this doesn't matter.
>
> Oleg.
>

