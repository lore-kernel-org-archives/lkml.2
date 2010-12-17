Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0LQDI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:08:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:26489 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0LQDI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:08:28 -0500
Message-ID: <4D0AD3ED.8070607@kernel.org>
Date: Thu, 16 Dec 2010 19:07:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Maxim Uvarov <muvarov@gmail.com>,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216143925.GA13870@redhat.com> <4D0A3E31.4000109@zytor.com> <4D0A4C51.3070008@kernel.org> <4D0A6F66.1010006@zytor.com> <4D0AA116.4050707@kernel.org> <4D0AA592.3060805@kernel.org> <4D0AB14F.9050900@kernel.org> <4D0AC213.3050102@zytor.com>
In-Reply-To: <4D0AC213.3050102@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 05:51 PM, H. Peter Anvin wrote:
> Can whomever has a test case for this please test the attached test patch?
> 
with PAGE_OFFSET=0x40000000

I'm in purgatory
bootconsole [uart0] enabled
Kernel Layout:
  .text: [0x2f000000-0x2f3fbf4a]
.rodata: [0x2f3fe000-0x2f5b1fff]
  .data: [0x2f5b2000-0x2f60e067]
  .init: [0x2f60f000-0x2f690fff]
   .bss: [0x2f695000-0x2f796fff]
   .brk: [0x2f797000-0x2fdbafff]
    memblock_x86_reserve_range: [0x00001000-0x00001fff]    EX TRAMPOLINE
    memblock_x86_reserve_range: [0x2f000000-0x2f796fff]    TEXT DATA BSS
    memblock_x86_reserve_range: [0x36d8a000-0x36f49fff]          RAMDISK
    memblock_x86_reserve_range: [0x0009c800-0x000fffff]  * BIOS reserved
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.37-rc5-tip+ (root@mpk12-3214-189-181) (gcc version 4.4.4 20100726 (Red Hat 4.4.4-13) (GCC) ) #11 SMP Thu Dec 16 10:49:27 PST 2010
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: [0x00000000000100-0x0000000009c7ff] (usable)
 BIOS-e820: [0x0000000009c800-0x0000000009ffff] (reserved)
 BIOS-e820: [0x000000000e0000-0x000000000fffff] (reserved)
 BIOS-e820: [0x00000000100000-0x0000007ff9ffff] (usable)
 BIOS-e820: [0x0000007ffae000-0x0000007ffaffff] (usable)
 BIOS-e820: [0x0000007ffb0000-0x0000007ffbdfff] (ACPI data)
 BIOS-e820: [0x0000007ffbe000-0x0000007ffeffff] (ACPI NVS)
 BIOS-e820: [0x0000007fff0000-0x0000007fffffff] (reserved)
 BIOS-e820: [0x000000e0000000-0x000000efffffff] (reserved)
 BIOS-e820: [0x000000fec00000-0x000000fec00fff] (reserved)
 BIOS-e820: [0x000000fee00000-0x000000feefffff] (reserved)
 BIOS-e820: [0x000000ff700000-0x000000ffffffff] (reserved)
last_pfn = 0x7ffb0 max_arch_pfn = 0x1000000
NX (Execute Disable) protection: active
user-defined physical RAM map:
 user: [0x00000000000000-0x0000000009ffff] (usable)
 user: [0x0000002f000000-0x00000036f59fff] (usable)
 user: [0x0000007ffb0000-0x0000007ffeffff] (ACPI data)
DMI present.
_brk_end: 6f919000, __brk_limit: 6fdbb000
_brk_end: 6f91901c, __brk_limit: 6fdbb000
_brk_end: 6f919024, __brk_limit: 6fdbb000
_brk_end: 6f919030, __brk_limit: 6fdbb000
_brk_end: 6f919048, __brk_limit: 6fdbb000
_brk_end: 6f919058, __brk_limit: 6fdbb000
_brk_end: 6f919060, __brk_limit: 6fdbb000
_brk_end: 6f91907c, __brk_limit: 6fdbb000
_brk_end: 6f9190a4, __brk_limit: 6fdbb000
_brk_end: 6f9190bc, __brk_limit: 6fdbb000
_brk_end: 6f9190cc, __brk_limit: 6fdbb000
_brk_end: 6f9190e0, __brk_limit: 6fdbb000
_brk_end: 6f919104, __brk_limit: 6fdbb000
_brk_end: 6f919118, __brk_limit: 6fdbb000
_brk_end: 6f919130, __brk_limit: 6fdbb000
_brk_end: 6f919134, __brk_limit: 6fdbb000
_brk_end: 6f919148, __brk_limit: 6fdbb000
_brk_end: 6f919160, __brk_limit: 6fdbb000
_brk_end: 6f91918c, __brk_limit: 6fdbb000
_brk_end: 6f9191b8, __brk_limit: 6fdbb000
_brk_end: 6f9191e4, __brk_limit: 6fdbb000
_brk_end: 6f919210, __brk_limit: 6fdbb000
_brk_end: 6f919234, __brk_limit: 6fdbb000
_brk_end: 6f919240, __brk_limit: 6fdbb000
_brk_end: 6f919254, __brk_limit: 6fdbb000
_brk_end: 6f919268, __brk_limit: 6fdbb000
DMI: Sun Fire X4240/Sun Fire X4240, BIOS 080014  10/15/2008
e820 update range: [0x00000000000000-0x0000000000ffff] (usable) ==> (reserved)
e820 remove range: [0x000000000a0000-0x000000000fffff] (usable)
last_pfn = 0x36f5a max_arch_pfn = 0x1000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
Scan SMP from 40000000 for 1024 bytes.
Scan SMP from 4009fc00 for 1024 bytes.
Scan SMP from 400f0000 for 65536 bytes.
found SMP MP-table at [400ff780] ff780
    memblock_x86_reserve_range: [0x000ff780-0x000ff78f]   * MP-table mpf
  mpc: fc4e0-fc6e4
    memblock_x86_reserve_range: [0x000fc4e0-0x000fc6e3]   * MP-table mpc
    memblock_x86_reserve_range: [0x2f797000-0x2f91927b]              BRK
