Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab3ADKhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 05:37:10 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58239 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3ADKhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 05:37:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAAYFAvpQxqZPqCipd3UztTi0Hy2qOVkkRTBs3hLivfudXJ5y2Q@mail.gmail.com>
References: <CA+NV+Vnj+P0fbAthKOuJSeJeV8SaTGFYwbbMgc4Bu2Cidh=-0w@mail.gmail.com>
	<CAGdaadYK2P2AKKiu84q0q9E_bJ1wzJxfs203Y0V=EWAETzWk9A@mail.gmail.com>
	<CA+NV+Vn7=nk4jRZNg3nSOLvB7QUfG+WiVt_wjM7hKN7-JfRjhg@mail.gmail.com>
	<CAAYFAvrVEnw6ce0Ck-b4UkpsK=PWRHfacCimmvy2o51nCdJ7gQ@mail.gmail.com>
	<BLU402-EAS4096A6B653D423D295F1FABBC200@phx.gbl>
	<CAAYFAvpQxqZPqCipd3UztTi0Hy2qOVkkRTBs3hLivfudXJ5y2Q@mail.gmail.com>
Date: Fri, 4 Jan 2013 15:59:21 +0530
Message-ID: <CAK7N6vr+Obx7GanssHEc0FL5-xAGDnhXWWHJhWrfpvWEtenMXg@mail.gmail.com>
Subject: Re: What is asmlinkage ?
From: anish singh <anish198519851985@gmail.com>
To: Rajat Sharma <fs.rajat@gmail.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?B?5Y2c5byL5aSp?= <buyit@live.cn>,
        Rahul Bedarkar <rpal143@gmail.com>,
        Mulyadi Santosa <mulyadi.santosa@gmail.com>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 3:41 PM, Rajat Sharma <fs.rajat@gmail.com> wrote:
>> Is this correct for all architectures?
>
> I guess not, asmlinkage is undefined for arm, so I assume this mechanism is
> not there for arm.
then how do they do it?
>
>
>
> On Fri, Jan 4, 2013 at 2:24 PM, 卜弋天 <buyit@live.cn> wrote:
>>
>>
>>
>> 在 2013-1-4，15:38，"Rajat Sharma" <fs.rajat@gmail.com> 写道：
>>
>> > So with asmlinkage we request compiler to put args on stack. What is
>> > advantage of this to start_kernel or in general to other functions ?
>>
>> See its about implementation ease and little of performance too. Assuming
>> the default model of keeping arguments in registers is used. lets say
>> arguments are assumed to be in registers R1, R2, R3, R4, R5, R6 and beyond
>> that in stack. Since system call number is a transparent argument which is
>> chopped off when calling the actual kernel handler and if R1 had the system
>> call number, then you have to shift all register values and stack arguments
>> too.
>>
>>    Is this correct for all architectures?
>>
>>    As I remembered, ARM uses SWI instruction to implement the system call,
>> it will pass system call number by register R7, and use normal register
>> R0~R3 to pass parameters.
>>
>>
>>
>> Now consider that all arguments are pushed on stack (as enforced by
>> asmlinkage), you have all function argument in the beginning of the stack
>> and the system call number on top of the stack. you just need to pop out
>> stack top to remove system call number from function argument.
>>
>> You might argue that why not always keep system call number on stack top
>> and use registers for function arguments? But thats part of the compiler ABI
>> and if you had fewer arguments lets say 2 only and used up R1 and R2 only,
>> you may not jump to stack top directly for storing system call as its turn
>> for R3 as argument.
>>
>> So, isn't it simpler implementation with everything on stack?
>>
>> -Rajat
>>
>>
>> On Fri, Jan 4, 2013 at 12:13 PM, Rahul Bedarkar <rpal143@gmail.com> wrote:
>>>
>>> Thanks. So with asmlinkage we request compiler to put args on stack. What
>>> is advantage of this to start_kernel or in general to other functions ?
>>>
>>> Regards,
>>> Rahul
>>>
>>>
>>> On Thu, Jan 3, 2013 at 9:34 PM, Mulyadi Santosa
>>> <mulyadi.santosa@gmail.com> wrote:
>>>>
>>>> On Thu, Jan 3, 2013 at 7:40 PM, Rahul Bedarkar <rpal143@gmail.com>
>>>> wrote:
>>>> > Hi,
>>>> >
>>>> > I was searching for asmlinkage and found that it is already explained
>>>> > at
>>>> > http://kernelnewbies.org/FAQ/asmlinkage
>>>> >
>>>> > But I didn't get this. Can someone tell me about it in brief ?
>>>>
>>>> the point is, parameters which is usually passed via stack, is passed
>>>> using different way.
>>>>
>>>> A good example is system call.... they are passed using registers IIRC
>>>>
>>>>
>>>> --
>>>> regards,
>>>>
>>>> Mulyadi Santosa
>>>> Freelance Linux trainer and consultant
>>>>
>>>> blog: the-hydra.blogspot.com
>>>> training: mulyaditraining.blogspot.com
>>>
>>>
>>>
>>> _______________________________________________
>>> Kernelnewbies mailing list
>>> Kernelnewbies@kernelnewbies.org
>>> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>>>
>>
>> _______________________________________________
>> Kernelnewbies mailing list
>> Kernelnewbies@kernelnewbies.org
>> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>
>
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>
