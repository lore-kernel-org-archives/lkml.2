Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0D0HzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:55:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62878 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0D0HzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:55:07 -0400
Message-ID: <4BD69846.8090607@monstr.eu>
Date: Tue, 27 Apr 2010 09:54:46 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: steve@digidescorp.com
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] microblaze: add stack unwinder
References: <1271220928-3502-1-git-send-email-steve@digidescorp.com>	 <4BC5F11C.3080305@monstr.eu> <1272339089.17476.1.camel@iscandar.digidescorp.com>
In-Reply-To: <1272339089.17476.1.camel@iscandar.digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> On Wed, 2010-04-14 at 18:45 +0200, Michal Simek wrote:
>>> diff -uprN a/arch/microblaze/kernel/traps.c
>> b/arch/microblaze/kernel/traps.c
>>> --- a/arch/microblaze/kernel/traps.c  2010-04-09 21:52:36.000000000
>>> +++ b/arch/microblaze/kernel/traps.c  2010-04-12 22:16:01.000000000 
> [snip]
>>>  
>>> -     if (!stack)
>>> -             stack = (unsigned long *)&stack;
>>> +     if (fp == 0) {
>>> +             if (task)
>>> +                     fp = ((struct thread_info *)
>>> +                             (task->stack))->cpu_context.r1;
>>> +             else {
>>> +                     /* Pick up caller of dump_stack() */
>>> +                     fp = (__u32)&sp - 8;
>>> +             }
>>> +     }
>> just coding style.
>>
>>         if (fp == 0)
>>                 if (task)
>>                         fp = ((struct thread_info *)
>>                                 (task->stack))->cpu_context.r1;
>>                 else
>>                         /* Pick up caller of dump_stack() */
>>                         fp = (__u32)&sp - 8;
> 
> Do you feel strongly about this? I try to always use braces on if/else
> clauses that have more than one line. I've found that the extra
> characters are well worth the savings in debugging time when someone
> tries to extend the clause and forgets to add the braces.

It will work. I like brackets too. I agree that can save a lot of time 
with debugging.

I just didn't like that inconsistency in if (task) part.

If is if (task)  { ... } else {...} then I am ok with it if 
checkpatch.pl doesn't report it as warning.


Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
