Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1JLSMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:12:54 -0400
Received: from mail.agmk.net ([91.192.224.71]:47415 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1JLSMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:12:53 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: Hugh Dickins <hughd@google.com>, linux-mm@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Date: Wed, 12 Oct 2011 20:12:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc8-00060-g47ea91b; KDE/4.7.2; x86_64; ; )
Cc: jpiszcz@lucidpixels.com, arekm@pld-linux.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201110122012.33767.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,
i'm resending previous private email with larger cc list as you've requested.


in the last weekend my server died again (processes stuck for 22/23s!) but this time i have more logs for you.
 
on my dual-opteron machines i have non-standard settings:
- DISABLED swap space (fast user process killing is better for my autotest farm than long disk swapping
                       and 64GB ecc-ram is enough for my processing).
- vm.overcommit_memory = 2,
- vm.overcommit_ratio = 100.

after initial BUG_ON (pasted below) there's a flood of 'rcu_sched_state detected stalls / CPU#X stuck for 22s!'
(full compressed log is available at: http://pluto.agmk.net/kernel/kernel.bz2)

Oct  9 08:06:43 hal kernel: [408578.629070] ------------[ cut here ]------------
Oct  9 08:06:43 hal kernel: [408578.629143] kernel BUG at include/linux/swapops.h:105!
Oct  9 08:06:43 hal kernel: [408578.629143] invalid opcode: 0000 [#1] SMP
Oct  9 08:06:43 hal kernel: [408578.629143] CPU 14
Oct  9 08:06:43 hal kernel: [408578.629143] Modules linked in: nfs fscache binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 dm_mod uvesafb autofs4 dummy aoe joydev usbhid hid ide_cd_mod cdrom ata_generic pata_acpi ohci_hcd pata_atiixp sp5100_tco ide_pci_generic ssb ehci_hcd igb i2c_piix4 pcmcia evdev atiixp pcmcia_core psmouse ide_core usbcore i2c_core amd64_edac_mod mmc_core edac_core pcspkr sg edac_mce_amd button serio_raw processor dca ghes k10temp hwmon hed sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
Oct  9 08:06:43 hal kernel: [408578.629143]
Oct  9 08:06:43 hal kernel: [408578.629143] Pid: 29214, comm: bitgen Not tainted 3.0.4 #5 Supermicro H8DGU/H8DGU
Oct  9 08:06:43 hal kernel: [408578.629143] RIP: 0010:[<ffffffff81127b76>]  [<ffffffff81127b76>] migration_entry_wait+0x156/0x160
Oct  9 08:06:43 hal kernel: [408578.629143] RSP: 0000:ffff88021cee7d18  EFLAGS: 00010246
Oct  9 08:06:43 hal kernel: [408578.629143] RAX: 0a00000000080068 RBX: ffffea001d1dbe70 RCX: ffff880c02d18978
Oct  9 08:06:43 hal kernel: [408578.629143] RDX: 0000000000851a42 RSI: ffff880d8fe33618 RDI: ffffea002a09dd50
Oct  9 08:06:43 hal kernel: [408578.629143] RBP: ffff88021cee7d38 R08: ffff880d8fe33618 R09: 0000000000000028
Oct  9 08:06:43 hal kernel: [408578.629143] R10: ffff881006eb0f00 R11: f800000000851a42 R12: ffffea002a09dd40
Oct  9 08:06:43 hal kernel: [408578.629143] R13: 0000000c02d18978 R14: 00000000d872f000 R15: ffff880d8fe33618
Oct  9 08:06:43 hal kernel: [408578.629143] FS:  00007f864d7fa700(0000) GS:ffff880c1fc80000(0063) knlGS:00000000f432a910
Oct  9 08:06:43 hal kernel: [408578.629143] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
Oct  9 08:06:43 hal kernel: [408578.629143] CR2: 00000000d872f000 CR3: 000000100668c000 CR4: 00000000000006e0
Oct  9 08:06:43 hal kernel: [408578.629143] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  9 08:06:43 hal kernel: [408578.629143] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  9 08:06:43 hal kernel: [408578.629143] Process bitgen (pid: 29214, threadinfo ffff88021cee6000, task ffff880407b06900)
Oct  9 08:06:43 hal kernel: [408578.629143] Stack:
Oct  9 08:06:43 hal kernel: [408578.629143]  00000000dcef4000 ffff880c00968c98 ffff880c02d18978 000000010a34843e
Oct  9 08:06:43 hal kernel: [408578.629143]  ffff88021cee7de8 ffffffff811016a1 ffff88021cee7d78 ffff881006eb0f00
Oct  9 08:06:43 hal kernel: [408578.629143]  ffff88021cee7d98 ffffffff810feee2 ffff880c06f0d170 8000000b98d14067
Oct  9 08:06:43 hal kernel: [408578.629143] Call Trace:
Oct  9 08:06:43 hal kernel: [408578.629143]  [<ffffffff811016a1>] handle_pte_fault+0xae1/0xaf0
Oct  9 08:06:43 hal kernel: [408578.629143]  [<ffffffff810feee2>] ? __pte_alloc+0x42/0x120
Oct  9 08:06:43 hal kernel: [408578.629143]  [<ffffffff8112c26b>] ? do_huge_pmd_anonymous_page+0xab/0x310
Oct  9 08:06:43 hal kernel: [408578.629143]  [<ffffffff81102a31>] handle_mm_fault+0x181/0x310
Oct  9 08:06:43 hal kernel: [408578.629143]  [<ffffffff81106097>] ? vma_adjust+0x537/0x570
Oct  9 08:06:43 hal kernel: [408578.629143]  [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
Oct  9 08:06:43 hal kernel: [408578.629143]  [<ffffffff81109a05>] ? do_mremap+0x2d5/0x570
Oct  9 08:06:43 hal kernel: [408578.629143]  [<ffffffff81421d5f>] page_fault+0x1f/0x30
Oct  9 08:06:43 hal kernel: [408578.629143] Code: 80 00 00 00 00 31 f6 48 89 df e8 e6 58 fb ff eb d7 85 c9 0f 84 44 ff ff ff 8d 51 01 89 c8 f0 0f b1 16 39 c1 90 74 b5 89 c1 eb e6 <0f> 0b 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 83 ec 20 48 85 ff
Oct  9 08:06:43 hal kernel: [408578.629143] RIP  [<ffffffff81127b76>] migration_entry_wait+0x156/0x160
Oct  9 08:06:43 hal kernel: [408578.629143]  RSP <ffff88021cee7d18>
Oct  9 08:06:43 hal kernel: [408578.642823] ---[ end trace 0a37362301163711 ]---
Oct  9 08:07:10 hal kernel: [408605.283257] BUG: soft lockup - CPU#12 stuck for 23s! [par:29801]
Oct  9 08:07:10 hal kernel: [408605.283367] Modules linked in: nfs fscache binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 dm_mod uvesafb autofs4 dummy aoe joydev usbhid hid ide_cd_mod cdrom ata_generic pata_acpi ohci_hcd pata_atiixp sp5100_tco ide_pci_generic ssb ehci_hcd igb i2c_piix4 pcmcia evdev atiixp pcmcia_core psmouse ide_core usbcore i2c_core amd64_edac_mod mmc_core edac_core pcspkr sg edac_mce_amd button serio_raw processor dca ghes k10temp hwmon hed sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
Oct  9 08:07:10 hal kernel: [408605.285807] CPU 12
Oct  9 08:07:10 hal kernel: [408605.285807] Modules linked in: nfs fscache binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 dm_mod uvesafb autofs4 dummy aoe joydev usbhid hid ide_cd_mod cdrom ata_generic pata_acpi ohci_hcd pata_atiixp sp5100_tco ide_pci_generic ssb ehci_hcd igb i2c_piix4 pcmcia evdev atiixp pcmcia_core psmouse ide_core usbcore i2c_core amd64_edac_mod mmc_core edac_core pcspkr sg edac_mce_amd button serio_raw processor dca ghes k10temp hwmon hed sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
Oct  9 08:07:10 hal kernel: [408605.285807]
Oct  9 08:07:10 hal kernel: [408605.285807] Pid: 29801, comm: par Tainted: G      D     3.0.4 #5 Supermicro H8DGU/H8DGU
Oct  9 08:07:10 hal kernel: [408605.285807] RIP: 0010:[<ffffffff814216a4>]  [<ffffffff814216a4>] _raw_spin_lock+0x14/0x20
Oct  9 08:07:10 hal kernel: [408605.285807] RSP: 0018:ffff880c02def808  EFLAGS: 00000293
Oct  9 08:07:10 hal kernel: [408605.285807] RAX: 0000000000000b09 RBX: ffffea002741f6b8 RCX: ffff880000000000
Oct  9 08:07:10 hal kernel: [408605.285807] RDX: ffffea0000000000 RSI: 000000002a09dd40 RDI: ffffea002a09dd50
Oct  9 08:07:10 hal kernel: [408605.285807] RBP: ffff880c02def808 R08: 0000000000000000 R09: ffff880f2e4f4d70
Oct  9 08:07:10 hal kernel: [408605.285807] R10: ffff880c1fffbe00 R11: 0000000000000050 R12: ffffffff8142988e
Oct  9 08:07:10 hal kernel: [408605.285807] R13: ffff880c02def7b8 R14: ffffffff810e63dc R15: ffff880c02def7b8
Oct  9 08:07:10 hal kernel: [408605.285807] FS:  00007fe6b677c720(0000) GS:ffff880c1fc00000(0063) knlGS:00000000f6e0d910
Oct  9 08:07:10 hal kernel: [408605.285807] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
Oct  9 08:07:10 hal kernel: [408605.285807] CR2: 00000000dd40012c CR3: 00000009f6b78000 CR4: 00000000000006e0
Oct  9 08:07:10 hal kernel: [408605.285807] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct  9 08:07:10 hal kernel: [408605.285807] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct  9 08:07:10 hal kernel: [408605.285807] Process par (pid: 29801, threadinfo ffff880c02dee000, task ffff880c07c90700)
Oct  9 08:07:10 hal kernel: [408605.285807] Stack:
Oct  9 08:07:10 hal kernel: [408605.285807]  ffff880c02def858 ffffffff8110a2d7 ffffea001fc16fe0 ffff880c02d183a8
Oct  9 08:07:10 hal kernel: [408605.285807]  ffff880c02def8c8 ffffea001fc16fa8 ffff880c00968c98 ffff881006eb0f00
Oct  9 08:07:10 hal kernel: [408605.285807]  0000000000000301 00000000d8675000 ffff880c02def8c8 ffffffff8110aa6a
Oct  9 08:07:10 hal kernel: [408605.285807] Call Trace:
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110a2d7>] __page_check_address+0x107/0x1a0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110aa6a>] try_to_unmap_one+0x3a/0x420
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110be44>] try_to_unmap_anon+0xb4/0x130
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110bf75>] try_to_unmap+0x65/0x80
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff811285d0>] migrate_pages+0x310/0x4c0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e93c2>] ? ____pagevec_lru_add+0x12/0x20
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111cbf0>] ? ftrace_define_fields_mm_compaction_isolate_template+0x70/0x70
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111d5da>] compact_zone+0x52a/0x8c0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810f9919>] ? zone_statistics+0x99/0xc0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111dade>] compact_zone_order+0x7e/0xb0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e46a8>] ? get_page_from_freelist+0x3b8/0x7e0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111dbcd>] try_to_compact_pages+0xbd/0xf0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e5148>] __alloc_pages_direct_compact+0xa8/0x180
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e56c5>] __alloc_pages_nodemask+0x4a5/0x7f0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e9698>] ? lru_cache_add_lru+0x28/0x50
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110a92d>] ? page_add_new_anon_rmap+0x9d/0xb0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111b865>] alloc_pages_vma+0x95/0x180
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8112c2f8>] do_huge_pmd_anonymous_page+0x138/0x310
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff81102ace>] handle_mm_fault+0x21e/0x310
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff81001716>] ? __switch_to+0x1e6/0x2c0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8141f178>] ? schedule+0x308/0xa10
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff811077a7>] ? do_mmap_pgoff+0x357/0x370
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110790d>] ? sys_mmap_pgoff+0x14d/0x220
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff81421d5f>] page_fault+0x1f/0x30
Oct  9 08:07:10 hal kernel: [408605.285807] Code: 0f b6 c2 85 c0 0f 95 c0 0f b6 c0 5d c3 66 2e 0f 1f 84 00 00 00 00 00 55 b8 00 01 00 00 48 89 e5 f0 66 0f c1 07 38 e0 74 06 f3 90 <8a> 07 eb f6 5d c3 66 0f 1f 44 00 00 55 48 89 e5 9c 58 fa ba 00
Oct  9 08:07:10 hal kernel: [408605.285807] Call Trace:
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110a2d7>] __page_check_address+0x107/0x1a0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110aa6a>] try_to_unmap_one+0x3a/0x420
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110be44>] try_to_unmap_anon+0xb4/0x130
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110bf75>] try_to_unmap+0x65/0x80
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff811285d0>] migrate_pages+0x310/0x4c0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e93c2>] ? ____pagevec_lru_add+0x12/0x20
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111cbf0>] ? ftrace_define_fields_mm_compaction_isolate_template+0x70/0x70
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111d5da>] compact_zone+0x52a/0x8c0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810f9919>] ? zone_statistics+0x99/0xc0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111dade>] compact_zone_order+0x7e/0xb0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e46a8>] ? get_page_from_freelist+0x3b8/0x7e0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111dbcd>] try_to_compact_pages+0xbd/0xf0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e5148>] __alloc_pages_direct_compact+0xa8/0x180
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e56c5>] __alloc_pages_nodemask+0x4a5/0x7f0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff810e9698>] ? lru_cache_add_lru+0x28/0x50
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110a92d>] ? page_add_new_anon_rmap+0x9d/0xb0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8111b865>] alloc_pages_vma+0x95/0x180
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8112c2f8>] do_huge_pmd_anonymous_page+0x138/0x310
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff81102ace>] handle_mm_fault+0x21e/0x310
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff81001716>] ? __switch_to+0x1e6/0x2c0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff81424bed>] do_page_fault+0x11d/0x4e0
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8141f178>] ? schedule+0x308/0xa10
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff811077a7>] ? do_mmap_pgoff+0x357/0x370
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff8110790d>] ? sys_mmap_pgoff+0x14d/0x220
Oct  9 08:07:10 hal kernel: [408605.285807]  [<ffffffff81421d5f>] page_fault+0x1f/0x30

BR,
Paweł.
