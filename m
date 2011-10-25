Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1JYTZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:25:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41131 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1JYTZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:25:50 -0400
Date: Tue, 25 Oct 2011 15:25:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: 2013pfoley <2013pfoley@tjhsst.edu>, david.vrabel@citrix.com
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Andrew Hamilton <ahamilto@tjhsst.edu>
Subject: Re: Xen dom0 linux kernel 3.1 boot failure ptwr_emulate: could not
 get_page_from_l1e
Message-ID: <20111025192536.GG10062@phenom.dumpdata.com>
References: <05c3da5dc6158197e28d62e853ac2f04@tjhsst.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05c3da5dc6158197e28d62e853ac2f04@tjhsst.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EA70D3A.0001:SCFMA922111,ss=1,re=-6.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 03:34:57PM -0400, 2013pfoley wrote:
> Hi,
> 
> I'm having xen dom0 crash during bootup when using the linux 3.1
> kernel however it worked when using the linux 2.6.34 kernel.
> I tried using xen-unstable but got the exact same error as with xen
> 4.1.1.
> 
> xen-unstable changeset:   23981:6c583d35d76d
> linux kernel 3.1.0

.. snip.. 
> (XEN) Xen-e820 RAM map:
> (XEN)  0000000000000000 - 000000000009f400 (usable)
> (XEN)  000000000009f400 - 00000000000a0000 (reserved)
> (XEN)  00000000000f0000 - 0000000000100000 (reserved)
> (XEN)  0000000000100000 - 00000000df61f000 (usable)
> (XEN)  00000000df61f000 - 00000000df62c000 (ACPI data)
> (XEN)  00000000df62c000 - 00000000df62d000 (usable)
> (XEN)  00000000df62d000 - 00000000e4000000 (reserved)
> (XEN)  00000000fec00000 - 00000000fee10000 (reserved)
> (XEN)  00000000ff800000 - 0000000100000000 (reserved)
> (XEN)  0000000100000000 - 000000061ffff000 (usable) 

So 24MB..
.. snip..

> mapping kernel into physical memory
> Xen: setup ISA identity maps
> about to get started...
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.1.0 (root@galapagos) (gcc version
> 4.5.3 (Gentoo 4.5.3-r1 p1.0, pie-0.4.5) ) #4 SMP Mon Oct 24 15:03:22
> EDT 2011
> [    0.000000] Command line: root=/dev/sda2 bonding.mode=4
> bonding.miimon=100 console=hvc0 debug initcall_debug earlyprintk=xen
> [    0.000000] Freeing  e4000-fec00 pfn range: 109568 pages freed
> [    0.000000] Freeing  fee10-ff800 pfn range: 2544 pages freed
> [    0.000000] released 112112 pages of unused memory
> [    0.000000] 1-1 mapping on a0->100
> [    0.000000] 1-1 mapping on df61f->df62c
> [    0.000000] 1-1 mapping on df62d->100000
> [    0.000000] Set 133696 page(s) to 1-1 mapping.
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  Xen: 0000000000000000 - 000000000009f000 (usable)
> [    0.000000]  Xen: 000000000009f400 - 0000000000100000 (reserved)
> [    0.000000]  Xen: 0000000000100000 - 00000000df61f000 (usable)
> [    0.000000]  Xen: 00000000df61f000 - 00000000df62c000 (ACPI data)
> [    0.000000]  Xen: 00000000df62c000 - 00000000df62d000 (usable)
> [    0.000000]  Xen: 00000000df62d000 - 00000000e4000000 (reserved)
> [    0.000000]  Xen: 00000000fec00000 - 00000000fee10000 (reserved)
> [    0.000000]  Xen: 00000000ff800000 - 0000000100000000 (reserved)
> [    0.000000]  Xen: 0000000100000000 - 000000063b5ef000 (usable)

So Xen reported that memory ends at       000000061ffff000

but we decided that it must have more. Which is OK as we basically
adding the 112112 pages we freed. CC-ing David here in case he has some ideas.

> [    0.000000] bootconsole [xenboot0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI 2.7 present.
> [    0.000000] DMI: HP ProLiant DL380 G6, BIOS P62 05/05/2011
> [    0.000000] e820 update range: 0000000000000000 -
> 0000000000010000 (usable) ==> (reserved)
> [    0.000000] e820 remove range: 00000000000a0000 -
> 0000000000100000 (usable)
> [    0.000000] No AGP bridge found
> [    0.000000] last_pfn = 0x63b5ef max_arch_pfn = 0x400000000
> [    0.000000] last_pfn = 0xdf62d max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
> (XEN) mm.c:945:d0 Error getting mfn 100 (pfn 5555555555555555) from
> L1 entry 8000000000100461 for l1e_owner=0, pg_owner=0
> (XEN) mm.c:5046:d0 ptwr_emulate: could not get_page_from_l1e()

Oh wait, This is MFN 100? Nothing to do with E820 then.
But what is weird is that the PFN is 555555..


> [    0.000000] BUG: unable to handle kernel NULL pointer dereference
> at          (null)
> [    0.000000] IP: [<ffffffff81008a5a>] xen_set_pte+0x3a/0x1f0
> [    0.000000] PGD 0
> [    0.000000] Oops: 0003 [#1] SMP
> [    0.000000] CPU 0
> [    0.000000] Modules linked in:
> [    0.000000]
> [    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0 #4 HP
> ProLiant DL380 G6
> [    0.000000] RIP: e030:[<ffffffff81008a5a>]  [<ffffffff81008a5a>]
> xen_set_pte+0x3a/0x1f0
> [    0.000000] RSP: e02b:ffffffff81c01d50  EFLAGS: 00010097
> [    0.000000] RAX: 0000000000000000 RBX: ffffffff81d573c0 RCX:
> 0000000000000001
> [    0.000000] RDX: 0000000010000001 RSI: 8000000000100461 RDI:
> ffffffff81d573c0
> [    0.000000] RBP: ffffffff81c01d90 R08: 0000000000000000 R09:
> 00000000000f4f90
> [    0.000000] R10: 00000000deadbeef R11: 0000000000000010 R12:
> 8000000000100461
> [    0.000000] R13: 8000000000100463 R14: 8000000000000563 R15:
> 0000000000100000
> [    0.000000] FS:  0000000000000000(0000) GS:ffffffff81c9a000(0000)
> knlGS:0000000000000000
> [    0.000000] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.000000] CR2: 0000000000000000 CR3: 0000000001c05000 CR4:
> 0000000000002660
> [    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [    0.000000] DR3: 0000000000000000 DR6: 0000000000000000 DR7:
> 0000000000000000
> [    0.000000] Process swapper (pid: 0, threadinfo ffffffff81c00000,
> task ffffffff81c0d020)
> [    0.000000] Stack:
> [    0.000000]  ffffffff81004ef1 0000000000000010 00000000deadbeef
> ffffffff81d573c0
> [    0.000000]  0000000000000100 8000000000100463 8000000000000563
> 0000000000100000
> [    0.000000]  ffffffff81c01dc0 ffffffff81cb299f 0000000000100000
> ffffffffff478000
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff81004ef1>] ?
> __raw_callee_save_xen_pte_val+0x11/0x1e
> [    0.000000]  [<ffffffff81cb299f>] xen_set_pte_init+0x7f/0x87
> [    0.000000]  [<ffffffff81cc2a99>] __early_set_fixmap+0x73/0xbc
> [    0.000000]  [<ffffffff81cc2c01>] __early_ioremap+0x11f/0x1ad
> [    0.000000]  [<ffffffff81cc2f07>] early_ioremap+0x13/0x15
> [    0.000000]  [<ffffffff81cbc2ad>] get_mpc_size+0x14/0x4c
> [    0.000000]  [<ffffffff81cbc3b1>] smp_scan_config+0xcc/0xfa
> [    0.000000]  [<ffffffff81cf3300>] ?
> firmware_map_add_hotplug+0xa4/0xa4
> [    0.000000]  [<ffffffff81cbcfb3>] default_find_smp_config+0x36/0x5a
> [    0.000000]  [<ffffffff81cb4770>] setup_arch+0x539/0xad7
> [    0.000000]  [<ffffffff81009ecf>] ?
> __raw_callee_save_xen_restore_fl+0x11/0x1e
> [    0.000000]  [<ffffffff81cf3300>] ?
> firmware_map_add_hotplug+0xa4/0xa4
> [    0.000000]  [<ffffffff81709534>] ? printk+0x3c/0x3e
> [    0.000000]  [<ffffffff8170c2ea>] ?
> _raw_spin_unlock_irqrestore+0x1a/0x20
> [    0.000000]  [<ffffffff81cf3300>] ?
> firmware_map_add_hotplug+0xa4/0xa4
> [    0.000000]  [<ffffffff81cae93b>] start_kernel+0x8e/0x359
> [    0.000000]  [<ffffffff81cae347>]
> x86_64_start_reservations+0x132/0x136
> [    0.000000]  [<ffffffff81cb1eac>] xen_start_kernel+0x5ef/0x5f6
> [    0.000000] Code: 89 5d d8 4c 89 65 e0 48 89 fb 4c 89 6d e8 4c 89
> 75 f0 49 89 f4 85 c0 4c 89 7d f8 0f 85 17 01 00 00 e8 2b 06 03 00 83
> f8 01 74 1e <4c> 89 23 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75
> f0 4c 8b
> [    0.000000] RIP  [<ffffffff81008a5a>] xen_set_pte+0x3a/0x1f0
> [    0.000000]  RSP <ffffffff81c01d50>
> [    0.000000] CR2: 0000000000000000
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000000] Kernel panic - not syncing: Attempted to kill the
> idle task!
> [    0.000000] Pid: 0, comm: swapper Tainted: G      D     3.1.0 #4
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff817093d8>] panic+0x8c/0x1ac
> [    0.000000]  [<ffffffff8105db63>] do_exit+0x803/0x950
> [    0.000000]  [<ffffffff8170c2ea>] ?
> _raw_spin_unlock_irqrestore+0x1a/0x20
> [    0.000000]  [<ffffffff8105b3b5>] ? kmsg_dump+0x45/0x100
> [    0.000000]  [<ffffffff8170d46f>] oops_end+0xaf/0xf0
> [    0.000000]  [<ffffffff8103e050>] no_context+0xf0/0x260
> [    0.000000]  [<ffffffff8103e2dd>] __bad_area_nosemaphore+0x11d/0x220
> [    0.000000]  [<ffffffff8103e3ee>] bad_area_nosemaphore+0xe/0x10
> [    0.000000]  [<ffffffff8170fd8b>] do_page_fault+0x36b/0x510
> [    0.000000]  [<ffffffff81009ecf>] ?
> __raw_callee_save_xen_restore_fl+0x11/0x1e
> [    0.000000]  [<ffffffff8170c7b5>] page_fault+0x25/0x30
> [    0.000000]  [<ffffffff81008a5a>] ? xen_set_pte+0x3a/0x1f0
> [    0.000000]  [<ffffffff81004ef1>] ?
> __raw_callee_save_xen_pte_val+0x11/0x1e
> [    0.000000]  [<ffffffff81cb299f>] xen_set_pte_init+0x7f/0x87
> [    0.000000]  [<ffffffff81cc2a99>] __early_set_fixmap+0x73/0xbc
> [    0.000000]  [<ffffffff81cc2c01>] __early_ioremap+0x11f/0x1ad
> [    0.000000]  [<ffffffff81cc2f07>] early_ioremap+0x13/0x15
> [    0.000000]  [<ffffffff81cbc2ad>] get_mpc_size+0x14/0x4c
> [    0.000000]  [<ffffffff81cbc3b1>] smp_scan_config+0xcc/0xfa
> [    0.000000]  [<ffffffff81cf3300>] ?
> firmware_map_add_hotplug+0xa4/0xa4
> [    0.000000]  [<ffffffff81cbcfb3>] default_find_smp_config+0x36/0x5a
> [    0.000000]  [<ffffffff81cb4770>] setup_arch+0x539/0xad7
> [    0.000000]  [<ffffffff81009ecf>] ?
> __raw_callee_save_xen_restore_fl+0x11/0x1e
> [    0.000000]  [<ffffffff81cf3300>] ?
> firmware_map_add_hotplug+0xa4/0xa4
> [    0.000000]  [<ffffffff81709534>] ? printk+0x3c/0x3e
> [    0.000000]  [<ffffffff8170c2ea>] ?
> _raw_spin_unlock_irqrestore+0x1a/0x20
> [    0.000000]  [<ffffffff81cf3300>] ?
> firmware_map_add_hotplug+0xa4/0xa4
> [    0.000000]  [<ffffffff81cae93b>] start_kernel+0x8e/0x359
> [    0.000000]  [<ffffffff81cae347>]
> x86_64_start_reservations+0x132/0x136
> [    0.000000]  [<ffffffff81cb1eac>] xen_start_kernel+0x5ef/0x5f6
> (XEN) Domain 0 crashed: 'noreboot' set - not rebooting.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
