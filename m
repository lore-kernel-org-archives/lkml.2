Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab2D3QfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:35:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41272 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab2D3QfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:35:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6697"; a="186223648"
Message-ID: <4F9EBF3E.8060401@codeaurora.org>
Date: Mon, 30 Apr 2012 09:35:10 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org> <201204301415.56690.arnd@arndb.de>
In-Reply-To: <201204301415.56690.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/12 07:15, Arnd Bergmann wrote:
> On Tuesday 24 April 2012, Stephen Boyd wrote:
>> diff --git a/include/asm-generic/current.h b/include/asm-generic/current.h
>> index 5e86f6a..bbfb795 100644
>> --- a/include/asm-generic/current.h
>> +++ b/include/asm-generic/current.h
>> @@ -1,9 +1,16 @@
>>  #ifndef __ASM_GENERIC_CURRENT_H
>>  #define __ASM_GENERIC_CURRENT_H
>>  
>> +#include <linux/compiler.h>
>>  #include <linux/thread_info.h>
>>  
>> -#define get_current() (current_thread_info()->task)
>> +struct task_struct;
>> +
>> +static __always_inline struct task_struct *get_current(void)
>> +{
>> +       return current_thread_info()->task;
>> +}
>> +
>>  #define current get_current()
>>  
>>  #endif /* __ASM_GENERIC_CURRENT_H */
> Does this need to be an inline function rather than a macro? I think I
> remember having trouble with header file dependencies when I tried making
> it an inline function initially and I don't know if those have been
> resolved.
>
> I realize that the macro is ugly, but if you don't mind keeping it,
> that would be the safer option in terms of breaking some architecture
> in the process. If course if you can prove that all architectures using
> the generic implementation can use the inline function, I'm all for
> the change.
>

I admit I haven't compile tested this on all the affected architectures.
Looking at the architectures that are migrated here I don't see any that
are defining get_current() as a macro except for alpha. Should I drop
alpha from the patch? Or would it be easier if someone threw this into
linux-next and see if it blows up?

In the meantime I can scrounge around for those kernel.org
cross-compilers and see if I can compile alpha.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

