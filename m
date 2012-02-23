Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab2BWO3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:29:35 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39284 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756185Ab2BWO3d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:29:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jiangtao.jit@gmail.com designates 10.152.104.143 as permitted sender) smtp.mail=jiangtao.jit@gmail.com; dkim=pass header.i=jiangtao.jit@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAJd=RBCF+1xON8VHCHt1KujSkgn9-XNwSHyf7-dfVYZLNFpyFg@mail.gmail.com>
References: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com>
	<CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com>
	<4F411373.50304@gmail.com>
	<CAOe6JY3yM24CGYOpPc98QfjRYah5U+L9DB46WH60LVrxN9=eRQ@mail.gmail.com>
	<CAMzpN2gnOgZWZFTVHnL8ySQSXCykc9ZpoDYMUvHGPVpy4OVWOw@mail.gmail.com>
	<CAOe6JY21ao5BUcsOfS2S1xtp0iuO+9O_O9qK=AMNmjZGmTMGOw@mail.gmail.com>
	<CAJd=RBCF+1xON8VHCHt1KujSkgn9-XNwSHyf7-dfVYZLNFpyFg@mail.gmail.com>
Date: Thu, 23 Feb 2012 22:29:31 +0800
Message-ID: <CAOe6JY2_E7FCAHkLJpG5BF9xvMiH4=MDmEkFzJOcViKBWBF6kw@mail.gmail.com>
Subject: Re: A problem with percpu variable cpu_number
From: Tao Jiang <jiangtao.jit@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton:

Thanks for your remind
and sorry for my poor English.


2012/2/22 Hillf Danton <dhillf@gmail.com>:
> On Wed, Feb 22, 2012 at 7:13 PM, Tao Jiang <jiangtao.jit@gmail.com> wrote:
>> Hi:
>>
>> Thank you all.
>>
>> So in boot_cpu_init(), it will always set bit 0 to these masks.
>> If the boot cpu is the first processor, it's the right case.
>> And if the BP is not the first one, is it wrong?
>> But can it happen that the BP is not cpu0?
>
> BP could be not "the first one".
> Due to that current code boots fine, I guess, you mess
> logic CPU with hard CPU.
>
> btw, replying messages in this way looks not fine.
>
>> Thank you.
>>
>>
>> 2012/2/22 Brian Gerst <brgerst@gmail.com>:
>>> On Tue, Feb 21, 2012 at 9:29 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>> On 02/21/2012 08:41 PM, Tao Jiang wrote:
>>>>>
>>>>> Hi Cong Wang:
>>>>>
>>>>> I read the file vmlinux.lds.S in arch/x86/kernel
>>>>> section .data..percpu is between .init.data and .init.end
>>>>> Is that means these percpu variables will be freed after init?
>>>>
>>>>
>>>> % grep -e __init_begin -e __init_end -e __per_cpu_start -e __per_cpu_end
>>>> /boot/System.map
>>>> 0000000000000000 D __per_cpu_start
>>>> 0000000000014bc0 D __per_cpu_end
>>>> ffffffff81cf3000 D __init_begin
>>>> ffffffff81dfc000 R __init_end
>>>> % objdump -d -j .data..percpu vmlinux | grep cpu_number
>>>> 000000000000dc38 <cpu_number>:
>>>
>>> The .data..percpu section is placed in the init section, but x86-64 is
>>> a special case as noted below.  The boot cpu is pointed to the init
>>> percpu section until setup_per_cpu_areas() is called, when it switches
>>> to the regular percpu area.  The init percpu data is then freed with
>>> all other init data.
>>>
>>> The reason the percpu symbols start at virtual address 0 on x86-64 is
>>> because of the requirement that gs_base must be a canonical address
>>> (it cannot be a simple offset like x86-32).  But, the data is still
>>> loaded in the init section in memory.  See
>>> arch/x86/kernel/vmlinux.lds.S for the explanation of how the linker
>>> changes the program headers to set the virtual address to zero but
>>> keeps the load address in the init section.
>>>
>>> To answer the original question. in the case of cpu_number, it is set
>>> to zero in the init section because it doesn't have an explicit
>>> initializer.  Therefore the boot cpu will always read zero for the
>>> cpu_number, even before setup_per_cpu_areas() is called.
>>>
>>>
>>> --
>>> Brian Gerst
>> --
