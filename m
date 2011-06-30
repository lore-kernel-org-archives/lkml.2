Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1F3Qcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:32:51 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:11185 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1F3Qcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:32:47 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz179dN1432N98dKzz1202hzzz32i668h839h34h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNM3AG-02-6R7-02
X-M-MSG: 
Date: Thu, 30 Jun 2011 18:32:28 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Tejun Heo <tj@kernel.org>
CC: "Seidel, Conny" <Conny.Seidel@amd.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 32bit NUMA and fakeNUMA broken for AMD CPUs
Message-ID: <20110630163227.GU478@escobedo.osrc.amd.com>
References: <20110626102235.GC12200@mtj.dyndns.org>
 <20110626223807.47cef5c6.conny.seidel_amd.com@marah.osrc.amd.com>
 <20110628174613.GP478@escobedo.osrc.amd.com>
 <20110629094451.GJ3386@htj.dyndns.org>
 <20110629123409.GL3386@htj.dyndns.org>
 <20110629125507.GQ478@escobedo.osrc.amd.com>
 <20110629130349.GM3386@htj.dyndns.org>
 <20110629161517.GN3386@htj.dyndns.org>
 <20110630131337.GT478@escobedo.osrc.amd.com>
 <20110630155557.GS3386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <20110630155557.GS3386@htj.dyndns.org>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b.
 Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach,
 Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr.
 43632
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Jun 30, 2011 at 11:55:57AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jun 30, 2011 at 03:13:38PM +0200, Hans Rosenfeld wrote:
> > On Wed, Jun 29, 2011 at 12:15:17PM -0400, Tejun Heo wrote:
> > > Hans, can you please apply the following patch and post the boot log
> > > from both SPARSEMEM and DISCONTIGMEM kernels?  On SPARSEMEM, it should
> > > reject NUMA config and boot w/ flatmem.
> > 
> > Bootlogs are attached. Now DISCONTIGMEM panics.
> ...
> > [    0.000000] Linux version 2.6.39-rc5-00181-g2706a0b-dirty (root@worms) (gcc version 4.5.2 (Gentoo 4.5.2 p1.1, pie-0.4.5) ) #26 SMP Thu Jun 30 14:39:05 CEST 2011
> 
> Hmmm... it looks like the kernel is crashing from the other bug in
> this thread.  Can you please apply both patches on top of 3.0-rc5 and
> re-test?

Oh, thats why it looked so familiar :)

I wasn't able to reproduce this panic on this machine earlier without
DISCONTIGMEM.

It works now with both patches, bootlog is attached.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset="us-ascii"; name="bootlog_discontigmem"
Content-Disposition: attachment; filename="bootlog_discontigmem"
Content-Transfer-Encoding: quoted-printable
Content-Description: bootlog_discontigmem

kernel /boot/vmlinuz.panic root=3D/dev/sda1 console=3DttyS0,115200 console=
=3Dtty0 ign
ore_loglevel earlyprintk=3DttyS0,115200 debug
   [Linux-bzImage, setup=3D0x3200, size=3D0x34ced0]

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 2.6.39-rc5-00181-g2706a0b-dirty (root@worms) (=
gcc version 4.5.2 (Gentoo 4.5.2 p1.1, pie-0.4.5) ) #37 SM
P Thu Jun 30 18:18:48 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000087800 (usable)
[    0.000000]  BIOS-e820: 0000000000087800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000cc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7e70000 (usable)
[    0.000000]  BIOS-e820: 00000000c7e70000 - 00000000c7e8c000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7e8c000 - 00000000c7e8e000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7e8e000 - 00000000c8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000001838000000 (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: AMD DRACHMA/DRACHMA, BIOS PDPAX1-6 12/15/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usab=
le)
[    0.000000] last_pfn =3D 0x1000000 max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D7FFF write-protect
[    0.000000]   D8000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000001838000000 aka 99200M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] found SMP MP-table at [c00f7240] f7240
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c0083000] 83000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000375fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00375fe000 page 4k
[    0.000000] kernel direct mapping tables up to 375fe000 @ 1bf8000-1c00000
[    0.000000] ACPI: RSDP 000f71c0 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT c7e78aee 00074 (v01 PTLTD  ? XSDT   06040000  LTP=
 00000000)
[    0.000000] ACPI: FACP c7e83b26 000F4 (v03 AMD    CHIPOTLE 06040000 AMD =
 000F4240)
[    0.000000] ACPI: DSDT c7e78b62 0AFC4 (v02    AMD    SB700 06040000 MSFT=
 03000000)
[    0.000000] ACPI: FACS c7e8dfc0 00040
[    0.000000] ACPI: TCPA c7e83c8e 00032 (v02 AMD             06040000 PTEC=
 00000000)
[    0.000000] ACPI: SLIT c7e83cc0 0006C (v01 AMD    F10      06040000 AMD =
 00000001)
[    0.000000] ACPI: SRAT c7e83d2c 004C0 (v02 AMD    F10      06040000 AMD =
 00000001)
[    0.000000] ACPI: IVRS c7e841ec 000E8 (v01  AMD     RD890S 06040000 AMD =
 00000000)
[    0.000000] ACPI: SSDT c7e842d4 078B4 (v01 AMD    POWERNOW 06040000 AMD =
 00000001)
[    0.000000] ACPI: SSDT c7e8bb88 0010A (v01 AMD-K8 AMD-ACPI 06040000  AMD=
 00000001)
[    0.000000] ACPI: APIC c7e8bc92 002FA (v01 PTLTD  ? APIC   06040000  LTP=
 00000000)
[    0.000000] ACPI: MCFG c7e8bf8c 0003C (v01 PTLTD    MCFG   06040000  LTP=
 00000000)
[    0.000000] ACPI: HPET c7e8bfc8 00038 (v01 PTLTD  HPETTBL  06040000  LTP=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] Number of physical nodes 8
[    0.000000] Node 0 MemBase 0000000000000000 Limit 0000000238000000
[    0.000000] Node 1 MemBase 0000000238000000 Limit 0000000638000000
[    0.000000] Node 2 MemBase 0000000638000000 Limit 0000000838000000
[    0.000000] Node 3 MemBase 0000000838000000 Limit 0000000c38000000
[    0.000000] Node 4 MemBase 0000000c38000000 Limit 0000000e38000000
[    0.000000] Node 5 MemBase 0000000e38000000 Limit 0000001000000000
[    0.000000] Node 6 bogus settings 1238000000-1000000000.
[    0.000000] Node 7 bogus settings 1438000000-1000000000.
[    0.000000] BSP APIC ID: 10
[    0.000000] node 0 pfn: [0 - 238000]
[    0.000000] remap_alloc: node 0 [233800000-238000000) -> [f2c00000-f7400=
000)
[    0.000000] Initmem setup node 0 0000000000000000-0000000238000000
[    0.000000]   NODE_DATA [0000000032c00000 - 0000000032c01fff] (remapped)
[    0.000000] node 1 pfn: [238000 - 638000]
[    0.000000] remap_alloc: node 1 [62fe00000-638000000) -> [eaa00000-f2c00=
000)
[    0.000000] Initmem setup node 1 0000000238000000-0000000638000000
[    0.000000]   NODE_DATA [000000002aa00000 - 000000002aa01fff] (remapped)
[    0.000000] node 2 pfn: [638000 - 838000]
[    0.000000] remap_alloc: node 2 [833e00000-838000000) -> [e6800000-eaa00=
000)
[    0.000000] Initmem setup node 2 0000000638000000-0000000838000000
[    0.000000]   NODE_DATA [0000000026800000 - 0000000026801fff] (remapped)
[    0.000000] node 3 pfn: [838000 - c38000]
[    0.000000] remap_alloc: node 3 [c2fe00000-c38000000) -> [de600000-e6800=
000)
[    0.000000] Initmem setup node 3 0000000838000000-0000000c38000000
[    0.000000]   NODE_DATA [000000001e600000 - 000000001e601fff] (remapped)
[    0.000000] node 4 pfn: [c38000 - e38000]
[    0.000000] remap_alloc: node 4 [e33e00000-e38000000) -> [da400000-de600=
000)
[    0.000000] Initmem setup node 4 0000000c38000000-0000000e38000000
[    0.000000]   NODE_DATA [000000001a400000 - 000000001a401fff] (remapped)
[    0.000000] node 5 pfn: [e38000 - 1000000]
[    0.000000] remap_alloc: node 5 [ffc600000-1000000000) -> [d6a00000-da40=
0000)
[    0.000000] Initmem setup node 5 0000000e38000000-0000001000000000
[    0.000000]   NODE_DATA [0000000016a00000 - 0000000016a01fff] (remapped)
[    0.000000] 64650MB HIGHMEM available.
[    0.000000] 885MB LOWMEM available.
[    0.000000] max_low_pfn =3D 375fe, highstart_pfn =3D 375fe
[    0.000000] Low memory ends at vaddr f75fe000
[    0.000000] High memory starts at vaddr f75fe000
[    0.000000]   mapped low ram: 0 - 375fe000
[    0.000000]   low ram: 0 - 375fe000
[    0.000000] Node: 0, start_pfn: 10, end_pfn: 87
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   10
[    0.000000] Node: 0, start_pfn: 100, end_pfn: c7e70
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   100 4100 8100 c100 10100 14100 18100 1c100 20100 24100 281=
00 2c100 30100 34100 38100 3c100 40100 44100 48100 4c100 50100 54100 58100 =
5c100 60100 64100 68100 6c100 70100 74100 78100 7c100 80100 84100 88100 8c1=
00 90100 94100 98100 9c100 a0100 a4100 a8100 ac100 b0100 b4100 b8100 bc100 =
c0100 c4100
[    0.000000] Node: 0, start_pfn: 100000, end_pfn: 238000
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   100000 104000 108000 10c000 110000 114000 118000 11c000 12=
0000 124000 128000 12c000 130000 134000 138000 13c000 140000 144000 148000 =
14c000 150000 154000 158000 15c000 160000 164000 168000 16c000 170000 17400=
0 178000 17c000 180000 184000 188000 18c000 190000 194000 198000 19c000 1a0=
000 1a4000 1a8000 1ac000 1b0000 1b4000 1b8000 1bc000 1c0000 1c4000 1c8000 1=
cc000 1d0000 1d4000 1d8000 1dc000 1e0000 1e4000 1e8000 1ec000 1f0000 1f4000=
 1f8000 1fc000 200000 204000 208000 20c000 210000 214000 218000 21c000 2200=
00 224000 228000 22c000 230000 234000
[    0.000000] Node: 1, start_pfn: 238000, end_pfn: 638000
[    0.000000]   Setting physnode_map array to node 1 for pfns:
[    0.000000]   238000 23c000 240000 244000 248000 24c000 250000 254000 25=
8000 25c000 260000 264000 268000 26c000 270000 274000 278000 27c000 280000 =
284000 288000 28c000 290000 294000 298000 29c000 2a0000 2a4000 2a8000 2ac00=
0 2b0000 2b4000 2b8000 2bc000 2c0000 2c4000 2c8000 2cc000 2d0000 2d4000 2d8=
000 2dc000 2e0000 2e4000 2e8000 2ec000 2f0000 2f4000 2f8000 2fc000 300000 3=
04000 308000 30c000 310000 314000 318000 31c000 320000 324000 328000 32c000=
 330000 334000 338000 33c000 340000 344000 348000 34c000 350000 354000 3580=
00 35c000 360000 364000 368000 36c000 370000 374000 378000 37c000 380000 38=
4000 388000 38c000 390000 394000 398000 39c000 3a0000 3a4000 3a8000 3ac000 =
3b0000 3b4000 3b8000 3bc000 3c0000 3c4000 3c8000 3cc000 3d0000 3d4000 3d800=
0 3dc000 3e0000 3e4000 3e8000 3ec000 3f0000 3f4000 3f8000 3fc000 400000 404=
000 408000 40c000 410000 414000 418000 41c000 420000 424000 428000 42c000 4=
30000 434000 438000 43c000 440000 444000 448000 44c000 450000 454000 458000=
 45c000 460000 464000 468000 46c000 470000 474000 478000 47c000 480000 4840=
00 488000 48c000 490000 494000 498000 49c000 4a0000 4a4000 4a8000 4ac000 4b=
0000 4b4000 4b8000 4bc000 4c0000 4c4000 4c8000 4cc000 4d0000 4d4000 4d8000 =
4dc000 4e0000 4e4000 4e8000 4ec000 4f0000 4f4000 4f8000 4fc000 500000 50400=
0 508000 50c000 510000 514000 518000 51c000 520000 524000 528000 52c000 530=
000 534000 538000 53c000 540000 544000 548000 54c000 550000 554000 558000 5=
5c000 560000 564000 568000 56c000 570000 574000 578000 57c000 580000 584000=
 588000 58c000 590000 594000 598000 59c000 5a0000 5a4000 5a8000 5ac000 5b00=
00 5b4000 5b8000 5bc000 5c0000 5c4000 5c8000 5cc000 5d0000 5d4000 5d8000 5d=
c000 5e0000 5e4000 5e8000 5ec000 5f0000 5f4000 5f8000 5fc000 600000 604000 =
608000 60c000 610000 614000 618000 61c000 620000 624000 628000 62c000 63000=
0 634000
[    0.000000] Node: 2, start_pfn: 638000, end_pfn: 838000
[    0.000000]   Setting physnode_map array to node 2 for pfns:
[    0.000000]   638000 63c000 640000 644000 648000 64c000 650000 654000 65=
8000 65c000 660000 664000 668000 66c000 670000 674000 678000 67c000 680000 =
684000 688000 68c000 690000 694000 698000 69c000 6a0000 6a4000 6a8000 6ac00=
0 6b0000 6b4000 6b8000 6bc000 6c0000 6c4000 6c8000 6cc000 6d0000 6d4000 6d8=
000 6dc000 6e0000 6e4000 6e8000 6ec000 6f0000 6f4000 6f8000 6fc000 700000 7=
04000 708000 70c000 710000 714000 718000 71c000 720000 724000 728000 72c000=
 730000 734000 738000 73c000 740000 744000 748000 74c000 750000 754000 7580=
00 75c000 760000 764000 768000 76c000 770000 774000 778000 77c000 780000 78=
4000 788000 78c000 790000 794000 798000 79c000 7a0000 7a4000 7a8000 7ac000 =
7b0000 7b4000 7b8000 7bc000 7c0000 7c4000 7c8000 7cc000 7d0000 7d4000 7d800=
0 7dc000 7e0000 7e4000 7e8000 7ec000 7f0000 7f4000 7f8000 7fc000 800000 804=
000 808000 80c000 810000 814000 818000 81c000 820000 824000 828000 82c000 8=
30000 834000
[    0.000000] Node: 3, start_pfn: 838000, end_pfn: c38000
[    0.000000]   Setting physnode_map array to node 3 for pfns:
[    0.000000]   838000 83c000 840000 844000 848000 84c000 850000 854000 85=
8000 85c000 860000 864000 868000 86c000 870000 874000 878000 87c000 880000 =
884000 888000 88c000 890000 894000 898000 89c000 8a0000 8a4000 8a8000 8ac00=
0 8b0000 8b4000 8b8000 8bc000 8c0000 8c4000 8c8000 8cc000 8d0000 8d4000 8d8=
000 8dc000 8e0000 8e4000 8e8000 8ec000 8f0000 8f4000 8f8000 8fc000 900000 9=
04000 908000 90c000 910000 914000 918000 91c000 920000 924000 928000 92c000=
 930000 934000 938000 93c000 940000 944000 948000 94c000 950000 954000 9580=
00 95c000 960000 964000 968000 96c000 970000 974000 978000 97c000 980000 98=
4000 988000 98c000 990000 994000 998000 99c000 9a0000 9a4000 9a8000 9ac000 =
9b0000 9b4000 9b8000 9bc000 9c0000 9c4000 9c8000 9cc000 9d0000 9d4000 9d800=
0 9dc000 9e0000 9e4000 9e8000 9ec000 9f0000 9f4000 9f8000 9fc000 a00000 a04=
000 a08000 a0c000 a10000 a14000 a18000 a1c000 a20000 a24000 a28000 a2c000 a=
30000 a34000 a38000 a3c000 a40000 a44000 a48000 a4c000 a50000 a54000 a58000=
 a5c000 a60000 a64000 a68000 a6c000 a70000 a74000 a78000 a7c000 a80000 a840=
00 a88000 a8c000 a90000 a94000 a98000 a9c000 aa0000 aa4000 aa8000 aac000 ab=
0000 ab4000 ab8000 abc000 ac0000 ac4000 ac8000 acc000 ad0000 ad4000 ad8000 =
adc000 ae0000 ae4000 ae8000 aec000 af0000 af4000 af8000 afc000 b00000 b0400=
0 b08000 b0c000 b10000 b14000 b18000 b1c000 b20000 b24000 b28000 b2c000 b30=
000 b34000 b38000 b3c000 b40000 b44000 b48000 b4c000 b50000 b54000 b58000 b=
5c000 b60000 b64000 b68000 b6c000 b70000 b74000 b78000 b7c000 b80000 b84000=
 b88000 b8c000 b90000 b94000 b98000 b9c000 ba0000 ba4000 ba8000 bac000 bb00=
00 bb4000 bb8000 bbc000 bc0000 bc4000 bc8000 bcc000 bd0000 bd4000 bd8000 bd=
c000 be0000 be4000 be8000 bec000 bf0000 bf4000 bf8000 bfc000 c00000 c04000 =
c08000 c0c000 c10000 c14000 c18000 c1c000 c20000 c24000 c28000 c2c000 c3000=
0 c34000
[    0.000000] Node: 4, start_pfn: c38000, end_pfn: e38000
[    0.000000]   Setting physnode_map array to node 4 for pfns:
[    0.000000]   c38000 c3c000 c40000 c44000 c48000 c4c000 c50000 c54000 c5=
8000 c5c000 c60000 c64000 c68000 c6c000 c70000 c74000 c78000 c7c000 c80000 =
c84000 c88000 c8c000 c90000 c94000 c98000 c9c000 ca0000 ca4000 ca8000 cac00=
0 cb0000 cb4000 cb8000 cbc000 cc0000 cc4000 cc8000 ccc000 cd0000 cd4000 cd8=
000 cdc000 ce0000 ce4000 ce8000 cec000 cf0000 cf4000 cf8000 cfc000 d00000 d=
04000 d08000 d0c000 d10000 d14000 d18000 d1c000 d20000 d24000 d28000 d2c000=
 d30000 d34000 d38000 d3c000 d40000 d44000 d48000 d4c000 d50000 d54000 d580=
00 d5c000 d60000 d64000 d68000 d6c000 d70000 d74000 d78000 d7c000 d80000 d8=
4000 d88000 d8c000 d90000 d94000 d98000 d9c000 da0000 da4000 da8000 dac000 =
db0000 db4000 db8000 dbc000 dc0000 dc4000 dc8000 dcc000 dd0000 dd4000 dd800=
0 ddc000 de0000 de4000 de8000 dec000 df0000 df4000 df8000 dfc000 e00000 e04=
000 e08000 e0c000 e10000 e14000 e18000 e1c000 e20000 e24000 e28000 e2c000 e=
30000 e34000
[    0.000000] Node: 5, start_pfn: e38000, end_pfn: 1000000
[    0.000000]   Setting physnode_map array to node 5 for pfns:
[    0.000000]   e38000 e3c000 e40000 e44000 e48000 e4c000 e50000 e54000 e5=
8000 e5c000 e60000 e64000 e68000 e6c000 e70000 e74000 e78000 e7c000 e80000 =
e84000 e88000 e8c000 e90000 e94000 e98000 e9c000 ea0000 ea4000 ea8000 eac00=
0 eb0000 eb4000 eb8000 ebc000 ec0000 ec4000 ec8000 ecc000 ed0000 ed4000 ed8=
000 edc000 ee0000 ee4000 ee8000 eec000 ef0000 ef4000 ef8000 efc000 f00000 f=
04000 f08000 f0c000 f10000 f14000 f18000 f1c000 f20000 f24000 f28000 f2c000=
 f30000 f34000 f38000 f3c000 f40000 f44000 f48000 f4c000 f50000 f54000 f580=
00 f5c000 f60000 f64000 f68000 f6c000 f70000 f74000 f78000 f7c000 f80000 f8=
4000 f88000 f8c000 f90000 f94000 f98000 f9c000 fa0000 fa4000 fa8000 fac000 =
fb0000 fb4000 fb8000 fbc000 fc0000 fc4000 fc8000 fcc000 fd0000 fd4000 fd800=
0 fdc000 fe0000 fe4000 fe8000 fec000 ff0000 ff4000 ff8000 ffc000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000375fe
[    0.000000]   HighMem  0x000375fe -> 0x01000000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000087
[    0.000000]     0: 0x00000100 -> 0x000c7e70
[    0.000000]     0: 0x00100000 -> 0x00238000
[    0.000000]     1: 0x00238000 -> 0x00638000
[    0.000000]     2: 0x00638000 -> 0x00838000
[    0.000000]     3: 0x00838000 -> 0x00c38000
[    0.000000]     4: 0x00c38000 -> 0x00e38000
[    0.000000]     5: 0x00e38000 -> 0x01000000
[    0.000000] On node 0 totalpages: 2096615
[    0.000000] free_area_init_node: node 0, pgdat f2c00000, node_mem_map f2=
c02200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   Normal zone: 1740 pages used for memmap
[    0.000000]   Normal zone: 220978 pages, LIFO batch:31
[    0.000000]   HighMem zone: 16405 pages used for memmap
[    0.000000]   HighMem zone: 1853533 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 4194304
[    0.000000] free_area_init_node: node 1, pgdat eaa00000, node_mem_map ea=
a02000
[    0.000000]   HighMem zone: 32768 pages used for memmap
[    0.000000]   HighMem zone: 4161536 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 2097152
[    0.000000] free_area_init_node: node 2, pgdat e6800000, node_mem_map e6=
802000
[    0.000000]   HighMem zone: 16384 pages used for memmap
[    0.000000]   HighMem zone: 2080768 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 4194304
[    0.000000] free_area_init_node: node 3, pgdat de600000, node_mem_map de=
602000
[    0.000000]   HighMem zone: 32768 pages used for memmap
[    0.000000]   HighMem zone: 4161536 pages, LIFO batch:31
[    0.000000] On node 4 totalpages: 2097152
[    0.000000] free_area_init_node: node 4, pgdat da400000, node_mem_map da=
402000
[    0.000000]   HighMem zone: 16384 pages used for memmap
[    0.000000]   HighMem zone: 2080768 pages, LIFO batch:31
[    0.000000] On node 5 totalpages: 1867776
[    0.000000] free_area_init_node: node 5, pgdat d6a00000, node_mem_map d6=
a02000
[    0.000000]   HighMem zone: 14592 pages used for memmap
[    0.000000]   HighMem zone: 1853184 pages, LIFO batch:31
[    0.000000] Using APIC driver default

--V88s5gaDVPzZ0KCq--
