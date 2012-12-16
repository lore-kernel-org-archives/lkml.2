Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2LPVo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 16:44:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40498 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab2LPVo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 16:44:26 -0500
Message-ID: <50CE4097.2020104@zytor.com>
Date: Sun, 16 Dec 2012 13:43:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v3 08/10] x86/head64.c: Early update ucode in 64-bit
References: <1355654609-16800-1-git-send-email-fenghua.yu@intel.com> <1355654609-16800-9-git-send-email-fenghua.yu@intel.com> <CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
In-Reply-To: <CAE9FiQWFRMpxQTTbS+p21EjBvmetup75zD6ipc3COZg7=KyNig@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 09:59 AM, Yinghai Lu wrote:
>> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
>> index 037df57..a512f56 100644
>> --- a/arch/x86/kernel/head64.c
>> +++ b/arch/x86/kernel/head64.c
>> @@ -25,6 +25,7 @@
>>  #include <asm/kdebug.h>
>>  #include <asm/e820.h>
>>  #include <asm/bios_ebda.h>
>> +#include <asm/microcode.h>
>>
>>  static void __init zap_identity_mappings(void)
>>  {
>> @@ -73,6 +74,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
>>         /* clear bss before set_intr_gate with early_idt_handler */
>>         clear_bss();
>>
>> +       /*
>> +        * Load microcode early on BSP.
>> +        */
>> +       load_ucode_bsp(real_mode_data);
>> +
>>         /* Make NULL pointers segfault */
>>         zap_identity_mappings();
>>
> 
> So this patchset is after #PF handler set early page table version?
> 
> then load_ucode_bsp() should be after
> 
>    load_idt((const struct desc_ptr *)&idt_descr);
> 

This patchset isn't before the #PF handler version (you can tell because
it has zap_identity_mappings()), but it does make sense to load the IDT
first.

	-hpa


