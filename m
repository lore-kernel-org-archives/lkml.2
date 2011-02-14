Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1BNJ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 04:27:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57777 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1BNJ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 04:27:28 -0500
Message-ID: <4D58F578.8090201@mvista.com>
Date: Mon, 14 Feb 2011 18:27:20 +0900
From: Tadashi Abe <tabe@mvista.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: x86@kernel.org, tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix io_bitmap_ptr memory leak on copy_process()
References: <4D50CDE6.5000903@mvista.com> <alpine.LNX.2.00.1102101901420.26035@swampdragon.chaosbits.net> <alpine.LNX.2.00.1102101909520.26035@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102101909520.26035@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>>> index b3feabc..290e98b 100644
>>> --- a/arch/x86/kernel/process.c
>>> +++ b/arch/x86/kernel/process.c
>>> @@ -122,6 +122,12 @@ void flush_thread(void)
>>>  	clear_used_math();
>>>  }
>>>  
>>> +void free_thread_struct(struct task_struct *p)
>>> +{
>>> +	if (p->thread.io_bitmap_ptr)
>>> +		kfree(p->thread.io_bitmap_ptr);
>>
>> kfree(NULL) is perfectly legal, so the 'if' is not needed.

Thanks. agreed.

>> Why is this a new function? Why not simply call kfree() when needed.

io_bitmap_ptr is a x86 specific variable
so I didn't think it should be in generic kernel codes (kernel/fork.c).
I understand making a new function looks overkill though.
Even if you call kfree() directly in kernel/fork.c,
"#ifdef CONFIG_X86" is necessary anyway.

But I don't have any insistence on how to fix it and leave it to experts' choice.

Thanks
--
Tadashi
