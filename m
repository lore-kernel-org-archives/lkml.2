Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2LPXfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 18:35:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49024 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2LPXfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 18:35:45 -0500
MIME-Version: 1.0
In-Reply-To: <50CE4097.2020104@zytor.com>
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com>
	<1355654609-16800-9-git-send-email-fenghua.yu@intel.com>
	<CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
	<50CE4097.2020104@zytor.com>
Date: Sun, 16 Dec 2012 15:35:44 -0800
X-Google-Sender-Auth: EFcJxIBTR2UUMI1Ww-Yw-jRnaDo
Message-ID: <CAE9FiQXmz07SUEwJdr0QD8Y2Uro6Sizkeg4KfFkJSuQLFW3Fow@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 1:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/16/2012 09:59 AM, Yinghai Lu wrote:
>>> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
>>> index 037df57..a512f56 100644
>>> --- a/arch/x86/kernel/head64.c
>>> +++ b/arch/x86/kernel/head64.c
>>> @@ -25,6 +25,7 @@
>>>  #include <asm/kdebug.h>
>>>  #include <asm/e820.h>
>>>  #include <asm/bios_ebda.h>
>>> +#include <asm/microcode.h>
>>>
>>>  static void __init zap_identity_mappings(void)
>>>  {
>>> @@ -73,6 +74,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
>>>         /* clear bss before set_intr_gate with early_idt_handler */
>>>         clear_bss();
>>>
>>> +       /*
>>> +        * Load microcode early on BSP.
>>> +        */
>>> +       load_ucode_bsp(real_mode_data);
>>> +
>>>         /* Make NULL pointers segfault */
>>>         zap_identity_mappings();
>>>
>>
>> So this patchset is after #PF handler set early page table version?
>>
>> then load_ucode_bsp() should be after
>>
>>    load_idt((const struct desc_ptr *)&idt_descr);
>>
>
> This patchset isn't before the #PF handler version (you can tell because
> it has zap_identity_mappings()), but it does make sense to load the IDT
> first.

it has to be rebased after #PF handler version. otherwise it can not
handle for framdisk
that is loaded after 1G.

Fenghua,

can you post your boot log with 64bit with your patch?

Yinghai
