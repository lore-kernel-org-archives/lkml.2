Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1H3JRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:17:13 -0400
Received: from krak.alatek.krakow.pl ([46.170.108.42]:1721 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1H3JRK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:17:10 -0400
From: Pawel Sikora <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Cc: arekm@pld-linux.org, gregkh@suse.de
Subject: [3.0.2-stable] BUG: soft lockup - CPU#13 stuck for 22s! [kswapd2:1092]
Date: Tue, 30 Aug 2011 11:17:07 +0200
Message-ID: <2282318.Znj0vdeLmO@pawels>
User-Agent: KMail/4.7.0  (Linux/2.6.38.8-3; KDE/4.7.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during copying (cp -ar) ~100GB files from ext2(md1/raid0) to ext4(md2/raid0)
i've noticed a problem in kernel log:

(...)
[ 5721.376582] BUG: soft lockup - CPU#13 stuck for 22s! [kswapd2:1092]
[ 5721.376586] Modules linked in: ext4 jbd2 crc16 nfs fscache binfmt_misc nfsd lockd exportfs nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext2 raid0 dm_mod autofs4 
dummy usbhid hid ide_cd_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generic ohci_hcd ssb pcmcia igb i2c_piix4 ghes pcmcia_core i2c_core atiixp k10temp 
ehci_hcd hwmon button hed processor ide_core sg usbcore dca mmc_core amd64_edac_mod edac_core pcspkr edac_mce_amd evdev sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci 
libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[ 5721.376644] CPU 13 
[ 5721.376646] Modules linked in: ext4 jbd2 crc16 nfs fscache binfmt_misc nfsd lockd exportfs nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext2 raid0 dm_mod autofs4 
dummy usbhid hid ide_cd_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generic ohci_hcd ssb pcmcia igb i2c_piix4 ghes pcmcia_core i2c_core atiixp k10temp 
ehci_hcd hwmon button hed processor ide_core sg usbcore dca mmc_core amd64_edac_mod edac_core pcspkr edac_mce_amd evdev sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci 
libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[ 5721.376685] 
[ 5721.376688] Pid: 1092, comm: kswapd2 Not tainted 3.0.2 #4 Supermicro H8DGU/H8DGU
[ 5721.376692] RIP: 0010:[<ffffffff810ded2e>]  [<ffffffff810ded2e>] find_get_pages+0x4e/0x130
[ 5721.376702] RSP: 0018:ffff8804074fdb30  EFLAGS: 00000246
[ 5721.376705] RAX: ffff8800645ada78 RBX: 0000000000000000 RCX: 0000000000000000
[ 5721.376707] RDX: ffff8804074fdbd0 RSI: 000000000000000e RDI: ffffea000db458f8
[ 5721.376709] RBP: ffff8804074fdb80 R08: 0000000000000000 R09: 0000000000000000
[ 5721.376711] R10: ffffea000db45900 R11: ffff880353cc5178 R12: ffffffff8142194e
[ 5721.376713] R13: ffff880322e92420 R14: 000000000000000e R15: ffffffff811626dc
[ 5721.376716] FS:  00007f9576703700(0000) GS:ffff880c1fc40000(0000) knlGS:00000000ee14bb70
[ 5721.376718] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5721.376721] CR2: 00007f9576839000 CR3: 0000000001803000 CR4: 00000000000006e0
[ 5721.376723] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5721.376725] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5721.376727] Process kswapd2 (pid: 1092, threadinfo ffff8804074fc000, task ffff880407ae2a00)
[ 5721.376729] Stack:
[ 5721.376825]  ffff880c1fc4d8e0 0000000000000005 ffff8803b9175a68 ffffea000db45888
[ 5721.376833]  ffff8804074fdb80 ffff8804074fdbc0 000000000000010c ffffffffffffffff
[ 5721.376837]  ffff8803b9175a68 ffffea000db45888 ffff8804074fdba0 ffffffff810e7aed
[ 5721.376841] Call Trace:
[ 5721.376935]  [<ffffffff810e7aed>] pagevec_lookup+0x1d/0x30
[ 5721.376939]  [<ffffffff810e9abf>] invalidate_mapping_pages+0x5f/0x180
[ 5721.376945]  [<ffffffff81150185>] shrink_icache_memory+0x2d5/0x320
[ 5721.376950]  [<ffffffff810ec97d>] shrink_slab+0x11d/0x190
[ 5721.376954]  [<ffffffff810f00fa>] balance_pgdat+0x51a/0x6e0
[ 5721.376958]  [<ffffffff810f03c2>] kswapd+0x102/0x3e0
[ 5721.376963]  [<ffffffff81068610>] ? abort_exclusive_wait+0xb0/0xb0
[ 5721.376966]  [<ffffffff810f02c0>] ? balance_pgdat+0x6e0/0x6e0
[ 5721.376970]  [<ffffffff81067d87>] kthread+0x87/0x90
[ 5721.376976]  [<ffffffff81422094>] kernel_thread_helper+0x4/0x10
[ 5721.376979]  [<ffffffff81067d00>] ? kthread_worker_fn+0x190/0x190
[ 5721.376983]  [<ffffffff81422090>] ? gs_change+0xb/0xb
[ 5721.376985] Code: f1 4c 89 e2 4c 89 ef e8 a1 fe 13 00 85 c0 89 c6 0f 84 c7 00 00 00 48 89 da 31 c9 45 31 ff 0f 1f 80 00 00 00 00 48 8b 02 48 8b 38 
[ 5721.379415]  85 ff 74 3e 40 f6 c7 01 75 5f 44 8b 47 08 45 85 c0 74 ec 45 
[ 5721.379432] Call Trace:
[ 5721.379432]  [<ffffffff810e7aed>] pagevec_lookup+0x1d/0x30
[ 5721.379432]  [<ffffffff810e9abf>] invalidate_mapping_pages+0x5f/0x180
[ 5721.379432]  [<ffffffff81150185>] shrink_icache_memory+0x2d5/0x320
[ 5721.379432]  [<ffffffff810ec97d>] shrink_slab+0x11d/0x190
[ 5721.379432]  [<ffffffff810f00fa>] balance_pgdat+0x51a/0x6e0
[ 5721.379432]  [<ffffffff810f03c2>] kswapd+0x102/0x3e0
[ 5721.379432]  [<ffffffff81068610>] ? abort_exclusive_wait+0xb0/0xb0
[ 5721.379432]  [<ffffffff810f02c0>] ? balance_pgdat+0x6e0/0x6e0
[ 5721.379432]  [<ffffffff81067d87>] kthread+0x87/0x90
[ 5721.379432]  [<ffffffff81422094>] kernel_thread_helper+0x4/0x10
[ 5721.379432]  [<ffffffff81067d00>] ? kthread_worker_fn+0x190/0x190
[ 5721.379432]  [<ffffffff81422090>] ? gs_change+0xb/0xb
[ 5749.376580] BUG: soft lockup - CPU#13 stuck for 22s! [kswapd2:1092]
[ 5749.376583] Modules linked in: ext4 jbd2 crc16 nfs fscache binfmt_misc nfsd lockd exportfs nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext2 raid0 dm_mod autofs4 
dummy usbhid hid ide_cd_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generic ohci_hcd ssb pcmcia igb i2c_piix4 ghes pcmcia_core i2c_core atiixp k10temp 
ehci_hcd hwmon button hed processor ide_core sg usbcore dca mmc_core amd64_edac_mod edac_core pcspkr edac_mce_amd evdev sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci 
libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[ 5749.376627] CPU 13
[ 5749.376628] Modules linked in: ext4 jbd2 crc16 nfs fscache binfmt_misc nfsd lockd exportfs nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_devintf ipmi_msghandler sch_sfq iptable_nat 
nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext2 raid0 dm_mod autofs4 
dummy usbhid hid ide_cd_mod cdrom ata_generic pata_acpi pata_atiixp sp5100_tco ide_pci_generic ohci_hcd ssb pcmcia igb i2c_piix4 ghes pcmcia_core i2c_core atiixp k10temp 
ehci_hcd hwmon button hed processor ide_core sg usbcore dca mmc_core amd64_edac_mod edac_core pcspkr edac_mce_amd evdev sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci 
libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[ 5749.376665]
[ 5749.376668] Pid: 1092, comm: kswapd2 Not tainted 3.0.2 #4 Supermicro H8DGU/H8DGU
[ 5749.376671] RIP: 0010:[<ffffffff810ded31>]  [<ffffffff810ded31>] find_get_pages+0x51/0x130
[ 5749.376678] RSP: 0018:ffff8804074fdb30  EFLAGS: 00000282
[ 5749.376680] RAX: ffff8800645ada78 RBX: 0000000000000000 RCX: 0000000000000000
[ 5749.376682] RDX: ffff8804074fdbd0 RSI: 000000000000000e RDI: ffffea000db458f8
[ 5749.376684] RBP: ffff8804074fdb80 R08: 0000000000000000 R09: 0000000000000000
[ 5749.376686] R10: ffffea000db45900 R11: ffff880353cc5178 R12: ffffffff8142194e
[ 5749.376688] R13: ffff880322e92420 R14: 000000000000000e R15: ffffffff811626dc
[ 5749.376691] FS:  00007f9576703700(0000) GS:ffff880c1fc40000(0000) knlGS:00000000ee14bb70
[ 5749.376693] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5749.376696] CR2: 00007f9576839000 CR3: 0000000001803000 CR4: 00000000000006e0
[ 5749.376698] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5749.376700] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5749.376702] Process kswapd2 (pid: 1092, threadinfo ffff8804074fc000, task ffff880407ae2a00)
[ 5749.376704] Stack:
[ 5749.376800]  ffff880c1fc4d8e0 0000000000000005 ffff8803b9175a68 ffffea000db45888
[ 5749.376806]  ffff8804074fdb80 ffff8804074fdbc0 000000000000010c ffffffffffffffff
[ 5749.376811]  ffff8803b9175a68 ffffea000db45888 ffff8804074fdba0 ffffffff810e7aed
[ 5749.376815] Call Trace:
[ 5749.376915]  [<ffffffff810e7aed>] pagevec_lookup+0x1d/0x30
[ 5749.376919]  [<ffffffff810e9abf>] invalidate_mapping_pages+0x5f/0x180
[ 5749.376923]  [<ffffffff81150185>] shrink_icache_memory+0x2d5/0x320
[ 5749.376927]  [<ffffffff810ec97d>] shrink_slab+0x11d/0x190
[ 5749.376931]  [<ffffffff810f00fa>] balance_pgdat+0x51a/0x6e0
[ 5749.376935]  [<ffffffff810f03c2>] kswapd+0x102/0x3e0
[ 5749.376939]  [<ffffffff81068610>] ? abort_exclusive_wait+0xb0/0xb0
[ 5749.376942]  [<ffffffff810f02c0>] ? balance_pgdat+0x6e0/0x6e0
[ 5749.376945]  [<ffffffff81067d87>] kthread+0x87/0x90
[ 5749.376950]  [<ffffffff81422094>] kernel_thread_helper+0x4/0x10
[ 5749.376953]  [<ffffffff81067d00>] ? kthread_worker_fn+0x190/0x190
[ 5749.376957]  [<ffffffff81422090>] ? gs_change+0xb/0xb
[ 5749.376958] Code: e2 4c 89 ef e8 a1 fe 13 00 85 c0 89 c6 0f 84 c7 00 00 00 48 89 da 31 c9 45 31 ff 0f 1f 80 00 00 00 00 48 8b 02 48 8b 38 48 85 ff
[ 5749.379426]  3e 40 f6 c7 01 75 5f 44 8b 47 08 45 85 c0 74 ec 45 8d 48 01
[ 5749.379426] Call Trace:
[ 5749.379426]  [<ffffffff810e7aed>] pagevec_lookup+0x1d/0x30
[ 5749.379426]  [<ffffffff810e9abf>] invalidate_mapping_pages+0x5f/0x180
[ 5749.379426]  [<ffffffff81150185>] shrink_icache_memory+0x2d5/0x320
[ 5749.379426]  [<ffffffff810ec97d>] shrink_slab+0x11d/0x190
[ 5749.379426]  [<ffffffff810f00fa>] balance_pgdat+0x51a/0x6e0
[ 5749.379426]  [<ffffffff810f03c2>] kswapd+0x102/0x3e0
[ 5749.379426]  [<ffffffff81068610>] ? abort_exclusive_wait+0xb0/0xb0
[ 5749.379426]  [<ffffffff810f02c0>] ? balance_pgdat+0x6e0/0x6e0
[ 5749.379426]  [<ffffffff81067d87>] kthread+0x87/0x90
[ 5749.379426]  [<ffffffff81422094>] kernel_thread_helper+0x4/0x10
[ 5749.379426]  [<ffffffff81067d00>] ? kthread_worker_fn+0x190/0x190
[ 5749.379426]  [<ffffffff81422090>] ? gs_change+0xb/0xb

machine desc: 2x opteron 6128, 64GB ecc ram, 4x sata 500GB.

BR,
Paweł.

