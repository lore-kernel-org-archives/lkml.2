Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab0LPW6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 17:58:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38130 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0LPW6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 17:58:32 -0500
Message-ID: <4D0A993D.4060708@kernel.org>
Date: Thu, 16 Dec 2010 14:57:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216143925.GA13870@redhat.com> <4D0A3E31.4000109@zytor.com> <4D0A4C51.3070008@kernel.org> <4D0A6F66.1010006@zytor.com>
In-Reply-To: <4D0A6F66.1010006@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 11:58 AM, H. Peter Anvin wrote:
> On 12/16/2010 09:28 AM, Yinghai Lu wrote:
>>
>> the brk is complaining if i change that to 
>>
>>  	if (end > ((-__PAGE_OFFSET-(128 <<20)-1) & 0x7fffffff))
>>  		error("Destination address too large");
>>
>> brk is complaining when try to get more for dmi ...
>> ...
>> I'm in purgatory
>> bootconsole [uart0] enabled
>> Kernel Layout:
>>   .text: [0x2e000000-0x2e3f08ca]
>> .rodata: [0x2e3f2000-0x2e5a2fff]
>>   .data: [0x2e5a3000-0x2e5f6467]
>>   .init: [0x2e5f7000-0x2e670fff]
>>    .bss: [0x2e675000-0x2e76ffff]
>>    .brk: [0x2e770000-0x2e894fff]
>>     memblock_x86_reserve_range: [0x00001000-0x00001fff]    EX TRAMPOLINE
>>     memblock_x86_reserve_range: [0x2e000000-0x2e76ffff]    TEXT DATA BSS
>>     memblock_x86_reserve_range: [0x35bdd000-0x35f49fff]          RAMDISK
>>     memblock_x86_reserve_range: [0x0009c800-0x000fffff]  * BIOS reserved
>> Initializing cgroup subsys cpuset
>> Initializing cgroup subsys cpu
>> Linux version 2.6.37-rc5-tip+ (root@mpk12-3214-189-181) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #4 SMP Wed Dec 15 11:04:32 PST 2010
>> KERNEL supported cpus:
>>   Intel GenuineIntel
>>   AMD AuthenticAMD
>>   NSC Geode by NSC
>>   Cyrix CyrixInstead
>>   Centaur CentaurHauls
>>   Transmeta GenuineTMx86
>>   Transmeta TransmetaCPU
>>   UMC UMC UMC UMC
>> BIOS-provided physical RAM map:
>>  BIOS-e820: [0x00000000000100-0x0000000009c7ff] (usable)
>>  BIOS-e820: [0x0000000009c800-0x0000000009ffff] (reserved)
>>  BIOS-e820: [0x000000000e0000-0x000000000fffff] (reserved)
>>  BIOS-e820: [0x00000000100000-0x0000007ff9ffff] (usable)
>>  BIOS-e820: [0x0000007ffae000-0x0000007ffaffff] (usable)
>>  BIOS-e820: [0x0000007ffb0000-0x0000007ffbdfff] (ACPI data)
>>  BIOS-e820: [0x0000007ffbe000-0x0000007ffeffff] (ACPI NVS)
>>  BIOS-e820: [0x0000007fff0000-0x0000007fffffff] (reserved)
>>  BIOS-e820: [0x000000e0000000-0x000000efffffff] (reserved)
>>  BIOS-e820: [0x000000fec00000-0x000000fec00fff] (reserved)
>>  BIOS-e820: [0x000000fee00000-0x000000feefffff] (reserved)
>>  BIOS-e820: [0x000000ff700000-0x000000ffffffff] (reserved)
>> last_pfn = 0x7ffb0 max_arch_pfn = 0x1000000
>> NX (Execute Disable) protection: active
>> user-defined physical RAM map:
>>  user: [0x00000000000000-0x0000000009ffff] (usable)
>>  user: [0x0000002e000000-0x00000035f59fff] (usable)
>>  user: [0x0000007ffb0000-0x0000007ffeffff] (ACPI data)
>> DMI present.
>> BUG: Int 6: CR2   (null)
>>      EDI 00000019  ESI ff940c18  EBP   (null)  ESP ee5a5e84
>>      EBX ee5cfb68  EDX 00000006  ECX 00000019  EAX ee8e6019
>>      err   (null)  EIP ee5fb4dd   CS 00000060  flg 00010002
>> Stack: 00000019 ee62bf45 ff942000 00000563 00000001 ff940c00 000018c7 ee62bf83
>>        ff940c00 ee62c063 80000000 ee3e6f2f ee50a3c0 ee5a5ed4 ff940c00 ff940c43
>>        000018c7   (null) ee3173d4 000018c8 0000007f ff940c00 ff90b1bf ee5a5f18
>> Pid: 0, comm: swapper Not tainted 2.6.37-rc5-tip+ #4
>> Call Trace:
>>  [<ee3dd1d5>] ? hlt_loop+0x0/0x3
>>  [<ee5fb4dd>] ? extend_brk+0x31/0x44
> 
> I'm assuming it bails due to:
> 
> 	BUG_ON((char *)(_brk_end + size) > __brk_limit);
> 
> ... could you find out what _brk_end and __brk_limit are?

void __init print_kernel_layout(void)
{
        printk("Kernel Layout:\n");
        printk("  .text: [%#010lx-%#010lx]\n", __pa_symbol(&_text), __pa_symbol(&_etext) - 1);
        printk(".rodata: [%#010lx-%#010lx]\n", __pa_symbol(&__start_rodata), __pa_symbol(&__end_rodata) - 1);
        printk("  .data: [%#010lx-%#010lx]\n", __pa_symbol(&_sdata), __pa_symbol(&_edata) - 1);
        printk("  .init: [%#010lx-%#010lx]\n", __pa_symbol(&__init_begin), __pa_symbol(&__init_end) - 1);
        printk("   .bss: [%#010lx-%#010lx]\n", __pa_symbol(&__bss_start), __pa_symbol(&__bss_stop) - 1);
        printk("   .brk: [%#010lx-%#010lx]\n", __pa_symbol(&__brk_base), __pa_symbol(&__brk_limit) - 1);
}

>> Kernel Layout:
>>   .text: [0x2e000000-0x2e3f08ca]
>> .rodata: [0x2e3f2000-0x2e5a2fff]
>>   .data: [0x2e5a3000-0x2e5f6467]
>>   .init: [0x2e5f7000-0x2e670fff]
>>    .bss: [0x2e675000-0x2e76ffff]
>>    .brk: [0x2e770000-0x2e894fff]

so __brk_limit should be right?
