Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab2EXCSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 22:18:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2EXCSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 22:18:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205231731250.8785@chino.kir.corp.google.com>
References: <CABawtvMgrsAQaQy7RO5XFbj7qu8+4WHqaZbbNQOeEwhMs58Oyw@mail.gmail.com>
	<alpine.DEB.2.00.1205222035591.28165@chino.kir.corp.google.com>
	<20120523233240.GD4071@redhat.com>
	<alpine.DEB.2.00.1205231731250.8785@chino.kir.corp.google.com>
Date: Thu, 24 May 2012 10:18:03 +0800
Message-ID: <CABawtvO7kTR0OyY9yPhL+cLF8ehDF1R94ayBc4yQXc16Mbd0yg@mail.gmail.com>
Subject: Re: Huge memory takes too long time to initialize on 4TB ?
From: ethan zhao <ethan.kernel@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole dmesg  FYI, note 2.6.39 actually is 3.0.26
When switch to TSC first, initialize huge memory second,
Lockup on CPU 42# between thread cpu_stopper and thread hugepage_init
for more than 21s.

nitializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.39-100.6.1.el6uek.x86_64
(mockbuild@ca-build44.us.oracle.com) (gcc version 4.4.6 20110731 (Red
Hat 4.4.6-3) (GCC) ) #1 SMP Wed Apr 18 20:38:47 EDT 2012
Command line: ro root=/dev/mapper/vg0-lv0 intel_iommu=on rd_NO_LUKS
LANG=en_US.UTF-8 rd_LVM_LV=vg0/lv1 rd_LVM_LV=vg0/lv0 rd_NO_MD
SYSFONT=latarcyrheb-sun16  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM
rd_NO_LUKS LANG=en_US.UTF-8 rd_LVM_LV=vg0/lv1 rd_LVM_LV=vg0/lv0
rd_NO_MD SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc KEYTABLE=us
rd_NO_DM
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000095800 (usable)
 BIOS-e820: 0000000000095800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f750000 (usable)
 BIOS-e820: 000000007f75e000 - 000000007f760000 type 9
 BIOS-e820: 000000007f760000 - 000000007f76e000 (ACPI data)
 BIOS-e820: 000000007f76e000 - 000000007f7d0000 (ACPI NVS)
 BIOS-e820: 000000007f7d0000 - 000000007f7e0000 (reserved)
 BIOS-e820: 000000007f7ec000 - 0000000090000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000040080000000 (usable)
NX (Execute Disable) protection: active
DMI present.
DMI: Oracle Corporation  Sun Fire X4800 M2 /     , BIOS 15013200    04/19/2012
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==>  (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x40080000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
 00000-9FFFF write-back
 A0000-BFFFF uncachable
 C0000-C3FFF write-protect
 C4000-C7FFF uncachable
 C8000-D7FFF write-protect
 D8000-DBFFF uncachable
 DC000-DFFFF write-through
 E0000-EBFFF write-protect
 EC000-EFFFF write-through
 F0000-FFFFF write-protect
MTRR variable ranges enabled:
 0 base 00000000000 mask C0000000000 write-back
 1 base 40000000000 mask FFF80000000 write-back
 2 base 00080000000 mask FFF80000000 uncachable
 3 base 0007F800000 mask FFFFF800000 uncachable
 4 disabled
 5 disabled
 6 disabled
 7 disabled
 8 disabled
 9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 0GB, range: 4096GB, type WB
reg 1, base: 4096GB, range: 2GB, type WB
reg 2, base: 2GB, range: 2GB, type UC
reg 3, base: 2040MB, range: 8MB, type UC
total RAM covered: 4194296M
 gran_size: 64K         chunk_size: 64K         num_reg: 10     lose
cover RAM: 4082G
 gran_size: 64K         chunk_size: 128K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 64K         chunk_size: 256K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 64K         chunk_size: 512K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 64K         chunk_size: 1M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 64K         chunk_size: 2M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 64K         chunk_size: 4M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 64K         chunk_size: 8M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 64K         chunk_size: 16M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 64K         chunk_size: 32M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 64K         chunk_size: 64M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 64K         chunk_size: 128M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 64K         chunk_size: 256M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 64K         chunk_size: 512M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 64K         chunk_size: 1G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 64K         chunk_size: 2G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 128K        chunk_size: 128K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 128K        chunk_size: 256K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 128K        chunk_size: 512K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 128K        chunk_size: 1M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 128K        chunk_size: 2M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 128K        chunk_size: 4M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 128K        chunk_size: 8M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 128K        chunk_size: 16M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 128K        chunk_size: 32M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 128K        chunk_size: 64M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 128K        chunk_size: 128M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 128K        chunk_size: 256M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 128K        chunk_size: 512M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 128K        chunk_size: 1G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 128K        chunk_size: 2G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 256K        chunk_size: 256K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 256K        chunk_size: 512K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 256K        chunk_size: 1M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 256K        chunk_size: 2M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 256K        chunk_size: 4M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 256K        chunk_size: 8M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 256K        chunk_size: 16M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 256K        chunk_size: 32M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 256K        chunk_size: 64M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 256K        chunk_size: 128M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 256K        chunk_size: 256M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 256K        chunk_size: 512M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 256K        chunk_size: 1G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 256K        chunk_size: 2G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 512K        chunk_size: 512K        num_reg: 10     lose
cover RAM: 4082G
 gran_size: 512K        chunk_size: 1M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 512K        chunk_size: 2M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 512K        chunk_size: 4M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 512K        chunk_size: 8M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 512K        chunk_size: 16M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 512K        chunk_size: 32M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 512K        chunk_size: 64M         num_reg: 10     lose
cover RAM: 3074G
 gran_size: 512K        chunk_size: 128M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 512K        chunk_size: 256M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 512K        chunk_size: 512M        num_reg: 10     lose
cover RAM: 3074G
 gran_size: 512K        chunk_size: 1G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 512K        chunk_size: 2G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 1M  chunk_size: 1M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 1M  chunk_size: 2M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 1M  chunk_size: 4M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 1M  chunk_size: 8M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 1M  chunk_size: 16M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 1M  chunk_size: 32M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 1M  chunk_size: 64M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 1M  chunk_size: 128M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 1M  chunk_size: 256M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 1M  chunk_size: 512M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 1M  chunk_size: 1G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 1M  chunk_size: 2G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 2M  chunk_size: 2M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 2M  chunk_size: 4M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 2M  chunk_size: 8M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 2M  chunk_size: 16M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 2M  chunk_size: 32M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 2M  chunk_size: 64M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 2M  chunk_size: 128M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 2M  chunk_size: 256M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 2M  chunk_size: 512M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 2M  chunk_size: 1G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 2M  chunk_size: 2G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 4M  chunk_size: 4M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 4M  chunk_size: 8M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 4M  chunk_size: 16M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 4M  chunk_size: 32M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 4M  chunk_size: 64M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 4M  chunk_size: 128M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 4M  chunk_size: 256M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 4M  chunk_size: 512M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 4M  chunk_size: 1G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 4M  chunk_size: 2G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 8M  chunk_size: 8M  num_reg: 10     lose cover RAM: 4082G
 gran_size: 8M  chunk_size: 16M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 8M  chunk_size: 32M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 8M  chunk_size: 64M         num_reg: 10     lose cover RAM: 3074G
 gran_size: 8M  chunk_size: 128M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 8M  chunk_size: 256M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 8M  chunk_size: 512M        num_reg: 10     lose cover RAM: 3074G
 gran_size: 8M  chunk_size: 1G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 8M  chunk_size: 2G  num_reg: 10     lose cover RAM: 3074G
 gran_size: 16M         chunk_size: 16M         num_reg: 10     lose
cover RAM: 4163592M
 gran_size: 16M         chunk_size: 32M         num_reg: 10     lose
cover RAM: 3147784M
 gran_size: 16M         chunk_size: 64M         num_reg: 10     lose
cover RAM: 3147784M
 gran_size: 16M         chunk_size: 128M        num_reg: 10     lose
cover RAM: 3147784M
 gran_size: 16M         chunk_size: 256M        num_reg: 10     lose
cover RAM: 3147784M
 gran_size: 16M         chunk_size: 512M        num_reg: 10     lose
cover RAM: 3147784M
 gran_size: 16M         chunk_size: 1G  num_reg: 10     lose cover RAM: 3147784M
 gran_size: 16M         chunk_size: 2G  num_reg: 10     lose cover RAM: 3147784M
 gran_size: 32M         chunk_size: 32M         num_reg: 10     lose
cover RAM: 4130840M
 gran_size: 32M         chunk_size: 64M         num_reg: 10     lose
cover RAM: 3147800M
 gran_size: 32M         chunk_size: 128M        num_reg: 10     lose
cover RAM: 3147800M
 gran_size: 32M         chunk_size: 256M        num_reg: 10     lose
cover RAM: 3147800M
 gran_size: 32M         chunk_size: 512M        num_reg: 10     lose
cover RAM: 3147800M
 gran_size: 32M         chunk_size: 1G  num_reg: 10     lose cover RAM: 3147800M
 gran_size: 32M         chunk_size: 2G  num_reg: 10     lose cover RAM: 3147800M
 gran_size: 64M         chunk_size: 64M         num_reg: 10     lose
cover RAM: 4065336M
 gran_size: 64M         chunk_size: 128M        num_reg: 10     lose
cover RAM: 3147832M
 gran_size: 64M         chunk_size: 256M        num_reg: 10     lose
cover RAM: 3147832M
 gran_size: 64M         chunk_size: 512M        num_reg: 10     lose
cover RAM: 3147832M
 gran_size: 64M         chunk_size: 1G  num_reg: 10     lose cover RAM: 3147832M
 gran_size: 64M         chunk_size: 2G  num_reg: 10     lose cover RAM: 3147832M
 gran_size: 128M        chunk_size: 128M        num_reg: 10     lose
cover RAM: 3934328M
 gran_size: 128M        chunk_size: 256M        num_reg: 10     lose
cover RAM: 3147896M
 gran_size: 128M        chunk_size: 512M        num_reg: 10     lose
cover RAM: 3147896M
 gran_size: 128M        chunk_size: 1G  num_reg: 10     lose cover RAM: 3147896M
 gran_size: 128M        chunk_size: 2G  num_reg: 10     lose cover RAM: 3147896M
 gran_size: 256M        chunk_size: 256M        num_reg: 10     lose
cover RAM: 3672312M
 gran_size: 256M        chunk_size: 512M        num_reg: 10     lose
cover RAM: 3148024M
 gran_size: 256M        chunk_size: 1G  num_reg: 10     lose cover RAM: 3148024M
 gran_size: 256M        chunk_size: 2G  num_reg: 10     lose cover RAM: 3148024M
 gran_size: 512M        chunk_size: 512M        num_reg: 10     lose
cover RAM: 3148280M
 gran_size: 512M        chunk_size: 1G  num_reg: 10     lose cover RAM: 3148280M
 gran_size: 512M        chunk_size: 2G  num_reg: 10     lose cover RAM: 3148280M
 gran_size: 1G  chunk_size: 1G  num_reg: 10     lose cover RAM: 2100216M
 gran_size: 1G  chunk_size: 2G  num_reg: 10     lose cover RAM: 2100216M
*BAD*gran_size: 2G      chunk_size: 2G  num_reg: 10     lose cover
RAM: -18014398505283592M
mtrr_cleanup: can not find optimal value
please specify mtrr_gran_size/mtrr_chunk_size
e820 update range: 000000007f800000 - 0000000100000000 (usable) ==>  (reserved)
x2apic enabled by BIOS, switching to x2apic ops
last_pfn = 0x7f750 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000090000] 90000 size 20480
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-000000007f750000
 0000000000 - 0040000000 page 1G
 0040000000 - 007f600000 page 2M
 007f600000 - 007f750000 page 4k
kernel direct mapping tables up to 7f750000 @ 1fffd000-20000000
init_memory_mapping: 0000000100000000-0000040080000000
 0100000000 - 40080000000 page 1G
kernel direct mapping tables up to 40080000000 @ 7f747000-7f750000
RAMDISK: 366f8000 - 37ff0000
ACPI: RSDP 00000000000fb160 00024 (v02 SUN   )
ACPI: XSDT 000000007f760100 0009C (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: FACP 000000007f760290 000F4 (v04 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: DSDT 000000007f760db0 08A1F (v02 SUN    X4800 M2 00000032 INTL 20051117)
ACPI: FACS 000000007f76e000 00040
ACPI: APIC 000000007f760390 00808 (v02 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: SPCR 000000007f760ba0 00050 (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: MCFG 000000007f760bf0 0003C (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: SLIT 000000007f760cec 0006C (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: SPMI 000000007f760d60 00041 (v05 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: OEMB 000000007f76e040 00139 (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: HPET 000000007f76bdb0 00038 (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: SRAT 000000007f76bdf0 00E40 (v02 SUN    X4800 M2 00000001 INTL 00000001)
ACPI: DMAR 000000007f76e180 002C8 (v01 SUN    X4800 M2 00000001 MSFT 00000097)
ACPI: SSDT 000000007f78fe70 0036D (v01 SUN       CpuPm 00000012 INTL 20051117)
ACPI: EINJ 000000007f76cc30 00130 (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: BERT 000000007f76cdc0 00030 (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: ERST 000000007f76cdf0 00210 (v01 SUN    X4800    20120419 MSFT 00000097)
ACPI: HEST 000000007f76d000 000A8 (v01 SUN    X4800 M2 20120419 MSFT 00000097)
ACPI: Local APIC address 0xfee00000
Setting APIC routing to cluster x2apic.
SRAT: PXM 0 ->  APIC 0x00 ->  Node 0
SRAT: PXM 0 ->  APIC 0x02 ->  Node 0
SRAT: PXM 0 ->  APIC 0x04 ->  Node 0
SRAT: PXM 0 ->  APIC 0x10 ->  Node 0
SRAT: PXM 0 ->  APIC 0x12 ->  Node 0
SRAT: PXM 0 ->  APIC 0x20 ->  Node 0
SRAT: PXM 0 ->  APIC 0x22 ->  Node 0
SRAT: PXM 0 ->  APIC 0x24 ->  Node 0
SRAT: PXM 0 ->  APIC 0x30 ->  Node 0
SRAT: PXM 0 ->  APIC 0x32 ->  Node 0
SRAT: PXM 1 ->  APIC 0x40 ->  Node 1
SRAT: PXM 1 ->  APIC 0x42 ->  Node 1
SRAT: PXM 1 ->  APIC 0x44 ->  Node 1
SRAT: PXM 1 ->  APIC 0x50 ->  Node 1
SRAT: PXM 1 ->  APIC 0x52 ->  Node 1
SRAT: PXM 1 ->  APIC 0x60 ->  Node 1
SRAT: PXM 1 ->  APIC 0x62 ->  Node 1
SRAT: PXM 1 ->  APIC 0x64 ->  Node 1
SRAT: PXM 1 ->  APIC 0x70 ->  Node 1
SRAT: PXM 1 ->  APIC 0x72 ->  Node 1
SRAT: PXM 2 ->  APIC 0x80 ->  Node 2
SRAT: PXM 2 ->  APIC 0x82 ->  Node 2
SRAT: PXM 2 ->  APIC 0x84 ->  Node 2
SRAT: PXM 2 ->  APIC 0x90 ->  Node 2
SRAT: PXM 2 ->  APIC 0x92 ->  Node 2
SRAT: PXM 2 ->  APIC 0xa0 ->  Node 2
SRAT: PXM 2 ->  APIC 0xa2 ->  Node 2
SRAT: PXM 2 ->  APIC 0xa4 ->  Node 2
SRAT: PXM 2 ->  APIC 0xb0 ->  Node 2
SRAT: PXM 2 ->  APIC 0xb2 ->  Node 2
SRAT: PXM 3 ->  APIC 0xc0 ->  Node 3
SRAT: PXM 3 ->  APIC 0xc2 ->  Node 3
SRAT: PXM 3 ->  APIC 0xc4 ->  Node 3
SRAT: PXM 3 ->  APIC 0xd0 ->  Node 3
SRAT: PXM 3 ->  APIC 0xd2 ->  Node 3
SRAT: PXM 3 ->  APIC 0xe0 ->  Node 3
SRAT: PXM 3 ->  APIC 0xe2 ->  Node 3
SRAT: PXM 3 ->  APIC 0xe4 ->  Node 3
SRAT: PXM 3 ->  APIC 0xf0 ->  Node 3
SRAT: PXM 3 ->  APIC 0xf2 ->  Node 3
SRAT: PXM 4 ->  APIC 0x0100 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0102 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0104 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0110 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0112 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0120 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0122 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0124 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0130 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0132 ->  Node 4
SRAT: PXM 5 ->  APIC 0x0140 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0142 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0144 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0150 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0152 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0160 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0162 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0164 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0170 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0172 ->  Node 5
SRAT: PXM 6 ->  APIC 0x0180 ->  Node 6
SRAT: PXM 6 ->  APIC 0x0182 ->  Node 6
SRAT: PXM 6 ->  APIC 0x0184 ->  Node 6
SRAT: PXM 6 ->  APIC 0x0190 ->  Node 6
SRAT: PXM 6 ->  APIC 0x0192 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01a0 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01a2 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01a4 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01b0 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01b2 ->  Node 6
SRAT: PXM 7 ->  APIC 0x01c0 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01c2 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01c4 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01d0 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01d2 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01e0 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01e2 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01e4 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01f0 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01f2 ->  Node 7
SRAT: PXM 0 ->  APIC 0x01 ->  Node 0
SRAT: PXM 0 ->  APIC 0x03 ->  Node 0
SRAT: PXM 0 ->  APIC 0x05 ->  Node 0
SRAT: PXM 0 ->  APIC 0x11 ->  Node 0
SRAT: PXM 0 ->  APIC 0x13 ->  Node 0
SRAT: PXM 0 ->  APIC 0x21 ->  Node 0
SRAT: PXM 0 ->  APIC 0x23 ->  Node 0
SRAT: PXM 0 ->  APIC 0x25 ->  Node 0
SRAT: PXM 0 ->  APIC 0x31 ->  Node 0
SRAT: PXM 0 ->  APIC 0x33 ->  Node 0
SRAT: PXM 1 ->  APIC 0x41 ->  Node 1
SRAT: PXM 1 ->  APIC 0x43 ->  Node 1
SRAT: PXM 1 ->  APIC 0x45 ->  Node 1
SRAT: PXM 1 ->  APIC 0x51 ->  Node 1
SRAT: PXM 1 ->  APIC 0x53 ->  Node 1
SRAT: PXM 1 ->  APIC 0x61 ->  Node 1
SRAT: PXM 1 ->  APIC 0x63 ->  Node 1
SRAT: PXM 1 ->  APIC 0x65 ->  Node 1
SRAT: PXM 1 ->  APIC 0x71 ->  Node 1
SRAT: PXM 1 ->  APIC 0x73 ->  Node 1
SRAT: PXM 2 ->  APIC 0x81 ->  Node 2
SRAT: PXM 2 ->  APIC 0x83 ->  Node 2
SRAT: PXM 2 ->  APIC 0x85 ->  Node 2
SRAT: PXM 2 ->  APIC 0x91 ->  Node 2
SRAT: PXM 2 ->  APIC 0x93 ->  Node 2
SRAT: PXM 2 ->  APIC 0xa1 ->  Node 2
SRAT: PXM 2 ->  APIC 0xa3 ->  Node 2
SRAT: PXM 2 ->  APIC 0xa5 ->  Node 2
SRAT: PXM 2 ->  APIC 0xb1 ->  Node 2
SRAT: PXM 2 ->  APIC 0xb3 ->  Node 2
SRAT: PXM 3 ->  APIC 0xc1 ->  Node 3
SRAT: PXM 3 ->  APIC 0xc3 ->  Node 3
SRAT: PXM 3 ->  APIC 0xc5 ->  Node 3
SRAT: PXM 3 ->  APIC 0xd1 ->  Node 3
SRAT: PXM 3 ->  APIC 0xd3 ->  Node 3
SRAT: PXM 3 ->  APIC 0xe1 ->  Node 3
SRAT: PXM 3 ->  APIC 0xe3 ->  Node 3
SRAT: PXM 3 ->  APIC 0xe5 ->  Node 3
SRAT: PXM 3 ->  APIC 0xf1 ->  Node 3
SRAT: PXM 3 ->  APIC 0xf3 ->  Node 3
SRAT: PXM 4 ->  APIC 0x0101 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0103 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0105 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0111 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0113 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0121 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0123 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0125 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0131 ->  Node 4
SRAT: PXM 4 ->  APIC 0x0133 ->  Node 4
SRAT: PXM 5 ->  APIC 0x0141 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0143 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0145 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0151 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0153 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0161 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0163 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0165 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0171 ->  Node 5
SRAT: PXM 5 ->  APIC 0x0173 ->  Node 5
SRAT: PXM 6 ->  APIC 0x0181 ->  Node 6
SRAT: PXM 6 ->  APIC 0x0183 ->  Node 6
SRAT: PXM 6 ->  APIC 0x0185 ->  Node 6
SRAT: PXM 6 ->  APIC 0x0191 ->  Node 6
SRAT: PXM 6 ->  APIC 0x0193 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01a1 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01a3 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01a5 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01b1 ->  Node 6
SRAT: PXM 6 ->  APIC 0x01b3 ->  Node 6
SRAT: PXM 7 ->  APIC 0x01c1 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01c3 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01c5 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01d1 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01d3 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01e1 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01e3 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01e5 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01f1 ->  Node 7
SRAT: PXM 7 ->  APIC 0x01f3 ->  Node 7
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-8080000000
SRAT: Node 1 PXM 1 8080000000-10080000000
SRAT: Node 2 PXM 2 10080000000-18080000000
SRAT: Node 3 PXM 3 18080000000-20080000000
SRAT: Node 4 PXM 4 20080000000-28080000000
SRAT: Node 5 PXM 5 28080000000-30080000000
SRAT: Node 6 PXM 6 30080000000-38080000000
SRAT: Node 7 PXM 7 38080000000-40080000000
NUMA: Initialized distance table, cnt=8
NUMA: Node 0 [0,a0000) + [100000,80000000) ->  [0,80000000)
NUMA: Node 0 [0,80000000) + [100000000,8080000000) ->  [0,8080000000)
Initmem setup node 0 0000000000000000-0000008080000000
 NODE_DATA [000000807ffec000 - 000000807fffffff]
Initmem setup node 1 0000008080000000-0000010080000000
 NODE_DATA [000001007ffec000 - 000001007fffffff]
Initmem setup node 2 0000010080000000-0000018080000000
 NODE_DATA [000001807ffec000 - 000001807fffffff]
Initmem setup node 3 0000018080000000-0000020080000000
 NODE_DATA [000002007ffec000 - 000002007fffffff]
Initmem setup node 4 0000020080000000-0000028080000000
 NODE_DATA [000002807ffec000 - 000002807fffffff]
Initmem setup node 5 0000028080000000-0000030080000000
 NODE_DATA [000003007ffec000 - 000003007fffffff]
Initmem setup node 6 0000030080000000-0000038080000000
 NODE_DATA [000003807ffec000 - 000003807fffffff]
Initmem setup node 7 0000038080000000-0000040080000000
 NODE_DATA [000004007ffeb000 - 000004007fffefff]
 [ffffea0000000000-ffffea01c1bfffff] PMD ->
[ffff887e7fe00000-ffff88803fdfffff] on node 0
 [ffffea01c1c00000-ffffea0381bfffff] PMD ->
[ffff88fe7fe00000-ffff89003fdfffff] on node 1
 [ffffea0381c00000-ffffea0541bfffff] PMD ->
[ffff897e7fe00000-ffff89803fdfffff] on node 2
 [ffffea0541c00000-ffffea0701bfffff] PMD ->
[ffff89fe7fe00000-ffff8a003fdfffff] on node 3
 [ffffea0701c00000-ffffea08c1bfffff] PMD ->
[ffff8a7e7fe00000-ffff8a803fdfffff] on node 4
 [ffffea08c1c00000-ffffea0a81bfffff] PMD ->
[ffff8afe7fe00000-ffff8b003fdfffff] on node 5
 [ffffea0a81c00000-ffffea0c41bfffff] PMD ->
[ffff8b7e7fe00000-ffff8b803fdfffff] on node 6
 [ffffea0c41c00000-ffffea0e01bfffff] PMD ->
[ffff8bfe7f600000-ffff8c003f5fffff] on node 7
Zone PFN ranges:
 DMA      0x00000010 ->  0x00001000
 DMA32    0x00001000 ->  0x00100000
 Normal   0x00100000 ->  0x40080000
Movable zone start PFN for each node
early_node_map[10] active PFN ranges
   0: 0x00000010 ->  0x00000095
   0: 0x00000100 ->  0x0007f750
   0: 0x00100000 ->  0x08080000
   1: 0x08080000 ->  0x10080000
   2: 0x10080000 ->  0x18080000
   3: 0x18080000 ->  0x20080000
   4: 0x20080000 ->  0x28080000
   5: 0x28080000 ->  0x30080000
   6: 0x30080000 ->  0x38080000
   7: 0x38080000 ->  0x40080000
On node 0 totalpages: 134215381
 DMA zone: 56 pages used for memmap
 DMA zone: 5 pages reserved
 DMA zone: 3912 pages, LIFO batch:0
 DMA32 zone: 14280 pages used for memmap
 DMA32 zone: 503688 pages, LIFO batch:31
 Normal zone: 1827840 pages used for memmap
 Normal zone: 131865600 pages, LIFO batch:31
On node 1 totalpages: 134217728
 Normal zone: 1835008 pages used for memmap
 Normal zone: 132382720 pages, LIFO batch:31
On node 2 totalpages: 134217728
 Normal zone: 1835008 pages used for memmap
 Normal zone: 132382720 pages, LIFO batch:31
On node 3 totalpages: 134217728
 Normal zone: 1835008 pages used for memmap
 Normal zone: 132382720 pages, LIFO batch:31
On node 4 totalpages: 134217728
 Normal zone: 1835008 pages used for memmap
 Normal zone: 132382720 pages, LIFO batch:31
On node 5 totalpages: 134217728
 Normal zone: 1835008 pages used for memmap
 Normal zone: 132382720 pages, LIFO batch:31
On node 6 totalpages: 134217728
 Normal zone: 1835008 pages used for memmap
 Normal zone: 132382720 pages, LIFO batch:31
On node 7 totalpages: 134217728
 Normal zone: 1835008 pages used for memmap
 Normal zone: 132382720 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x20] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x22] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x24] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x30] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x32] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x40] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x42] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x44] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x50] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x52] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x60] enabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x62] enabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x64] enabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x70] enabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x72] enabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x80] enabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x82] enabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x84] enabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x90] enabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x92] enabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0xa0] enabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0xa2] enabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0xa4] enabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0xb0] enabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0xb2] enabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0xc0] enabled)
ACPI: LAPIC (acpi_id[0x20] lapic_id[0xc2] enabled)
ACPI: LAPIC (acpi_id[0x21] lapic_id[0xc4] enabled)
ACPI: LAPIC (acpi_id[0x22] lapic_id[0xd0] enabled)
ACPI: LAPIC (acpi_id[0x23] lapic_id[0xd2] enabled)
ACPI: LAPIC (acpi_id[0x24] lapic_id[0xe0] enabled)
ACPI: LAPIC (acpi_id[0x25] lapic_id[0xe2] enabled)
ACPI: LAPIC (acpi_id[0x26] lapic_id[0xe4] enabled)
ACPI: LAPIC (acpi_id[0x27] lapic_id[0xf0] enabled)
ACPI: LAPIC (acpi_id[0x28] lapic_id[0xf2] enabled)
ACPI: X2APIC (apic_id[0x100] uid[0x29] enabled)
ACPI: X2APIC (apic_id[0x102] uid[0x2a] enabled)
ACPI: X2APIC (apic_id[0x104] uid[0x2b] enabled)
ACPI: X2APIC (apic_id[0x110] uid[0x2c] enabled)
ACPI: X2APIC (apic_id[0x112] uid[0x2d] enabled)
ACPI: X2APIC (apic_id[0x120] uid[0x2e] enabled)
ACPI: X2APIC (apic_id[0x122] uid[0x2f] enabled)
ACPI: X2APIC (apic_id[0x124] uid[0x30] enabled)
ACPI: X2APIC (apic_id[0x130] uid[0x31] enabled)
ACPI: X2APIC (apic_id[0x132] uid[0x32] enabled)
ACPI: X2APIC (apic_id[0x140] uid[0x33] enabled)
ACPI: X2APIC (apic_id[0x142] uid[0x34] enabled)
ACPI: X2APIC (apic_id[0x144] uid[0x35] enabled)
ACPI: X2APIC (apic_id[0x150] uid[0x36] enabled)
ACPI: X2APIC (apic_id[0x152] uid[0x37] enabled)
ACPI: X2APIC (apic_id[0x160] uid[0x38] enabled)
ACPI: X2APIC (apic_id[0x162] uid[0x39] enabled)
ACPI: X2APIC (apic_id[0x164] uid[0x3a] enabled)
ACPI: X2APIC (apic_id[0x170] uid[0x3b] enabled)
ACPI: X2APIC (apic_id[0x172] uid[0x3c] enabled)
ACPI: X2APIC (apic_id[0x180] uid[0x3d] enabled)
ACPI: X2APIC (apic_id[0x182] uid[0x3e] enabled)
ACPI: X2APIC (apic_id[0x184] uid[0x3f] enabled)
ACPI: X2APIC (apic_id[0x190] uid[0x40] enabled)
ACPI: X2APIC (apic_id[0x192] uid[0x41] enabled)
ACPI: X2APIC (apic_id[0x1a0] uid[0x42] enabled)
ACPI: X2APIC (apic_id[0x1a2] uid[0x43] enabled)
ACPI: X2APIC (apic_id[0x1a4] uid[0x44] enabled)
ACPI: X2APIC (apic_id[0x1b0] uid[0x45] enabled)
ACPI: X2APIC (apic_id[0x1b2] uid[0x46] enabled)
ACPI: X2APIC (apic_id[0x1c0] uid[0x47] enabled)
ACPI: X2APIC (apic_id[0x1c2] uid[0x48] enabled)
ACPI: X2APIC (apic_id[0x1c4] uid[0x49] enabled)
ACPI: X2APIC (apic_id[0x1d0] uid[0x4a] enabled)
ACPI: X2APIC (apic_id[0x1d2] uid[0x4b] enabled)
ACPI: X2APIC (apic_id[0x1e0] uid[0x4c] enabled)
ACPI: X2APIC (apic_id[0x1e2] uid[0x4d] enabled)
ACPI: X2APIC (apic_id[0x1e4] uid[0x4e] enabled)
ACPI: X2APIC (apic_id[0x1f0] uid[0x4f] enabled)
ACPI: X2APIC (apic_id[0x1f2] uid[0x50] enabled)
ACPI: LAPIC (acpi_id[0x51] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x52] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x53] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x54] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x55] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x56] lapic_id[0x21] enabled)
ACPI: LAPIC (acpi_id[0x57] lapic_id[0x23] enabled)
ACPI: LAPIC (acpi_id[0x58] lapic_id[0x25] enabled)
ACPI: LAPIC (acpi_id[0x59] lapic_id[0x31] enabled)
ACPI: LAPIC (acpi_id[0x5a] lapic_id[0x33] enabled)
ACPI: LAPIC (acpi_id[0x5b] lapic_id[0x41] enabled)
ACPI: LAPIC (acpi_id[0x5c] lapic_id[0x43] enabled)
ACPI: LAPIC (acpi_id[0x5d] lapic_id[0x45] enabled)
ACPI: LAPIC (acpi_id[0x5e] lapic_id[0x51] enabled)
ACPI: LAPIC (acpi_id[0x5f] lapic_id[0x53] enabled)
ACPI: LAPIC (acpi_id[0x60] lapic_id[0x61] enabled)
ACPI: LAPIC (acpi_id[0x61] lapic_id[0x63] enabled)
ACPI: LAPIC (acpi_id[0x62] lapic_id[0x65] enabled)
ACPI: LAPIC (acpi_id[0x63] lapic_id[0x71] enabled)
ACPI: LAPIC (acpi_id[0x64] lapic_id[0x73] enabled)
ACPI: LAPIC (acpi_id[0x65] lapic_id[0x81] enabled)
ACPI: LAPIC (acpi_id[0x66] lapic_id[0x83] enabled)
ACPI: LAPIC (acpi_id[0x67] lapic_id[0x85] enabled)
ACPI: LAPIC (acpi_id[0x68] lapic_id[0x91] enabled)
ACPI: LAPIC (acpi_id[0x69] lapic_id[0x93] enabled)
ACPI: LAPIC (acpi_id[0x6a] lapic_id[0xa1] enabled)
ACPI: LAPIC (acpi_id[0x6b] lapic_id[0xa3] enabled)
ACPI: LAPIC (acpi_id[0x6c] lapic_id[0xa5] enabled)
ACPI: LAPIC (acpi_id[0x6d] lapic_id[0xb1] enabled)
ACPI: LAPIC (acpi_id[0x6e] lapic_id[0xb3] enabled)
ACPI: LAPIC (acpi_id[0x6f] lapic_id[0xc1] enabled)
ACPI: LAPIC (acpi_id[0x70] lapic_id[0xc3] enabled)
ACPI: LAPIC (acpi_id[0x71] lapic_id[0xc5] enabled)
ACPI: LAPIC (acpi_id[0x72] lapic_id[0xd1] enabled)
ACPI: LAPIC (acpi_id[0x73] lapic_id[0xd3] enabled)
ACPI: LAPIC (acpi_id[0x74] lapic_id[0xe1] enabled)
ACPI: LAPIC (acpi_id[0x75] lapic_id[0xe3] enabled)
ACPI: LAPIC (acpi_id[0x76] lapic_id[0xe5] enabled)
ACPI: LAPIC (acpi_id[0x77] lapic_id[0xf1] enabled)
ACPI: LAPIC (acpi_id[0x78] lapic_id[0xf3] enabled)
ACPI: X2APIC (apic_id[0x101] uid[0x79] enabled)
ACPI: X2APIC (apic_id[0x103] uid[0x7a] enabled)
ACPI: X2APIC (apic_id[0x105] uid[0x7b] enabled)
ACPI: X2APIC (apic_id[0x111] uid[0x7c] enabled)
ACPI: X2APIC (apic_id[0x113] uid[0x7d] enabled)
ACPI: X2APIC (apic_id[0x121] uid[0x7e] enabled)
ACPI: X2APIC (apic_id[0x123] uid[0x7f] enabled)
ACPI: X2APIC (apic_id[0x125] uid[0x80] enabled)
ACPI: X2APIC (apic_id[0x131] uid[0x81] enabled)
ACPI: X2APIC (apic_id[0x133] uid[0x82] enabled)
ACPI: X2APIC (apic_id[0x141] uid[0x83] enabled)
ACPI: X2APIC (apic_id[0x143] uid[0x84] enabled)
ACPI: X2APIC (apic_id[0x145] uid[0x85] enabled)
ACPI: X2APIC (apic_id[0x151] uid[0x86] enabled)
ACPI: X2APIC (apic_id[0x153] uid[0x87] enabled)
ACPI: X2APIC (apic_id[0x161] uid[0x88] enabled)
ACPI: X2APIC (apic_id[0x163] uid[0x89] enabled)
ACPI: X2APIC (apic_id[0x165] uid[0x8a] enabled)
ACPI: X2APIC (apic_id[0x171] uid[0x8b] enabled)
ACPI: X2APIC (apic_id[0x173] uid[0x8c] enabled)
ACPI: X2APIC (apic_id[0x181] uid[0x8d] enabled)
ACPI: X2APIC (apic_id[0x183] uid[0x8e] enabled)
ACPI: X2APIC (apic_id[0x185] uid[0x8f] enabled)
ACPI: X2APIC (apic_id[0x191] uid[0x90] enabled)
ACPI: X2APIC (apic_id[0x193] uid[0x91] enabled)
ACPI: X2APIC (apic_id[0x1a1] uid[0x92] enabled)
ACPI: X2APIC (apic_id[0x1a3] uid[0x93] enabled)
ACPI: X2APIC (apic_id[0x1a5] uid[0x94] enabled)
ACPI: X2APIC (apic_id[0x1b1] uid[0x95] enabled)
ACPI: X2APIC (apic_id[0x1b3] uid[0x96] enabled)
ACPI: X2APIC (apic_id[0x1c1] uid[0x97] enabled)
ACPI: X2APIC (apic_id[0x1c3] uid[0x98] enabled)
ACPI: X2APIC (apic_id[0x1c5] uid[0x99] enabled)
ACPI: X2APIC (apic_id[0x1d1] uid[0x9a] enabled)
ACPI: X2APIC (apic_id[0x1d3] uid[0x9b] enabled)
ACPI: X2APIC (apic_id[0x1e1] uid[0x9c] enabled)
ACPI: X2APIC (apic_id[0x1e3] uid[0x9d] enabled)
ACPI: X2APIC (apic_id[0x1e5] uid[0x9e] enabled)
ACPI: X2APIC (apic_id[0x1f1] uid[0x9f] enabled)
ACPI: X2APIC (apic_id[0x1f3] uid[0xa0] enabled)
ACPI: X2APIC_NMI (uid[0xffffffff] high edge lint[0x1])
ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 6, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x07] address[0xfec02000] gsi_base[24])
IOAPIC[1]: apic_id 7, version 32, address 0xfec02000, GSI 24-47
ACPI: IOAPIC (id[0x08] address[0xfec04000] gsi_base[48])
IOAPIC[2]: apic_id 8, version 32, address 0xfec04000, GSI 48-71
ACPI: IOAPIC (id[0x09] address[0xfec08000] gsi_base[72])
IOAPIC[3]: apic_id 9, version 32, address 0xfec08000, GSI 72-95
ACPI: IOAPIC (id[0x0a] address[0xfec0c000] gsi_base[96])
IOAPIC[4]: apic_id 10, version 32, address 0xfec0c000, GSI 96-119
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 160 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 136
PM: Registered nosave memory: 0000000000095000 - 0000000000096000
PM: Registered nosave memory: 0000000000096000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 000000007f750000 - 000000007f75e000
PM: Registered nosave memory: 000000007f75e000 - 000000007f760000
PM: Registered nosave memory: 000000007f760000 - 000000007f76e000
PM: Registered nosave memory: 000000007f76e000 - 000000007f7d0000
PM: Registered nosave memory: 000000007f7d0000 - 000000007f7e0000
PM: Registered nosave memory: 000000007f7e0000 - 000000007f7ec000
PM: Registered nosave memory: 000000007f7ec000 - 0000000090000000
PM: Registered nosave memory: 0000000090000000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ffc00000
PM: Registered nosave memory: 00000000ffc00000 - 0000000100000000
Allocating PCI resources starting at 90000000 (gap: 90000000:6ee00000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:160 nr_node_ids:8
PERCPU: Embedded 26 pages/cpu @ffff88807f800000 s76672 r8192 d21632 u262144
pcpu-alloc: s76672 r8192 d21632 u262144 alloc=1*2097152
pcpu-alloc: [0] 000 001 002 003 004 005 006 007
pcpu-alloc: [0] 008 009 080 081 082 083 084 085
pcpu-alloc: [0] 086 087 088 089 --- --- --- ---
pcpu-alloc: [1] 010 011 012 013 014 015 016 017
pcpu-alloc: [1] 018 019 090 091 092 093 094 095
pcpu-alloc: [1] 096 097 098 099 --- --- --- ---
pcpu-alloc: [2] 020 021 022 023 024 025 026 027
pcpu-alloc: [2] 028 029 100 101 102 103 104 105
pcpu-alloc: [2] 106 107 108 109 --- --- --- ---
pcpu-alloc: [3] 030 031 032 033 034 035 036 037
pcpu-alloc: [3] 038 039 110 111 112 113 114 115
pcpu-alloc: [3] 116 117 118 119 --- --- --- ---
pcpu-alloc: [4] 040 041 042 043 044 045 046 047
pcpu-alloc: [4] 048 049 120 121 122 123 124 125
pcpu-alloc: [4] 126 127 128 129 --- --- --- ---
pcpu-alloc: [5] 050 051 052 053 054 055 056 057
pcpu-alloc: [5] 058 059 130 131 132 133 134 135
pcpu-alloc: [5] 136 137 138 139 --- --- --- ---
pcpu-alloc: [6] 060 061 062 063 064 065 066 067
pcpu-alloc: [6] 068 069 140 141 142 143 144 145
pcpu-alloc: [6] 146 147 148 149 --- --- --- ---
pcpu-alloc: [7] 070 071 072 073 074 075 076 077
pcpu-alloc: [7] 078 079 150 151 152 153 154 155
pcpu-alloc: [7] 156 157 158 159 --- --- --- ---
Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 1059052240
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg0-lv0 intel_iommu=on
rd_NO_LUKS LANG=en_US.UTF-8 rd_LVM_LV=vg0/lv1 rd_LVM_LV=vg0/lv0
rd_NO_MD SYSFONT=latarcyrheb-sun16  KEYBOARDTYPE=pc KEYTABLE=us
rd_NO_DM rd_NO_LUKS LANG=en_US.UTF-8 rd_LVM_LV=vg0/lv1
rd_LVM_LV=vg0/lv0 rd_NO_MD SYSFONT=latarcyrheb-sun16 KEYBOARDTYPE=pc
KEYTABLE=us rd_NO_DM
Intel-IOMMU: enabled
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Queued invalidation will be enabled to support x2apic and Intr-remapping.
Memory: 4236113664k/4297064448k available (5149k kernel code, 2106540k
absent, 58844244k reserved, 3745k data, 1144k init)
Hierarchical RCU implementation.
NR_IRQS:16640 nr_irqs:3592 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
allocated 34359738368 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2393.748 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4787.49 BogoMIPS (lpj=2393748)
pid_max: default: 163840 minimum: 1280
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 536870912 (order: 20, 4294967296 bytes)
Inode-cache hash table entries: 268435456 (order: 19, 2147483648 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
mce: CPU supports 24 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20110413
ftrace: allocating 20923 entries in 83 pages
DMAR: Host address width 46
DMAR: DRHD base: 0x000000f8efe000 flags: 0x0
IOMMU 0: reg_base_addr f8efe000 ver 1:0 cap c90780106f0462 ecap f020fe
DMAR: DRHD base: 0x000000ecefe000 flags: 0x0
IOMMU 1: reg_base_addr ecefe000 ver 1:0 cap c90780106f0462 ecap f020fe
DMAR: DRHD base: 0x000000ccefe000 flags: 0x0
IOMMU 2: reg_base_addr ccefe000 ver 1:0 cap c90780106f0462 ecap f020fe
DMAR: DRHD base: 0x000000ac3fe000 flags: 0x1
IOMMU 3: reg_base_addr ac3fe000 ver 1:0 cap c90780106f0462 ecap f020fe
DMAR: RMRR base: 0x000000000ec000 end: 0x000000000effff
DMAR: RMRR base: 0x0000007f7ec000 end: 0x0000007f7fffff
DMAR: ATSR flags: 0x0
IOAPIC id 8 under DRHD base  0xccefe000 IOMMU 2
IOAPIC id 9 under DRHD base  0xecefe000 IOMMU 1
IOAPIC id 10 under DRHD base  0xf8efe000 IOMMU 0
IOAPIC id 6 under DRHD base  0xac3fe000 IOMMU 3
IOAPIC id 7 under DRHD base  0xac3fe000 IOMMU 3
Enabled Interrupt-remapping
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU E7- 8870  @ 2.40GHz stepping 02
Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #2
smpboot cpu 2: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #3
smpboot cpu 3: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #4
smpboot cpu 4: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #5
smpboot cpu 5: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #6
smpboot cpu 6: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #7
smpboot cpu 7: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #8
smpboot cpu 8: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #9
smpboot cpu 9: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   1, Processors  #10
smpboot cpu 10: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #11
smpboot cpu 11: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #12
smpboot cpu 12: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #13
smpboot cpu 13: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #14
smpboot cpu 14: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #15
smpboot cpu 15: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #16
smpboot cpu 16: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #17
smpboot cpu 17: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #18
smpboot cpu 18: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #19
smpboot cpu 19: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   2, Processors  #20
smpboot cpu 20: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #21
smpboot cpu 21: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #22
smpboot cpu 22: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #23
smpboot cpu 23: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #24
smpboot cpu 24: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #25
smpboot cpu 25: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #26
smpboot cpu 26: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #27
smpboot cpu 27: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #28
smpboot cpu 28: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #29
smpboot cpu 29: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   3, Processors  #30
smpboot cpu 30: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #31
smpboot cpu 31: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #32
smpboot cpu 32: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #33
smpboot cpu 33: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #34
smpboot cpu 34: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #35
smpboot cpu 35: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #36
smpboot cpu 36: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #37
smpboot cpu 37: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #38
smpboot cpu 38: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #39
smpboot cpu 39: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   4, Processors  #40
smpboot cpu 40: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #41
smpboot cpu 41: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #42
smpboot cpu 42: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #43
smpboot cpu 43: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #44
smpboot cpu 44: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #45
smpboot cpu 45: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #46
smpboot cpu 46: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #47
smpboot cpu 47: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #48
smpboot cpu 48: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #49
smpboot cpu 49: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   5, Processors  #50
smpboot cpu 50: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #51
smpboot cpu 51: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #52
smpboot cpu 52: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #53
smpboot cpu 53: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #54
smpboot cpu 54: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #55
smpboot cpu 55: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #56
smpboot cpu 56: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #57
smpboot cpu 57: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #58
smpboot cpu 58: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #59
smpboot cpu 59: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   6, Processors  #60
smpboot cpu 60: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #61
smpboot cpu 61: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #62
smpboot cpu 62: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #63
smpboot cpu 63: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #64
smpboot cpu 64: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #65
smpboot cpu 65: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #66
smpboot cpu 66: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #67
smpboot cpu 67: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #68
smpboot cpu 68: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #69
smpboot cpu 69: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   7, Processors  #70
smpboot cpu 70: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #71
smpboot cpu 71: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #72
smpboot cpu 72: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #73
smpboot cpu 73: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #74
smpboot cpu 74: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #75
smpboot cpu 75: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #76
smpboot cpu 76: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #77
smpboot cpu 77: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #78
smpboot cpu 78: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #79
smpboot cpu 79: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   0, Processors  #80
smpboot cpu 80: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #81
smpboot cpu 81: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #82
smpboot cpu 82: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #83
smpboot cpu 83: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #84
smpboot cpu 84: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #85
smpboot cpu 85: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #86
smpboot cpu 86: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #87
smpboot cpu 87: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #88
smpboot cpu 88: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #89
smpboot cpu 89: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   1, Processors  #90
smpboot cpu 90: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #91
smpboot cpu 91: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #92
smpboot cpu 92: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #93
smpboot cpu 93: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #94
smpboot cpu 94: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #95
smpboot cpu 95: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #96
smpboot cpu 96: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #97
smpboot cpu 97: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #98
smpboot cpu 98: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #99
smpboot cpu 99: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   2, Processors  #100
smpboot cpu 100: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #101
smpboot cpu 101: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #102
smpboot cpu 102: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #103
smpboot cpu 103: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #104
smpboot cpu 104: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #105
smpboot cpu 105: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #106
smpboot cpu 106: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #107
smpboot cpu 107: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #108
smpboot cpu 108: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #109
smpboot cpu 109: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   3, Processors  #110
smpboot cpu 110: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #111
smpboot cpu 111: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #112
smpboot cpu 112: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #113
smpboot cpu 113: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #114
smpboot cpu 114: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #115
smpboot cpu 115: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #116
smpboot cpu 116: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #117
smpboot cpu 117: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #118
smpboot cpu 118: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #119
smpboot cpu 119: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   4, Processors  #120
smpboot cpu 120: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #121
smpboot cpu 121: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #122
smpboot cpu 122: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #123
smpboot cpu 123: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #124
smpboot cpu 124: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #125
smpboot cpu 125: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #126
smpboot cpu 126: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #127
smpboot cpu 127: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #128
smpboot cpu 128: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #129
smpboot cpu 129: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   5, Processors  #130
smpboot cpu 130: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #131
smpboot cpu 131: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #132
smpboot cpu 132: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #133
smpboot cpu 133: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #134
smpboot cpu 134: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #135
smpboot cpu 135: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #136
smpboot cpu 136: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #137
smpboot cpu 137: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #138
smpboot cpu 138: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #139
smpboot cpu 139: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   6, Processors  #140
smpboot cpu 140: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #141
smpboot cpu 141: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #142
smpboot cpu 142: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #143
smpboot cpu 143: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #144
smpboot cpu 144: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #145
smpboot cpu 145: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #146
smpboot cpu 146: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #147
smpboot cpu 147: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #148
smpboot cpu 148: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #149
smpboot cpu 149: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 Ok.
Booting Node   7, Processors  #150
smpboot cpu 150: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #151
smpboot cpu 151: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #152
smpboot cpu 152: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #153
smpboot cpu 153: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #154
smpboot cpu 154: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #155
smpboot cpu 155: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #156
smpboot cpu 156: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #157
smpboot cpu 157: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #158
smpboot cpu 158: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
 #159 Ok.
smpboot cpu 159: start_ip = 90000
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 160 CPUs
Total of 160 processors activated (766679.34 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region at 7f76e000 (401408 bytes)
print_constraints: dummy:
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0x80000000-0x8fffffff] (base 0x80000000)
PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab<bio-0>  at 0
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 000000007f76e450 07E80 (v01 SUN    CPU_PST  00000011 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 07E80 (v01 SUN    CPU_PST  00000011 INTL 20051117)
ACPI: SSDT 000000007f7762d0 14D7B (v01 SUN     CPU_CST 00003001 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 14D7B (v01 SUN     CPU_CST 00003001 INTL 20051117)
ACPI: SSDT 000000007f78b050 04E12 (v01 SUN     CPU_TST 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 04E12 (v01 SUN     CPU_TST 00003000 INTL 20051117)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
HEST: Table parsing has been initialized.
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x3fff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
pci_root PNP0A08:00: host bridge window [mem 0x90000000-0xafffffff]
pci_root PNP0A08:00: host bridge window [mem 0xfc000000000-0xfc07fffffff pref]
pci_root PNP0A08:00: address space collision: host bridge window [mem
0x000d0000-0x000dffff] conflicts with Adapter ROM [mem
0x000cf800-0x000d07ff]
pci 0000:00:00.0: [8086:3407] type 0 class 0x000600
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:05.0: [8086:340c] type 1 class 0x000604
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:09.0: [8086:3410] type 1 class 0x000604
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
pci 0000:00:1a.0: reg 20: [io  0x0a00-0x0a1f]
pci 0000:00:1a.1: [8086:3a38] type 0 class 0x000c03
pci 0000:00:1a.1: reg 20: [io  0x0c00-0x0c1f]
pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
pci 0000:00:1a.2: reg 20: [io  0x0e00-0x0e1f]
pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
pci 0000:00:1a.7: reg 10: [mem 0xaf0fa000-0xaf0fa3ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x0200-0x021f]
pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x0600-0x061f]
pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x0880-0x089f]
pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xaf0f8000-0xaf0f83ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
pci 0000:00:1f.0: [8086:3a18] type 0 class 0x000601
pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x0d80-0x0d87]
pci 0000:00:1f.2: reg 14: [io  0x0d00-0x0d03]
pci 0000:00:1f.2: reg 18: [io  0x0b00-0x0b07]
pci 0000:00:1f.2: reg 1c: [io  0x0a80-0x0a83]
pci 0000:00:1f.2: reg 20: [io  0x0980-0x099f]
pci 0000:00:1f.2: reg 24: [mem 0xaf0f4000-0xaf0f47ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xaf0f6000-0xaf0f60ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
pci 0000:01:00.0: [1000:0079] type 0 class 0x000104
pci 0000:01:00.0: reg 10: [io  0x1c00-0x1cff]
pci 0000:01:00.0: reg 14: [mem 0xac4fc000-0xac4fffff 64bit]
pci 0000:01:00.0: reg 1c: [mem 0xac480000-0xac4bffff 64bit]
pci 0000:01:00.0: reg 30: [mem 0xac460000-0xac47ffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:01.0:   bridge window [mem 0xac400000-0xac4fffff]
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:03.0: PCI bridge to [bus 02-07]
pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xac500000-0xad4fffff]
pci 0000:00:03.0:   bridge window [mem 0xaa000000-0xaaffffff 64bit pref]
pci 0000:00:05.0: PCI bridge to [bus 08-0d]
pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:05.0:   bridge window [mem 0xad500000-0xae4fffff]
pci 0000:00:05.0:   bridge window [mem 0xab000000-0xabffffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 0e-0e]
pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:09.0: PCI bridge to [bus 0f-0f]
pci 0000:00:09.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:10:00.0: [8086:10c9] type 0 class 0x000200
pci 0000:10:00.0: reg 10: [mem 0xae5e0000-0xae5fffff]
pci 0000:10:00.0: reg 14: [mem 0xae5c0000-0xae5dffff]
pci 0000:10:00.0: reg 18: [io  0x2c80-0x2c9f]
pci 0000:10:00.0: reg 1c: [mem 0xae5bc000-0xae5bffff]
pci 0000:10:00.0: reg 30: [mem 0xae580000-0xae59ffff pref]
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:10:00.0: reg 184: [mem 0xae620000-0xae623fff 64bit]
pci 0000:10:00.0: reg 190: [mem 0xae600000-0xae603fff 64bit]
pci 0000:10:00.1: [8086:10c9] type 0 class 0x000200
pci 0000:10:00.1: reg 10: [mem 0xae6a0000-0xae6bffff]
pci 0000:10:00.1: reg 14: [mem 0xae680000-0xae69ffff]
pci 0000:10:00.1: reg 18: [io  0x2e00-0x2e1f]
pci 0000:10:00.1: reg 1c: [mem 0xae67c000-0xae67ffff]
pci 0000:10:00.1: reg 30: [mem 0xae640000-0xae65ffff pref]
pci 0000:10:00.1: PME# supported from D0 D3hot D3cold
pci 0000:10:00.1: PME# disabled
pci 0000:10:00.1: reg 184: [mem 0xae6e0000-0xae6e3fff 64bit]
pci 0000:10:00.1: reg 190: [mem 0xae6c0000-0xae6c3fff 64bit]
pci 0000:00:1c.0: PCI bridge to [bus 10-11]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xae500000-0xae6fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:12:05.0: [1a03:2000] type 0 class 0x000300
pci 0000:12:05.0: reg 10: [mem 0xae800000-0xaeffffff]
pci 0000:12:05.0: reg 14: [mem 0xae7e0000-0xae7fffff]
pci 0000:12:05.0: reg 18: [io  0x3e00-0x3e7f]
pci 0000:12:05.0: supports D1 D2
pci 0000:12:05.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:12:05.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 12-12] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xae700000-0xaeffffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x3fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xafffffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xfc000000000-0xfc07fffffff
pref] (subtractive decode)
pci_bus 0000:00: on NUMA node 0 (pxm 0)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Root Bridge [PCIB] (domain 0000 [bus 40-7f])
pci_root PNP0A08:01: host bridge window [io  0x4000-0x7fff]
pci_root PNP0A08:01: host bridge window [mem 0xb0000000-0xcfffffff]
pci_root PNP0A08:01: host bridge window [mem 0xfc080000000-0xfc0ffffffff pref]
pci 0000:40:00.0: [8086:3420] type 1 class 0x000604
pci 0000:40:00.0: PME# supported from D0 D3hot D3cold
pci 0000:40:00.0: PME# disabled
pci 0000:40:01.0: [8086:3408] type 1 class 0x000604
pci 0000:40:01.0: PME# supported from D0 D3hot D3cold
pci 0000:40:01.0: PME# disabled
pci 0000:40:03.0: [8086:340a] type 1 class 0x000604
pci 0000:40:03.0: PME# supported from D0 D3hot D3cold
pci 0000:40:03.0: PME# disabled
pci 0000:40:05.0: [8086:340c] type 1 class 0x000604
pci 0000:40:05.0: PME# supported from D0 D3hot D3cold
pci 0000:40:05.0: PME# disabled
pci 0000:40:07.0: [8086:340e] type 1 class 0x000604
pci 0000:40:07.0: PME# supported from D0 D3hot D3cold
pci 0000:40:07.0: PME# disabled
pci 0000:40:09.0: [8086:3410] type 1 class 0x000604
pci 0000:40:09.0: PME# supported from D0 D3hot D3cold
pci 0000:40:09.0: PME# disabled
pci 0000:40:14.0: [8086:342e] type 0 class 0x000800
pci 0000:40:14.3: [8086:3438] type 0 class 0x000800
pci 0000:41:00.0: [8086:10c9] type 0 class 0x000200
pci 0000:41:00.0: reg 10: [mem 0xccfe0000-0xccffffff]
pci 0000:41:00.0: reg 14: [mem 0xccfc0000-0xccfdffff]
pci 0000:41:00.0: reg 18: [io  0x5c80-0x5c9f]
pci 0000:41:00.0: reg 1c: [mem 0xccfbc000-0xccfbffff]
pci 0000:41:00.0: reg 30: [mem 0xccf80000-0xccf9ffff pref]
pci 0000:41:00.0: PME# supported from D0 D3hot D3cold
pci 0000:41:00.0: PME# disabled
pci 0000:41:00.0: reg 184: [mem 0xcd020000-0xcd023fff 64bit]
pci 0000:41:00.0: reg 190: [mem 0xcd000000-0xcd003fff 64bit]
pci 0000:41:00.1: [8086:10c9] type 0 class 0x000200
pci 0000:41:00.1: reg 10: [mem 0xcd0a0000-0xcd0bffff]
pci 0000:41:00.1: reg 14: [mem 0xcd080000-0xcd09ffff]
pci 0000:41:00.1: reg 18: [io  0x5e00-0x5e1f]
pci 0000:41:00.1: reg 1c: [mem 0xcd07c000-0xcd07ffff]
pci 0000:41:00.1: reg 30: [mem 0xcd040000-0xcd05ffff pref]
pci 0000:41:00.1: PME# supported from D0 D3hot D3cold
pci 0000:41:00.1: PME# disabled
pci 0000:41:00.1: reg 184: [mem 0xcd0e0000-0xcd0e3fff 64bit]
pci 0000:41:00.1: reg 190: [mem 0xcd0c0000-0xcd0c3fff 64bit]
pci 0000:40:00.0: PCI bridge to [bus 41-42]
pci 0000:40:00.0:   bridge window [io  0x5000-0x5fff]
pci 0000:40:00.0:   bridge window [mem 0xccf00000-0xcd0fffff]
pci 0000:40:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:40:01.0: PCI bridge to [bus 43-43]
pci 0000:40:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:40:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:40:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:40:03.0: PCI bridge to [bus 44-49]
pci 0000:40:03.0:   bridge window [io  0x6000-0x6fff]
pci 0000:40:03.0:   bridge window [mem 0xcd100000-0xce0fffff]
pci 0000:40:03.0:   bridge window [mem 0xca000000-0xcaffffff 64bit pref]
pci 0000:40:05.0: PCI bridge to [bus 4a-4f]
pci 0000:40:05.0:   bridge window [io  0x7000-0x7fff]
pci 0000:40:05.0:   bridge window [mem 0xce100000-0xcf0fffff]
pci 0000:40:05.0:   bridge window [mem 0xcb000000-0xcbffffff 64bit pref]
pci 0000:40:07.0: PCI bridge to [bus 50-50]
pci 0000:40:07.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:40:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:40:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:40:09.0: PCI bridge to [bus 51-51]
pci 0000:40:09.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:40:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:40:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:40: on NUMA node 2 (pxm 2)
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.NPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.NPE5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.NPE7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.NPE9._PRT]
 pci0000:40: Requesting ACPI _OSC control (0x1d)
 pci0000:40: ACPI _OSC control (0x1d) granted
ACPI: PCI Root Bridge [PCIC] (domain 0000 [bus 80-bf])
pci_root PNP0A08:02: host bridge window [io  0x8000-0xbfff]
pci_root PNP0A08:02: host bridge window [mem 0xd0000000-0xefffffff]
pci_root PNP0A08:02: host bridge window [mem 0xfc100000000-0xfc17fffffff pref]
pci 0000:80:00.0: [8086:3420] type 1 class 0x000604
pci 0000:80:00.0: PME# supported from D0 D3hot D3cold
pci 0000:80:00.0: PME# disabled
pci 0000:80:01.0: [8086:3408] type 1 class 0x000604
pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
pci 0000:80:01.0: PME# disabled
pci 0000:80:03.0: [8086:340a] type 1 class 0x000604
pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
pci 0000:80:03.0: PME# disabled
pci 0000:80:05.0: [8086:340c] type 1 class 0x000604
pci 0000:80:05.0: PME# supported from D0 D3hot D3cold
pci 0000:80:05.0: PME# disabled
pci 0000:80:07.0: [8086:340e] type 1 class 0x000604
pci 0000:80:07.0: PME# supported from D0 D3hot D3cold
pci 0000:80:07.0: PME# disabled
pci 0000:80:09.0: [8086:3410] type 1 class 0x000604
pci 0000:80:09.0: PME# supported from D0 D3hot D3cold
pci 0000:80:09.0: PME# disabled
pci 0000:80:14.0: [8086:342e] type 0 class 0x000800
pci 0000:80:14.3: [8086:3438] type 0 class 0x000800
pci 0000:81:00.0: [8086:10c9] type 0 class 0x000200
pci 0000:81:00.0: reg 10: [mem 0xecfe0000-0xecffffff]
pci 0000:81:00.0: reg 14: [mem 0xecfc0000-0xecfdffff]
pci 0000:81:00.0: reg 18: [io  0x9c80-0x9c9f]
pci 0000:81:00.0: reg 1c: [mem 0xecfbc000-0xecfbffff]
pci 0000:81:00.0: reg 30: [mem 0xecf80000-0xecf9ffff pref]
pci 0000:81:00.0: PME# supported from D0 D3hot D3cold
pci 0000:81:00.0: PME# disabled
pci 0000:81:00.0: reg 184: [mem 0xed020000-0xed023fff 64bit]
pci 0000:81:00.0: reg 190: [mem 0xed000000-0xed003fff 64bit]
pci 0000:81:00.1: [8086:10c9] type 0 class 0x000200
pci 0000:81:00.1: reg 10: [mem 0xed0a0000-0xed0bffff]
pci 0000:81:00.1: reg 14: [mem 0xed080000-0xed09ffff]
pci 0000:81:00.1: reg 18: [io  0x9e00-0x9e1f]
pci 0000:81:00.1: reg 1c: [mem 0xed07c000-0xed07ffff]
pci 0000:81:00.1: reg 30: [mem 0xed040000-0xed05ffff pref]
pci 0000:81:00.1: PME# supported from D0 D3hot D3cold
pci 0000:81:00.1: PME# disabled
pci 0000:81:00.1: reg 184: [mem 0xed0e0000-0xed0e3fff 64bit]
pci 0000:81:00.1: reg 190: [mem 0xed0c0000-0xed0c3fff 64bit]
pci 0000:80:00.0: PCI bridge to [bus 81-82]
pci 0000:80:00.0:   bridge window [io  0x9000-0x9fff]
pci 0000:80:00.0:   bridge window [mem 0xecf00000-0xed0fffff]
pci 0000:80:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:80:01.0: PCI bridge to [bus 83-83]
pci 0000:80:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:80:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:80:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:80:03.0: PCI bridge to [bus 84-89]
pci 0000:80:03.0:   bridge window [io  0xa000-0xafff]
pci 0000:80:03.0:   bridge window [mem 0xed100000-0xee0fffff]
pci 0000:80:03.0:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
pci 0000:80:05.0: PCI bridge to [bus 8a-8f]
pci 0000:80:05.0:   bridge window [io  0xb000-0xbfff]
pci 0000:80:05.0:   bridge window [mem 0xee100000-0xef0fffff]
pci 0000:80:05.0:   bridge window [mem 0xeb000000-0xebffffff 64bit pref]
pci 0000:80:07.0: PCI bridge to [bus 90-90]
pci 0000:80:07.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:80:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:80:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:80:09.0: PCI bridge to [bus 91-91]
pci 0000:80:09.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:80:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:80:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:80: on NUMA node 4 (pxm 4)
ACPI: PCI Interrupt Routing Table [\_SB_.PCIC._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIC.NPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIC.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIC.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIC.NPE5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIC.NPE7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIC.NPE9._PRT]
 pci0000:80: Requesting ACPI _OSC control (0x1d)
 pci0000:80: ACPI _OSC control (0x1d) granted
ACPI: PCI Root Bridge [PCID] (domain 0000 [bus c0-f7])
pci_root PNP0A08:03: host bridge window [io  0xc000-0xffff]
pci_root PNP0A08:03: host bridge window [mem 0xf0000000-0xfbffffff]
pci_root PNP0A08:03: host bridge window [mem 0xfc180000000-0xfc1ffffffff pref]
pci 0000:c0:00.0: [8086:3420] type 1 class 0x000604
pci 0000:c0:00.0: PME# supported from D0 D3hot D3cold
pci 0000:c0:00.0: PME# disabled
pci 0000:c0:01.0: [8086:3408] type 1 class 0x000604
pci 0000:c0:01.0: PME# supported from D0 D3hot D3cold
pci 0000:c0:01.0: PME# disabled
pci 0000:c0:03.0: [8086:340a] type 1 class 0x000604
pci 0000:c0:03.0: PME# supported from D0 D3hot D3cold
pci 0000:c0:03.0: PME# disabled
pci 0000:c0:05.0: [8086:340c] type 1 class 0x000604
pci 0000:c0:05.0: PME# supported from D0 D3hot D3cold
pci 0000:c0:05.0: PME# disabled
pci 0000:c0:07.0: [8086:340e] type 1 class 0x000604
pci 0000:c0:07.0: PME# supported from D0 D3hot D3cold
pci 0000:c0:07.0: PME# disabled
pci 0000:c0:09.0: [8086:3410] type 1 class 0x000604
pci 0000:c0:09.0: PME# supported from D0 D3hot D3cold
pci 0000:c0:09.0: PME# disabled
pci 0000:c0:14.0: [8086:342e] type 0 class 0x000800
pci 0000:c0:14.3: [8086:3438] type 0 class 0x000800
pci 0000:c1:00.0: [8086:10c9] type 0 class 0x000200
pci 0000:c1:00.0: reg 10: [mem 0xf8fe0000-0xf8ffffff]
pci 0000:c1:00.0: reg 14: [mem 0xf8fc0000-0xf8fdffff]
pci 0000:c1:00.0: reg 18: [io  0xdc80-0xdc9f]
pci 0000:c1:00.0: reg 1c: [mem 0xf8fbc000-0xf8fbffff]
pci 0000:c1:00.0: reg 30: [mem 0xf8f80000-0xf8f9ffff pref]
pci 0000:c1:00.0: PME# supported from D0 D3hot D3cold
pci 0000:c1:00.0: PME# disabled
pci 0000:c1:00.0: reg 184: [mem 0xf9020000-0xf9023fff 64bit]
pci 0000:c1:00.0: reg 190: [mem 0xf9000000-0xf9003fff 64bit]
pci 0000:c1:00.1: [8086:10c9] type 0 class 0x000200
pci 0000:c1:00.1: reg 10: [mem 0xf90a0000-0xf90bffff]
pci 0000:c1:00.1: reg 14: [mem 0xf9080000-0xf909ffff]
pci 0000:c1:00.1: reg 18: [io  0xde00-0xde1f]
pci 0000:c1:00.1: reg 1c: [mem 0xf907c000-0xf907ffff]
pci 0000:c1:00.1: reg 30: [mem 0xf9040000-0xf905ffff pref]
pci 0000:c1:00.1: PME# supported from D0 D3hot D3cold
pci 0000:c1:00.1: PME# disabled
pci 0000:c1:00.1: reg 184: [mem 0xf90e0000-0xf90e3fff 64bit]
pci 0000:c1:00.1: reg 190: [mem 0xf90c0000-0xf90c3fff 64bit]
pci 0000:c0:00.0: PCI bridge to [bus c1-c2]
pci 0000:c0:00.0:   bridge window [io  0xd000-0xdfff]
pci 0000:c0:00.0:   bridge window [mem 0xf8f00000-0xf90fffff]
pci 0000:c0:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:c0:01.0: PCI bridge to [bus c3-c3]
pci 0000:c0:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:c0:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:c0:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
pci 0000:c0:03.0:   bridge window [io  0xe000-0xefff]
pci 0000:c0:03.0:   bridge window [mem 0xf9100000-0xfa0fffff]
pci 0000:c0:03.0:   bridge window [mem 0xf6000000-0xf6ffffff 64bit pref]
pci 0000:c0:05.0: PCI bridge to [bus ca-cf]
pci 0000:c0:05.0:   bridge window [io  0xf000-0xffff]
pci 0000:c0:05.0:   bridge window [mem 0xfa100000-0xfb0fffff]
pci 0000:c0:05.0:   bridge window [mem 0xf7000000-0xf7ffffff 64bit pref]
pci 0000:c0:07.0: PCI bridge to [bus d0-d0]
pci 0000:c0:07.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:c0:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:c0:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:c0:09.0: PCI bridge to [bus d1-d1]
pci 0000:c0:09.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:c0:09.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:c0:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci_bus 0000:c0: on NUMA node 6 (pxm 6)
ACPI: PCI Interrupt Routing Table [\_SB_.PCID._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCID.NPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCID.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCID.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCID.NPE5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCID.NPE7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCID.NPE9._PRT]
 pci0000:c0: Requesting ACPI _OSC control (0x1d)
 pci0000:c0: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 6 7 10 11 12 14 15)
vgaarb: device added: PCI:0000:12:05.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:12:05.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: Discovered peer bus f8
pci 0000:f8:00.0: [8086:2b00] type 0 class 0x000600
pci 0000:f8:00.2: [8086:2b02] type 0 class 0x000600
pci 0000:f8:00.4: [8086:2b22] type 0 class 0x000600
pci 0000:f8:00.6: [8086:2b2a] type 0 class 0x000600
pci 0000:f8:01.0: [8086:2b04] type 0 class 0x000600
pci 0000:f8:02.0: [8086:2b08] type 0 class 0x000600
pci 0000:f8:03.0: [8086:2b0c] type 0 class 0x000600
pci 0000:f8:04.0: [8086:2b10] type 0 class 0x000600
pci 0000:f8:05.0: [8086:2b14] type 0 class 0x000600
pci 0000:f8:05.2: [8086:2b16] type 0 class 0x000600
pci 0000:f8:05.4: [8086:2b13] type 0 class 0x000600
pci 0000:f8:05.6: [8086:2b53] type 0 class 0x000600
pci 0000:f8:06.0: [8086:2b18] type 0 class 0x000600
pci 0000:f8:07.0: [8086:2b1c] type 0 class 0x000600
pci 0000:f8:07.2: [8086:2b1e] type 0 class 0x000600
pci 0000:f8:07.4: [8086:2b1b] type 0 class 0x000600
pci 0000:f8:07.6: [8086:2b5b] type 0 class 0x000600
pci 0000:f8:08.0: [8086:2b20] type 0 class 0x000600
pci 0000:f8:09.0: [8086:2b24] type 0 class 0x000600
pci 0000:f8:0a.0: [8086:2b28] type 0 class 0x000600
pci 0000:f8:0b.0: [8086:2b2c] type 0 class 0x000600
pci 0000:f8:0c.0: [8086:2b30] type 0 class 0x000600
pci 0000:f8:0d.0: [8086:2b34] type 0 class 0x000600
pci 0000:f8:0e.0: [8086:2b38] type 0 class 0x000600
pci 0000:f8:0f.0: [8086:2b3c] type 0 class 0x000600
pci 0000:f8:10.0: [8086:2b40] type 0 class 0x000600
pci 0000:f8:10.2: [8086:2b42] type 0 class 0x000600
pci 0000:f8:10.4: [8086:2b32] type 0 class 0x000600
pci 0000:f8:10.6: [8086:2b3a] type 0 class 0x000600
pci 0000:f8:11.0: [8086:2b44] type 0 class 0x000600
pci 0000:f8:11.2: [8086:2b46] type 0 class 0x000600
pci 0000:f8:11.4: [8086:2b36] type 0 class 0x000600
pci 0000:f8:11.6: [8086:2b3e] type 0 class 0x000600
pci 0000:f8:12.0: [8086:2b48] type 0 class 0x000600
pci 0000:f8:13.0: [8086:2b4c] type 0 class 0x000600
pci 0000:f8:14.0: [8086:2b50] type 0 class 0x000600
pci 0000:f8:14.2: [8086:2b52] type 0 class 0x000600
pci 0000:f8:15.0: [8086:2b54] type 0 class 0x000600
pci 0000:f8:15.2: [8086:2b56] type 0 class 0x000600
pci 0000:f8:16.0: [8086:2b58] type 0 class 0x000600
pci 0000:f8:16.2: [8086:2b5a] type 0 class 0x000600
pci 0000:f8:17.0: [8086:2b5c] type 0 class 0x000600
pci 0000:f8:17.2: [8086:2b5e] type 0 class 0x000600
pci 0000:f8:18.0: [8086:2b60] type 0 class 0x000600
pci 0000:f8:18.2: [8086:2b62] type 0 class 0x000600
pci 0000:f8:19.0: [8086:2b64] type 0 class 0x000600
pci 0000:f8:19.2: [8086:2b66] type 0 class 0x000600
pci 0000:f8:1a.0: [8086:2b68] type 0 class 0x000600
pci 0000:f8:1b.0: [8086:2b6c] type 0 class 0x000600
PCI: Discovered peer bus f9
pci 0000:f9:00.0: [8086:2b00] type 0 class 0x000600
pci 0000:f9:00.2: [8086:2b02] type 0 class 0x000600
pci 0000:f9:00.4: [8086:2b22] type 0 class 0x000600
pci 0000:f9:00.6: [8086:2b2a] type 0 class 0x000600
pci 0000:f9:01.0: [8086:2b04] type 0 class 0x000600
pci 0000:f9:02.0: [8086:2b08] type 0 class 0x000600
pci 0000:f9:03.0: [8086:2b0c] type 0 class 0x000600
pci 0000:f9:04.0: [8086:2b10] type 0 class 0x000600
pci 0000:f9:05.0: [8086:2b14] type 0 class 0x000600
pci 0000:f9:05.2: [8086:2b16] type 0 class 0x000600
pci 0000:f9:05.4: [8086:2b13] type 0 class 0x000600
pci 0000:f9:05.6: [8086:2b53] type 0 class 0x000600
pci 0000:f9:06.0: [8086:2b18] type 0 class 0x000600
pci 0000:f9:07.0: [8086:2b1c] type 0 class 0x000600
pci 0000:f9:07.2: [8086:2b1e] type 0 class 0x000600
pci 0000:f9:07.4: [8086:2b1b] type 0 class 0x000600
pci 0000:f9:07.6: [8086:2b5b] type 0 class 0x000600
pci 0000:f9:08.0: [8086:2b20] type 0 class 0x000600
pci 0000:f9:09.0: [8086:2b24] type 0 class 0x000600
pci 0000:f9:0a.0: [8086:2b28] type 0 class 0x000600
pci 0000:f9:0b.0: [8086:2b2c] type 0 class 0x000600
pci 0000:f9:0c.0: [8086:2b30] type 0 class 0x000600
pci 0000:f9:0d.0: [8086:2b34] type 0 class 0x000600
pci 0000:f9:0e.0: [8086:2b38] type 0 class 0x000600
pci 0000:f9:0f.0: [8086:2b3c] type 0 class 0x000600
pci 0000:f9:10.0: [8086:2b40] type 0 class 0x000600
pci 0000:f9:10.2: [8086:2b42] type 0 class 0x000600
pci 0000:f9:10.4: [8086:2b32] type 0 class 0x000600
pci 0000:f9:10.6: [8086:2b3a] type 0 class 0x000600
pci 0000:f9:11.0: [8086:2b44] type 0 class 0x000600
pci 0000:f9:11.2: [8086:2b46] type 0 class 0x000600
pci 0000:f9:11.4: [8086:2b36] type 0 class 0x000600
pci 0000:f9:11.6: [8086:2b3e] type 0 class 0x000600
pci 0000:f9:12.0: [8086:2b48] type 0 class 0x000600
pci 0000:f9:13.0: [8086:2b4c] type 0 class 0x000600
pci 0000:f9:14.0: [8086:2b50] type 0 class 0x000600
pci 0000:f9:14.2: [8086:2b52] type 0 class 0x000600
pci 0000:f9:15.0: [8086:2b54] type 0 class 0x000600
pci 0000:f9:15.2: [8086:2b56] type 0 class 0x000600
pci 0000:f9:16.0: [8086:2b58] type 0 class 0x000600
pci 0000:f9:16.2: [8086:2b5a] type 0 class 0x000600
pci 0000:f9:17.0: [8086:2b5c] type 0 class 0x000600
pci 0000:f9:17.2: [8086:2b5e] type 0 class 0x000600
pci 0000:f9:18.0: [8086:2b60] type 0 class 0x000600
pci 0000:f9:18.2: [8086:2b62] type 0 class 0x000600
pci 0000:f9:19.0: [8086:2b64] type 0 class 0x000600
pci 0000:f9:19.2: [8086:2b66] type 0 class 0x000600
pci 0000:f9:1a.0: [8086:2b68] type 0 class 0x000600
pci 0000:f9:1b.0: [8086:2b6c] type 0 class 0x000600
PCI: Discovered peer bus fa
pci 0000:fa:00.0: [8086:2b00] type 0 class 0x000600
pci 0000:fa:00.2: [8086:2b02] type 0 class 0x000600
pci 0000:fa:00.4: [8086:2b22] type 0 class 0x000600
pci 0000:fa:00.6: [8086:2b2a] type 0 class 0x000600
pci 0000:fa:01.0: [8086:2b04] type 0 class 0x000600
pci 0000:fa:02.0: [8086:2b08] type 0 class 0x000600
pci 0000:fa:03.0: [8086:2b0c] type 0 class 0x000600
pci 0000:fa:04.0: [8086:2b10] type 0 class 0x000600
pci 0000:fa:05.0: [8086:2b14] type 0 class 0x000600
pci 0000:fa:05.2: [8086:2b16] type 0 class 0x000600
pci 0000:fa:05.4: [8086:2b13] type 0 class 0x000600
pci 0000:fa:05.6: [8086:2b53] type 0 class 0x000600
pci 0000:fa:06.0: [8086:2b18] type 0 class 0x000600
pci 0000:fa:07.0: [8086:2b1c] type 0 class 0x000600
pci 0000:fa:07.2: [8086:2b1e] type 0 class 0x000600
pci 0000:fa:07.4: [8086:2b1b] type 0 class 0x000600
pci 0000:fa:07.6: [8086:2b5b] type 0 class 0x000600
pci 0000:fa:08.0: [8086:2b20] type 0 class 0x000600
pci 0000:fa:09.0: [8086:2b24] type 0 class 0x000600
pci 0000:fa:0a.0: [8086:2b28] type 0 class 0x000600
pci 0000:fa:0b.0: [8086:2b2c] type 0 class 0x000600
pci 0000:fa:0c.0: [8086:2b30] type 0 class 0x000600
pci 0000:fa:0d.0: [8086:2b34] type 0 class 0x000600
pci 0000:fa:0e.0: [8086:2b38] type 0 class 0x000600
pci 0000:fa:0f.0: [8086:2b3c] type 0 class 0x000600
pci 0000:fa:10.0: [8086:2b40] type 0 class 0x000600
pci 0000:fa:10.2: [8086:2b42] type 0 class 0x000600
pci 0000:fa:10.4: [8086:2b32] type 0 class 0x000600
pci 0000:fa:10.6: [8086:2b3a] type 0 class 0x000600
pci 0000:fa:11.0: [8086:2b44] type 0 class 0x000600
pci 0000:fa:11.2: [8086:2b46] type 0 class 0x000600
pci 0000:fa:11.4: [8086:2b36] type 0 class 0x000600
pci 0000:fa:11.6: [8086:2b3e] type 0 class 0x000600
pci 0000:fa:12.0: [8086:2b48] type 0 class 0x000600
pci 0000:fa:13.0: [8086:2b4c] type 0 class 0x000600
pci 0000:fa:14.0: [8086:2b50] type 0 class 0x000600
pci 0000:fa:14.2: [8086:2b52] type 0 class 0x000600
pci 0000:fa:15.0: [8086:2b54] type 0 class 0x000600
pci 0000:fa:15.2: [8086:2b56] type 0 class 0x000600
pci 0000:fa:16.0: [8086:2b58] type 0 class 0x000600
pci 0000:fa:16.2: [8086:2b5a] type 0 class 0x000600
pci 0000:fa:17.0: [8086:2b5c] type 0 class 0x000600
pci 0000:fa:17.2: [8086:2b5e] type 0 class 0x000600
pci 0000:fa:18.0: [8086:2b60] type 0 class 0x000600
pci 0000:fa:18.2: [8086:2b62] type 0 class 0x000600
pci 0000:fa:19.0: [8086:2b64] type 0 class 0x000600
pci 0000:fa:19.2: [8086:2b66] type 0 class 0x000600
pci 0000:fa:1a.0: [8086:2b68] type 0 class 0x000600
pci 0000:fa:1b.0: [8086:2b6c] type 0 class 0x000600
PCI: Discovered peer bus fb
pci 0000:fb:00.0: [8086:2b00] type 0 class 0x000600
pci 0000:fb:00.2: [8086:2b02] type 0 class 0x000600
pci 0000:fb:00.4: [8086:2b22] type 0 class 0x000600
pci 0000:fb:00.6: [8086:2b2a] type 0 class 0x000600
pci 0000:fb:01.0: [8086:2b04] type 0 class 0x000600
pci 0000:fb:02.0: [8086:2b08] type 0 class 0x000600
pci 0000:fb:03.0: [8086:2b0c] type 0 class 0x000600
pci 0000:fb:04.0: [8086:2b10] type 0 class 0x000600
pci 0000:fb:05.0: [8086:2b14] type 0 class 0x000600
pci 0000:fb:05.2: [8086:2b16] type 0 class 0x000600
pci 0000:fb:05.4: [8086:2b13] type 0 class 0x000600
pci 0000:fb:05.6: [8086:2b53] type 0 class 0x000600
pci 0000:fb:06.0: [8086:2b18] type 0 class 0x000600
pci 0000:fb:07.0: [8086:2b1c] type 0 class 0x000600
pci 0000:fb:07.2: [8086:2b1e] type 0 class 0x000600
pci 0000:fb:07.4: [8086:2b1b] type 0 class 0x000600
pci 0000:fb:07.6: [8086:2b5b] type 0 class 0x000600
pci 0000:fb:08.0: [8086:2b20] type 0 class 0x000600
pci 0000:fb:09.0: [8086:2b24] type 0 class 0x000600
pci 0000:fb:0a.0: [8086:2b28] type 0 class 0x000600
pci 0000:fb:0b.0: [8086:2b2c] type 0 class 0x000600
pci 0000:fb:0c.0: [8086:2b30] type 0 class 0x000600
pci 0000:fb:0d.0: [8086:2b34] type 0 class 0x000600
pci 0000:fb:0e.0: [8086:2b38] type 0 class 0x000600
pci 0000:fb:0f.0: [8086:2b3c] type 0 class 0x000600
pci 0000:fb:10.0: [8086:2b40] type 0 class 0x000600
pci 0000:fb:10.2: [8086:2b42] type 0 class 0x000600
pci 0000:fb:10.4: [8086:2b32] type 0 class 0x000600
pci 0000:fb:10.6: [8086:2b3a] type 0 class 0x000600
pci 0000:fb:11.0: [8086:2b44] type 0 class 0x000600
pci 0000:fb:11.2: [8086:2b46] type 0 class 0x000600
pci 0000:fb:11.4: [8086:2b36] type 0 class 0x000600
pci 0000:fb:11.6: [8086:2b3e] type 0 class 0x000600
pci 0000:fb:12.0: [8086:2b48] type 0 class 0x000600
pci 0000:fb:13.0: [8086:2b4c] type 0 class 0x000600
pci 0000:fb:14.0: [8086:2b50] type 0 class 0x000600
pci 0000:fb:14.2: [8086:2b52] type 0 class 0x000600
pci 0000:fb:15.0: [8086:2b54] type 0 class 0x000600
pci 0000:fb:15.2: [8086:2b56] type 0 class 0x000600
pci 0000:fb:16.0: [8086:2b58] type 0 class 0x000600
pci 0000:fb:16.2: [8086:2b5a] type 0 class 0x000600
pci 0000:fb:17.0: [8086:2b5c] type 0 class 0x000600
pci 0000:fb:17.2: [8086:2b5e] type 0 class 0x000600
pci 0000:fb:18.0: [8086:2b60] type 0 class 0x000600
pci 0000:fb:18.2: [8086:2b62] type 0 class 0x000600
pci 0000:fb:19.0: [8086:2b64] type 0 class 0x000600
pci 0000:fb:19.2: [8086:2b66] type 0 class 0x000600
pci 0000:fb:1a.0: [8086:2b68] type 0 class 0x000600
pci 0000:fb:1b.0: [8086:2b6c] type 0 class 0x000600
PCI: Discovered peer bus fc
pci 0000:fc:00.0: [8086:2b00] type 0 class 0x000600
pci 0000:fc:00.2: [8086:2b02] type 0 class 0x000600
pci 0000:fc:00.4: [8086:2b22] type 0 class 0x000600
pci 0000:fc:00.6: [8086:2b2a] type 0 class 0x000600
pci 0000:fc:01.0: [8086:2b04] type 0 class 0x000600
pci 0000:fc:02.0: [8086:2b08] type 0 class 0x000600
pci 0000:fc:03.0: [8086:2b0c] type 0 class 0x000600
pci 0000:fc:04.0: [8086:2b10] type 0 class 0x000600
pci 0000:fc:05.0: [8086:2b14] type 0 class 0x000600
pci 0000:fc:05.2: [8086:2b16] type 0 class 0x000600
pci 0000:fc:05.4: [8086:2b13] type 0 class 0x000600
pci 0000:fc:05.6: [8086:2b53] type 0 class 0x000600
pci 0000:fc:06.0: [8086:2b18] type 0 class 0x000600
pci 0000:fc:07.0: [8086:2b1c] type 0 class 0x000600
pci 0000:fc:07.2: [8086:2b1e] type 0 class 0x000600
pci 0000:fc:07.4: [8086:2b1b] type 0 class 0x000600
pci 0000:fc:07.6: [8086:2b5b] type 0 class 0x000600
pci 0000:fc:08.0: [8086:2b20] type 0 class 0x000600
pci 0000:fc:09.0: [8086:2b24] type 0 class 0x000600
pci 0000:fc:0a.0: [8086:2b28] type 0 class 0x000600
pci 0000:fc:0b.0: [8086:2b2c] type 0 class 0x000600
pci 0000:fc:0c.0: [8086:2b30] type 0 class 0x000600
pci 0000:fc:0d.0: [8086:2b34] type 0 class 0x000600
pci 0000:fc:0e.0: [8086:2b38] type 0 class 0x000600
pci 0000:fc:0f.0: [8086:2b3c] type 0 class 0x000600
pci 0000:fc:10.0: [8086:2b40] type 0 class 0x000600
pci 0000:fc:10.2: [8086:2b42] type 0 class 0x000600
pci 0000:fc:10.4: [8086:2b32] type 0 class 0x000600
pci 0000:fc:10.6: [8086:2b3a] type 0 class 0x000600
pci 0000:fc:11.0: [8086:2b44] type 0 class 0x000600
pci 0000:fc:11.2: [8086:2b46] type 0 class 0x000600
pci 0000:fc:11.4: [8086:2b36] type 0 class 0x000600
pci 0000:fc:11.6: [8086:2b3e] type 0 class 0x000600
pci 0000:fc:12.0: [8086:2b48] type 0 class 0x000600
pci 0000:fc:13.0: [8086:2b4c] type 0 class 0x000600
pci 0000:fc:14.0: [8086:2b50] type 0 class 0x000600
pci 0000:fc:14.2: [8086:2b52] type 0 class 0x000600
pci 0000:fc:15.0: [8086:2b54] type 0 class 0x000600
pci 0000:fc:15.2: [8086:2b56] type 0 class 0x000600
pci 0000:fc:16.0: [8086:2b58] type 0 class 0x000600
pci 0000:fc:16.2: [8086:2b5a] type 0 class 0x000600
pci 0000:fc:17.0: [8086:2b5c] type 0 class 0x000600
pci 0000:fc:17.2: [8086:2b5e] type 0 class 0x000600
pci 0000:fc:18.0: [8086:2b60] type 0 class 0x000600
pci 0000:fc:18.2: [8086:2b62] type 0 class 0x000600
pci 0000:fc:19.0: [8086:2b64] type 0 class 0x000600
pci 0000:fc:19.2: [8086:2b66] type 0 class 0x000600
pci 0000:fc:1a.0: [8086:2b68] type 0 class 0x000600
pci 0000:fc:1b.0: [8086:2b6c] type 0 class 0x000600
PCI: Discovered peer bus fd
pci 0000:fd:00.0: [8086:2b00] type 0 class 0x000600
pci 0000:fd:00.2: [8086:2b02] type 0 class 0x000600
pci 0000:fd:00.4: [8086:2b22] type 0 class 0x000600
pci 0000:fd:00.6: [8086:2b2a] type 0 class 0x000600
pci 0000:fd:01.0: [8086:2b04] type 0 class 0x000600
pci 0000:fd:02.0: [8086:2b08] type 0 class 0x000600
pci 0000:fd:03.0: [8086:2b0c] type 0 class 0x000600
pci 0000:fd:04.0: [8086:2b10] type 0 class 0x000600
pci 0000:fd:05.0: [8086:2b14] type 0 class 0x000600
pci 0000:fd:05.2: [8086:2b16] type 0 class 0x000600
pci 0000:fd:05.4: [8086:2b13] type 0 class 0x000600
pci 0000:fd:05.6: [8086:2b53] type 0 class 0x000600
pci 0000:fd:06.0: [8086:2b18] type 0 class 0x000600
pci 0000:fd:07.0: [8086:2b1c] type 0 class 0x000600
pci 0000:fd:07.2: [8086:2b1e] type 0 class 0x000600
pci 0000:fd:07.4: [8086:2b1b] type 0 class 0x000600
pci 0000:fd:07.6: [8086:2b5b] type 0 class 0x000600
pci 0000:fd:08.0: [8086:2b20] type 0 class 0x000600
pci 0000:fd:09.0: [8086:2b24] type 0 class 0x000600
pci 0000:fd:0a.0: [8086:2b28] type 0 class 0x000600
pci 0000:fd:0b.0: [8086:2b2c] type 0 class 0x000600
pci 0000:fd:0c.0: [8086:2b30] type 0 class 0x000600
pci 0000:fd:0d.0: [8086:2b34] type 0 class 0x000600
pci 0000:fd:0e.0: [8086:2b38] type 0 class 0x000600
pci 0000:fd:0f.0: [8086:2b3c] type 0 class 0x000600
pci 0000:fd:10.0: [8086:2b40] type 0 class 0x000600
pci 0000:fd:10.2: [8086:2b42] type 0 class 0x000600
pci 0000:fd:10.4: [8086:2b32] type 0 class 0x000600
pci 0000:fd:10.6: [8086:2b3a] type 0 class 0x000600
pci 0000:fd:11.0: [8086:2b44] type 0 class 0x000600
pci 0000:fd:11.2: [8086:2b46] type 0 class 0x000600
pci 0000:fd:11.4: [8086:2b36] type 0 class 0x000600
pci 0000:fd:11.6: [8086:2b3e] type 0 class 0x000600
pci 0000:fd:12.0: [8086:2b48] type 0 class 0x000600
pci 0000:fd:13.0: [8086:2b4c] type 0 class 0x000600
pci 0000:fd:14.0: [8086:2b50] type 0 class 0x000600
pci 0000:fd:14.2: [8086:2b52] type 0 class 0x000600
pci 0000:fd:15.0: [8086:2b54] type 0 class 0x000600
pci 0000:fd:15.2: [8086:2b56] type 0 class 0x000600
pci 0000:fd:16.0: [8086:2b58] type 0 class 0x000600
pci 0000:fd:16.2: [8086:2b5a] type 0 class 0x000600
pci 0000:fd:17.0: [8086:2b5c] type 0 class 0x000600
pci 0000:fd:17.2: [8086:2b5e] type 0 class 0x000600
pci 0000:fd:18.0: [8086:2b60] type 0 class 0x000600
pci 0000:fd:18.2: [8086:2b62] type 0 class 0x000600
pci 0000:fd:19.0: [8086:2b64] type 0 class 0x000600
pci 0000:fd:19.2: [8086:2b66] type 0 class 0x000600
pci 0000:fd:1a.0: [8086:2b68] type 0 class 0x000600
pci 0000:fd:1b.0: [8086:2b6c] type 0 class 0x000600
PCI: Discovered peer bus fe
pci 0000:fe:00.0: [8086:2b00] type 0 class 0x000600
pci 0000:fe:00.2: [8086:2b02] type 0 class 0x000600
pci 0000:fe:00.4: [8086:2b22] type 0 class 0x000600
pci 0000:fe:00.6: [8086:2b2a] type 0 class 0x000600
pci 0000:fe:01.0: [8086:2b04] type 0 class 0x000600
pci 0000:fe:02.0: [8086:2b08] type 0 class 0x000600
pci 0000:fe:03.0: [8086:2b0c] type 0 class 0x000600
pci 0000:fe:04.0: [8086:2b10] type 0 class 0x000600
pci 0000:fe:05.0: [8086:2b14] type 0 class 0x000600
pci 0000:fe:05.2: [8086:2b16] type 0 class 0x000600
pci 0000:fe:05.4: [8086:2b13] type 0 class 0x000600
pci 0000:fe:05.6: [8086:2b53] type 0 class 0x000600
pci 0000:fe:06.0: [8086:2b18] type 0 class 0x000600
pci 0000:fe:07.0: [8086:2b1c] type 0 class 0x000600
pci 0000:fe:07.2: [8086:2b1e] type 0 class 0x000600
pci 0000:fe:07.4: [8086:2b1b] type 0 class 0x000600
pci 0000:fe:07.6: [8086:2b5b] type 0 class 0x000600
pci 0000:fe:08.0: [8086:2b20] type 0 class 0x000600
pci 0000:fe:09.0: [8086:2b24] type 0 class 0x000600
pci 0000:fe:0a.0: [8086:2b28] type 0 class 0x000600
pci 0000:fe:0b.0: [8086:2b2c] type 0 class 0x000600
pci 0000:fe:0c.0: [8086:2b30] type 0 class 0x000600
pci 0000:fe:0d.0: [8086:2b34] type 0 class 0x000600
pci 0000:fe:0e.0: [8086:2b38] type 0 class 0x000600
pci 0000:fe:0f.0: [8086:2b3c] type 0 class 0x000600
pci 0000:fe:10.0: [8086:2b40] type 0 class 0x000600
pci 0000:fe:10.2: [8086:2b42] type 0 class 0x000600
pci 0000:fe:10.4: [8086:2b32] type 0 class 0x000600
pci 0000:fe:10.6: [8086:2b3a] type 0 class 0x000600
pci 0000:fe:11.0: [8086:2b44] type 0 class 0x000600
pci 0000:fe:11.2: [8086:2b46] type 0 class 0x000600
pci 0000:fe:11.4: [8086:2b36] type 0 class 0x000600
pci 0000:fe:11.6: [8086:2b3e] type 0 class 0x000600
pci 0000:fe:12.0: [8086:2b48] type 0 class 0x000600
pci 0000:fe:13.0: [8086:2b4c] type 0 class 0x000600
pci 0000:fe:14.0: [8086:2b50] type 0 class 0x000600
pci 0000:fe:14.2: [8086:2b52] type 0 class 0x000600
pci 0000:fe:15.0: [8086:2b54] type 0 class 0x000600
pci 0000:fe:15.2: [8086:2b56] type 0 class 0x000600
pci 0000:fe:16.0: [8086:2b58] type 0 class 0x000600
pci 0000:fe:16.2: [8086:2b5a] type 0 class 0x000600
pci 0000:fe:17.0: [8086:2b5c] type 0 class 0x000600
pci 0000:fe:17.2: [8086:2b5e] type 0 class 0x000600
pci 0000:fe:18.0: [8086:2b60] type 0 class 0x000600
pci 0000:fe:18.2: [8086:2b62] type 0 class 0x000600
pci 0000:fe:19.0: [8086:2b64] type 0 class 0x000600
pci 0000:fe:19.2: [8086:2b66] type 0 class 0x000600
pci 0000:fe:1a.0: [8086:2b68] type 0 class 0x000600
pci 0000:fe:1b.0: [8086:2b6c] type 0 class 0x000600
PCI: Discovered peer bus ff
pci 0000:ff:00.0: [8086:2b00] type 0 class 0x000600
pci 0000:ff:00.2: [8086:2b02] type 0 class 0x000600
pci 0000:ff:00.4: [8086:2b22] type 0 class 0x000600
pci 0000:ff:00.6: [8086:2b2a] type 0 class 0x000600
pci 0000:ff:01.0: [8086:2b04] type 0 class 0x000600
pci 0000:ff:02.0: [8086:2b08] type 0 class 0x000600
pci 0000:ff:03.0: [8086:2b0c] type 0 class 0x000600
pci 0000:ff:04.0: [8086:2b10] type 0 class 0x000600
pci 0000:ff:05.0: [8086:2b14] type 0 class 0x000600
pci 0000:ff:05.2: [8086:2b16] type 0 class 0x000600
pci 0000:ff:05.4: [8086:2b13] type 0 class 0x000600
pci 0000:ff:05.6: [8086:2b53] type 0 class 0x000600
pci 0000:ff:06.0: [8086:2b18] type 0 class 0x000600
pci 0000:ff:07.0: [8086:2b1c] type 0 class 0x000600
pci 0000:ff:07.2: [8086:2b1e] type 0 class 0x000600
pci 0000:ff:07.4: [8086:2b1b] type 0 class 0x000600
pci 0000:ff:07.6: [8086:2b5b] type 0 class 0x000600
pci 0000:ff:08.0: [8086:2b20] type 0 class 0x000600
pci 0000:ff:09.0: [8086:2b24] type 0 class 0x000600
pci 0000:ff:0a.0: [8086:2b28] type 0 class 0x000600
pci 0000:ff:0b.0: [8086:2b2c] type 0 class 0x000600
pci 0000:ff:0c.0: [8086:2b30] type 0 class 0x000600
pci 0000:ff:0d.0: [8086:2b34] type 0 class 0x000600
pci 0000:ff:0e.0: [8086:2b38] type 0 class 0x000600
pci 0000:ff:0f.0: [8086:2b3c] type 0 class 0x000600
pci 0000:ff:10.0: [8086:2b40] type 0 class 0x000600
pci 0000:ff:10.2: [8086:2b42] type 0 class 0x000600
pci 0000:ff:10.4: [8086:2b32] type 0 class 0x000600
pci 0000:ff:10.6: [8086:2b3a] type 0 class 0x000600
pci 0000:ff:11.0: [8086:2b44] type 0 class 0x000600
pci 0000:ff:11.2: [8086:2b46] type 0 class 0x000600
pci 0000:ff:11.4: [8086:2b36] type 0 class 0x000600
pci 0000:ff:11.6: [8086:2b3e] type 0 class 0x000600
pci 0000:ff:12.0: [8086:2b48] type 0 class 0x000600
pci 0000:ff:13.0: [8086:2b4c] type 0 class 0x000600
pci 0000:ff:14.0: [8086:2b50] type 0 class 0x000600
pci 0000:ff:14.2: [8086:2b52] type 0 class 0x000600
pci 0000:ff:15.0: [8086:2b54] type 0 class 0x000600
pci 0000:ff:15.2: [8086:2b56] type 0 class 0x000600
pci 0000:ff:16.0: [8086:2b58] type 0 class 0x000600
pci 0000:ff:16.2: [8086:2b5a] type 0 class 0x000600
pci 0000:ff:17.0: [8086:2b5c] type 0 class 0x000600
pci 0000:ff:17.2: [8086:2b5e] type 0 class 0x000600
pci 0000:ff:18.0: [8086:2b60] type 0 class 0x000600
pci 0000:ff:18.2: [8086:2b62] type 0 class 0x000600
pci 0000:ff:19.0: [8086:2b64] type 0 class 0x000600
pci 0000:ff:19.2: [8086:2b66] type 0 class 0x000600
pci 0000:ff:1a.0: [8086:2b68] type 0 class 0x000600
pci 0000:ff:1b.0: [8086:2b6c] type 0 class 0x000600
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 0000000000095800 - 000000000009ffff
reserve RAM buffer: 000000007f750000 - 000000007fffffff
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
Switched to NOHz mode on CPU #53
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #3
Switched to NOHz mode on CPU #130
Switched to NOHz mode on CPU #89
Switched to NOHz mode on CPU #16
Switched to NOHz mode on CPU #44
Switched to NOHz mode on CPU #60
Switched to NOHz mode on CPU #132
Switched to NOHz mode on CPU #55
Switched to NOHz mode on CPU #70
Switched to NOHz mode on CPU #73
Switched to NOHz mode on CPU #79
Switched to NOHz mode on CPU #159
Switched to NOHz mode on CPU #72
Switched to NOHz mode on CPU #152
Switched to NOHz mode on CPU #154
Switched to NOHz mode on CPU #76
Switched to NOHz mode on CPU #77
Switched to NOHz mode on CPU #158
Switched to NOHz mode on CPU #134
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #153
Switched to NOHz mode on CPU #59
Switched to NOHz mode on CPU #18
Switched to NOHz mode on CPU #40
Switched to NOHz mode on CPU #156
Switched to NOHz mode on CPU #141
Switched to NOHz mode on CPU #150
Switched to NOHz mode on CPU #137
Switched to NOHz mode on CPU #47
Switched to NOHz mode on CPU #62
Switched to NOHz mode on CPU #74
Switched to NOHz mode on CPU #121
Switched to NOHz mode on CPU #63
Switched to NOHz mode on CPU #83
Switched to NOHz mode on CPU #136
Switched to NOHz mode on CPU #88
Switched to NOHz mode on CPU #114
Switched to NOHz mode on CPU #110
Switched to NOHz mode on CPU #45
Switched to NOHz mode on CPU #86
Switched to NOHz mode on CPU #58
Switched to NOHz mode on CPU #80
Switched to NOHz mode on CPU #50
Switched to NOHz mode on CPU #116
Switched to NOHz mode on CPU #124
Switched to NOHz mode on CPU #41
Switched to NOHz mode on CPU #151
Switched to NOHz mode on CPU #71
Switched to NOHz mode on CPU #155
Switched to NOHz mode on CPU #75
Switched to NOHz mode on CPU #157
Switched to NOHz mode on CPU #78
Switched to NOHz mode on CPU #38
Switched to NOHz mode on CPU #26
Switched to NOHz mode on CPU #69
Switched to NOHz mode on CPU #106
Switched to NOHz mode on CPU #84
Switched to NOHz mode on CPU #7
Switched to NOHz mode on CPU #133
Switched to NOHz mode on CPU #87
Switched to NOHz mode on CPU #135
Switched to NOHz mode on CPU #82
Switched to NOHz mode on CPU #24
Switched to NOHz mode on CPU #104
Switched to NOHz mode on CPU #102
Switched to NOHz mode on CPU #37
Switched to NOHz mode on CPU #117
Switched to NOHz mode on CPU #17
Switched to NOHz mode on CPU #25
Switched to NOHz mode on CPU #145
Switched to NOHz mode on CPU #142
Switched to NOHz mode on CPU #34
Switched to NOHz mode on CPU #143
Switched to NOHz mode on CPU #64
Switched to NOHz mode on CPU #129
Switched to NOHz mode on CPU #119
Switched to NOHz mode on CPU #11
Switched to NOHz mode on CPU #105
Switched to NOHz mode on CPU #97
Switched to NOHz mode on CPU #5
Switched to NOHz mode on CPU #9
Switched to NOHz mode on CPU #85
Switched to NOHz mode on CPU #13
Switched to NOHz mode on CPU #30
Switched to NOHz mode on CPU #111
Switched to NOHz mode on CPU #29
Switched to NOHz mode on CPU #31
Switched to NOHz mode on CPU #91
Switched to NOHz mode on CPU #98
Switched to NOHz mode on CPU #139
Switched to NOHz mode on CPU #93
Switched to NOHz mode on CPU #61
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #8
Switched to NOHz mode on CPU #4
Switched to NOHz mode on CPU #109
Switched to NOHz mode on CPU #81
Switched to NOHz mode on CPU #112
Switched to NOHz mode on CPU #32
Switched to NOHz mode on CPU #54
Switched to NOHz mode on CPU #120
Switched to NOHz mode on CPU #6
Switched to NOHz mode on CPU #94
Switched to NOHz mode on CPU #127
Switched to NOHz mode on CPU #148
Switched to NOHz mode on CPU #96
Switched to NOHz mode on CPU #51
Switched to NOHz mode on CPU #138
Switched to NOHz mode on CPU #14
Switched to NOHz mode on CPU #68
Switched to NOHz mode on CPU #56
Switched to NOHz mode on CPU #131
Switched to NOHz mode on CPU #57
Switched to NOHz mode on CPU #140
Switched to NOHz mode on CPU #22
Switched to NOHz mode on CPU #52
Switched to NOHz mode on CPU #128
Switched to NOHz mode on CPU #65
Switched to NOHz mode on CPU #146
Switched to NOHz mode on CPU #149
Switched to NOHz mode on CPU #48
Switched to NOHz mode on CPU #101
Switched to NOHz mode on CPU #103
Switched to NOHz mode on CPU #123
Switched to NOHz mode on CPU #125
Switched to NOHz mode on CPU #43
Switched to NOHz mode on CPU #19
Switched to NOHz mode on CPU #23
Switched to NOHz mode on CPU #66
Switched to NOHz mode on CPU #20
Switched to NOHz mode on CPU #113
Switched to NOHz mode on CPU #147
Switched to NOHz mode on CPU #126
Switched to NOHz mode on CPU #21
Switched to NOHz mode on CPU #46
Switched to NOHz mode on CPU #67
Switched to NOHz mode on CPU #100
Switched to NOHz mode on CPU #33
Switched to NOHz mode on CPU #49
Switched to NOHz mode on CPU #122
Switched to NOHz mode on CPU #42
Switched to NOHz mode on CPU #15
Switched to NOHz mode on CPU #95
Switched to NOHz mode on CPU #90
Switched to NOHz mode on CPU #144
Switched to NOHz mode on CPU #10
Switched to NOHz mode on CPU #92
Switched to NOHz mode on CPU #12
Switched to NOHz mode on CPU #108
Switched to NOHz mode on CPU #28
Switched to NOHz mode on CPU #99
Switched to NOHz mode on CPU #39
Switched to NOHz mode on CPU #107
Switched to NOHz mode on CPU #35
Switched to NOHz mode on CPU #27
Switched to NOHz mode on CPU #115
Switched to NOHz mode on CPU #36
Switched to NOHz mode on CPU #118
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-3f]
pnp 00:00: [io  0x0000-0x3fff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000d0000-0x000dffff window]
pnp 00:00: [mem 0x00000000-0xffffffff window]
pnp 00:00: [mem 0x90000000-0xafffffff window]
pnp 00:00: [mem 0xfed40000-0xfed44fff window]
pnp 00:00: [mem 0xfc000000000-0xfc07fffffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfc000000-0xfcffffff]
pnp 00:01: [mem 0xfd000000-0xfdffffff]
pnp 00:01: [mem 0xfe000000-0xfebfffff]
system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:02: [dma 4]
pnp 00:02: [io  0x0000-0x000f]
pnp 00:02: [io  0x0081-0x0083]
pnp 00:02: [io  0x0087]
pnp 00:02: [io  0x0089-0x008b]
pnp 00:02: [io  0x008f]
pnp 00:02: [io  0x00c0-0x00df]
pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:03: [io  0x0070-0x0071]
pnp 00:03: [irq 8]
pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:04: [io  0x00f0-0x00ff]
pnp 00:04: [irq 13]
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x0010-0x001f]
pnp 00:05: [io  0x0022-0x003f]
pnp 00:05: [io  0x0044-0x005f]
pnp 00:05: [io  0x0062-0x0063]
pnp 00:05: [io  0x0065-0x006f]
pnp 00:05: [io  0x0072-0x007f]
pnp 00:05: [io  0x0080]
pnp 00:05: [io  0x0084-0x0086]
pnp 00:05: [io  0x0088]
pnp 00:05: [io  0x008c-0x008e]
pnp 00:05: [io  0x0090-0x009f]
pnp 00:05: [io  0x00a2-0x00bf]
pnp 00:05: [io  0x00e0-0x00ef]
pnp 00:05: [io  0x04d0-0x04d1]
pnp 00:05: [io  0x0800-0x087f]
pnp 00:05: [io  0x0000-0xffffffffffffffff disabled]
pnp 00:05: [io  0x0500-0x057f]
pnp 00:05: [mem 0xfed1c000-0xfed1ffff]
pnp 00:05: [mem 0xfed20000-0xfed3ffff]
pnp 00:05: [mem 0xfed40000-0xfed8ffff]
system 00:05: [io  0x04d0-0x04d1] has been reserved
system 00:05: [io  0x0800-0x087f] has been reserved
system 00:05: [io  0x0500-0x057f] has been reserved
system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:05: [mem 0xfed40000-0xfed8ffff] has been reserved
system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:06: [mem 0xfed00000-0xfed003ff]
pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [mem 0xfec00000-0xfec00fff]
pnp 00:07: [mem 0xfee00000-0xfee00fff]
system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:08: [io  0x03f8-0x03ff]
pnp 00:08: [irq 4]
pnp 00:08: [dma 0 disabled]
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:09: [io  0x0ca2]
pnp 00:09: [io  0x0ca6]
pnp 00:09: Plug and Play ACPI device, IDs IPI0001 (active)
pnp 00:0a: [mem 0x80000000-0x8fffffff]
system 00:0a: [mem 0x80000000-0x8fffffff] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: [mem 0x00000000-0x0009ffff]
pnp 00:0b: [mem 0x000c0000-0x000cffff]
pnp 00:0b: [mem 0x000e0000-0x000fffff]
pnp 00:0b: [mem 0x00100000-0xffffffff]
pnp 00:0b: [mem 0xfed90000-0xffffffff]
system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0b: [mem 0x000c0000-0x000cffff] could not be reserved
system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0b: [mem 0x00100000-0xffffffff] could not be reserved
system 00:0b: [mem 0xfed90000-0xffffffff] could not be reserved
system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:0c: [bus 40-7f]
pnp 00:0c: [io  0x0000 window]
pnp 00:0c: [io  0x0000 window]
pnp 00:0c: [io  0x4000-0x7fff window]
pnp 00:0c: [mem 0x00000000 window]
pnp 00:0c: [mem 0x00000000 window]
pnp 00:0c: [mem 0xb0000000-0xcfffffff window]
pnp 00:0c: [mem 0x00000000-0xffffffff window]
pnp 00:0c: [mem 0xfc080000000-0xfc0ffffffff window]
pnp 00:0c: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
system 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:0e: [bus 80-bf]
pnp 00:0e: [io  0x0000 window]
pnp 00:0e: [io  0x0000 window]
pnp 00:0e: [io  0x8000-0xbfff window]
pnp 00:0e: [mem 0x00000000 window]
pnp 00:0e: [mem 0x00000000 window]
pnp 00:0e: [mem 0xd0000000-0xefffffff window]
pnp 00:0e: [mem 0x00000000-0xffffffff window]
pnp 00:0e: [mem 0xfc100000000-0xfc17fffffff window]
pnp 00:0e: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:10: [bus c0-f7]
pnp 00:10: [io  0x0000 window]
pnp 00:10: [io  0x0000 window]
pnp 00:10: [io  0xc000-0xffff window]
pnp 00:10: [mem 0x00000000 window]
pnp 00:10: [mem 0x00000000 window]
pnp 00:10: [mem 0xf0000000-0xfbffffff window]
pnp 00:10: [mem 0x00000000-0xffffffff window]
pnp 00:10: [mem 0xfc180000000-0xfc1ffffffff window]
pnp 00:10: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
system 00:11: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 18 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:1c.0: BAR 15: assigned [mem 0xfc000000000-0xfc0001fffff 64bit pref]
pci 0000:00:05.0: BAR 13: can't assign io (size 0x1000)
pci 0000:00:03.0: BAR 13: can't assign io (size 0x1000)
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:01.0:   bridge window [mem 0xac400000-0xac4fffff]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 02-07]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem 0xac500000-0xad4fffff]
pci 0000:00:03.0:   bridge window [mem 0xaa000000-0xaaffffff 64bit pref]
pci 0000:00:05.0: PCI bridge to [bus 08-0d]
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem 0xad500000-0xae4fffff]
pci 0000:00:05.0:   bridge window [mem 0xab000000-0xabffffff 64bit pref]
pci 0000:00:07.0: PCI bridge to [bus 0e-0e]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem disabled]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 0f-0f]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem disabled]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI bridge to [bus 10-11]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xae500000-0xae6fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfc000000000-0xfc0001fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 12-12]
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xae700000-0xaeffffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:40:00.0: PCI bridge to [bus 41-42]
pci 0000:40:00.0:   bridge window [io  0x5000-0x5fff]
pci 0000:40:00.0:   bridge window [mem 0xccf00000-0xcd0fffff]
pci 0000:40:00.0:   bridge window [mem pref disabled]
pci 0000:40:01.0: PCI bridge to [bus 43-43]
pci 0000:40:01.0:   bridge window [io  disabled]
pci 0000:40:01.0:   bridge window [mem disabled]
pci 0000:40:01.0:   bridge window [mem pref disabled]
pci 0000:40:03.0: PCI bridge to [bus 44-49]
pci 0000:40:03.0:   bridge window [io  0x6000-0x6fff]
pci 0000:40:03.0:   bridge window [mem 0xcd100000-0xce0fffff]
pci 0000:40:03.0:   bridge window [mem 0xca000000-0xcaffffff 64bit pref]
pci 0000:40:05.0: PCI bridge to [bus 4a-4f]
pci 0000:40:05.0:   bridge window [io  0x7000-0x7fff]
pci 0000:40:05.0:   bridge window [mem 0xce100000-0xcf0fffff]
pci 0000:40:05.0:   bridge window [mem 0xcb000000-0xcbffffff 64bit pref]
pci 0000:40:07.0: PCI bridge to [bus 50-50]
pci 0000:40:07.0:   bridge window [io  disabled]
pci 0000:40:07.0:   bridge window [mem disabled]
pci 0000:40:07.0:   bridge window [mem pref disabled]
pci 0000:40:09.0: PCI bridge to [bus 51-51]
pci 0000:40:09.0:   bridge window [io  disabled]
pci 0000:40:09.0:   bridge window [mem disabled]
pci 0000:40:09.0:   bridge window [mem pref disabled]
pci 0000:80:00.0: PCI bridge to [bus 81-82]
pci 0000:80:00.0:   bridge window [io  0x9000-0x9fff]
pci 0000:80:00.0:   bridge window [mem 0xecf00000-0xed0fffff]
pci 0000:80:00.0:   bridge window [mem pref disabled]
pci 0000:80:01.0: PCI bridge to [bus 83-83]
pci 0000:80:01.0:   bridge window [io  disabled]
pci 0000:80:01.0:   bridge window [mem disabled]
pci 0000:80:01.0:   bridge window [mem pref disabled]
pci 0000:80:03.0: PCI bridge to [bus 84-89]
pci 0000:80:03.0:   bridge window [io  0xa000-0xafff]
pci 0000:80:03.0:   bridge window [mem 0xed100000-0xee0fffff]
pci 0000:80:03.0:   bridge window [mem 0xea000000-0xeaffffff 64bit pref]
pci 0000:80:05.0: PCI bridge to [bus 8a-8f]
pci 0000:80:05.0:   bridge window [io  0xb000-0xbfff]
pci 0000:80:05.0:   bridge window [mem 0xee100000-0xef0fffff]
pci 0000:80:05.0:   bridge window [mem 0xeb000000-0xebffffff 64bit pref]
pci 0000:80:07.0: PCI bridge to [bus 90-90]
pci 0000:80:07.0:   bridge window [io  disabled]
pci 0000:80:07.0:   bridge window [mem disabled]
pci 0000:80:07.0:   bridge window [mem pref disabled]
pci 0000:80:09.0: PCI bridge to [bus 91-91]
pci 0000:80:09.0:   bridge window [io  disabled]
pci 0000:80:09.0:   bridge window [mem disabled]
pci 0000:80:09.0:   bridge window [mem pref disabled]
pci 0000:c0:00.0: PCI bridge to [bus c1-c2]
pci 0000:c0:00.0:   bridge window [io  0xd000-0xdfff]
pci 0000:c0:00.0:   bridge window [mem 0xf8f00000-0xf90fffff]
pci 0000:c0:00.0:   bridge window [mem pref disabled]
pci 0000:c0:01.0: PCI bridge to [bus c3-c3]
pci 0000:c0:01.0:   bridge window [io  disabled]
pci 0000:c0:01.0:   bridge window [mem disabled]
pci 0000:c0:01.0:   bridge window [mem pref disabled]
pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
pci 0000:c0:03.0:   bridge window [io  0xe000-0xefff]
pci 0000:c0:03.0:   bridge window [mem 0xf9100000-0xfa0fffff]
pci 0000:c0:03.0:   bridge window [mem 0xf6000000-0xf6ffffff 64bit pref]
pci 0000:c0:05.0: PCI bridge to [bus ca-cf]
pci 0000:c0:05.0:   bridge window [io  0xf000-0xffff]
pci 0000:c0:05.0:   bridge window [mem 0xfa100000-0xfb0fffff]
pci 0000:c0:05.0:   bridge window [mem 0xf7000000-0xf7ffffff 64bit pref]
pci 0000:c0:07.0: PCI bridge to [bus d0-d0]
pci 0000:c0:07.0:   bridge window [io  disabled]
pci 0000:c0:07.0:   bridge window [mem disabled]
pci 0000:c0:07.0:   bridge window [mem pref disabled]
pci 0000:c0:09.0: PCI bridge to [bus d1-d1]
pci 0000:c0:09.0:   bridge window [io  disabled]
pci 0000:c0:09.0:   bridge window [mem disabled]
pci 0000:c0:09.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:40:00.0: setting latency timer to 64
pci 0000:40:01.0: setting latency timer to 64
pci 0000:40:03.0: setting latency timer to 64
pci 0000:40:05.0: setting latency timer to 64
pci 0000:40:07.0: setting latency timer to 64
pci 0000:40:09.0: setting latency timer to 64
pci 0000:80:00.0: setting latency timer to 64
pci 0000:80:01.0: setting latency timer to 64
pci 0000:80:03.0: setting latency timer to 64
pci 0000:80:05.0: setting latency timer to 64
pci 0000:80:07.0: setting latency timer to 64
pci 0000:80:09.0: setting latency timer to 64
pci 0000:c0:00.0: setting latency timer to 64
pci 0000:c0:01.0: setting latency timer to 64
pci 0000:c0:03.0: setting latency timer to 64
pci 0000:c0:05.0: setting latency timer to 64
pci 0000:c0:07.0: setting latency timer to 64
pci 0000:c0:09.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x3fff]
pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 6 [mem 0x90000000-0xafffffff]
pci_bus 0000:00: resource 7 [mem 0xfc000000000-0xfc07fffffff pref]
pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:01: resource 1 [mem 0xac400000-0xac4fffff]
pci_bus 0000:02: resource 1 [mem 0xac500000-0xad4fffff]
pci_bus 0000:02: resource 2 [mem 0xaa000000-0xaaffffff 64bit pref]
pci_bus 0000:08: resource 1 [mem 0xad500000-0xae4fffff]
pci_bus 0000:08: resource 2 [mem 0xab000000-0xabffffff 64bit pref]
pci_bus 0000:10: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:10: resource 1 [mem 0xae500000-0xae6fffff]
pci_bus 0000:10: resource 2 [mem 0xfc000000000-0xfc0001fffff 64bit pref]
pci_bus 0000:12: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:12: resource 1 [mem 0xae700000-0xaeffffff]
pci_bus 0000:12: resource 4 [io  0x0000-0x3fff]
pci_bus 0000:12: resource 5 [mem 0x000a0000-0x000bffff]
pci_bus 0000:12: resource 6 [mem 0x90000000-0xafffffff]
pci_bus 0000:12: resource 7 [mem 0xfc000000000-0xfc07fffffff pref]
pci_bus 0000:40: resource 4 [io  0x4000-0x7fff]
pci_bus 0000:40: resource 5 [mem 0xb0000000-0xcfffffff]
pci_bus 0000:40: resource 6 [mem 0xfc080000000-0xfc0ffffffff pref]
pci_bus 0000:41: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:41: resource 1 [mem 0xccf00000-0xcd0fffff]
pci_bus 0000:44: resource 0 [io  0x6000-0x6fff]
pci_bus 0000:44: resource 1 [mem 0xcd100000-0xce0fffff]
pci_bus 0000:44: resource 2 [mem 0xca000000-0xcaffffff 64bit pref]
pci_bus 0000:4a: resource 0 [io  0x7000-0x7fff]
pci_bus 0000:4a: resource 1 [mem 0xce100000-0xcf0fffff]
pci_bus 0000:4a: resource 2 [mem 0xcb000000-0xcbffffff 64bit pref]
pci_bus 0000:80: resource 4 [io  0x8000-0xbfff]
pci_bus 0000:80: resource 5 [mem 0xd0000000-0xefffffff]
pci_bus 0000:80: resource 6 [mem 0xfc100000000-0xfc17fffffff pref]
pci_bus 0000:81: resource 0 [io  0x9000-0x9fff]
pci_bus 0000:81: resource 1 [mem 0xecf00000-0xed0fffff]
pci_bus 0000:84: resource 0 [io  0xa000-0xafff]
pci_bus 0000:84: resource 1 [mem 0xed100000-0xee0fffff]
pci_bus 0000:84: resource 2 [mem 0xea000000-0xeaffffff 64bit pref]
pci_bus 0000:8a: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:8a: resource 1 [mem 0xee100000-0xef0fffff]
pci_bus 0000:8a: resource 2 [mem 0xeb000000-0xebffffff 64bit pref]
pci_bus 0000:c0: resource 4 [io  0xc000-0xffff]
pci_bus 0000:c0: resource 5 [mem 0xf0000000-0xfbffffff]
pci_bus 0000:c0: resource 6 [mem 0xfc180000000-0xfc1ffffffff pref]
pci_bus 0000:c1: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:c1: resource 1 [mem 0xf8f00000-0xf90fffff]
pci_bus 0000:c4: resource 0 [io  0xe000-0xefff]
pci_bus 0000:c4: resource 1 [mem 0xf9100000-0xfa0fffff]
pci_bus 0000:c4: resource 2 [mem 0xf6000000-0xf6ffffff 64bit pref]
pci_bus 0000:ca: resource 0 [io  0xf000-0xffff]
pci_bus 0000:ca: resource 1 [mem 0xfa100000-0xfb0fffff]
pci_bus 0000:ca: resource 2 [mem 0xf7000000-0xf7ffffff 64bit pref]
pci_bus 0000:f8: resource 0 [io  0x0000-0xffff]
pci_bus 0000:f8: resource 1 [mem 0x00000000-0xfffffffffff]
pci_bus 0000:f9: resource 0 [io  0x0000-0xffff]
pci_bus 0000:f9: resource 1 [mem 0x00000000-0xfffffffffff]
pci_bus 0000:fa: resource 0 [io  0x0000-0xffff]
pci_bus 0000:fa: resource 1 [mem 0x00000000-0xfffffffffff]
pci_bus 0000:fb: resource 0 [io  0x0000-0xffff]
pci_bus 0000:fb: resource 1 [mem 0x00000000-0xfffffffffff]
pci_bus 0000:fc: resource 0 [io  0x0000-0xffff]
pci_bus 0000:fc: resource 1 [mem 0x00000000-0xfffffffffff]
pci_bus 0000:fd: resource 0 [io  0x0000-0xffff]
pci_bus 0000:fd: resource 1 [mem 0x00000000-0xfffffffffff]
pci_bus 0000:fe: resource 0 [io  0x0000-0xffff]
pci_bus 0000:fe: resource 1 [mem 0x00000000-0xfffffffffff]
pci_bus 0000:ff: resource 0 [io  0x0000-0xffff]
pci_bus 0000:ff: resource 1 [mem 0x00000000-0xfffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 65536 (order: 9, 2097152 bytes)
UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
NET: Registered protocol family 1
pci 0000:12:05.0: Boot video device
PCI: CLS 256 bytes, default 64
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 25568k freed
IOMMU 2 0xccefe000: using Queued invalidation
IOMMU 1 0xecefe000: using Queued invalidation
IOMMU 0 0xf8efe000: using Queued invalidation
IOMMU 3 0xac3fe000: using Queued invalidation
IOMMU: Setting RMRR:
IOMMU: Setting identity map for device 0000:00:1d.0 [0x7f7ec000 - 0x7f7fffff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0x7f7ec000 - 0x7f7fffff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0x7f7ec000 - 0x7f7fffff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0x7f7ec000 - 0x7f7fffff]
IOMMU: Setting identity map for device 0000:00:1a.0 [0x7f7ec000 - 0x7f7fffff]
IOMMU: Setting identity map for device 0000:00:1a.1 [0x7f7ec000 - 0x7f7fffff]
IOMMU: Setting identity map for device 0000:00:1a.2 [0x7f7ec000 - 0x7f7fffff]
IOMMU: Setting identity map for device 0000:00:1a.7 [0x7f7ec000 - 0x7f7fffff]
IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xeffff]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xeffff]
IOMMU: Prepare 0-16MiB unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
audit: initializing netlink socket (disabled)
type=2000 audit(1336986857.518:1): initialized
Refined TSC clocksource calibration: 2393.999 MHz.
Switching to clocksource tsc
BUG: soft lockup - CPU#159 stuck for 22s! [migration/159:786]
Modules linked in:
CPU 159
Modules linked in:

Pid: 786, comm: migration/159 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8dc9fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8dc9fde0 R08: ffff8c007f4ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000009f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f4c0000(0000) knlGS:0000000000000000
BUG: soft lockup - CPU#105 stuck for 22s! [migration/105:518]
Modules linked in:
CPU 105
Modules linked in:

Pid: 518, comm: migration/105 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8e401dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8e401de0 R08: ffff89807fbce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000069 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fbc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/105 (pid: 518, threadinfo ffff897d8e400000, task
ffff897d8ebfe580)
Stack:
 ffff8b7d8e4e3c60 ffff897d8ebfe580 ffff89807fbce340 ffffffff810bfe70
 ffff897d8e401ee0 ffffffff810bfd90 ffff897d8e401e30 ffff897d8e401fd8
 ffff897d8ebfe580 ffff89807fbce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#51 stuck for 22s! [migration/51:237]
Modules linked in:
CPU 51
Modules linked in:

Pid: 237, comm: migration/51 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8afd8e987dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8e987de0 R08: ffff8b007f84e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000033 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007f840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/51 (pid: 237, threadinfo ffff8afd8e986000, task
ffff8afd8e984100)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8e984100 ffff8b007f84e340 ffffffff810bfe70
 ffff8afd8e987ee0 ffffffff810bfd90 ffff8afd8e987e30 ffff8afd8e987fd8
 ffff8afd8e984100 ffff8b007f84e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/159 (pid: 786, threadinfo ffff8bfd8dc9e000, task
ffff8bfd8dc9c880)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8dc9c880 ffff8c007f4ce340 ffffffff810bfe70
 ffff8bfd8dc9fee0 ffffffff810bfd90 ffff8bfd8dc9fe30 ffff8bfd8dc9ffd8
 ffff8bfd8dc9c880 ffff8c007f4ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#52 stuck for 22s! [migration/52:241]
Modules linked in:
BUG: soft lockup - CPU#106 stuck for 22s! [migration/106:522]
Modules linked in:
CPU 106
Modules linked in:

Pid: 522, comm: migration/106 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8e431dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8e431de0 R08: ffff89807fc0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000006a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/106 (pid: 522, threadinfo ffff897d8e430000, task
ffff897d8e42e640)
Stack:
 ffff8b7d8e4e3c60 ffff897d8e42e640 ffff89807fc0e340 ffffffff810bfe70
 ffff897d8e431ee0 ffffffff810bfd90 ffff897d8e431e30 ffff897d8e431fd8
 ffff897d8e42e640 ffff89807fc0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
CPU 52
Modules linked in:

Pid: 241, comm: migration/52 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8e9d5dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8e9d5de0 R08: ffff8b007f88e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000034 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/52 (pid: 241, threadinfo ffff8afd8e9d4000, task
ffff8afd8e9d21c0)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8e9d21c0 ffff8b007f88e340 ffffffff810bfe70
 ffff8afd8e9d5ee0 ffffffff810bfd90 ffff8afd8e9d5e00 ffff8afd8e9d5fd8
 ffff8afd8e9d21c0 ffff8b007f88e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#107 stuck for 22s! [migration/107:526]
Modules linked in:
CPU 107
Modules linked in:
BUG: soft lockup - CPU#53 stuck for 22s! [migration/53:255]
Modules linked in:
CPU 53
Modules linked in:

Pid: 255, comm: migration/53 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8ea05dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8ea05de0 R08: ffff8b007f8ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000035 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/53 (pid: 255, threadinfo ffff8afd8ea04000, task
ffff8afd8ea02280)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8ea02280 ffff8b007f8ce340 ffffffff810bfe70
 ffff8afd8ea05ee0 ffffffff810bfd90 ffff8afd8ea05e30 ffff8afd8ea05fd8
 ffff8afd8ea02280 ffff8b007f8ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13

Pid: 526, comm: migration/107 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8e441dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8e441de0 R08: ffff89807fc4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000006b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/107 (pid: 526, threadinfo ffff897d8e440000, task
ffff897d8e43e700)
Stack:
 ffff8b7d8e4e3c60 ffff897d8e43e700 ffff89807fc4e340 ffffffff810bfe70
 ffff897d8e441ee0 ffffffff810bfd90 ffff897d8e441e30 ffff897d8e441fd8
 ffff897d8e43e700 ffff89807fc4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:6]
Modules linked in:
CPU 0
Modules linked in:

Pid: 6, comm: migration/0 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0018:ffff887d8efd9dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: ffff887d8efd9d60 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8efd9de0 R08: ffff88807f80e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000000 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/0 (pid: 6, threadinfo ffff887d8efd8000, task ffff887d8efd6180)
Stack:
 ffff8b7d8e4e3c60 ffff887d8efd6180 ffff88807f80e340 ffffffff810bfe70
 ffff887d8efd9ee0 ffffffff810bfd90 ffff887d8efd9e30 ffff887d8efd9fd8
 ffff887d8efd6180 ffff88807f80e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
BUG: soft lockup - CPU#54 stuck for 22s! [migration/54:262]
Modules linked in:
CPU 54
Modules linked in:

Pid: 262, comm: migration/54 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8ea33dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8ea33de0 R08: ffff8b007f90e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000036 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007f900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/54 (pid: 262, threadinfo ffff8afd8ea32000, task
ffff8afd8ea30340)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8ea30340 ffff8b007f90e340 ffffffff810bfe70
 ffff8afd8ea33ee0 ffffffff810bfd90 ffff8afd8ea33e30 ffff8afd8ea33fd8
 ffff8afd8ea30340 ffff8b007f90e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#108 stuck for 22s! [migration/108:530]
Modules linked in:
CPU 108
Modules linked in:

Pid: 530, comm: migration/108 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8e46fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8e46fde0 R08: ffff89807fc8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000006c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/108 (pid: 530, threadinfo ffff897d8e46e000, task
ffff897d8e46c7c0)
Stack:
 ffff8b7d8e4e3c60 ffff897d8e46c7c0 ffff89807fc8e340 ffffffff810bfe70
 ffff897d8e46fee0 ffffffff810bfd90 ffff897d8e46fe30 ffff897d8e46ffd8
 ffff897d8e46c7c0 ffff89807fc8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#1 stuck for 22s! [migration/1:8]
Modules linked in:
CPU 1
Modules linked in:

Pid: 8, comm: migration/1 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e541dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e541de0 R08: ffff88807f84e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000001 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807f840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/1 (pid: 8, threadinfo ffff887d8e540000, task ffff887d8e46e200)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e46e200 ffff88807f84e340 ffffffff810bfe70
 ffff887d8e541ee0 ffffffff810bfd90 ffff887d8e541e30 ffff887d8e541fd8
 ffff887d8e46e200 ffff88807f84e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
BUG: soft lockup - CPU#55 stuck for 22s! [migration/55:266]
Modules linked in:
CPU 55
Modules linked in:

Pid: 266, comm: migration/55 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8afd8ea63dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8ea63de0 R08: ffff8b007f94e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000037 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007f940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/55 (pid: 266, threadinfo ffff8afd8ea62000, task
ffff8afd8ea60400)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8ea60400 ffff8b007f94e340 ffffffff810bfe70
 ffff8afd8ea63ee0 ffffffff810bfd90 ffff8afd8ea63e30 ffff8afd8ea63fd8
 ffff8afd8ea60400 ffff8b007f94e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#109 stuck for 22s! [migration/109:534]
Modules linked in:
CPU 109
Modules linked in:

Pid: 534, comm: migration/109 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8e47fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8e47fde0 R08: ffff89807fcce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000006d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/109 (pid: 534, threadinfo ffff897d8e47e000, task
ffff897d8e47c880)
Stack:
 ffff8b7d8e4e3c60 ffff897d8e47c880 ffff89807fcce340 ffffffff810bfe70
 ffff897d8e47fee0 ffffffff810bfd90 ffff897d8e47fe30 ffff897d8e47ffd8
 ffff897d8e47c880 ffff89807fcce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#2 stuck for 22s! [migration/2:13]
Modules linked in:
CPU 2
Modules linked in:

Pid: 13, comm: migration/2 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e565dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e565de0 R08: ffff88807f88e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000002 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/2 (pid: 13, threadinfo ffff887d8e564000, task
ffff887d8e562380)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e562380 ffff88807f88e340 ffffffff810bfe70
 ffff887d8e565ee0 ffffffff810bfd90 ffff887d8e565e30 ffff887d8e565fd8
 ffff887d8e562380 ffff88807f88e348 0000000000011ec0 0000000000000000
BUG: soft lockup - CPU#56 stuck for 22s! [migration/56:270]
Modules linked in:
CPU 56
Modules linked in:

Pid: 270, comm: migration/56 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8ea73dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8ea73de0 R08: ffff8b007f98e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000038 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007f980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/56 (pid: 270, threadinfo ffff8afd8ea72000, task
ffff8afd8ea704c0)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8ea704c0 ffff8b007f98e340 ffffffff810bfe70
 ffff8afd8ea73ee0 ffffffff810bfd90 ffff8afd8ea73e30 ffff8afd8ea73fd8
 ffff8afd8ea704c0 ffff8b007f98e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#110 stuck for 22s! [migration/110:538]
Modules linked in:
CPU 110
Modules linked in:

Pid: 538, comm: migration/110 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8eb55dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8eb55de0 R08: ffff8a007fa8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000006e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/110 (pid: 538, threadinfo ffff89fd8eb54000, task
ffff89fd8eb521c0)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8eb521c0 ffff8a007fa8e340 ffffffff810bfe70
 ffff89fd8eb55ee0 ffffffff810bfd90 ffff89fd8eb55e30 ffff89fd8eb55fd8
 ffff89fd8eb521c0 ffff8a007fa8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#3 stuck for 22s! [migration/3:17]
Modules linked in:
CPU 3
Modules linked in:

Pid: 17, comm: migration/3 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e5a1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e5a1de0 R08: ffff88807f8ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000003 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/3 (pid: 17, threadinfo ffff887d8e5a0000, task
ffff887d8e59e4c0)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e59e4c0 ffff88807f8ce340 ffffffff810bfe70
 ffff887d8e5a1ee0 ffffffff810bfd90 ffff887d8e5a1e30 ffff887d8e5a1fd8
 ffff887d8e59e4c0 ffff88807f8ce348 0000000000011ec0 0000000000000000
BUG: soft lockup - CPU#57 stuck for 22s! [migration/57:274]
Modules linked in:
CPU 57
Modules linked in:

Pid: 274, comm: migration/57 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8eaa1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8eaa1de0 R08: ffff8b007f9ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000039 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007f9c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/57 (pid: 274, threadinfo ffff8afd8eaa0000, task
ffff8afd8ea9e580)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8ea9e580 ffff8b007f9ce340 ffffffff810bfe70
 ffff8afd8eaa1ee0 ffffffff810bfd90 ffff8afd8eaa1e30 ffff8afd8eaa1fd8
 ffff8afd8ea9e580 ffff8b007f9ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#111 stuck for 22s! [migration/111:542]
Modules linked in:
CPU 111
Modules linked in:

Pid: 542, comm: migration/111 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8eb83dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8eb83de0 R08: ffff8a007face360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000006f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/111 (pid: 542, threadinfo ffff89fd8eb82000, task
ffff89fd8eb80280)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8eb80280 ffff8a007face340 ffffffff810bfe70
 ffff89fd8eb83ee0 ffffffff810bfd90 ffff89fd8eb83e30 ffff89fd8eb83fd8
 ffff89fd8eb80280 ffff8a007face348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#4 stuck for 22s! [migration/4:21]
Modules linked in:
CPU 4
Modules linked in:

Pid: 21, comm: migration/4 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e5bfdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e5bfde0 R08: ffff88807f90e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000004 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807f900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/4 (pid: 21, threadinfo ffff887d8e5be000, task
ffff887d8e5bc600)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e5bc600 ffff88807f90e340 ffffffff810bfe70
 ffff887d8e5bfee0 ffffffff810bfd90 ffff887d8e5bfe30 ffff887d8e5bffd8
 ffff887d8e5bc600 ffff88807f90e348 0000000000011ec0 0000000000000000
BUG: soft lockup - CPU#58 stuck for 22s! [migration/58:278]
Modules linked in:
CPU 58
Modules linked in:

Pid: 278, comm: migration/58 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8ead1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8ead1de0 R08: ffff8b007fa0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000003a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/58 (pid: 278, threadinfo ffff8afd8ead0000, task
ffff8afd8eace640)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8eace640 ffff8b007fa0e340 ffffffff810bfe70
 ffff8afd8ead1ee0 ffffffff810bfd90 ffff8afd8ead1e30 ffff8afd8ead1fd8
 ffff8afd8eace640 ffff8b007fa0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#112 stuck for 22s! [migration/112:546]
Modules linked in:
CPU 112
Modules linked in:

Pid: 546, comm: migration/112 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff89fd8eb93dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8eb93de0 R08: ffff8a007fb0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000070 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/112 (pid: 546, threadinfo ffff89fd8eb92000, task
ffff89fd8eb90340)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8eb90340 ffff8a007fb0e340 ffffffff810bfe70
 ffff89fd8eb93ee0 ffffffff810bfd90 ffff89fd8eb93e30 ffff89fd8eb93fd8
 ffff89fd8eb90340 ffff8a007fb0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#5 stuck for 22s! [migration/5:25]
Modules linked in:
CPU 5
Modules linked in:

Pid: 25, comm: migration/5 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e5f9dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e5f9de0 R08: ffff88807f94e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000005 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807f940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/5 (pid: 25, threadinfo ffff887d8e5f8000, task
ffff887d8e5f6740)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e5f6740 ffff88807f94e340 ffffffff810bfe70
 ffff887d8e5f9ee0 ffffffff810bfd90 ffff887d8e5f9e30 ffff887d8e5f9fd8
 ffff887d8e5f6740 ffff88807f94e348 0000000000011ec0 0000000000000000
BUG: soft lockup - CPU#59 stuck for 22s! [migration/59:282]
Modules linked in:
CPU 59
Modules linked in:

Pid: 282, comm: migration/59 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8afd8eae1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8eae1de0 R08: ffff8b007fa4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000003b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/59 (pid: 282, threadinfo ffff8afd8eae0000, task
ffff8afd8eade700)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8eade700 ffff8b007fa4e340 ffffffff810bfe70
 ffff8afd8eae1ee0 ffffffff810bfd90 ffff8afd8eae1e30 ffff8afd8eae1fd8
 ffff8afd8eade700 ffff8b007fa4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#113 stuck for 22s! [migration/113:550]
Modules linked in:
CPU 113
Modules linked in:

Pid: 550, comm: migration/113 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff89fd8ebc3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8ebc3de0 R08: ffff8a007fb4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000071 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/113 (pid: 550, threadinfo ffff89fd8ebc2000, task
ffff89fd8ebc0400)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8ebc0400 ffff8a007fb4e340 ffffffff810bfe70
 ffff89fd8ebc3ee0 ffffffff810bfd90 ffff89fd8ebc3e30 ffff89fd8ebc3fd8
 ffff89fd8ebc0400 ffff8a007fb4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#6 stuck for 23s! [migration/6:29]
Modules linked in:
CPU 6
Modules linked in:

Pid: 29, comm: migration/6 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e617dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e617de0 R08: ffff88807f98e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000006 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807f980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/6 (pid: 29, threadinfo ffff887d8e616000, task
ffff887d8e614880)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e614880 ffff88807f98e340 ffffffff810bfe70
 ffff887d8e617ee0 ffffffff810bfd90 ffff887d8e617e30 ffff887d8e617fd8
 ffff887d8e614880 ffff88807f98e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
BUG: soft lockup - CPU#114 stuck for 23s! [migration/114:554]
Modules linked in:
CPU 114
Modules linked in:

Pid: 554, comm: migration/114 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8ebd3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8ebd3de0 R08: ffff8a007fb8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000072 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/114 (pid: 554, threadinfo ffff89fd8ebd2000, task
ffff89fd8ebd04c0)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8ebd04c0 ffff8a007fb8e340 ffffffff810bfe70
 ffff89fd8ebd3ee0 ffffffff810bfd90 ffff89fd8ebd3e30 ffff89fd8ebd3fd8
 ffff89fd8ebd04c0 ffff8a007fb8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#60 stuck for 21s! [swapper:1]
Modules linked in:
CPU 60
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff814fb2d9>]  [<ffffffff814fb2d9>]
_raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff887d8efbfe38  EFLAGS: 00000286
RAX: 0000000038080200 RBX: ffff887d8efbfe00 RCX: 0340000000000400
RDX: ffffea0c41bfe8d0 RSI: 0000000000000286 RDI: 0000000000000286
RBP: ffff887d8efbfe40 R08: 0000000000000004 R09: 0000000000000000
R10: ffff8b807ffcbfe8 R11: 0000000000014f50 R12: ffffffff81503f4e
R13: ffffea0a81c00000 R14: ffff897d8d69b060 R15: ffff897d8d69b000
FS:  0000000000000000(0000) GS:ffff8b807f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff887d8efbe000, task ffff887d8efbc040)
Stack:
 ffff8b807ffece00 ffff887d8efbfe80 ffffffff811105d1 ffff887d8efbfe80
 ffffffff819aee60 0000000000000000 ffffffff814f7483 0000000000000000
 0000000000000000 ffff887d8efbfea0 ffffffff814f74c0 ffffffff819aee58
Call Trace:
 [<ffffffff811105d1>] setup_per_zone_wmarks+0xb1/0xe0
 [<ffffffff814f7483>] ? free_area_init_node+0xcb/0xcb
 [<ffffffff814f74c0>] init_per_zone_wmark_min+0x3d/0x8b
 [<ffffffff81002043>] do_one_initcall+0x43/0x190
 [<ffffffff818c46fd>] kernel_init+0x15b/0x1e6
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff818c45a2>] ? parse_early_options+0x20/0x20
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 66 90 e8 bb 2b b4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89
e5 53 66 66 66 66 90 48 89 f3 e8 ee 2b b4 ff 66 90 48 89 df 57
BUG: soft lockup - CPU#7 stuck for 23s! [migration/7:33]
Modules linked in:
CPU 7
Modules linked in:

Pid: 33, comm: migration/7 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e653dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e653de0 R08: ffff88807f9ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000007 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807f9c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/7 (pid: 33, threadinfo ffff887d8e652000, task
ffff887d8e650140)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e650140 ffff88807f9ce340 ffffffff810bfe70
 ffff887d8e653ee0 ffffffff810bfd90 ffff887d8e653e30 ffff887d8e653fd8
 ffff887d8e650140 ffff88807f9ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#61 stuck for 23s! [migration/61:290]
Modules linked in:
CPU 61
Modules linked in:

Pid: 290, comm: migration/61 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8e987dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e987de0 R08: ffff8b807f84e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000003d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807f840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/61 (pid: 290, threadinfo ffff8b7d8e986000, task
ffff8b7d8e984100)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e984100 ffff8b807f84e340 ffffffff810bfe70
 ffff8b7d8e987ee0 ffffffff810bfd90 ffff8b7d8e987e30 ffff8b7d8e987fd8
 ffff8b7d8e984100 ffff8b807f84e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#115 stuck for 23s! [migration/115:558]
Modules linked in:
CPU 115
Modules linked in:

Pid: 558, comm: migration/115 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff89fd8e401dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8e401de0 R08: ffff8a007fbce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000073 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fbc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/115 (pid: 558, threadinfo ffff89fd8e400000, task
ffff89fd8ebfe580)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8ebfe580 ffff8a007fbce340 ffffffff810bfe70
 ffff89fd8e401ee0 ffffffff810bfd90 ffff89fd8e401e30 ffff89fd8e401fd8
 ffff89fd8ebfe580 ffff8a007fbce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
9d
 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00
Call Trace:
 [<ffffffff811105d1>] setup_per_zone_wmarks+0xb1/0xe0
 [<ffffffff814f7483>] ? free_area_init_node+0xcb/0xcb
 [<ffffffff814f74c0>] init_per_zone_wmark_min+0x3d/0x8b
 [<ffffffff81002043>] do_one_initcall+0x43/0x190
 [<ffffffff818c46fd>] kernel_init+0x15b/0x1e6
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff818c45a2>] ? parse_early_options+0x20/0x20
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#8 stuck for 23s! [migration/8:37]
Modules linked in:
CPU 8
Modules linked in:

Pid: 37, comm: migration/8 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e66ddc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e66dde0 R08: ffff88807fa0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000008 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
BUG: soft lockup - CPU#116 stuck for 23s! [migration/116:562]
Modules linked in:
CPU 116
Modules linked in:

Pid: 562, comm: migration/116 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfedf>]  [<ffffffff810bfedf>]
stop_machine_cpu_stop+0x6f/0xd0
RSP: 0000:ffff89fd8e411dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8e411de0 R08: ffff8a007fc0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000074 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/116 (pid: 562, threadinfo ffff89fd8e410000, task
ffff89fd8e40e640)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8e40e640 ffff8a007fc0e340 ffffffff810bfe70
 ffff89fd8e411ee0 ffffffff810bfd90 ffff89fd8e411e30 ffff89fd8e411fd8
 ffff89fd8e40e640 ffff8a007fc0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74
0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31
 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#62 stuck for 23s! [migration/62:294]
Modules linked in:
CPU 62
Modules linked in:

Pid: 294, comm: migration/62 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8b7d8e9d5dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e9d5de0 R08: ffff8b807f88e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000003e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/62 (pid: 294, threadinfo ffff8b7d8e9d4000, task
ffff8b7d8e9d21c0)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e9d21c0 ffff8b807f88e340 ffffffff810bfe70
 ffff8b7d8e9d5ee0 ffffffff810bfd90 ffff8b7d8e9d5e30 ffff8b7d8e9d5fd8
 ffff8b7d8e9d21c0 ffff8b807f88e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/8 (pid: 37, threadinfo ffff887d8e66c000, task
ffff887d8e66a280)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e66a280 ffff88807fa0e340 ffffffff810bfe70
 ffff887d8e66dee0 ffffffff810bfd90 ffff887d8e66de30 ffff887d8e66dfd8
 ffff887d8e66a280 ffff88807fa0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#9 stuck for 23s! [migration/9:41]
Modules linked in:
CPU 9
Modules linked in:

Pid: 41, comm: migration/9 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee2>]  [<ffffffff810bfee2>]
stop_machine_cpu_stop+0x72/0xd0
RSP: 0000:ffff887d8e68bdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e68bde0 R08: ffff88807fa4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000009 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/9 (pid: 41, threadinfo ffff887d8e68a000, task
ffff887d8e6883c0)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e6883c0 ffff88807fa4e340 ffffffff810bfe70
 ffff887d8e68bee0 ffffffff810bfd90
BUG: soft lockup - CPU#117 stuck for 23s! [migration/117:566]
Modules linked in:
CPU 117
Modules linked in:

Pid: 566, comm: migration/117 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8e441dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8e441de0 R08: ffff8a007fc4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000075 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/117 (pid: 566, threadinfo ffff89fd8e440000, task
ffff89fd8e43e700)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8e43e700 ffff8a007fc4e340 ffffffff810bfe70
 ffff89fd8e441ee0 ffffffff810bfd90 ffff89fd8e441e30 ffff89fd8e441fd8
 ffff89fd8e43e700 ffff8a007fc4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#63 stuck for 23s! [migration/63:298]
Modules linked in:
CPU 63
Modules linked in:

Pid: 298, comm: migration/63 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8ea05dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8ea05de0 R08: ffff8b807f8ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000003f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/63 (pid: 298, threadinfo ffff8b7d8ea04000, task
ffff8b7d8ea02280)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8ea02280 ffff8b807f8ce340 ffffffff810bfe70
 ffff8b7d8ea05ee0 ffffffff810bfd90 ffff8b7d8ea05e30 ffff8b7d8ea05fd8
 ffff8b7d8ea02280 ffff8b807f8ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 ffff887d8e68be30 ffff887d8e68bfd8
 ffff887d8e6883c0 ffff88807fa4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43
20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0<f3>
90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#10 stuck for 23s! [migration/10:45]
Modules linked in:
CPU 10
Modules linked in:

Pid: 45, comm: migration/10 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8ecf9dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ecf9de0 R08: ffff89007f80e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000000a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/10 (pid: 45, threadinfo ffff88fd8ecf8000, task
ffff88fd8ecf6040)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ecf6040 ffff89007f80e340 ffffffff810bfe70
 ffff88fd8ecf9ee0 ffffffff810bfd90
BUG: soft lockup - CPU#118 stuck for 23s! [migration/118:583]
Modules linked in:
CPU 118
Modules linked in:

Pid: 583, comm: migration/118 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfedf>]  [<ffffffff810bfedf>]
stop_machine_cpu_stop+0x6f/0xd0
RSP: 0000:ffff89fd8e451dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8e451de0 R08: ffff8a007fc8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000076 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/118 (pid: 583, threadinfo ffff89fd8e450000, task
ffff89fd8e44e7c0)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8e44e7c0 ffff8a007fc8e340 ffffffff810bfe70
 ffff89fd8e451ee0 ffffffff810bfd90 ffff89fd8e451e30 ffff89fd8e451fd8
 ffff89fd8e44e7c0 ffff8a007fc8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74
0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31
 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#64 stuck for 23s! [migration/64:302]
Modules linked in:
CPU 64
Modules linked in:

Pid: 302, comm: migration/64 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8b7d8ea33dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8ea33de0 R08: ffff8b807f90e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000040 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807f900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/64 (pid: 302, threadinfo ffff8b7d8ea32000, task
ffff8b7d8ea30340)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8ea30340 ffff8b807f90e340 ffffffff810bfe70
 ffff8b7d8ea33ee0 ffffffff810bfd90 ffff8b7d8ea33e30 ffff8b7d8ea33fd8
 ffff8b7d8ea30340 ffff8b807f90e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 ffff88fd8ecf9e30 ffff88fd8ecf9fd8
 ffff88fd8ecf6040 ffff89007f80e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#11 stuck for 22s! [migration/11:49]
Modules linked in:
CPU 11
Modules linked in:

Pid: 49, comm: migration/11 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8ed47dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ed47de0 R08: ffff89007f84e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000000b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007f840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/11 (pid: 49, threadinfo ffff88fd8ed46000, task
ffff88fd8ed44100)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ed44100 ffff89007f84e340 ffffffff810bfe70
 ffff88fd8ed47ee0 ffffffff810bfd90
BUG: soft lockup - CPU#119 stuck for 22s! [migration/119:587]
Modules linked in:
CPU 119
Modules linked in:

Pid: 587, comm: migration/119 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8e47fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8e47fde0 R08: ffff8a007fcce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000077 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/119 (pid: 587, threadinfo ffff89fd8e47e000, task
ffff89fd8e47c880)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8e47c880 ffff8a007fcce340 ffffffff810bfe70
 ffff89fd8e47fee0 ffffffff810bfd90 ffff89fd8e47fe30 ffff89fd8e47ffd8
 ffff89fd8e47c880 ffff8a007fcce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#65 stuck for 22s! [migration/65:306]
Modules linked in:
CPU 65
Modules linked in:

Pid: 306, comm: migration/65 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8ea63dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8ea63de0 R08: ffff8b807f94e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000041 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807f940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/65 (pid: 306, threadinfo ffff8b7d8ea62000, task
ffff8b7d8ea60400)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8ea60400 ffff8b807f94e340 ffffffff810bfe70
 ffff8b7d8ea63ee0 ffffffff810bfd90 ffff8b7d8ea63e30 ffff8b7d8ea63fd8
 ffff8b7d8ea60400 ffff8b807f94e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 ffff88fd8ed47e30 ffff88fd8ed47fd8
 ffff88fd8ed44100 ffff89007f84e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#12 stuck for 22s! [migration/12:53]
Modules linked in:
CPU 12
Modules linked in:

Pid: 53, comm: migration/12 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee2>]  [<ffffffff810bfee2>]
stop_machine_cpu_stop+0x72/0xd0
RSP: 0000:ffff88fd8ed95dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ed95de0 R08: ffff89007f88e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000000c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/12 (pid: 53, threadinfo ffff88fd8ed94000, task
ffff88fd8ed921c0)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ed921c0 ffff89007f88e340 ffffffff810bfe70
 ffff88fd8ed95ee0 ffffffff810bfd90
BUG: soft lockup - CPU#120 stuck for 22s! [migration/120:591]
Modules linked in:
CPU 120
Modules linked in:

Pid: 591, comm: migration/120 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8eb73dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8eb73de0 R08: ffff8a807fa8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000078 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/120 (pid: 591, threadinfo ffff8a7d8eb72000, task
ffff8a7d8eb701c0)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8eb701c0 ffff8a807fa8e340 ffffffff810bfe70
 ffff8a7d8eb73ee0 ffffffff810bfd90 ffff8a7d8eb73e30 ffff8a7d8eb73fd8
 ffff8a7d8eb701c0 ffff8a807fa8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#66 stuck for 22s! [migration/66:321]
Modules linked in:
CPU 66
Modules linked in:

Pid: 321, comm: migration/66 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8b7d8ea91dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8ea91de0 R08: ffff8b807f98e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000042 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807f980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/66 (pid: 321, threadinfo ffff8b7d8ea90000, task
ffff8b7d8ea8e4c0)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8ea8e4c0 ffff8b807f98e340 ffffffff810bfe70
 ffff8b7d8ea91ee0 ffffffff810bfd90 ffff8b7d8ea91e30 ffff8b7d8ea91fd8
 ffff8b7d8ea8e4c0 ffff8b807f98e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 ffff88fd8ed95e30 ffff88fd8ed95fd8
 ffff88fd8ed921c0 ffff89007f88e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43
20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0<f3>
90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#13 stuck for 22s! [migration/13:57]
Modules linked in:
CPU 13
Modules linked in:

Pid: 57, comm: migration/13 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff88fd8ede3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ede3de0 R08: ffff89007f8ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000000d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/13 (pid: 57, threadinfo ffff88fd8ede2000, task
ffff88fd8ede0280)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ede0280 ffff89007f8ce340 ffffffff810bfe70
 ffff88fd8ede3ee0 ffffffff810bfd90
BUG: soft lockup - CPU#121 stuck for 22s! [migration/121:595]
Modules linked in:
CPU 121
Modules linked in:

Pid: 595, comm: migration/121 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8a7d8eb83dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8eb83de0 R08: ffff8a807face360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000079 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/121 (pid: 595, threadinfo ffff8a7d8eb82000, task
ffff8a7d8eb80280)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8eb80280 ffff8a807face340 ffffffff810bfe70
 ffff8a7d8eb83ee0 ffffffff810bfd90 ffff8a7d8eb83e30 ffff8a7d8eb83fd8
 ffff8a7d8eb80280 ffff8a807face348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#67 stuck for 22s! [migration/67:327]
Modules linked in:
CPU 67
Modules linked in:

Pid: 327, comm: migration/67 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8eaa1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8eaa1de0 R08: ffff8b807f9ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000043 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807f9c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/67 (pid: 327, threadinfo ffff8b7d8eaa0000, task
ffff8b7d8ea9e580)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8ea9e580 ffff8b807f9ce340 ffffffff810bfe70
 ffff8b7d8eaa1ee0 ffffffff810bfd90 ffff8b7d8eaa1e30 ffff8b7d8eaa1fd8
 ffff8b7d8ea9e580 ffff8b807f9ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 ffff88fd8ede3e30 ffff88fd8ede3fd8
 ffff88fd8ede0280 ffff89007f8ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#14 stuck for 22s! [migration/14:63]
Modules linked in:
CPU 14
Modules linked in:

Pid: 63, comm: migration/14 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff88fd8ee13dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ee13de0 R08: ffff89007f90e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000000e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007f900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/14 (pid: 63, threadinfo ffff88fd8ee12000, task
ffff88fd8ee10340)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ee10340 ffff89007f90e340 ffffffff810bfe70
 ffff88fd8ee13ee0 ffffffff810bfd90 ffff88fd8ee13e30 ffff88fd8ee13fd8
 ffff88fd8ee10340 ffff89007f90e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
BUG: soft lockup - CPU#122 stuck for 22s! [migration/122:599]
Modules linked in:
CPU 122
Modules linked in:

Pid: 599, comm: migration/122 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8ebb3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8ebb3de0 R08: ffff8a807fb0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000007a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/122 (pid: 599, threadinfo ffff8a7d8ebb2000, task
ffff8a7d8ebb0340)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8ebb0340 ffff8a807fb0e340 ffffffff810bfe70
 ffff8a7d8ebb3ee0 ffffffff810bfd90 ffff8a7d8ebb3e30 ffff8a7d8ebb3fd8
 ffff8a7d8ebb0340 ffff8a807fb0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#68 stuck for 22s! [migration/68:331]
Modules linked in:
CPU 68
Modules linked in:

Pid: 331, comm: migration/68 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8ead1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8ead1de0 R08: ffff8b807fa0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000044 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/68 (pid: 331, threadinfo ffff8b7d8ead0000, task
ffff8b7d8eace640)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8eace640 ffff8b807fa0e340 ffffffff810bfe70
 ffff8b7d8ead1ee0 ffffffff810bfd90 ffff8b7d8ead1e30 ffff8b7d8ead1fd8
 ffff8b7d8eace640 ffff8b807fa0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#15 stuck for 22s! [migration/15:67]
Modules linked in:
CPU 15
Modules linked in:

Pid: 67, comm: migration/15 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff88fd8ee23dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ee23de0 R08: ffff89007f94e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000000f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007f940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/15 (pid: 67, threadinfo ffff88fd8ee22000, task
ffff88fd8ee20400)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ee20400 ffff89007f94e340 ffffffff810bfe70
 ffff88fd8ee23ee0 ffffffff810bfd90 ffff88fd8ee23e30 ffff88fd8ee23fd8
 ffff88fd8ee20400 ffff89007f94e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
BUG: soft lockup - CPU#123 stuck for 22s! [migration/123:603]
Modules linked in:
CPU 123
Modules linked in:

Pid: 603, comm: migration/123 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8ebe1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8ebe1de0 R08: ffff8a807fb4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000007b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/123 (pid: 603, threadinfo ffff8a7d8ebe0000, task
ffff8a7d8ebde400)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8ebde400 ffff8a807fb4e340 ffffffff810bfe70
 ffff8a7d8ebe1ee0 ffffffff810bfd90 ffff8a7d8ebe1e30 ffff8a7d8ebe1fd8
 ffff8a7d8ebde400 ffff8a807fb4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#69 stuck for 22s! [migration/69:335]
Modules linked in:
CPU 69
Modules linked in:

Pid: 335, comm: migration/69 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8eaffdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8eaffde0 R08: ffff8b807fa4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000045 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/69 (pid: 335, threadinfo ffff8b7d8eafe000, task
ffff8b7d8eafc700)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8eafc700 ffff8b807fa4e340 ffffffff810bfe70
 ffff8b7d8eaffee0 ffffffff810bfd90 ffff8b7d8eaffe30 ffff8b7d8eafffd8
 ffff8b7d8eafc700 ffff8b807fa4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#16 stuck for 22s! [migration/16:71]
Modules linked in:
CPU 16
Modules linked in:

Pid: 71, comm: migration/16 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8ee51dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ee51de0 R08: ffff89007f98e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000010 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007f980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/16 (pid: 71, threadinfo ffff88fd8ee50000, task
ffff88fd8ee4e4c0)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ee4e4c0 ffff89007f98e340 ffffffff810bfe70
 ffff88fd8ee51ee0 ffffffff810bfd90 ffff88fd8ee51e30 ffff88fd8ee51fd8
 ffff88fd8ee4e4c0 ffff89007f98e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
BUG: soft lockup - CPU#124 stuck for 22s! [migration/124:607]
Modules linked in:
CPU 124
Modules linked in:

Pid: 607, comm: migration/124 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8e411dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e411de0 R08: ffff8a807fb8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000007c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/124 (pid: 607, threadinfo ffff8a7d8e410000, task
ffff8a7d8e40e4c0)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e40e4c0 ffff8a807fb8e340 ffffffff810bfe70
 ffff8a7d8e411ee0 ffffffff810bfd90 ffff8a7d8e411e30 ffff8a7d8e411fd8
 ffff8a7d8e40e4c0 ffff8a807fb8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#70 stuck for 22s! [migration/70:339]
Modules linked in:
CPU 70
Modules linked in:

Pid: 339, comm: migration/70 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e137dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e137de0 R08: ffff8c007f00e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000046 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/70 (pid: 339, threadinfo ffff8bfd8e136000, task
ffff8bfd8e134040)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e134040 ffff8c007f00e340 ffffffff810bfe70
 ffff8bfd8e137ee0 ffffffff810bfd90 ffff8bfd8e137e30 ffff8bfd8e137fd8
 ffff8bfd8e134040 ffff8c007f00e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#17 stuck for 22s! [migration/17:75]
Modules linked in:
CPU 17
Modules linked in:

Pid: 75, comm: migration/17 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff88fd8ee81dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ee81de0 R08: ffff89007f9ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000011 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007f9c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/17 (pid: 75, threadinfo ffff88fd8ee80000, task
ffff88fd8ee7e580)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ee7e580 ffff89007f9ce340 ffffffff810bfe70
 ffff88fd8ee81ee0 ffffffff810bfd90 ffff88fd8ee81e30 ffff88fd8ee81fd8
 ffff88fd8ee7e580 ffff89007f9ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
BUG: soft lockup - CPU#125 stuck for 22s! [migration/125:611]
Modules linked in:
CPU 125
Modules linked in:

Pid: 611, comm: migration/125 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8a7d8e421dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e421de0 R08: ffff8a807fbce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000007d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fbc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/125 (pid: 611, threadinfo ffff8a7d8e420000, task
ffff8a7d8e41e580)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e41e580 ffff8a807fbce340 ffffffff810bfe70
 ffff8a7d8e421ee0 ffffffff810bfd90 ffff8a7d8e421e30 ffff8a7d8e421fd8
 ffff8a7d8e41e580 ffff8a807fbce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#71 stuck for 22s! [migration/71:343]
Modules linked in:
CPU 71
Modules linked in:

Pid: 343, comm: migration/71 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff8bfd8e1a5dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e1a5de0 R08: ffff8c007f04e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000047 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f040000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/71 (pid: 343, threadinfo ffff8bfd8e1a4000, task
ffff8bfd8e1a2100)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e1a2100 ffff8c007f04e340 ffffffff810bfe70
 ffff8bfd8e1a5ee0 ffffffff810bfd90 ffff8bfd8e1a5e30 ffff8bfd8e1a5fd8
 ffff8bfd8e1a2100 ffff8c007f04e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#18 stuck for 22s! [migration/18:79]
Modules linked in:
CPU 18
Modules linked in:

Pid: 79, comm: migration/18 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8ee91dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ee91de0 R08: ffff89007fa0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000012 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
BUG: soft lockup - CPU#126 stuck for 22s! [migration/126:615]
Modules linked in:
CPU 126
Modules linked in:

Pid: 615, comm: migration/126 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8a7d8e44fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e44fde0 R08: ffff8a807fc0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000007e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/126 (pid: 615, threadinfo ffff8a7d8e44e000, task
ffff8a7d8e44c640)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e44c640 ffff8a807fc0e340 ffffffff810bfe70
 ffff8a7d8e44fee0 ffffffff810bfd90 ffff8a7d8e44fe30 ffff8a7d8e44ffd8
 ffff8a7d8e44c640 ffff8a807fc0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#72 stuck for 22s! [migration/72:347]
Modules linked in:
CPU 72
Modules linked in:

Pid: 347, comm: migration/72 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e1d3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e1d3de0 R08: ffff8c007f08e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000048 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/72 (pid: 347, threadinfo ffff8bfd8e1d2000, task
ffff8bfd8e1d01c0)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e1d01c0 ffff8c007f08e340 ffffffff810bfe70
 ffff8bfd8e1d3ee0 ffffffff810bfd90 ffff8bfd8e1d3e30 ffff8bfd8e1d3fd8
 ffff8bfd8e1d01c0 ffff8c007f08e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Process migration/18 (pid: 79, threadinfo ffff88fd8ee90000, task
ffff88fd8ee8e640)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ee8e640 ffff89007fa0e340 ffffffff810bfe70
 ffff88fd8ee91ee0 ffffffff810bfd90 ffff88fd8ee91e30 ffff88fd8ee91fd8
 ffff88fd8ee8e640 ffff89007fa0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#19 stuck for 22s! [migration/19:83]
Modules linked in:
CPU 19
Modules linked in:

Pid: 83, comm: migration/19 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8eebfdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8eebfde0 R08: ffff89007fa4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000013 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
BUG: soft lockup - CPU#127 stuck for 22s! [migration/127:619]
Modules linked in:
CPU 127
Modules linked in:

Pid: 619, comm: migration/127 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8e45fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e45fde0 R08: ffff8a807fc4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000007f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/127 (pid: 619, threadinfo ffff8a7d8e45e000, task
ffff8a7d8e45c700)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e45c700 ffff8a807fc4e340 ffffffff810bfe70
 ffff8a7d8e45fee0 ffffffff810bfd90 ffff8a7d8e45fe30 ffff8a7d8e45ffd8
 ffff8a7d8e45c700 ffff8a807fc4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#73 stuck for 22s! [migration/73:351]
Modules linked in:
CPU 73
Modules linked in:

Pid: 351, comm: migration/73 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff8bfd8e221dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e221de0 R08: ffff8c007f0ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000049 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f0c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/73 (pid: 351, threadinfo ffff8bfd8e220000, task
ffff8bfd8e21e280)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e21e280 ffff8c007f0ce340 ffffffff810bfe70
 ffff8bfd8e221ee0 ffffffff810bfd90 ffff8bfd8e221e30 ffff8bfd8e221fd8
 ffff8bfd8e21e280 ffff8c007f0ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Process migration/19 (pid: 83, threadinfo ffff88fd8eebe000, task
ffff88fd8eebc700)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8eebc700 ffff89007fa4e340 ffffffff810bfe70
 ffff88fd8eebfee0 ffffffff810bfd90 ffff88fd8eebfe30 ffff88fd8eebffd8
 ffff88fd8eebc700 ffff89007fa4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#20 stuck for 22s! [migration/20:87]
Modules linked in:
CPU 20
Modules linked in:

Pid: 87, comm: migration/20 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8e8f9dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8e8f9de0 R08: ffff89807f80e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000014 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
BUG: soft lockup - CPU#128 stuck for 22s! [migration/128:623]
Modules linked in:
CPU 128
Modules linked in:

Pid: 623, comm: migration/128 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8e48fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e48fde0 R08: ffff8a807fc8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000080 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/128 (pid: 623, threadinfo ffff8a7d8e48e000, task
ffff8a7d8e48c7c0)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e48c7c0 ffff8a807fc8e340 ffffffff810bfe70
 ffff8a7d8e48fee0 ffffffff810bfd90 ffff8a7d8e48fe30 ffff8a7d8e48ffd8
 ffff8a7d8e48c7c0 ffff8a807fc8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#74 stuck for 22s! [migration/74:355]
Modules linked in:
CPU 74
Modules linked in:

Pid: 355, comm: migration/74 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e251dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e251de0 R08: ffff8c007f10e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000004a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f100000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/74 (pid: 355, threadinfo ffff8bfd8e250000, task
ffff8bfd8e24e340)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e24e340 ffff8c007f10e340 ffffffff810bfe70
 ffff8bfd8e251ee0 ffffffff810bfd90 ffff8bfd8e251e30 ffff8bfd8e251fd8
 ffff8bfd8e24e340 ffff8c007f10e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/20 (pid: 87, threadinfo ffff897d8e8f8000, task
ffff897d8e8f6040)
Stack:
 ffff8b7d8e4e3c60 ffff897d8e8f6040 ffff89807f80e340 ffffffff810bfe70
 ffff897d8e8f9ee0 ffffffff810bfd90 ffff897d8e8f9e30 ffff897d8e8f9fd8
 ffff897d8e8f6040 ffff89807f80e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#21 stuck for 23s! [migration/21:91]
Modules linked in:
CPU 21
Modules linked in:

Pid: 91, comm: migration/21 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8e947dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8e947de0 R08: ffff89807f84e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000015 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807f840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
BUG: soft lockup - CPU#129 stuck for 23s! [migration/129:627]
Modules linked in:
CPU 129
Modules linked in:

Pid: 627, comm: migration/129 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff8a7d8e49fdc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e49fde0 R08: ffff8a807fcce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000081 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/129 (pid: 627, threadinfo ffff8a7d8e49e000, task
ffff8a7d8e49c880)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e49c880 ffff8a807fcce340 ffffffff810bfe70
 ffff8a7d8e49fee0 ffffffff810bfd90 ffff8a7d8e49fe30 ffff8a7d8e49ffd8
 ffff8a7d8e49c880 ffff8a807fcce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#75 stuck for 23s! [migration/75:359]
Modules linked in:
CPU 75
Modules linked in:

Pid: 359, comm: migration/75 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e261dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e261de0 R08: ffff8c007f14e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000004b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f140000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/75 (pid: 359, threadinfo ffff8bfd8e260000, task
ffff8bfd8e25e400)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e25e400 ffff8c007f14e340 ffffffff810bfe70
 ffff8bfd8e261ee0 ffffffff810bfd90 ffff8bfd8e261e30 ffff8bfd8e261fd8
 ffff8bfd8e25e400 ffff8c007f14e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/21 (pid: 91, threadinfo ffff897d8e946000, task
ffff897d8e944100)
Stack:
 ffff8b7d8e4e3c60 ffff897d8e944100 ffff89807f84e340 ffffffff810bfe70
 ffff897d8e947ee0 ffffffff810bfd90 ffff897d8e947e30 ffff897d8e947fd8
 ffff897d8e944100 ffff89807f84e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#22 stuck for 23s! [migration/22:95]
Modules linked in:
CPU 22
Modules linked in:

Pid: 95, comm: migration/22 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8e995dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
BUG: soft lockup - CPU#130 stuck for 23s! [migration/130:631]
Modules linked in:
CPU 130
Modules linked in:

Pid: 631, comm: migration/130 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8afd8eb75dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8eb75de0 R08: ffff8b007fa8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000082 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/130 (pid: 631, threadinfo ffff8afd8eb74000, task
ffff8afd8eb721c0)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8eb721c0 ffff8b007fa8e340 ffffffff810bfe70
 ffff8afd8eb75ee0 ffffffff810bfd90 ffff8afd8eb75e00 ffff8afd8eb75fd8
 ffff8afd8eb721c0 ffff8b007fa8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#76 stuck for 23s! [migration/76:363]
Modules linked in:
CPU 76
Modules linked in:

Pid: 363, comm: migration/76 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e28fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e28fde0 R08: ffff8c007f18e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000004c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/76 (pid: 363, threadinfo ffff8bfd8e28e000, task
ffff8bfd8e28c4c0)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e28c4c0 ffff8c007f18e340 ffffffff810bfe70
 ffff8bfd8e28fee0 ffffffff810bfd90 ffff8bfd8e28fe30 ffff8bfd8e28ffd8
 ffff8bfd8e28c4c0 ffff8c007f18e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
RBP: ffff897d8e995de0 R08: ffff89807f88e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000016 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/22 (pid: 95, threadinfo ffff897d8e994000, task
ffff897d8e9921c0)
Stack:
 ffff8b7d8e4e3c60 ffff897d8e9921c0 ffff89807f88e340 ffffffff810bfe70
 ffff897d8e995ee0 ffffffff810bfd90 ffff897d8e995e30 ffff897d8e995fd8
 ffff897d8e9921c0 ffff89807f88e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#23 stuck for 23s! [migration/23:99]
Modules linked in:
CPU 23
Modules linked in:

Pid: 99, comm: migration/23 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff897d8e9e3dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8e9e3de0 R08: ffff89807f8ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000017 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
BUG: soft lockup - CPU#131 stuck for 23s! [migration/131:648]
Modules linked in:
CPU 131
Modules linked in:

Pid: 648, comm: migration/131 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8eb85dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8eb85de0 R08: ffff8b007face360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000083 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/131 (pid: 648, threadinfo ffff8afd8eb84000, task
ffff8afd8eb82280)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8eb82280 ffff8b007face340 ffffffff810bfe70
 ffff8afd8eb85ee0 ffffffff810bfd90 ffff8afd8eb85e30 ffff8afd8eb85fd8
 ffff8afd8eb82280 ffff8b007face348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#77 stuck for 23s! [migration/77:367]
Modules linked in:
CPU 77
Modules linked in:

Pid: 367, comm: migration/77 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e2bfdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e2bfde0 R08: ffff8c007f1ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000004d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f1c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/77 (pid: 367, threadinfo ffff8bfd8e2be000, task
ffff8bfd8e2bc580)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e2bc580 ffff8c007f1ce340 ffffffff810bfe70
 ffff8bfd8e2bfee0 ffffffff810bfd90 ffff8bfd8e2bfe30 ffff8bfd8e2bffd8
 ffff8bfd8e2bc580 ffff8c007f1ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/23 (pid: 99, threadinfo ffff897d8e9e2000, task
ffff897d8e9e0280)
Stack:
 ffff8b7d8e4e3c60 ffff897d8e9e0280 ffff89807f8ce340 ffffffff810bfe70
 ffff897d8e9e3ee0 ffffffff810bfd90 ffff897d8e9e3e30 ffff897d8e9e3fd8
 ffff897d8e9e0280 ffff89807f8ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#24 stuck for 23s! [migration/24:103]
Modules linked in:
CPU 24
Modules linked in:

Pid: 103, comm: migration/24 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff897d8ea13dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8ea13de0 R08: ffff89807f90e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000018 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807f900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
BUG: soft lockup - CPU#132 stuck for 23s! [migration/132:652]
Modules linked in:
CPU 132
Modules linked in:

Pid: 652, comm: migration/132 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee2>]  [<ffffffff810bfee2>]
stop_machine_cpu_stop+0x72/0xd0
RSP: 0000:ffff8afd8ebb5dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8ebb5de0 R08: ffff8b007fb0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000084 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/132 (pid: 652, threadinfo ffff8afd8ebb4000, task
ffff8afd8ebb2340)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8ebb2340 ffff8b007fb0e340 ffffffff810bfe70
 ffff8afd8ebb5ee0 ffffffff810bfd90 ffff8afd8ebb5e30 ffff8afd8ebb5fd8
 ffff8afd8ebb2340 ffff8b007fb0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43
20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0<f3>
90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#78 stuck for 23s! [migration/78:371]
Modules linked in:
CPU 78
Modules linked in:

Pid: 371, comm: migration/78 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e2cfdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e2cfde0 R08: ffff8c007f20e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000004e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/78 (pid: 371, threadinfo ffff8bfd8e2ce000, task
ffff8bfd8e2cc640)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e2cc640 ffff8c007f20e340 ffffffff810bfe70
 ffff8bfd8e2cfee0 ffffffff810bfd90 ffff8bfd8e2cfe30 ffff8bfd8e2cffd8
 ffff8bfd8e2cc640 ffff8c007f20e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Process migration/24 (pid: 103, threadinfo ffff897d8ea12000, task
ffff897d8ea10340)
Stack:
 ffff8b7d8e4e3c60 ffff897d8ea10340 ffff89807f90e340 ffffffff810bfe70
 ffff897d8ea13ee0 ffffffff810bfd90 ffff897d8ea13e30 ffff897d8ea13fd8
 ffff897d8ea10340 ffff89807f90e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#25 stuck for 22s! [migration/25:107]
Modules linked in:
CPU 25
Modules linked in:

Pid: 107, comm: migration/25 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff897d8ea41dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8ea41de0 R08: ffff89807f94e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000019 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807f940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
BUG: soft lockup - CPU#133 stuck for 22s! [migration/133:656]
Modules linked in:
CPU 133
Modules linked in:

Pid: 656, comm: migration/133 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8afd8ebc5dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8ebc5de0 R08: ffff8b007fb4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000085 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/133 (pid: 656, threadinfo ffff8afd8ebc4000, task
ffff8afd8ebc2400)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8ebc2400 ffff8b007fb4e340 ffffffff810bfe70
 ffff8afd8ebc5ee0 ffffffff810bfd90 ffff8afd8ebc5e30 ffff8afd8ebc5fd8
 ffff8afd8ebc2400 ffff8b007fb4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#79 stuck for 22s! [migration/79:387]
Modules linked in:
CPU 79
Modules linked in:

Pid: 387, comm: migration/79 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e2fddc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e2fdde0 R08: ffff8c007f24e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000004f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/79 (pid: 387, threadinfo ffff8bfd8e2fc000, task
ffff8bfd8e2fa700)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e2fa700 ffff8c007f24e340 ffffffff810bfe70
 ffff8bfd8e2fdee0 ffffffff810bfd90 ffff8bfd8e2fde30 ffff8bfd8e2fdfd8
 ffff8bfd8e2fa700 ffff8c007f24e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/25 (pid: 107, threadinfo ffff897d8ea40000, task
ffff897d8ea3e400)
Stack:
 ffff8b7d8e4e3c60 ffff897d8ea3e400 ffff89807f94e340 ffffffff810bfe70
 ffff897d8ea41ee0 ffffffff810bfd90 ffff897d8ea41e30 ffff897d8ea41fd8
 ffff897d8ea3e400 ffff89807f94e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#26 stuck for 22s! [migration/26:111]
Modules linked in:
CPU 26
Modules linked in:

Pid: 111, comm: migration/26 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8ea51dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8ea51de0 R08: ffff89807f98e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000001a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807f980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
BUG: soft lockup - CPU#134 stuck for 22s! [migration/134:660]
Modules linked in:
CPU 134
Modules linked in:

Pid: 660, comm: migration/134 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8ebf3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8ebf3de0 R08: ffff8b007fb8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000086 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/134 (pid: 660, threadinfo ffff8afd8ebf2000, task
ffff8afd8ebf04c0)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8ebf04c0 ffff8b007fb8e340 ffffffff810bfe70
 ffff8afd8ebf3ee0 ffffffff810bfd90 ffff8afd8ebf3e30 ffff8afd8ebf3fd8
 ffff8afd8ebf04c0 ffff8b007fb8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#80 stuck for 22s! [migration/80:392]
Modules linked in:
CPU 80
Modules linked in:

Pid: 392, comm: migration/80 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e3cddc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e3cdde0 R08: ffff88807fa8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000050 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/80 (pid: 392, threadinfo ffff887d8e3cc000, task
ffff887d8e3ca840)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e3ca840 ffff88807fa8e340 ffffffff810bfe70
 ffff887d8e3cdee0 ffffffff810bfd90 ffff887d8e3cde30 ffff887d8e3cdfd8
 ffff887d8e3ca840 ffff88807fa8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/26 (pid: 111, threadinfo ffff897d8ea50000, task
ffff897d8ea4e4c0)
Stack:
 ffff8b7d8e4e3c60 ffff897d8ea4e4c0 ffff89807f98e340 ffffffff810bfe70
 ffff897d8ea51ee0 ffffffff810bfd90 ffff897d8ea51e30 ffff897d8ea51fd8
 ffff897d8ea4e4c0 ffff89807f98e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#27 stuck for 22s! [migration/27:122]
Modules linked in:
CPU 27
Modules linked in:

Pid: 122, comm: migration/27 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff897d8ea81dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8ea81de0 R08: ffff89807f9ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000001b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807f9c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
BUG: soft lockup - CPU#135 stuck for 22s! [migration/135:664]
Modules linked in:
CPU 135
Modules linked in:

Pid: 664, comm: migration/135 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8e403dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8e403de0 R08: ffff8b007fbce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000087 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fbc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/135 (pid: 664, threadinfo ffff8afd8e402000, task
ffff8afd8e400580)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8e400580 ffff8b007fbce340 ffffffff810bfe70
 ffff8afd8e403ee0 ffffffff810bfd90 ffff8afd8e403e30 ffff8afd8e403fd8
 ffff8afd8e400580 ffff8b007fbce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#81 stuck for 22s! [migration/81:396]
Modules linked in:
CPU 81
Modules linked in:

Pid: 396, comm: migration/81 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8e3e9dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8e3e9de0 R08: ffff88807face360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000051 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/81 (pid: 396, threadinfo ffff887d8e3e8000, task
ffff887d8e3e6100)
Stack:
 ffff8b7d8e4e3c60 ffff887d8e3e6100 ffff88807face340 ffffffff810bfe70
 ffff887d8e3e9ee0 ffffffff810bfd90 ffff887d8e3e9e00 ffff887d8e3e9fd8
 ffff887d8e3e6100 ffff88807face348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/27 (pid: 122, threadinfo ffff897d8ea80000, task
ffff897d8ea7e580)
Stack:
 ffff8b7d8e4e3c60 ffff897d8ea7e580 ffff89807f9ce340 ffffffff810bfe70
 ffff897d8ea81ee0 ffffffff810bfd90 ffff897d8ea81e30 ffff897d8ea81fd8
 ffff897d8ea7e580 ffff89807f9ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#28 stuck for 22s! [migration/28:132]
Modules linked in:
CPU 28
Modules linked in:

Pid: 132, comm: migration/28 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8eaafdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8eaafde0 R08: ffff89807fa0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000001c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
BUG: soft lockup - CPU#136 stuck for 22s! [migration/136:668]
Modules linked in:
CPU 136
Modules linked in:

Pid: 668, comm: migration/136 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8e433dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8e433de0 R08: ffff8b007fc0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000088 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/136 (pid: 668, threadinfo ffff8afd8e432000, task
ffff8afd8e430640)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8e430640 ffff8b007fc0e340 ffffffff810bfe70
 ffff8afd8e433ee0 ffffffff810bfd90 ffff8afd8e433e30 ffff8afd8e433fd8
 ffff8afd8e430640 ffff8b007fc0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#82 stuck for 22s! [migration/82:400]
Modules linked in:
CPU 82
Modules linked in:

Pid: 400, comm: migration/82 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8dc27dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8dc27de0 R08: ffff88807fb0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000052 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/82 (pid: 400, threadinfo ffff887d8dc26000, task
ffff887d8dc24240)
Stack:
 ffff8b7d8e4e3c60 ffff887d8dc24240 ffff88807fb0e340 ffffffff810bfe70
 ffff887d8dc27ee0 ffffffff810bfd90 ffff887d8dc27e30 ffff887d8dc27fd8
 ffff887d8dc24240 ffff88807fb0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/28 (pid: 132, threadinfo ffff897d8eaae000, task
ffff897d8eaac640)
Stack:
 ffff8b7d8e4e3c60 ffff897d8eaac640 ffff89807fa0e340 ffffffff810bfe70
 ffff897d8eaafee0 ffffffff810bfd90 ffff897d8eaafe30 ffff897d8eaaffd8
 ffff897d8eaac640 ffff89807fa0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#29 stuck for 22s! [migration/29:136]
Modules linked in:
CPU 29
Modules linked in:

Pid: 136, comm: migration/29 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
BUG: soft lockup - CPU#137 stuck for 22s! [migration/137:672]
Modules linked in:
CPU 137
Modules linked in:

Pid: 672, comm: migration/137 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8e443dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8e443de0 R08: ffff8b007fc4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000089 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/137 (pid: 672, threadinfo ffff8afd8e442000, task
ffff8afd8e440700)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8e440700 ffff8b007fc4e340 ffffffff810bfe70
 ffff8afd8e443ee0 ffffffff810bfd90 ffff8afd8e443e30 ffff8afd8e443fd8
 ffff8afd8e440700 ffff8b007fc4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#83 stuck for 22s! [migration/83:404]
Modules linked in:
CPU 83
Modules linked in:

Pid: 404, comm: migration/83 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8dc45dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8dc45de0 R08: ffff88807fb4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000053 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/83 (pid: 404, threadinfo ffff887d8dc44000, task
ffff887d8dc42380)
Stack:
 ffff8b7d8e4e3c60 ffff887d8dc42380 ffff88807fb4e340 ffffffff810bfe70
 ffff887d8dc45ee0 ffffffff810bfd90 ffff887d8dc45e30 ffff887d8dc45fd8
 ffff887d8dc42380 ffff88807fb4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff897d8eabfdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8eabfde0 R08: ffff89807fa4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000001d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/29 (pid: 136, threadinfo ffff897d8eabe000, task
ffff897d8eabc700)
Stack:
 ffff8b7d8e4e3c60 ffff897d8eabc700 ffff89807fa4e340 ffffffff810bfe70
 ffff897d8eabfee0 ffffffff810bfd90 ffff897d8eabfe30 ffff897d8eabffd8
 ffff897d8eabc700 ffff89807fa4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#30 stuck for 22s! [migration/30:140]
Modules linked in:
CPU 30
Modules linked in:

BUG: soft lockup - CPU#138 stuck for 22s! [migration/138:676]
Modules linked in:
CPU 138
Modules linked in:

Pid: 676, comm: migration/138 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfedf>]  [<ffffffff810bfedf>]
stop_machine_cpu_stop+0x6f/0xd0
RSP: 0000:ffff8afd8e471dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8e471de0 R08: ffff8b007fc8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000008a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/138 (pid: 676, threadinfo ffff8afd8e470000, task
ffff8afd8e46e7c0)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8e46e7c0 ffff8b007fc8e340 ffffffff810bfe70
 ffff8afd8e471ee0 ffffffff810bfd90 ffff8afd8e471e30 ffff8afd8e471fd8
 ffff8afd8e46e7c0 ffff8b007fc8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74
0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31
 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#84 stuck for 22s! [migration/84:408]
Modules linked in:
CPU 84
Modules linked in:

Pid: 408, comm: migration/84 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8dc7ddc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8dc7dde0 R08: ffff88807fb8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000054 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/84 (pid: 408, threadinfo ffff887d8dc7c000, task
ffff887d8dc7a4c0)
Stack:
 ffff8b7d8e4e3c60 ffff887d8dc7a4c0 ffff88807fb8e340 ffffffff810bfe70
 ffff887d8dc7dee0 ffffffff810bfd90 ffff887d8dc7de30 ffff887d8dc7dfd8
 ffff887d8dc7a4c0 ffff88807fb8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Pid: 140, comm: migration/30 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8e919dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8e919de0 R08: ffff8a007f80e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000001e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/30 (pid: 140, threadinfo ffff89fd8e918000, task
ffff89fd8e916040)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8e916040 ffff8a007f80e340 ffffffff810bfe70
 ffff89fd8e919ee0 ffffffff810bfd90 ffff89fd8e919e30 ffff89fd8e919fd8
 ffff89fd8e916040 ffff8a007f80e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#31 stuck for 22s! [migration/31:144]
BUG: soft lockup - CPU#139 stuck for 22s! [migration/139:680]
Modules linked in:
CPU 139
Modules linked in:

Pid: 680, comm: migration/139 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8afd8e481dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8e481de0 R08: ffff8b007fcce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000008b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/139 (pid: 680, threadinfo ffff8afd8e480000, task
ffff8afd8e47e880)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8e47e880 ffff8b007fcce340 ffffffff810bfe70
 ffff8afd8e481ee0 ffffffff810bfd90 ffff8afd8e481e30 ffff8afd8e481fd8
 ffff8afd8e47e880 ffff8b007fcce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#85 stuck for 22s! [migration/85:412]
Modules linked in:
CPU 85
Modules linked in:

Pid: 412, comm: migration/85 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8dc9bdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8dc9bde0 R08: ffff88807fbce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000055 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fbc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/85 (pid: 412, threadinfo ffff887d8dc9a000, task
ffff887d8dc98600)
Stack:
 ffff8b7d8e4e3c60 ffff887d8dc98600 ffff88807fbce340 ffffffff810bfe70
 ffff887d8dc9bee0 ffffffff810bfd90 ffff887d8dc9be30 ffff887d8dc9bfd8
 ffff887d8dc98600 ffff88807fbce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Modules linked in:
CPU 31
Modules linked in:

Pid: 144, comm: migration/31 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8e967dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8e967de0 R08: ffff8a007f84e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000001f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007f840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/31 (pid: 144, threadinfo ffff89fd8e966000, task
ffff89fd8e964100)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8e964100 ffff8a007f84e340 ffffffff810bfe70
 ffff89fd8e967ee0 ffffffff810bfd90 ffff89fd8e967e30 ffff89fd8e967fd8
 ffff89fd8e964100 ffff8a007f84e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#32 stuck for 22s! [migration/32:148]
Modules linked in:
CPU 32
Modules linked in:

BUG: soft lockup - CPU#140 stuck for 22s! [migration/140:684]
Modules linked in:
CPU 140
Modules linked in:

Pid: 684, comm: migration/140 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8eb75dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: ffff8b7d8eb75d70 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8eb75de0 R08: ffff8b807fa8e360 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffffffff81503f4e
R13: 000000000000008c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/140 (pid: 684, threadinfo ffff8b7d8eb74000, task
ffff8b7d8eb721c0)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8eb721c0 ffff8b807fa8e340 ffffffff810bfe70
 ffff8b7d8eb75ee0 ffffffff810bfd90 ffff8b7d8eb75e30 ffff8b7d8eb75fd8
 ffff8b7d8eb721c0 ffff8b807fa8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#86 stuck for 22s! [migration/86:416]
Modules linked in:
CPU 86
Modules linked in:

Pid: 416, comm: migration/86 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfedf>]  [<ffffffff810bfedf>]
stop_machine_cpu_stop+0x6f/0xd0
RSP: 0000:ffff887d8dcb9dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8dcb9de0 R08: ffff88807fc0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000056 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/86 (pid: 416, threadinfo ffff887d8dcb8000, task
ffff887d8dcb6740)
Stack:
 ffff8b7d8e4e3c60 ffff887d8dcb6740 ffff88807fc0e340 ffffffff810bfe70
 ffff887d8dcb9ee0 ffffffff810bfd90 ffff887d8dcb9e00 ffff887d8dcb9fd8
 ffff887d8dcb6740 ffff88807fc0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74
0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31
 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Pid: 148, comm: migration/32 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff89fd8e9b5dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8e9b5de0 R08: ffff8a007f88e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000020 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/32 (pid: 148, threadinfo ffff89fd8e9b4000, task
ffff89fd8e9b21c0)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8e9b21c0 ffff8a007f88e340 ffffffff810bfe70
 ffff89fd8e9b5ee0 ffffffff810bfd90 ffff89fd8e9b5e30 ffff89fd8e9b5fd8
 ffff89fd8e9b21c0 ffff8a007f88e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#33 stuck for 22s! [migration/33:152]
Modules linked in:
CPU 33
Modules linked in:

BUG: soft lockup - CPU#141 stuck for 22s! [migration/141:688]
Modules linked in:
CPU 141
Modules linked in:

Pid: 688, comm: migration/141 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8eba5dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8eba5de0 R08: ffff8b807face360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000008d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/141 (pid: 688, threadinfo ffff8b7d8eba4000, task
ffff8b7d8eba2280)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8eba2280 ffff8b807face340 ffffffff810bfe70
 ffff8b7d8eba5ee0 ffffffff810bfd90 ffff8b7d8eba5e30 ffff8b7d8eba5fd8
 ffff8b7d8eba2280 ffff8b807face348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#87 stuck for 22s! [migration/87:420]
Modules linked in:
CPU 87
Modules linked in:

Pid: 420, comm: migration/87 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8dcf3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8dcf3de0 R08: ffff88807fc4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000057 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/87 (pid: 420, threadinfo ffff887d8dcf2000, task
ffff887d8dcf0880)
Stack:
 ffff8b7d8e4e3c60 ffff887d8dcf0880 ffff88807fc4e340 ffffffff810bfe70
 ffff887d8dcf3ee0 ffffffff810bfd90 ffff887d8dcf3e30 ffff887d8dcf3fd8
 ffff887d8dcf0880 ffff88807fc4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Pid: 152, comm: migration/33 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff89fd8ea03dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8ea03de0 R08: ffff8a007f8ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000021 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/33 (pid: 152, threadinfo ffff89fd8ea02000, task
ffff89fd8ea00280)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8ea00280 ffff8a007f8ce340 ffffffff810bfe70
 ffff89fd8ea03ee0 ffffffff810bfd90 ffff89fd8ea03e30 ffff89fd8ea03fd8
 ffff89fd8ea00280 ffff8a007f8ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#34 stuck for 22s! [migration/34:156]
Modules linked in:
CPU 34
Modules linked in:

BUG: soft lockup - CPU#142 stuck for 22s! [migration/142:692]
Modules linked in:
CPU 142
Modules linked in:

Pid: 692, comm: migration/142 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8b7d8ebd3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8ebd3de0 R08: ffff8b807fb0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000008e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/142 (pid: 692, threadinfo ffff8b7d8ebd2000, task
ffff8b7d8ebd0340)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8ebd0340 ffff8b807fb0e340 ffffffff810bfe70
 ffff8b7d8ebd3ee0 ffffffff810bfd90 ffff8b7d8ebd3e30 ffff8b7d8ebd3fd8
 ffff8b7d8ebd0340 ffff8b807fb0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#88 stuck for 22s! [migration/88:424]
Modules linked in:
CPU 88
Modules linked in:

Pid: 424, comm: migration/88 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8dd11dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8dd11de0 R08: ffff88807fc8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000058 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/88 (pid: 424, threadinfo ffff887d8dd10000, task
ffff887d8dd0e140)
Stack:
 ffff8b7d8e4e3c60 ffff887d8dd0e140 ffff88807fc8e340 ffffffff810bfe70
 ffff887d8dd11ee0 ffffffff810bfd90 ffff887d8dd11e30 ffff887d8dd11fd8
 ffff887d8dd0e140 ffff88807fc8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Pid: 156, comm: migration/34 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee2>]  [<ffffffff810bfee2>]
stop_machine_cpu_stop+0x72/0xd0
RSP: 0000:ffff89fd8ea13dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8ea13de0 R08: ffff8a007f90e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000022 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007f900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/34 (pid: 156, threadinfo ffff89fd8ea12000, task
ffff89fd8ea10340)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8ea10340 ffff8a007f90e340 ffffffff810bfe70
 ffff89fd8ea13ee0 ffffffff810bfd90 ffff89fd8ea13e30 ffff89fd8ea13fd8
 ffff89fd8ea10340 ffff8a007f90e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43
20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0<f3>
90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#35 stuck for 23s! [migration/35:160]
Modules linked in:
CPU 35
Modules linked in:

BUG: soft lockup - CPU#143 stuck for 23s! [migration/143:696]
Modules linked in:
CPU 143
Modules linked in:

Pid: 696, comm: migration/143 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8e403dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e403de0 R08: ffff8b807fb4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000008f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/143 (pid: 696, threadinfo ffff8b7d8e402000, task
ffff8b7d8e400400)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e400400 ffff8b807fb4e340 ffffffff810bfe70
 ffff8b7d8e403ee0 ffffffff810bfd90 ffff8b7d8e403e30 ffff8b7d8e403fd8
 ffff8b7d8e400400 ffff8b807fb4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#89 stuck for 23s! [migration/89:428]
Modules linked in:
CPU 89
Modules linked in:

Pid: 428, comm: migration/89 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff887d8dd4ddc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff887d8dd4dde0 R08: ffff88807fcce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000059 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88807fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/89 (pid: 428, threadinfo ffff887d8dd4c000, task
ffff887d8dd4a280)
Stack:
 ffff8b7d8e4e3c60 ffff887d8dd4a280 ffff88807fcce340 ffffffff810bfe70
 ffff887d8dd4dee0 ffffffff810bfd90 ffff887d8dd4de00 ffff887d8dd4dfd8
 ffff887d8dd4a280 ffff88807fcce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Pid: 160, comm: migration/35 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee2>]  [<ffffffff810bfee2>]
stop_machine_cpu_stop+0x72/0xd0
RSP: 0000:ffff89fd8ea41dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8ea41de0 R08: ffff8a007f94e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000023 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007f940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/35 (pid: 160, threadinfo ffff89fd8ea40000, task
ffff89fd8ea3e400)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8ea3e400 ffff8a007f94e340 ffffffff810bfe70
 ffff89fd8ea41ee0 ffffffff810bfd90 ffff89fd8ea41e30 ffff89fd8ea41fd8
 ffff89fd8ea3e400 ffff8a007f94e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43
20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0<f3>
90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#144 stuck for 23s! [migration/144:713]
Modules linked in:
BUG: soft lockup - CPU#36 stuck for 23s! [migration/36:164]
Modules linked in:
CPU 36
Modules linked in:

Pid: 164, comm: migration/36 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfedf>]  [<ffffffff810bfedf>]
stop_machine_cpu_stop+0x6f/0xd0
RSP: 0000:ffff89fd8ea71dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8ea71de0 R08: ffff8a007f98e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000024 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007f980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/36 (pid: 164, threadinfo ffff89fd8ea70000, task
ffff89fd8ea6e4c0)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8ea6e4c0 ffff8a007f98e340 ffffffff810bfe70
 ffff89fd8ea71ee0 ffffffff810bfd90 ffff89fd8ea71e30 ffff89fd8ea71fd8
 ffff89fd8ea6e4c0 ffff8a007f98e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74
0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31
 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#90 stuck for 23s! [migration/90:432]
Modules linked in:
CPU 90
Modules linked in:

Pid: 432, comm: migration/90 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8ef55dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ef55de0 R08: ffff89007fa8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000005a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/90 (pid: 432, threadinfo ffff88fd8ef54000, task
ffff88fd8ef521c0)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ef521c0 ffff89007fa8e340 ffffffff810bfe70
 ffff88fd8ef55ee0 ffffffff810bfd90 ffff88fd8ef55e30 ffff88fd8ef55fd8
 ffff88fd8ef521c0 ffff89007fa8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
CPU 144
Modules linked in:

Pid: 713, comm: migration/144 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff8b7d8e413dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e413de0 R08: ffff8b807fb8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000090 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/144 (pid: 713, threadinfo ffff8b7d8e412000, task
ffff8b7d8e4104c0)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e4104c0 ffff8b807fb8e340 ffffffff810bfe70
 ffff8b7d8e413ee0 ffffffff810bfd90 ffff8b7d8e413e30 ffff8b7d8e413fd8
 ffff8b7d8e4104c0 ffff8b807fb8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#145 stuck for 23s! [migration/145:717]
Modules linked in:
BUG: soft lockup - CPU#37 stuck for 23s! [migration/37:168]
Modules linked in:
CPU 37
Modules linked in:

Pid: 168, comm: migration/37 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8ea9fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8ea9fde0 R08: ffff8a007f9ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000025 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007f9c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/37 (pid: 168, threadinfo ffff89fd8ea9e000, task
ffff89fd8ea9c580)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8ea9c580 ffff8a007f9ce340 ffffffff810bfe70
 ffff89fd8ea9fee0 ffffffff810bfd90 ffff89fd8ea9fe30 ffff89fd8ea9ffd8
 ffff89fd8ea9c580 ffff8a007f9ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#91 stuck for 23s! [migration/91:436]
Modules linked in:
CPU 91
Modules linked in:

Pid: 436, comm: migration/91 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0018:ffff88fd8ef65dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ef65de0 R08: ffff89007face360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000005b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/91 (pid: 436, threadinfo ffff88fd8ef64000, task
ffff88fd8ef62280)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ef62280 ffff89007face340 ffffffff810bfe70
 ffff88fd8ef65ee0 ffffffff810bfd90 ffff88fd8ef65e30 ffff88fd8ef65fd8
 ffff88fd8ef62280 ffff89007face348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
CPU 145
Modules linked in:

Pid: 717, comm: migration/145 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8e441dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e441de0 R08: ffff8b807fbce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000091 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fbc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/145 (pid: 717, threadinfo ffff8b7d8e440000, task
ffff8b7d8e43e580)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e43e580 ffff8b807fbce340 ffffffff810bfe70
 ffff8b7d8e441ee0 ffffffff810bfd90 ffff8b7d8e441e30 ffff8b7d8e441fd8
 ffff8b7d8e43e580 ffff8b807fbce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#146 stuck for 23s! [migration/146:721]
Modules linked in:
BUG: soft lockup - CPU#38 stuck for 23s! [migration/38:172]
Modules linked in:
CPU 38
Modules linked in:

Pid: 172, comm: migration/38 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff89fd8eaafdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8eaafde0 R08: ffff8a007fa0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000026 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/38 (pid: 172, threadinfo ffff89fd8eaae000, task
ffff89fd8eaac640)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8eaac640 ffff8a007fa0e340 ffffffff810bfe70
 ffff89fd8eaafee0 ffffffff810bfd90 ffff89fd8eaafe30 ffff89fd8eaaffd8
 ffff89fd8eaac640 ffff8a007fa0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#92 stuck for 23s! [migration/92:452]
Modules linked in:
CPU 92
Modules linked in:

Pid: 452, comm: migration/92 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff88fd8ef75dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8ef75de0 R08: ffff89007fb0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000005c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/92 (pid: 452, threadinfo ffff88fd8ef74000, task
ffff88fd8ef72340)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8ef72340 ffff89007fb0e340 ffffffff810bfe70
 ffff88fd8ef75ee0 ffffffff810bfd90 ffff88fd8ef75e30 ffff88fd8ef75fd8
 ffff88fd8ef72340 ffff89007fb0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
CPU 146
Modules linked in:

Pid: 721, comm: migration/146 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8b7d8e451dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e451de0 R08: ffff8b807fc0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000092 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/146 (pid: 721, threadinfo ffff8b7d8e450000, task
ffff8b7d8e44e640)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e44e640 ffff8b807fc0e340 ffffffff810bfe70
 ffff8b7d8e451ee0 ffffffff810bfd90 ffff8b7d8e451e30 ffff8b7d8e451fd8
 ffff8b7d8e44e640 ffff8b807fc0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#147 stuck for 23s! [migration/147:725]
Modules linked in:
BUG: soft lockup - CPU#39 stuck for 23s! [migration/39:176]
Modules linked in:
CPU 39
Modules linked in:

Pid: 176, comm: migration/39 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff89fd8eadfdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff89fd8eadfde0 R08: ffff8a007fa4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000027 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a007fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/39 (pid: 176, threadinfo ffff89fd8eade000, task
ffff89fd8eadc700)
Stack:
 ffff8b7d8e4e3c60 ffff89fd8eadc700 ffff8a007fa4e340 ffffffff810bfe70
 ffff89fd8eadfee0 ffffffff810bfd90 ffff89fd8eadfe30 ffff89fd8eadffd8
 ffff89fd8eadc700 ffff8a007fa4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#93 stuck for 23s! [migration/93:457]
Modules linked in:
CPU 93
Modules linked in:

Pid: 457, comm: migration/93 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff88fd8efa3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8efa3de0 R08: ffff89007fb4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000005d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/93 (pid: 457, threadinfo ffff88fd8efa2000, task
ffff88fd8efa0400)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8efa0400 ffff89007fb4e340 ffffffff810bfe70
 ffff88fd8efa3ee0 ffffffff810bfd90 ffff88fd8efa3e30 ffff88fd8efa3fd8
 ffff88fd8efa0400 ffff89007fb4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13

CPU 147
Modules linked in:

Pid: 725, comm: migration/147 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8e481dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e481de0 R08: ffff8b807fc4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000093 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/147 (pid: 725, threadinfo ffff8b7d8e480000, task
ffff8b7d8e47e700)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e47e700 ffff8b807fc4e340 ffffffff810bfe70
 ffff8b7d8e481ee0 ffffffff810bfd90 ffff8b7d8e481e30 ffff8b7d8e481fd8
 ffff8b7d8e47e700 ffff8b807fc4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#148 stuck for 22s! [migration/148:729]
Modules linked in:
CPU 148
Modules linked in:

Pid: 729, comm: migration/148 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
BUG: soft lockup - CPU#94 stuck for 22s! [migration/94:461]
Modules linked in:
CPU 94
Modules linked in:

Pid: 461, comm: migration/94 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff88fd8efb3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8efb3de0 R08: ffff89007fb8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000005e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/94 (pid: 461, threadinfo ffff88fd8efb2000, task
ffff88fd8efb04c0)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8efb04c0 ffff89007fb8e340 ffffffff810bfe70
 ffff88fd8efb3ee0 ffffffff810bfd90 ffff88fd8efb3e30 ffff88fd8efb3fd8
 ffff88fd8efb04c0 ffff89007fb8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#40 stuck for 22s! [migration/40:188]
Modules linked in:
CPU 40
Modules linked in:

Pid: 188, comm: migration/40 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8e919dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e919de0 R08: ffff8a807f80e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000028 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/40 (pid: 188, threadinfo ffff8a7d8e918000, task
ffff8a7d8e916040)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e916040 ffff8a807f80e340 ffffffff810bfe70
 ffff8a7d8e919ee0 ffffffff810bfd90 ffff8a7d8e919e30 ffff8a7d8e919fd8
 ffff8a7d8e916040 ffff8a807f80e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
RSP: 0000:ffff8b7d8e491dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e491de0 R08: ffff8b807fc8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000094 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/148 (pid: 729, threadinfo ffff8b7d8e490000, task
ffff8b7d8e48e7c0)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e48e7c0 ffff8b807fc8e340 ffffffff810bfe70
 ffff8b7d8e491ee0 ffffffff810bfd90 ffff8b7d8e491e30 ffff8b7d8e491fd8
 ffff8b7d8e48e7c0 ffff8b807fc8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#149 stuck for 22s! [migration/149:733]
Modules linked in:
CPU 149
Modules linked in:

Pid: 733, comm: migration/149 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8b7d8e4bfdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8b7d8e4bfde0 R08: ffff8b807fcce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
BUG: soft lockup - CPU#41 stuck for 22s! [migration/41:197]
Modules linked in:
CPU 41
Modules linked in:

Pid: 197, comm: migration/41 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8e967dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e967de0 R08: ffff8a807f84e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000029 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807f840000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/41 (pid: 197, threadinfo ffff8a7d8e966000, task
ffff8a7d8e964100)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e964100 ffff8a807f84e340 ffffffff810bfe70
 ffff8a7d8e967ee0 ffffffff810bfd90 ffff8a7d8e967e30 ffff8a7d8e967fd8
 ffff8a7d8e964100 ffff8a807f84e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#95 stuck for 22s! [migration/95:465]
Modules linked in:
CPU 95
Modules linked in:

Pid: 465, comm: migration/95 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8efe3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8efe3de0 R08: ffff89007fbce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000005f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fbc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/95 (pid: 465, threadinfo ffff88fd8efe2000, task
ffff88fd8efe0580)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8efe0580 ffff89007fbce340 ffffffff810bfe70
 ffff88fd8efe3ee0 ffffffff810bfd90 ffff88fd8efe3e30 ffff88fd8efe3fd8
 ffff88fd8efe0580 ffff89007fbce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
R13: 0000000000000095 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b807fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/149 (pid: 733, threadinfo ffff8b7d8e4be000, task
ffff8b7d8e4bc880)
Stack:
 ffff8b7d8e4e3c60 ffff8b7d8e4bc880 ffff8b807fcce340 ffffffff810bfe70
 ffff8b7d8e4bfee0 ffffffff810bfd90 ffff8b7d8e4bfe30 ffff8b7d8e4bffd8
 ffff8b7d8e4bc880 ffff8b807fcce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#150 stuck for 22s! [migration/150:737]
Modules linked in:
CPU 150
Modules linked in:

Pid: 737, comm: migration/150 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8bfd8e393dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e393de0 R08: ffff8c007f28e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
BUG: soft lockup - CPU#42 stuck for 22s! [migration/42:201]
Modules linked in:
CPU 42
Modules linked in:

Pid: 201, comm: migration/42 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8e9b5dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8e9b5de0 R08: ffff8a807f88e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000002a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/42 (pid: 201, threadinfo ffff8a7d8e9b4000, task
ffff8a7d8e9b21c0)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8e9b21c0 ffff8a807f88e340 ffffffff810bfe70
 ffff8a7d8e9b5ee0 ffffffff810bfd90 ffff8a7d8e9b5e30 ffff8a7d8e9b5fd8
 ffff8a7d8e9b21c0 ffff8a807f88e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#96 stuck for 22s! [migration/96:469]
Modules linked in:
CPU 96
Modules linked in:

Pid: 469, comm: migration/96 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8eff3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8eff3de0 R08: ffff89007fc0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000060 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/96 (pid: 469, threadinfo ffff88fd8eff2000, task
ffff88fd8eff0640)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8eff0640 ffff89007fc0e340 ffffffff810bfe70
 ffff88fd8eff3ee0 ffffffff810bfd90 ffff88fd8eff3e30 ffff88fd8eff3fd8
 ffff88fd8eff0640 ffff89007fc0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
R13: 0000000000000096 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/150 (pid: 737, threadinfo ffff8bfd8e392000, task
ffff8bfd8e3901c0)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e3901c0 ffff8c007f28e340 ffffffff810bfe70
 ffff8bfd8e393ee0 ffffffff810bfd90 ffff8bfd8e393e30 ffff8bfd8e393fd8
 ffff8bfd8e3901c0 ffff8c007f28e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#151 stuck for 22s! [migration/151:741]
Modules linked in:
CPU 151
Modules linked in:

Pid: 741, comm: migration/151 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e3a3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e3a3de0 R08: ffff8c007f2ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
BUG: soft lockup - CPU#43 stuck for 22s! [migration/43:205]
Modules linked in:
CPU 43
Modules linked in:

Pid: 205, comm: migration/43 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8a7d8ea03dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8ea03de0 R08: ffff8a807f8ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000002b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807f8c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/43 (pid: 205, threadinfo ffff8a7d8ea02000, task
ffff8a7d8ea00280)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8ea00280 ffff8a807f8ce340 ffffffff810bfe70
 ffff8a7d8ea03ee0 ffffffff810bfd90 ffff8a7d8ea03e30 ffff8a7d8ea03fd8
 ffff8a7d8ea00280 ffff8a807f8ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#97 stuck for 22s! [migration/97:473]
Modules linked in:
CPU 97
Modules linked in:

Pid: 473, comm: migration/97 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8e821dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8e821de0 R08: ffff89007fc4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000061 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/97 (pid: 473, threadinfo ffff88fd8e820000, task
ffff88fd8e81e700)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8e81e700 ffff89007fc4e340 ffffffff810bfe70
 ffff88fd8e821ee0 ffffffff810bfd90 ffff88fd8e821e30 ffff88fd8e821fd8
 ffff88fd8e81e700 ffff89007fc4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
R13: 0000000000000097 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f2c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/151 (pid: 741, threadinfo ffff8bfd8e3a2000, task
ffff8bfd8e3a0280)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e3a0280 ffff8c007f2ce340 ffffffff810bfe70
 ffff8bfd8e3a3ee0 ffffffff810bfd90 ffff8bfd8e3a3e30 ffff8bfd8e3a3fd8
 ffff8bfd8e3a0280 ffff8c007f2ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#152 stuck for 22s! [migration/152:745]
Modules linked in:
CPU 152
Modules linked in:

Pid: 745, comm: migration/152 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8bfd8e3b3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e3b3de0 R08: ffff8c007f30e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000098 R14: ffffffff81795960 R15: 0000000000000000
BUG: soft lockup - CPU#44 stuck for 22s! [migration/44:209]
Modules linked in:
CPU 44
Modules linked in:

Pid: 209, comm: migration/44 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8ea31dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8ea31de0 R08: ffff8a807f90e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000002c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807f900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/44 (pid: 209, threadinfo ffff8a7d8ea30000, task
ffff8a7d8ea2e340)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8ea2e340 ffff8a807f90e340 ffffffff810bfe70
 ffff8a7d8ea31ee0 ffffffff810bfd90 ffff8a7d8ea31e30 ffff8a7d8ea31fd8
 ffff8a7d8ea2e340 ffff8a807f90e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
BUG: soft lockup - CPU#98 stuck for 22s! [migration/98:477]
Modules linked in: [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0

CPU 98
Modules linked in:

 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Pid: 477, comm: migration/98 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff88fd8e831dc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8e831de0 R08: ffff89007fc8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000062 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/98 (pid: 477, threadinfo ffff88fd8e830000, task
ffff88fd8e82e7c0)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8e82e7c0 ffff89007fc8e340 ffffffff810bfe70
 ffff88fd8e831ee0 ffffffff810bfd90 ffff88fd8e831e30 ffff88fd8e831fd8
 ffff88fd8e82e7c0 ffff89007fc8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
FS:  0000000000000000(0000) GS:ffff8c007f300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/152 (pid: 745, threadinfo ffff8bfd8e3b2000, task
ffff8bfd8e3b0340)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e3b0340 ffff8c007f30e340 ffffffff810bfe70
 ffff8bfd8e3b3ee0 ffffffff810bfd90 ffff8bfd8e3b3e30 ffff8bfd8e3b3fd8
 ffff8bfd8e3b0340 ffff8c007f30e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#153 stuck for 22s! [migration/153:749]
Modules linked in:
CPU 153
Modules linked in:

Pid: 749, comm: migration/153 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
BUG: soft lockup - CPU#45 stuck for 22s! [migration/45:213]
Modules linked in:
CPU 45
Modules linked in:

Pid: 213, comm: migration/45 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8ea61dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8ea61de0 R08: ffff8a807f94e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000002d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807f940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/45 (pid: 213, threadinfo ffff8a7d8ea60000, task
ffff8a7d8ea5e400)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8ea5e400 ffff8a807f94e340 ffffffff810bfe70
 ffff8a7d8ea61ee0 ffffffff810bfd90 ffff8a7d8ea61e30 ffff8a7d8ea61fd8
 ffff8a7d8ea5e400 ffff8a807f94e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#99 stuck for 22s! [migration/99:481]
Modules linked in:
CPU 99
Modules linked in:

Pid: 481, comm: migration/99 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff88fd8e861dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff88fd8e861de0 R08: ffff89007fcce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000063 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89007fcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/99 (pid: 481, threadinfo ffff88fd8e860000, task
ffff88fd8e85e880)
Stack:
 ffff8b7d8e4e3c60 ffff88fd8e85e880 ffff89007fcce340 ffffffff810bfe70
 ffff88fd8e861ee0 ffffffff810bfd90 ffff88fd8e861e30 ffff88fd8e861fd8
 ffff88fd8e85e880 ffff89007fcce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13

RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8e3e1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8e3e1de0 R08: ffff8c007f34e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000099 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f340000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/153 (pid: 749, threadinfo ffff8bfd8e3e0000, task
ffff8bfd8e3de400)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8e3de400 ffff8c007f34e340 ffffffff810bfe70
 ffff8bfd8e3e1ee0 ffffffff810bfd90 ffff8bfd8e3e1e30 ffff8bfd8e3e1fd8
 ffff8bfd8e3de400 ffff8c007f34e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#154 stuck for 22s! [migration/154:753]
Modules linked in:
CPU 154
Modules linked in:

Pid: 753, comm: migration/154 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8dc11dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8dc11de0 R08: ffff8c007f38e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
BUG: soft lockup - CPU#46 stuck for 22s! [migration/46:217]
Modules linked in:
CPU 46
Modules linked in:

Pid: 217, comm: migration/46 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8ea71dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8ea71de0 R08: ffff8a807f98e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000002e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807f980000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/46 (pid: 217, threadinfo ffff8a7d8ea70000, task
ffff8a7d8ea6e4c0)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8ea6e4c0 ffff8a807f98e340 ffffffff810bfe70
 ffff8a7d8ea71ee0 ffffffff810bfd90 ffff8a7d8ea71e30 ffff8a7d8ea71fd8
 ffff8a7d8ea6e4c0 ffff8a807f98e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#100 stuck for 22s! [migration/100:485]
Modules linked in:
CPU 100
Modules linked in:

Pid: 485, comm: migration/100 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfedf>]  [<ffffffff810bfedf>]
stop_machine_cpu_stop+0x6f/0xd0
RSP: 0000:ffff897d8eb55dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8eb55de0 R08: ffff89807fa8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000064 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fa80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/100 (pid: 485, threadinfo ffff897d8eb54000, task
ffff897d8eb521c0)
Stack:
 ffff8b7d8e4e3c60 ffff897d8eb521c0 ffff89807fa8e340 ffffffff810bfe70
 ffff897d8eb55ee0 ffffffff810bfd90 ffff897d8eb55e30 ffff897d8eb55fd8
 ffff897d8eb521c0 ffff89807fa8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74
0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31
 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
R13: 000000000000009a R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f380000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/154 (pid: 753, threadinfo ffff8bfd8dc10000, task
ffff8bfd8dc0e4c0)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8dc0e4c0 ffff8c007f38e340 ffffffff810bfe70
 ffff8bfd8dc11ee0 ffffffff810bfd90 ffff8bfd8dc11e30 ffff8bfd8dc11fd8
 ffff8bfd8dc0e4c0 ffff8c007f38e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#155 stuck for 22s! [migration/155:757]
Modules linked in:
CPU 155
Modules linked in:

Pid: 757, comm: migration/155 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8dc21dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8dc21de0 R08: ffff8c007f3ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
BUG: soft lockup - CPU#47 stuck for 22s! [migration/47:221]
Modules linked in:
CPU 47
Modules linked in:

Pid: 221, comm: migration/47 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8a7d8ea9fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8ea9fde0 R08: ffff8a807f9ce360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 000000000000002f R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807f9c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/47 (pid: 221, threadinfo ffff8a7d8ea9e000, task
ffff8a7d8ea9c580)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8ea9c580 ffff8a807f9ce340 ffffffff810bfe70
 ffff8a7d8ea9fee0 ffffffff810bfd90 ffff8a7d8ea9fe30 ffff8a7d8ea9ffd8
 ffff8a7d8ea9c580 ffff8a807f9ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#101 stuck for 22s! [migration/101:489]
Modules linked in:
CPU 101
Modules linked in:

Pid: 489, comm: migration/101 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8eb83dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8eb83de0 R08: ffff89807face360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000065 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fac0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/101 (pid: 489, threadinfo ffff897d8eb82000, task
ffff897d8eb80280)
Stack:
 ffff8b7d8e4e3c60 ffff897d8eb80280 ffff89807face340 ffffffff810bfe70
 ffff897d8eb83ee0 ffffffff810bfd90 ffff897d8eb83e30 ffff897d8eb83fd8
 ffff897d8eb80280 ffff89807face348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
R13: 000000000000009b R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f3c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/155 (pid: 757, threadinfo ffff8bfd8dc20000, task
ffff8bfd8dc1e580)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8dc1e580 ffff8c007f3ce340 ffffffff810bfe70
 ffff8bfd8dc21ee0 ffffffff810bfd90 ffff8bfd8dc21e30 ffff8bfd8dc21fd8
 ffff8bfd8dc1e580 ffff8c007f3ce348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#156 stuck for 22s! [migration/156:761]
Modules linked in:
CPU 156
Modules linked in:

Pid: 761, comm: migration/156 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee8>]  [<ffffffff810bfee8>]
stop_machine_cpu_stop+0x78/0xd0
RSP: 0000:ffff8bfd8dc31dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8dc31de0 R08: ffff8c007f40e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
BUG: soft lockup - CPU#48 stuck for 22s! [migration/48:225]
Modules linked in:
CPU 48
Modules linked in:

Pid: 225, comm: migration/48 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee2>]  [<ffffffff810bfee2>]
stop_machine_cpu_stop+0x72/0xd0
RSP: 0000:ffff8a7d8eacfdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8eacfde0 R08: ffff8a807fa0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000030 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/48 (pid: 225, threadinfo ffff8a7d8eace000, task
ffff8a7d8eacc640)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8eacc640 ffff8a807fa0e340 ffffffff810bfe70
 ffff8a7d8eacfee0 ffffffff810bfd90 ffff8a7d8eacfe30 ffff8a7d8eacffd8
 ffff8a7d8eacc640 ffff8a807fa0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 00 41 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43
20 8b 4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0<f3>
90 44 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#102 stuck for 22s! [migration/102:493]
Modules linked in:
CPU 102
Modules linked in:

Pid: 493, comm: migration/102 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8ebb3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8ebb3de0 R08: ffff89807fb0e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000066 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/102 (pid: 493, threadinfo ffff897d8ebb2000, task
ffff897d8ebb0340)
Stack:
 ffff8b7d8e4e3c60 ffff897d8ebb0340 ffff89807fb0e340 ffffffff810bfe70
 ffff897d8ebb3ee0 ffffffff810bfd90 ffff897d8ebb3e30 ffff897d8ebb3fd8
 ffff897d8ebb0340 ffff89807fb0e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
R13: 000000000000009c R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/156 (pid: 761, threadinfo ffff8bfd8dc30000, task
ffff8bfd8dc2e640)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8dc2e640 ffff8c007f40e340 ffffffff810bfe70
 ffff8bfd8dc31ee0 ffffffff810bfd90 ffff8bfd8dc31e30 ffff8bfd8dc31fd8
 ffff8bfd8dc2e640 ffff8c007f40e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0
01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20
 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66 90 eb c2 0f
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#157 stuck for 22s! [migration/157:778]
Modules linked in:
CPU 157
Modules linked in:

Pid: 778, comm: migration/157 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8dc5fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8dc5fde0 R08: ffff8c007f44e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
BUG: soft lockup - CPU#49 stuck for 22s! [migration/49:229]
Modules linked in:
CPU 49
Modules linked in:

Pid: 229, comm: migration/49 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfed9>]  [<ffffffff810bfed9>]
stop_machine_cpu_stop+0x69/0xd0
RSP: 0000:ffff8a7d8eadfdc0  EFLAGS: 00000246
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8a7d8eadfde0 R08: ffff8a807fa4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000031 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8a807fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/49 (pid: 229, threadinfo ffff8a7d8eade000, task
ffff8a7d8eadc700)
Stack:
 ffff8b7d8e4e3c60 ffff8a7d8eadc700 ffff8a807fa4e340 ffffffff810bfe70
 ffff8a7d8eadfee0 ffffffff810bfd90 ffff8a7d8eadfe30 ffff8a7d8eadffd8
 ffff8a7d8eadc700 ffff8a807fa4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: c0 eb 31 0f 1f 80 00 00 00 00 41 83 fc 03 74 42 f0 41 ff 4d 00
0f 94 c0 84 c0 74 0f 8b 43 20 8b 4b 10 83 c0 01 89 4b 24 89 43 20
 83 fc 04 74 31 44 89 e0 f3 90 44 8b 63 20 41 39 c4 74 ec 41
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#103 stuck for 22s! [migration/103:497]
Modules linked in:
CPU 103
Modules linked in:

Pid: 497, comm: migration/103 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8ebc3dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8ebc3de0 R08: ffff89807fb4e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000067 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fb40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/103 (pid: 497, threadinfo ffff897d8ebc2000, task
ffff897d8ebc0400)
Stack:
 ffff8b7d8e4e3c60 ffff897d8ebc0400 ffff89807fb4e340 ffffffff810bfe70
 ffff897d8ebc3ee0 ffffffff810bfd90 ffff897d8ebc3e30 ffff897d8ebc3fd8
 ffff897d8ebc0400 ffff89807fb4e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
R13: 000000000000009d R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/157 (pid: 778, threadinfo ffff8bfd8dc5e000, task
ffff8bfd8dc5c700)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8dc5c700 ffff8c007f44e340 ffffffff810bfe70
 ffff8bfd8dc5fee0 ffffffff810bfd90 ffff8bfd8dc5fe30 ffff8bfd8dc5ffd8
 ffff8bfd8dc5c700 ffff8c007f44e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#158 stuck for 23s! [migration/158:782]
Modules linked in:
CPU 158
Modules linked in:

Pid: 782, comm: migration/158 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8bfd8dc6fdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8bfd8dc6fde0 R08: ffff8c007f48e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
BUG: soft lockup - CPU#50 stuck for 23s! [migration/50:233]
Modules linked in:
CPU 50
Modules linked in:

Pid: 233, comm: migration/50 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff8afd8e91bdc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff8afd8e91bde0 R08: ffff8b007f80e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000032 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b007f800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/50 (pid: 233, threadinfo ffff8afd8e91a000, task
ffff8afd8e918040)
Stack:
 ffff8b7d8e4e3c60 ffff8afd8e918040 ffff8b007f80e340 ffffffff810bfe70
 ffff8afd8e91bee0 ffffffff810bfd90 ffff8afd8e91be30 ffff8afd8e91bfd8
 ffff8afd8e918040 ffff8b007f80e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
BUG: soft lockup - CPU#104 stuck for 23s! [migration/104:501]
Modules linked in:
CPU 104
Modules linked in:

Pid: 501, comm: migration/104 Not tainted 2.6.39-100.6.1.el6uek.x86_64
#1 Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff810bfee4>]  [<ffffffff810bfee4>]
stop_machine_cpu_stop+0x74/0xd0
RSP: 0000:ffff897d8ebf1dc0  EFLAGS: 00000293
RAX: 0000000000000001 RBX: 000000080000026f RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff818a9500
RBP: ffff897d8ebf1de0 R08: ffff89807fb8e360 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81503f4e
R13: 0000000000000068 R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff89807fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/104 (pid: 501, threadinfo ffff897d8ebf0000, task
ffff897d8ebee4c0)
Stack:
 ffff8b7d8e4e3c60 ffff897d8ebee4c0 ffff89807fb8e340 ffffffff810bfe70
 ffff897d8ebf1ee0 ffffffff810bfd90 ffff897d8ebf1e30 ffff897d8ebf1fd8
 ffff897d8ebee4c0 ffff89807fb8e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
R13: 000000000000009e R14: ffffffff81795960 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8c007f480000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/158 (pid: 782, threadinfo ffff8bfd8dc6e000, task
ffff8bfd8dc6c7c0)
Stack:
 ffff8b7d8e4e3c60 ffff8bfd8dc6c7c0 ffff8c007f48e340 ffffffff810bfe70
 ffff8bfd8dc6fee0 ffffffff810bfd90 ffff8bfd8dc6fe30 ffff8bfd8dc6ffd8
 ffff8bfd8dc6c7c0 ffff8c007f48e348 0000000000011ec0 0000000000000000
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 83 fc 03 74 42 f0 41 ff 4d 00 0f 94 c0 84 c0 74 0f 8b 43 20 8b
4b 10 83 c0 01 89 4b 24 89 43 20 41 83 fc 04 74 31 44 89 e0 f3 90
 8b 63 20 41 39 c4 74 ec 41 83 fc 02 75 c5 fa 66 66 90 66 66
Call Trace:
 [<ffffffff810bfe70>] ? cpu_stopper_thread+0x1d0/0x1d0
 [<ffffffff810bfd90>] cpu_stopper_thread+0xf0/0x1d0
 [<ffffffff814f8b40>] ? __schedule+0x3f0/0x800
 [<ffffffff810bfca0>] ? res_counter_charge+0x100/0x100
 [<ffffffff81089ef6>] kthread+0x96/0xa0
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
HugeTLB registered 2 MB page size, pre-allocated 0 pages
BUG: soft lockup - CPU#42 stuck for 21s! [swapper:1]
Modules linked in:
CPU 42
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
Oracle Corporation  Sun Fire X4800 M2 /
RIP: 0010:[<ffffffff814fb2d9>]  [<ffffffff814fb2d9>]
_raw_spin_unlock_irqrestore+0x19/0x30
RSP: 0000:ffff887d8efbfe18  EFLAGS: 00000282
RAX: 0000000018080200 RBX: 0000000000000006 RCX: 0140000000000400
RDX: ffffea0541bfe8d0 RSI: 0000000000000282 RDI: 0000000000000282
RBP: ffff887d8efbfe20 R08: 0000000000000004 R09: 0000000000000000
R10: ffff89807ffcbfe8 R11: 0000000000000300 R12: ffffffff81503f4e
R13: 0000000000000000 R14: 0000000000000082 R15: ffff887d8efbfe00
FS:  0000000000000000(0000) GS:ffff8a807f880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff887d8efbe000, task ffff887d8efbc040)
Stack:
 ffff89807ffece00 ffff887d8efbfe60 ffffffff811105d1 0000000000000000
 000000000000000a 0000000000000000 ffffffff818ea81d 0000000000000000
 0000000000000000 ffff887d8efbfe80 ffffffff81157f2a 0000000000000000
Call Trace:
 [<ffffffff811105d1>] setup_per_zone_wmarks+0xb1/0xe0
 [<ffffffff818ea81d>] ? kmem_cache_init_late+0x87/0x87
 [<ffffffff81157f2a>] set_recommended_min_free_kbytes+0x8a/0xa0
 [<ffffffff818ea935>] hugepage_init+0x118/0x12d
 [<ffffffff81002043>] do_one_initcall+0x43/0x190
 [<ffffffff818c46fd>] kernel_init+0x15b/0x1e6
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff818c45a2>] ? parse_early_options+0x20/0x20
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
Code: 66 90 e8 bb 2b b4 ff 66 90 c9 c3 0f 1f 80 00 00 00 00 55 48 89
e5 53 66 66 66 66 90 48 89 f3 e8 ee 2b b4 ff 66 90 48 89 df 57 9d
 66 90 66 90 5b c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00
Call Trace:
 [<ffffffff811105d1>] setup_per_zone_wmarks+0xb1/0xe0
 [<ffffffff818ea81d>] ? kmem_cache_init_late+0x87/0x87
 [<ffffffff81157f2a>] set_recommended_min_free_kbytes+0x8a/0xa0
 [<ffffffff818ea935>] hugepage_init+0x118/0x12d
 [<ffffffff81002043>] do_one_initcall+0x43/0x190
 [<ffffffff818c46fd>] kernel_init+0x15b/0x1e6
 [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
 [<ffffffff818c45a2>] ? parse_early_options+0x20/0x20
 [<ffffffff815046a0>] ? gs_change+0x13/0x13
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32768
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
ksign: Installing public key data
Loading keyring
- Added public key FFB33165C5735AD0
- User ID: Oracle America, Inc. (Kernel Module GPG key)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered (default)
io scheduler cfq registered
pcieport 0000:00:01.0: setting latency timer to 64
pcieport 0000:00:01.0: irq 140 for MSI/MSI-X
pcieport 0000:00:03.0: setting latency timer to 64
pcieport 0000:00:03.0: irq 141 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
pcieport 0000:00:05.0: irq 142 for MSI/MSI-X
pcieport 0000:00:07.0: setting latency timer to 64
pcieport 0000:00:07.0: irq 143 for MSI/MSI-X
pcieport 0000:00:09.0: setting latency timer to 64
pcieport 0000:00:09.0: irq 144 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 145 for MSI/MSI-X
pcieport 0000:40:00.0: setting latency timer to 64
pcieport 0000:40:00.0: irq 146 for MSI/MSI-X
pcieport 0000:40:01.0: setting latency timer to 64
pcieport 0000:40:01.0: irq 147 for MSI/MSI-X
pcieport 0000:40:03.0: setting latency timer to 64
pcieport 0000:40:03.0: irq 148 for MSI/MSI-X
pcieport 0000:40:05.0: setting latency timer to 64
pcieport 0000:40:05.0: irq 149 for MSI/MSI-X
pcieport 0000:40:07.0: setting latency timer to 64
pcieport 0000:40:07.0: irq 150 for MSI/MSI-X
pcieport 0000:40:09.0: setting latency timer to 64
pcieport 0000:40:09.0: irq 151 for MSI/MSI-X
pcieport 0000:80:00.0: setting latency timer to 64
pcieport 0000:80:00.0: irq 152 for MSI/MSI-X
pcieport 0000:80:01.0: setting latency timer to 64
pcieport 0000:80:01.0: irq 153 for MSI/MSI-X
pcieport 0000:80:03.0: setting latency timer to 64
pcieport 0000:80:03.0: irq 154 for MSI/MSI-X
pcieport 0000:80:05.0: setting latency timer to 64
pcieport 0000:80:05.0: irq 155 for MSI/MSI-X
pcieport 0000:80:07.0: setting latency timer to 64
pcieport 0000:80:07.0: irq 156 for MSI/MSI-X
pcieport 0000:80:09.0: setting latency timer to 64
pcieport 0000:80:09.0: irq 157 for MSI/MSI-X
pcieport 0000:c0:00.0: setting latency timer to 64
pcieport 0000:c0:00.0: irq 158 for MSI/MSI-X
pcieport 0000:c0:01.0: setting latency timer to 64
pcieport 0000:c0:01.0: irq 159 for MSI/MSI-X
pcieport 0000:c0:03.0: setting latency timer to 64
pcieport 0000:c0:03.0: irq 160 for MSI/MSI-X
pcieport 0000:c0:05.0: setting latency timer to 64
pcieport 0000:c0:05.0: irq 161 for MSI/MSI-X
pcieport 0000:c0:07.0: setting latency timer to 64
pcieport 0000:c0:07.0: irq 162 for MSI/MSI-X
pcieport 0000:c0:09.0: setting latency timer to 64
pcieport 0000:c0:09.0: irq 163 for MSI/MSI-X
aer 0000:00:01.0:pcie02: service driver aer loaded
aer 0000:00:03.0:pcie02: service driver aer loaded
aer 0000:00:05.0:pcie02: service driver aer loaded
aer 0000:00:07.0:pcie02: service driver aer loaded
aer 0000:00:09.0:pcie02: service driver aer loaded
aer 0000:40:00.0:pcie02: service driver aer loaded
aer 0000:40:01.0:pcie02: service driver aer loaded
aer 0000:40:03.0:pcie02: service driver aer loaded
aer 0000:40:05.0:pcie02: service driver aer loaded
aer 0000:40:07.0:pcie02: service driver aer loaded
aer 0000:40:09.0:pcie02: service driver aer loaded
aer 0000:80:00.0:pcie02: service driver aer loaded
aer 0000:80:01.0:pcie02: service driver aer loaded
aer 0000:80:03.0:pcie02: service driver aer loaded
aer 0000:80:05.0:pcie02: service driver aer loaded
aer 0000:80:07.0:pcie02: service driver aer loaded
aer 0000:80:09.0:pcie02: service driver aer loaded
aer 0000:c0:00.0:pcie02: service driver aer loaded
aer 0000:c0:01.0:pcie02: service driver aer loaded
aer 0000:c0:03.0:pcie02: service driver aer loaded
aer 0000:c0:05.0:pcie02: service driver aer loaded
aer 0000:c0:07.0:pcie02: service driver aer loaded
aer 0000:c0:09.0:pcie02: service driver aer loaded
pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
pci 0000:10:00.0: Signaling PME through PCIe PME interrupt
pci 0000:10:00.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
pcieport 0000:40:00.0: Signaling PME through PCIe PME interrupt
pci 0000:41:00.0: Signaling PME through PCIe PME interrupt
pci 0000:41:00.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:40:00.0:pcie01: service driver pcie_pme loaded
pcieport 0000:40:01.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:40:01.0:pcie01: service driver pcie_pme loaded
pcieport 0000:40:03.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:40:03.0:pcie01: service driver pcie_pme loaded
pcieport 0000:40:05.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:40:05.0:pcie01: service driver pcie_pme loaded
pcieport 0000:40:07.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:40:07.0:pcie01: service driver pcie_pme loaded
pcieport 0000:40:09.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:40:09.0:pcie01: service driver pcie_pme loaded
pcieport 0000:80:00.0: Signaling PME through PCIe PME interrupt
pci 0000:81:00.0: Signaling PME through PCIe PME interrupt
pci 0000:81:00.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:80:00.0:pcie01: service driver pcie_pme loaded
pcieport 0000:80:01.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:80:01.0:pcie01: service driver pcie_pme loaded
pcieport 0000:80:03.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:80:03.0:pcie01: service driver pcie_pme loaded
pcieport 0000:80:05.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:80:05.0:pcie01: service driver pcie_pme loaded
pcieport 0000:80:07.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:80:07.0:pcie01: service driver pcie_pme loaded
pcieport 0000:80:09.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:80:09.0:pcie01: service driver pcie_pme loaded
pcieport 0000:c0:00.0: Signaling PME through PCIe PME interrupt
pci 0000:c1:00.0: Signaling PME through PCIe PME interrupt
pci 0000:c1:00.1: Signaling PME through PCIe PME interrupt
pcie_pme 0000:c0:00.0:pcie01: service driver pcie_pme loaded
pcieport 0000:c0:01.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:c0:01.0:pcie01: service driver pcie_pme loaded
pcieport 0000:c0:03.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:c0:03.0:pcie01: service driver pcie_pme loaded
pcieport 0000:c0:05.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:c0:05.0:pcie01: service driver pcie_pme loaded
pcieport 0000:c0:07.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:c0:07.0:pcie01: service driver pcie_pme loaded
pcieport 0000:c0:09.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:c0:09.0:pcie01: service driver pcie_pme loaded
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp 0000:00:03.0:pcie04: HPC vendor_id 8086 device_id 340a ss_vid
8086 ss_did 0
pciehp 0000:00:03.0:pcie04: service driver pciehp loaded
pciehp 0000:00:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid
8086 ss_did 0
pciehp 0000:00:05.0:pcie04: service driver pciehp loaded
pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 3a40 ss_vid
8086 ss_did 3a40
pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
pciehp 0000:40:03.0:pcie04: HPC vendor_id 8086 device_id 340a ss_vid
8086 ss_did 0
pciehp 0000:40:03.0:pcie04: service driver pciehp loaded
pciehp 0000:40:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid
8086 ss_did 0
pciehp 0000:40:05.0:pcie04: service driver pciehp loaded
pciehp 0000:80:03.0:pcie04: HPC vendor_id 8086 device_id 340a ss_vid
8086 ss_did 0
pciehp 0000:80:03.0:pcie04: service driver pciehp loaded
pciehp 0000:80:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid
8086 ss_did 0
pciehp 0000:80:05.0:pcie04: service driver pciehp loaded
pciehp 0000:c0:03.0:pcie04: HPC vendor_id 8086 device_id 340a ss_vid
8086 ss_did 0
pciehp 0000:c0:03.0:pcie04: service driver pciehp loaded
pciehp 0000:c0:05.0:pcie04: HPC vendor_id 8086 device_id 340c ss_vid
8086 ss_did 0
pciehp 0000:c0:05.0:pcie04: service driver pciehp loaded
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
intel_idle: MWAIT substates: 0x1120
intel_idle: v0.4 model 0x2F
intel_idle: lapic_timer_reliable_states 0xffffffff
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: acpi_idle yielding to intel_idle
APEI: Can not request iomem region<000000007f7a4230-000000007f7a4234>  for GARs.
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
loop: module loaded
Fixed MDIO Bus: probed
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C ->  GSI 18 (level, low) ->  IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xaf0fa000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.39-100.6.1.el6uek.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A ->  GSI 23 (level, low) ->  IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xaf0f8000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.39-100.6.1.el6uek.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A ->  GSI 22 (level, low) ->  IRQ 22
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 22, io base 0x00000a00
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.39-100.6.1.el6uek.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B ->  GSI 21 (level, low) ->  IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00000c00
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.39-100.6.1.el6uek.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT D ->  GSI 19 (level, low) ->  IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00000e00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.39-100.6.1.el6uek.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A ->  GSI 23 (level, low) ->  IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00000200
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.39-100.6.1.el6uek.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B ->  GSI 19 (level, low) ->  IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00000600
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.39-100.6.1.el6uek.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C ->  GSI 18 (level, low) ->  IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00000880
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.39-100.6.1.el6uek.x86_64 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
i8042: PNP: No PS/2 controller found. Probing ports directly.
i8042: No controller found
mousedev: PS/2 mouse device common for all mice
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
zram: num_devices not specified. Using default: 1
zram: Creating 1 devices ...
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Registering the dns_resolver key type
registered taskstats version 1
usb 1-3: new high speed USB device number 2 using ehci_hcd
usb 1-3: config 1 interface 0 altsetting 0 endpoint 0x81 has an
invalid bInterval 255, changing to 11
usb 1-3: New USB device found, idVendor=046b, idProduct=ff01
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-3: Product: Generic Hub
usb 1-3: Manufacturer: American Megatrends Inc.
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 2 ports detected
usb 2-1: new high speed USB device number 2 using ehci_hcd
usb 2-1: New USB device found, idVendor=04b4, idProduct=6560
usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 4 ports detected
usb 5-1: new low speed USB device number 2 using uhci_hcd
usb 5-1: New USB device found, idVendor=046b, idProduct=ff10
usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-1: Product: Virtual Keyboard and Mouse
usb 5-1: Manufacturer: American Megatrends Inc.
input: American Megatrends Inc. Virtual Keyboard and Mouse as
/devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.0/input/input2
generic-usb 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard
[American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1a.2-1/input0
input: American Megatrends Inc. Virtual Keyboard and Mouse as
/devices/pci0000:00/0000:00:1a.2/usb5/5-1/5-1:1.1/input/input3
generic-usb 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse
[American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1a.2-1/input1
IMA: No TPM chip found, activating TPM-bypass!
rtc_cmos 00:03: setting system clock to 2012-05-14 09:16:26 UTC (1336986986)
Initializing network drop monitor service
Freeing unused kernel memory: 1144k freed
dracut: dracut-004-256.0.1.el6
dracut: rd_NO_LUKS: removing cryptoluks activation
Loading iSCSI transport class v2.0-870.
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
iscsi: registered transport (cxgb3i)
Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
iscsi: registered transport (cxgb4i)
NET: Registered protocol family 10
cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.7 (July 20, 2011)
Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.0.3 (Jun 15, 2011)
iscsi: registered transport (bnx2i)
iscsi: registered transport (be2iscsi)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
udev: starting version 147
udevd (1083): /proc/1083/oom_adj is deprecated, please use
/proc/1083/oom_score_adj instead.
dracut: Starting plymouth daemon
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
megasas: 00.00.05.40-rc1 Tue. Jul. 26 17:00:00 PDT 2011
megasas: 0x1000:0x0079:0x1000:0x9262: bus 1:slot 0:func 0
megaraid_sas 0000:01:00.0: PCI INT A ->  GSI 28 (level, low) ->  IRQ 28
megaraid_sas 0000:01:00.0: setting latency timer to 64
megasas: FW now in Ready state
megaraid_sas 0000:01:00.0: irq 164 for MSI/MSI-X
megasas_init_mfi: fw_support_ieee=0
megasas: INIT adapter done
scsi0 : LSI SAS based MegaRAID driver
scsi 0:0:9:0: Enclosure         SUN      C4 NEM           0700 PQ: 0 ANSI: 5
scsi 0:0:10:0: Enclosure         SUN      C4 NEM           0700 PQ: 0 ANSI: 5
scsi 0:0:14:0: Direct-Access     HITACHI  H106060SDSUN600G A202 PQ: 0 ANSI: 6
scsi 0:0:15:0: Direct-Access     HITACHI  H106060SDSUN600G A202 PQ: 0 ANSI: 6
dca service started, version 1.12.1
scsi 0:0:16:0: Direct-Access     SEAGATE  ST930003SSUN300G 0768 PQ: 0 ANSI: 5
scsi 0:0:17:0: Direct-Access     SEAGATE  ST930003SSUN300G 0768 PQ: 0 ANSI: 5
scsi 0:0:19:0: Direct-Access     SEAGATE  ST930003SSUN300G 0868 PQ: 0 ANSI: 5
Intel(R) Gigabit Ethernet Network Driver - version 3.0.6-k2
Copyright (c) 2007-2011 Intel Corporation.
scsi 0:0:20:0: Direct-Access     SEAGATE  ST930003SSUN300G 0868 PQ: 0 ANSI: 5
igb 0000:10:00.0: PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
igb 0000:10:00.0: setting latency timer to 64
igb 0000:10:00.0: irq 165 for MSI/MSI-X
igb 0000:10:00.0: irq 166 for MSI/MSI-X
igb 0000:10:00.0: irq 167 for MSI/MSI-X
igb 0000:10:00.0: irq 168 for MSI/MSI-X
igb 0000:10:00.0: irq 169 for MSI/MSI-X
igb 0000:10:00.0: irq 170 for MSI/MSI-X
igb 0000:10:00.0: irq 171 for MSI/MSI-X
igb 0000:10:00.0: irq 172 for MSI/MSI-X
igb 0000:10:00.0: irq 173 for MSI/MSI-X
igb 0000:10:00.0: 0 vfs allocated
scsi 0:2:0:0: Direct-Access     LSI      MR9262-8i        2.12 PQ: 0 ANSI: 5
scsi 0:2:1:0: Direct-Access     LSI      MR9262-8i        2.12 PQ: 0 ANSI: 5
scsi 0:2:2:0: Direct-Access     LSI      MR9262-8i        2.12 PQ: 0 ANSI: 5
scsi 0:2:4:0: Direct-Access     LSI      MR9262-8i        2.12 PQ: 0 ANSI: 5
igb 0000:10:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:10:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:21:28:a7:8d:cc
igb 0000:10:00.0: eth0: PBA No: 2020FF-0FF
igb 0000:10:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:10:00.1: PCI INT B ->  GSI 17 (level, low) ->  IRQ 17
igb 0000:10:00.1: setting latency timer to 64
igb 0000:10:00.1: irq 174 for MSI/MSI-X
igb 0000:10:00.1: irq 175 for MSI/MSI-X
igb 0000:10:00.1: irq 176 for MSI/MSI-X
igb 0000:10:00.1: irq 177 for MSI/MSI-X
igb 0000:10:00.1: irq 178 for MSI/MSI-X
igb 0000:10:00.1: irq 179 for MSI/MSI-X
igb 0000:10:00.1: irq 180 for MSI/MSI-X
igb 0000:10:00.1: irq 181 for MSI/MSI-X
igb 0000:10:00.1: irq 182 for MSI/MSI-X
igb 0000:10:00.1: 0 vfs allocated
igb 0000:10:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:10:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:21:28:a7:8d:cd
igb 0000:10:00.1: eth1: PBA No: 2020FF-0FF
igb 0000:10:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:41:00.0: PCI INT A ->  GSI 71 (level, low) ->  IRQ 71
igb 0000:41:00.0: setting latency timer to 64
igb 0000:41:00.0: irq 183 for MSI/MSI-X
igb 0000:41:00.0: irq 184 for MSI/MSI-X
igb 0000:41:00.0: irq 185 for MSI/MSI-X
igb 0000:41:00.0: irq 186 for MSI/MSI-X
igb 0000:41:00.0: irq 187 for MSI/MSI-X
igb 0000:41:00.0: irq 188 for MSI/MSI-X
igb 0000:41:00.0: irq 189 for MSI/MSI-X
igb 0000:41:00.0: irq 190 for MSI/MSI-X
igb 0000:41:00.0: irq 191 for MSI/MSI-X
igb 0000:41:00.0: 0 vfs allocated
igb 0000:41:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:41:00.0: eth2: (PCIe:2.5Gb/s:Width x4) 00:21:28:a7:90:f0
igb 0000:41:00.0: eth2: PBA No: 2020FF-0FF
igb 0000:41:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:41:00.1: PCI INT B ->  GSI 70 (level, low) ->  IRQ 70
igb 0000:41:00.1: setting latency timer to 64
igb 0000:41:00.1: irq 192 for MSI/MSI-X
igb 0000:41:00.1: irq 193 for MSI/MSI-X
igb 0000:41:00.1: irq 194 for MSI/MSI-X
igb 0000:41:00.1: irq 195 for MSI/MSI-X
igb 0000:41:00.1: irq 196 for MSI/MSI-X
igb 0000:41:00.1: irq 197 for MSI/MSI-X
igb 0000:41:00.1: irq 198 for MSI/MSI-X
igb 0000:41:00.1: irq 199 for MSI/MSI-X
igb 0000:41:00.1: irq 200 for MSI/MSI-X
igb 0000:41:00.1: 0 vfs allocated
igb 0000:41:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:41:00.1: eth3: (PCIe:2.5Gb/s:Width x4) 00:21:28:a7:90:f1
igb 0000:41:00.1: eth3: PBA No: 2020FF-0FF
igb 0000:41:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:81:00.0: PCI INT A ->  GSI 95 (level, low) ->  IRQ 95
igb 0000:81:00.0: setting latency timer to 64
igb 0000:81:00.0: irq 201 for MSI/MSI-X
igb 0000:81:00.0: irq 202 for MSI/MSI-X
igb 0000:81:00.0: irq 203 for MSI/MSI-X
igb 0000:81:00.0: irq 204 for MSI/MSI-X
igb 0000:81:00.0: irq 205 for MSI/MSI-X
igb 0000:81:00.0: irq 206 for MSI/MSI-X
igb 0000:81:00.0: irq 207 for MSI/MSI-X
igb 0000:81:00.0: irq 208 for MSI/MSI-X
igb 0000:81:00.0: irq 209 for MSI/MSI-X
igb 0000:81:00.0: 0 vfs allocated
igb 0000:81:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:81:00.0: eth4: (PCIe:2.5Gb/s:Width x4) 00:21:28:a7:91:64
igb 0000:81:00.0: eth4: PBA No: 2020FF-0FF
igb 0000:81:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:81:00.1: PCI INT B ->  GSI 94 (level, low) ->  IRQ 94
igb 0000:81:00.1: setting latency timer to 64
igb 0000:81:00.1: irq 210 for MSI/MSI-X
igb 0000:81:00.1: irq 211 for MSI/MSI-X
igb 0000:81:00.1: irq 212 for MSI/MSI-X
igb 0000:81:00.1: irq 213 for MSI/MSI-X
igb 0000:81:00.1: irq 214 for MSI/MSI-X
igb 0000:81:00.1: irq 215 for MSI/MSI-X
igb 0000:81:00.1: irq 216 for MSI/MSI-X
igb 0000:81:00.1: irq 217 for MSI/MSI-X
igb 0000:81:00.1: irq 218 for MSI/MSI-X
igb 0000:81:00.1: 0 vfs allocated
igb 0000:81:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:81:00.1: eth5: (PCIe:2.5Gb/s:Width x4) 00:21:28:a7:91:65
igb 0000:81:00.1: eth5: PBA No: 2020FF-0FF
igb 0000:81:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:c1:00.0: PCI INT A ->  GSI 119 (level, low) ->  IRQ 119
igb 0000:c1:00.0: setting latency timer to 64
igb 0000:c1:00.0: irq 219 for MSI/MSI-X
igb 0000:c1:00.0: irq 220 for MSI/MSI-X
igb 0000:c1:00.0: irq 221 for MSI/MSI-X
igb 0000:c1:00.0: irq 222 for MSI/MSI-X
igb 0000:c1:00.0: irq 223 for MSI/MSI-X
igb 0000:c1:00.0: irq 224 for MSI/MSI-X
igb 0000:c1:00.0: irq 225 for MSI/MSI-X
igb 0000:c1:00.0: irq 226 for MSI/MSI-X
igb 0000:c1:00.0: irq 227 for MSI/MSI-X
igb 0000:c1:00.0: 0 vfs allocated
igb 0000:c1:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:c1:00.0: eth6: (PCIe:2.5Gb/s:Width x4) 00:21:28:44:e5:1e
igb 0000:c1:00.0: eth6: PBA No: 2020FF-0FF
igb 0000:c1:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
igb 0000:c1:00.1: PCI INT B ->  GSI 118 (level, low) ->  IRQ 118
igb 0000:c1:00.1: setting latency timer to 64
igb 0000:c1:00.1: irq 228 for MSI/MSI-X
igb 0000:c1:00.1: irq 229 for MSI/MSI-X
igb 0000:c1:00.1: irq 230 for MSI/MSI-X
igb 0000:c1:00.1: irq 231 for MSI/MSI-X
igb 0000:c1:00.1: irq 232 for MSI/MSI-X
igb 0000:c1:00.1: irq 233 for MSI/MSI-X
igb 0000:c1:00.1: irq 234 for MSI/MSI-X
igb 0000:c1:00.1: irq 235 for MSI/MSI-X
igb 0000:c1:00.1: irq 236 for MSI/MSI-X
igb 0000:c1:00.1: 0 vfs allocated
igb 0000:c1:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:c1:00.1: eth7: (PCIe:2.5Gb/s:Width x4) 00:21:28:44:e5:1f
igb 0000:c1:00.1: eth7: PBA No: 2020FF-0FF
igb 0000:c1:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B ->  GSI 19 (level, low) ->  IRQ 19
ahci 0000:00:1f.2: irq 237 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part
ccc ems sxs
ahci 0000:00:1f.2: setting latency timer to 64
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci


On Thu, May 24, 2012 at 8:32 AM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 24 May 2012, Andrea Arcangeli wrote:
>
>> > This has nothing to do with mm/huge_memory.c, which is transparent
>> > hugepages code, it's the lengthy iteration done for a very large
>> > ZONE_NORMAL in setup_zone_migrate_reserve().
>> >
>> > This should be fixed by 938929f14cb5 ("mm: reduce the amount of work done
>> > when updating min_free_kbytes") and was merged in 3.3.  Let us know if
>> > there's still a problem after upgrading to either that or 3.4
>>
>> I thought that was only a performance optimization, so if the oops is
>> generated by a timeout it can fix it, so good idea to try it. But a
>> timeout watchdog triggering exactly in spin_unlock sounds a bit
>> unlikely occurence, so I assumed too long time here meant "wait forever
>> because it crashed".
>>
>
> The bug report is ambiguous because it doesn't include the full set of
> messages, so I was assuming it was timing out because irqs were disabled
> for too long while iterating over a large ZONE_NORMAL based on Ethan's
> description of what he was seeing.  Ethan, if the problem persists with a
> 3.3 or later kernel please follow-up with the full dmesg, thanks.
