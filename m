Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2ICGRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 02:17:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37822 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ICGRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 02:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFtpBnvtA3F=7NDJunqXRs4AL1=oe7HR6GECgGfr9TqDA@mail.gmail.com>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-14-git-send-email-yinghai@kernel.org>
	<CAOJsxLFtpBnvtA3F=7NDJunqXRs4AL1=oe7HR6GECgGfr9TqDA@mail.gmail.com>
Date: Sun, 2 Sep 2012 23:17:18 -0700
X-Google-Sender-Auth: _8AorOWngo19Wc4ygYqk8WHjh6M
Message-ID: <CAE9FiQV9pE0FOgqTbNpUf0s04yCTeHkApvUtzGXKwQw-7XB2KA@mail.gmail.com>
Subject: Re: [PATCH -v2 13/13] x86, 64bit: Map first 1M ram early before memblock_x86_fill()
From: Yinghai Lu <yinghai@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:50 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> This one intend to fix bugs:
>> when efi booting have too many memmap entries, will need to double memblock
>> memory array or reserved array.
>
> Okay, why do we need to do that?

memblock initial memory only have 128 entry, and some EFI system could
have more entries than that.

So during memblock_x86_fill need to double that array.

and efi_reserve_boot_services() could make thing more worse. aka need
more entries in memblock.memory.regions.

>
>> +RESERVE_BRK(early_pgt_alloc, 65536);
>
> What is this needed for?

for extra page table, and extend_brk will consume that.

>
>> +void  __init early_init_mem_mapping(void)
>> +{
>> +       unsigned long tables;
>> +       phys_addr_t base;
>> +       unsigned long start = 0, end = ISA_END_ADDRESS;
>> +
>> +       probe_page_size_mask();
>> +
>> +       if (max_pfn_mapped)
>> +               return;
>
> I find this confusing - what is this protecting for? Why is
> 'max_pfn_mapped' set when someone calls early_init_mem_mappings()?

for 32 bit, it will non zero max_pfn_mapped set in head_32.S

>
> Side note: we have multiple "pfn_mapped" globals and it's not at all
> obvious to me what the semantics for them are. Maybe adding a comment
> or two in arch/x86/include/asm/page_types.h would help.

move the comments  from arch/x86/kernel/setup.c to that header file ?

Thanks

Yinghai
