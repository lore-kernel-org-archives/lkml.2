Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2BTLEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:04:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38221 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab2BTLEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:04:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jiangtao.jit@gmail.com designates 10.112.84.170 as permitted sender) smtp.mail=jiangtao.jit@gmail.com; dkim=pass header.i=jiangtao.jit@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F411373.50304@gmail.com>
References: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com>
	<CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com>
	<4F411373.50304@gmail.com>
Date: Mon, 20 Feb 2012 19:04:38 +0800
Message-ID: <CAOe6JY3yM24CGYOpPc98QfjRYah5U+L9DB46WH60LVrxN9=eRQ@mail.gmail.com>
Subject: Re: A problem with percpu variable cpu_number
From: Tao Jiang <jiangtao.jit@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang:

Thanks for you reply.
But I think it's not the truth.

The percpu variable cpu_number is defined in arch/x86/kernel/setup_percpu.c
use DEFINE_PER_CPU(int, cpu_number);
and declared in head file arch/x86/include/asm/smp.h
use DECLARE_PER_CPU(int, cpu_number);

I read the macor DEFINE_PER_CPU
it's decorated by some percpu attributes
it will be put in section .data..percpu in init section
and init section will be free after the kernel had been initialized
so at the beginning of start_kernel()
what smp_processor_id() read is not initialized yet
am I right ?
Let me know if i made some misunderstanding of the code.
Thank you.




2012/2/19 Cong Wang <xiyou.wangcong@gmail.com>:
> On 02/19/2012 08:20 PM, Tao Jiang wrote:
>>
>> Hi :
>>
>> At the beginning of start_kernel() -- init/main.c
>> boot_cpu_init() is called
>>
>> and in boot_cpu_init() will call smp_processor_id()
>> it's a macro
>> and it will be expanded as (percpu_read(cpu_number)) and so on
>>
>> but i noticed that it's before setup_per_cpu_areas() in start_kernel()
>> is that mean the percpu areas hadn't be initialized yet
>> but why smp_processor_id() could be called before setup_per_cpu_areas()
>
>
> It doesn't matter, as the percpu var 'cpu_number' is defined statically:
> DECLARE_PER_CPU(int, cpu_number);.
>
> Thanks.
