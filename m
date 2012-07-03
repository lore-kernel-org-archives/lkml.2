Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab2GCL3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:29:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15507 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab2GCL3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:29:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Jul 2012 04:25:52 -0700
Message-ID: <4FF2D783.1030703@nvidia.com>
Date: Tue, 3 Jul 2012 16:59:07 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH 0/6] Port Tegra to generic clk framework
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com> <4FEDE4B6.4010405@wwwdotorg.org> <4FF1E488.9070806@wwwdotorg.org>
In-Reply-To: <4FF1E488.9070806@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2012 11:42 PM, Stephen Warren wrote:
> On 06/29/2012 11:24 AM, Stephen Warren wrote:
>> On 06/28/2012 04:37 AM, Prashant Gaikwad wrote:
>>> This patch set ports Tegra clock code to generic clock framework.
>>>
>>> Depends on
>>> [PATCH v3 0/9] Add clk_prepare/clk_unprepare series
>>> [PATCH] ARM: tegra: Remove second instance of uart clk
>>> [PATCH] dma: tegra: add clk_prepare/clk_unprepare
>>> [PATCH] ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"
>> Prashant, this doesn't apply either to my local development tree
>> (roughly what's in next-20120629), nor Tegra's for-3.6/common-clk
>> branch. Can you please regenerate the series on top of
>> for-3.6/common-clk. Thanks.
> Prashant,
>
> I managed to apply the patches to my local tree (although please note I
> still need a patchset that applies cleanly to common-clk without
> conflicting with PWM) and it appears to work fine on Tegra30/Cardhu, but
> fails on Tegra20 (I tested both Ventana and Whistler) with the kernel
> log below.
>
> Does this patch series have any dependencies not in 3.5-rc2, aside from
> the various patches already in Tegra's for-3.6/common-clk branch? Did
> you test it on Tegra20?
>
I had tested it on Tegra20. I have sent v2 rebased on top of Tegra'2 
for-3.6/common-clk.
Tested on Tegra30 (Cardhu) and Tegra20 (Ventana).

>> Uncompressing Linux... done, booting the kernel.
>> [    0.000000] Booting Linux on physical CPU 0
>> [    0.000000] Initializing cgroup subsys cpu
>> [    0.000000] Linux version 3.5.0-rc5-next-20120702-00018-g87d5256 (swarren@swarren-lx1) (gcc version 4.5.3 (crosstool-NG hg_unknown@20110628.165246) ) #86 S2
>> [    0.000000] CPU: ARMv7 Processor [411fc090] revision 0 (ARMv7), cr=10c5387d
>> [    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
>> [    0.000000] Machine: nVidia Tegra20 (Flattened Device Tree), model: NVIDIA Tegra2 Whistler evaluation board
>> [    0.000000] bootconsole [earlycon0] enabled
>> [    0.000000] Memory policy: ECC disabled, Data cache writealloc
>> [    0.000000] On node 0 totalpages: 131072
>> [    0.000000] free_area_init_node: node 0, pgdat c05f4800, node_mem_map c064a000
>> [    0.000000]   Normal zone: 1152 pages used for memmap
>> [    0.000000]   Normal zone: 0 pages reserved
>> [    0.000000]   Normal zone: 129920 pages, LIFO batch:31
>> [    0.000000] Tegra Revision: A02 SKU: 7 CPU Process: 0 Core Process: 0
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] kernel BUG at mm/slab.c:716!
>> [    0.000000] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
>> [    0.000000] Modules linked in:
>> [    0.000000] CPU: 0    Not tainted  (3.5.0-rc5-next-20120702-00018-g87d5256 #86)
>> [    0.000000] PC is at __kmalloc+0xf8/0x144
>> [    0.000000] LR is at __clk_set_parent+0x60/0x1e8
>> [    0.000000] pc : [<c00befd8>]    lr : [<c02d780c>]    psr: 600001d3
>> [    0.000000] sp : c0599f20  ip : 22222222  fp : 00000000
>> [    0.000000] r10: 00000000  r9 : c05bfdb4  r8 : 3fffffff
>> [    0.000000] r7 : c02d780c  r6 : c05bfff4  r5 : c05bfc74  r4 : 00000000
>> [    0.000000] r3 : c05d7c60  r2 : c05bfb74  r1 : 000080d0  r0 : 00000020
>> [    0.000000] Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
>> [    0.000000] Control: 10c5387d  Table: 0000404a  DAC: 00000015
>> [    0.000000] Process swapper (pid: 0, stack limit = 0xc05982f0)
>> [    0.000000] Stack: (0xc0599f20 to 0xc059a000)
>> [    0.000000] 9f20: 00000008 00000001 c05bfc74 c05bfff4 c0599fd4 c02d780c 22222222 c05eb6d0
>> [    0.000000] 9f40: c05bfff4 c058f028 c05bfff4 c05bfc74 c0599fd4 3fffffff 411fc090 00000000
>> [    0.000000] 9f60: 00000000 c02d7b84 c058f028 c05bfff4 c05bfdb4 c001d86c 3fffffff c0571608
>> [    0.000000] 9f80: c058f028 c05fea40 c058ea9c c001d990 c058d52c c0570eb0 c058d52c c056d350
>> [    0.000000] 9fa0: 00000000 c0599fb4 c05b6c00 c0598000 ffffffff c05fe600 00000001 c056a588
>> [    0.000000] 9fc0: 00000000 00000000 00000000 00000000 00000000 c058ea9c 00000000 10c5387d
>> [    0.000000] 9fe0: c05b6c58 c058ea94 c05bb4fc 0000406a 00000000 00008044 00000000 00000000
>> [    0.000000] [<c00befd8>] (__kmalloc+0xf8/0x144) from [<c02d780c>] (__clk_set_parent+0x60/0x1e8)
>> [    0.000000] [<c02d780c>] (__clk_set_parent+0x60/0x1e8) from [<c02d7b84>] (clk_set_parent+0x9c/0xd8)
>> [    0.000000] [<c02d7b84>] (clk_set_parent+0x9c/0xd8) from [<c001d86c>] (tegra_clk_init_one_from_table+0x4c/0x154)
>> [    0.000000] [<c001d86c>] (tegra_clk_init_one_from_table+0x4c/0x154) from [<c001d990>] (tegra_clk_init_from_table+0x1c/0x2c)
>> [    0.000000] [<c001d990>] (tegra_clk_init_from_table+0x1c/0x2c) from [<c0570eb0>] (tegra20_init_early+0x18/0x34)
>> [    0.000000] [<c0570eb0>] (tegra20_init_early+0x18/0x34) from [<c056d350>] (setup_arch+0x128/0x16c)
>> [    0.000000] [<c056d350>] (setup_arch+0x128/0x16c) from [<c056a588>] (start_kernel+0x88/0x320)
>> [    0.000000] [<c056a588>] (start_kernel+0x88/0x320) from [<00008044>] (0x8044)
>> [    0.000000] Code: e3550000 1a000002 e1a00006 e8bd80f8 (e7f001f2)
>> [    0.000000] ---[ end trace 1b75b31a2719ed1c ]---
>> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
>> [    0.000000] Unable to handle kernel NULL pointer dereference at virtual address 00000f00
>> [    0.000000] pgd = c0004000
>> [    0.000000] [00000f00] *pgd=00000000
>> [    0.000000] Internal error: Oops: 805 [#2] PREEMPT SMP ARM
>> [    0.000000] Modules linked in:
>> [    0.000000] CPU: 0    Tainted: G      D       (3.5.0-rc5-next-20120702-00018-g87d5256 #86)
>> [    0.000000] PC is at gic_raise_softirq+0x5c/0x70
>> [    0.000000] LR is at gic_raise_softirq+0x3c/0x70
>> [    0.000000] pc : [<c001d504>]    lr : [<c001d4e4>]    psr: 600001d3
>> [    0.000000] sp : c0599d88  ip : 00000000  fp : 00000000
>> [    0.000000] r10: 00000006  r9 : 600001d3  r8 : 00000001
>> [    0.000000] r7 : c05fe900  r6 : c0599dac  r5 : c05b7a90  r4 : 00000006
>> [    0.000000] r3 : 00000000  r2 : 00000004  r1 : 00000004  r0 : 00000004
>> [    0.000000] Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
>> [    0.000000] Control: 10c5387d  Table: 0000404a  DAC: 00000015
>> [    0.000000] Process swapper (pid: 0, stack limit = 0xc05982f0)
>> [    0.000000] Stack: (0xc0599d88 to 0xc059a000)
>> [    0.000000] 9d80:                   c001d4a8 000f4240 c05b7220 c0599dac c0598000 c05fe95c
>> [    0.000000] 9da0: c04c54bc c0013b28 c0598000 00000000 c05ff8b0 c0598000 0000000b c03ef2e4
>> [    0.000000] 9dc0: 0000000b c0599dec c0598000 c05ba5a0 c0598000 0000000b c0598000 c05fe95c
>> [    0.000000] 9de0: c04c54bc c002d70c c04ca7f8 200001d3 c0599df8 00000000 00000000 c05fe958
>> [    0.000000] 9e00: 0000000b c05bb678 c0598000 c0012548 00000000 00000004 c0599ed8 c00befd8
>> [    0.000000] 9e20: c0599f0c 3fffffff c000e9e8 00000000 00000000 c0008380 00000006 c0600210
>> [    0.000000] 9e40: 00000004 00000000 00030001 c00befd8 c0600e28 00000039 00000000 c01db58c
>> [    0.000000] 9e60: c0599f78 c0599e70 00000000 c0600e38 0000000f 00000039 c0600e28 c060021f
>> [    0.000000] 9e80: c05bbd28 c05ffd10 c0017f98 c0029dfc 000003f0 c05b7220 c04c80cd 00000001
>> [    0.000000] 9ea0: 00000002 c05c0268 c04c7d88 c02d6d34 00000001 c05c00a8 00000003 c05c0268
>> [    0.000000] 9ec0: c04c86dc c00befdc 600001d3 ffffffff c0599f0c c000e9e8 00000020 000080d0
>> [    0.000000] 9ee0: c05bfb74 c05d7c60 00000000 c05bfc74 c05bfff4 c02d780c 3fffffff c05bfdb4
>> [    0.000000] 9f00: 00000000 00000000 22222222 c0599f20 c02d780c c00befd8 600001d3 ffffffff
>> [    0.000000] 9f20: 00000008 00000001 c05bfc74 c05bfff4 c0599fd4 c02d780c 22222222 c05eb6d0
>> [    0.000000] 9f40: c05bfff4 c058f028 c05bfff4 c05bfc74 c0599fd4 3fffffff 411fc090 00000000
>> [    0.000000] 9f60: 00000000 c02d7b84 c058f028 c05bfff4 c05bfdb4 c001d86c 3fffffff c0571608
>> [    0.000000] 9f80: c058f028 c05fea40 c058ea9c c001d990 c058d52c c0570eb0 c058d52c c056d350
>> [    0.000000] 9fa0: 00000000 c0599fb4 c05b6c00 c0598000 ffffffff c05fe600 00000001 c056a588
>> [    0.000000] 9fc0: 00000000 00000000 00000000 00000000 00000000 c058ea9c 00000000 10c5387d
>> [    0.000000] 9fe0: c05b6c58 c058ea94 c05bb4fc 0000406a 00000000 00008044 00000000 00000000
>> [    0.000000] [<c001d504>] (gic_raise_softirq+0x5c/0x70) from [<c0013b28>] (smp_send_stop+0x50/0xb4)
>> [    0.000000] [<c0013b28>] (smp_send_stop+0x50/0xb4) from [<c03ef2e4>] (panic+0x94/0x1d8)
>> [    0.000000] [<c03ef2e4>] (panic+0x94/0x1d8) from [<c002d70c>] (do_exit+0x2b8/0x328)
>> [    0.000000] [<c002d70c>] (do_exit+0x2b8/0x328) from [<c0012548>] (die+0x120/0x19c)
>> [    0.000000] [<c0012548>] (die+0x120/0x19c) from [<c0008380>] (do_undefinstr+0x13c/0x160)
>> [    0.000000] [<c0008380>] (do_undefinstr+0x13c/0x160) from [<c000e9e8>] (__und_svc+0x48/0x60)
>> [    0.000000] Exception stack(0xc0599ed8 to 0xc0599f20)
>> [    0.000000] 9ec0:                                                       00000020 000080d0
>> [    0.000000] 9ee0: c05bfb74 c05d7c60 00000000 c05bfc74 c05bfff4 c02d780c 3fffffff c05bfdb4
>> [    0.000000] 9f00: 00000000 00000000 22222222 c0599f20 c02d780c c00befd8 600001d3 ffffffff
>> [    0.000000] [<c000e9e8>] (__und_svc+0x48/0x60) from [<c00befd8>] (__kmalloc+0xf8/0x144)
>> [    0.000000] [<c00befd8>] (__kmalloc+0xf8/0x144) from [<c02d780c>] (__clk_set_parent+0x60/0x1e8)
>> [    0.000000] [<c02d780c>] (__clk_set_parent+0x60/0x1e8) from [<c02d7b84>] (clk_set_parent+0x9c/0xd8)
>> [    0.000000] [<c02d7b84>] (clk_set_parent+0x9c/0xd8) from [<c001d86c>] (tegra_clk_init_one_from_table+0x4c/0x154)
>> [    0.000000] [<c001d86c>] (tegra_clk_init_one_from_table+0x4c/0x154) from [<c001d990>] (tegra_clk_init_from_table+0x1c/0x2c)
>> [    0.000000] [<c001d990>] (tegra_clk_init_from_table+0x1c/0x2c) from [<c0570eb0>] (tegra20_init_early+0x18/0x34)
>> [    0.000000] [<c0570eb0>] (tegra20_init_early+0x18/0x34) from [<c056d350>] (setup_arch+0x128/0x16c)
>> [    0.000000] [<c056d350>] (setup_arch+0x128/0x16c) from [<c056a588>] (start_kernel+0x88/0x320)
>> [    0.000000] [<c056a588>] (start_kernel+0x88/0x320) from [<00008044>] (0x8044)
>> [    0.000000] Code: f57ff04f e59f3014 e18a4804 e5933000 (e5834f00)
>> [    0.000000] ---[ end trace 1b75b31a2719ed1d ]---

