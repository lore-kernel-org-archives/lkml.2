Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0GVGam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:30:42 -0400
Received: from mail.agmk.net ([91.192.224.71]:48097 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048Ab0GVGaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:30:39 -0400
X-Greylist: delayed 1903 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jul 2010 02:30:38 EDT
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.34.1] OOPS in raid10 module.
Date: Thu, 22 Jul 2010 07:58:47 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.1-3; KDE/4.4.5; x86_64; ; )
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007220758.47974.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i'm testing an raid10 with ata-over-ethernet backend.
there're 13 slave machines and each one exports 2 partitions
via vbladed as /dev/etherd/e[1-13].[0-1].
there's also a master which assembles /dev/etherd/... into raid10.

everything seems to work fine until first failure event.
mdadm monitor sent to me 4 emails about failure of e13.1, e12.0,
e13.0, e12.1 and master oopsed.

# cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10]
md3 : active raid10 etherd/e13.0[26](F) etherd/e12.1[27](F) etherd/e12.0[28](F) etherd/e11.1[22] etherd/e11.0[21] etherd/e10.1[20] etherd/e10.0[19] etherd/e9.1[18] etherd/e9.0[17] etherd/e8.1[16] etherd/e8.0[15] etherd/e7.1[14] etherd/e7.0[13] etherd/e6.1[12] etherd/e6.0[11] etherd/e5.1[10] etherd/e5.0[9] etherd/e4.1[8] etherd/e4.0[7] etherd/e3.1[6] etherd/e3.0[5] etherd/e2.1[4] etherd/e2.0[3] etherd/e1.1[2] etherd/e1.0[1] etherd/e13.1[29](F)
      419045952 blocks 64K chunks 2 near-copies [26/22] [_UUUUUUUUUUUUUUUUUUUUUU___]

md2 : active raid10 sda4[0] sdd4[3] sdc4[2] sdb4[1]
      960943872 blocks 64K chunks 2 far-copies [4/4] [UUUU]

md1 : active raid0 sda3[0] sdd3[3] sdc3[2] sdb3[1]
      1953117952 blocks 64k chunks

md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
      4000064 blocks [4/4] [UUUU]


# aoe-stat 
     e10.0        33.008GB   eth0 up            
     e10.1        33.008GB   eth0 up            
      e1.0        33.008GB   eth0 up            
     e11.0        33.008GB   eth0 up            
     e11.1        33.008GB   eth0 up            
      e1.1        33.008GB   eth0 up            
     e12.0         0.000GB   eth0 down,closewait
     e12.1         0.000GB   eth0 down,closewait
     e13.0         0.000GB   eth0 down,closewait
     e13.1         0.000GB   eth0 down,closewait
      e2.0        33.008GB   eth0 up            
      e2.1        33.008GB   eth0 up            
      e3.0        33.008GB   eth0 up            
      e3.1        33.008GB   eth0 up            
      e4.0        33.008GB   eth0 up            
      e4.1        33.008GB   eth0 up            
      e5.0        33.008GB   eth0 up            
      e5.1        33.008GB   eth0 up            
      e6.0        33.008GB   eth0 up            
      e6.1        33.008GB   eth0 up            
      e7.0        33.008GB   eth0 up            
      e7.1        33.008GB   eth0 up            
      e8.0        33.008GB   eth0 up            
      e8.1        33.008GB   eth0 up            
      e9.0        33.008GB   eth0 up            
      e9.1        33.008GB   eth0 up


(...)
[55479.917878] RAID10 conf printout:
[55479.917880]  --- wd:22 rd:26
[55479.917881]  disk 1, wo:0, o:1, dev:etherd/e1.0
[55479.917882]  disk 2, wo:0, o:1, dev:etherd/e1.1
[55479.917883]  disk 3, wo:0, o:1, dev:etherd/e2.0
[55479.917885]  disk 4, wo:0, o:1, dev:etherd/e2.1
[55479.917886]  disk 5, wo:0, o:1, dev:etherd/e3.0
[55479.917887]  disk 6, wo:0, o:1, dev:etherd/e3.1
[55479.917888]  disk 7, wo:0, o:1, dev:etherd/e4.0
[55479.917889]  disk 8, wo:0, o:1, dev:etherd/e4.1
[55479.917890]  disk 9, wo:0, o:1, dev:etherd/e5.0
[55479.917891]  disk 10, wo:0, o:1, dev:etherd/e5.1
[55479.917892]  disk 11, wo:0, o:1, dev:etherd/e6.0
[55479.917893]  disk 12, wo:0, o:1, dev:etherd/e6.1
[55479.917895]  disk 13, wo:0, o:1, dev:etherd/e7.0
[55479.917896]  disk 14, wo:0, o:1, dev:etherd/e7.1
[55479.917897]  disk 15, wo:0, o:1, dev:etherd/e8.0
[55479.917898]  disk 16, wo:0, o:1, dev:etherd/e8.1
[55479.917899]  disk 17, wo:0, o:1, dev:etherd/e9.0
[55479.917900]  disk 18, wo:0, o:1, dev:etherd/e9.1
[55479.917901]  disk 19, wo:0, o:1, dev:etherd/e10.0
[55479.917902]  disk 20, wo:0, o:1, dev:etherd/e10.1
[55479.917904]  disk 21, wo:0, o:1, dev:etherd/e11.0
[55479.917905]  disk 22, wo:0, o:1, dev:etherd/e11.1
[55479.917927] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
[55479.917934] IP: [<ffffffffa02a1bba>] __this_module+0x5afa/0x6ff0 [raid10]
[55479.917942] PGD 11e8f9067 PUD 11e8f8067 PMD 0
[55479.917948] Oops: 0000 [#1] SMP
[55479.917952] last sysfs file: /sys/devices/virtual/block/md3/md/metadata_version
[55479.917957] CPU 0
[55479.917959] Modules linked in: ocfs2_stack_o2cb nfs fscache aoe binfmt_misc ocfs2_dlmfs ocfs2_stackglue ocfs2_dlm ocfs2_nodemanager configfs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 dm_mod autofs4 dummy hid_a4tech usbhid hid ata_generic pata_acpi ide_pci_generic pata_atiixp ohci_hcd ssb mmc_core evdev edac_core k10temp hwmon atiixp i2c_piix4 edac_mce_amd ide_core r8169 shpchp pcspkr processor mii i2c_core ehci_hcd thermal button wmi pci_hotplug usbcore pcmcia pcmcia_core sg psmouse serio_raw sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libata scsi_mod [last unloaded: scsi_wait_scan]
[55479.918056]
[55479.918059] Pid: 6318, xid: #0, comm: md3_raid10 Not tainted 2.6.34.1-3 #1 GA-MA785GMT-UD2H/GA-MA785GMT-UD2H
[55479.918065] RIP: 0010:[<ffffffffa02a1bba>]  [<ffffffffa02a1bba>] __this_module+0x5afa/0x6ff0 [raid10]
[55479.918072] RSP: 0018:ffff8800c1f87cc0  EFLAGS: 00010212
[55479.918078] RAX: ffff8800c68d7200 RBX: 0000000000000000 RCX: ffff880120b5bb08
[55479.918083] RDX: 0000000000000008 RSI: ffff8800c1f87d00 RDI: ffff880120b5ba80
[55479.918089] RBP: ffff8800c1f87d60 R08: 00000000ffffff02 R09: ffff8800bd40b580
[55479.918095] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000180
[55479.918101] R13: 0000000000000014 R14: ffff880120b5ba80 R15: 0000000000000000
[55479.918106] FS:  00007fd76c1667a0(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
[55479.918114] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[55479.918119] CR2: 0000000000000028 CR3: 000000011e58e000 CR4: 00000000000006f0
[55479.918125] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[55479.918130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[55479.918136] Process md3_raid10 (pid: 6318, threadinfo ffff8800c1f86000, task ffff8801210c3a80)
[55479.918144] Stack:
[55479.918147]  ffff8800c1f87cf0 0000000805486c00 ffff880005486c00 0000000000000000
[55479.918155] <0> ffff8800c1f87e80 0000000000000000 ffff8800c1f87d00 ffffffffa00a6b33
[55479.918166] <0> ffff8800c1f87d30 ffffffffa00a8336 ffff8800c1f87d30 ffff880005486c00
[55479.918179] Call Trace:
[55479.918187]  [<ffffffffa00a6b33>] ? md_wakeup_thread+0x23/0x30 [md_mod]
[55479.918195]  [<ffffffffa00a8336>] ? md_set_array_sectors+0x606/0xc90 [md_mod]
[55479.918202]  [<ffffffffa02a285c>] __this_module+0x679c/0x6ff0 [raid10]
[55479.918210]  [<ffffffff81040030>] ? default_wake_function+0x0/0x10
[55479.918218]  [<ffffffffa00acf73>] md_register_thread+0x1a3/0x270 [md_mod]
[55479.918225]  [<ffffffff810693a0>] ? autoremove_wake_function+0x0/0x40
[55479.918232]  [<ffffffffa00acf20>] ? md_register_thread+0x150/0x270 [md_mod]
[55479.918239]  [<ffffffff81068e8e>] kthread+0x8e/0xa0
[55479.918245]  [<ffffffff81003c94>] kernel_thread_helper+0x4/0x10
[55479.918252]  [<ffffffff8141bed1>] ? restore_args+0x0/0x30
[55479.918258]  [<ffffffff81068e00>] ? kthread+0x0/0xa0
[55479.918263]  [<ffffffff81003c90>] ? kernel_thread_helper+0x0/0x10
[55479.918268] Code: c0 49 63 41 30 44 8b ae 98 03 00 00 48 8d 75 a0 89 95 6c ff ff ff 48 8d 04 40 4d 63 64 c1 58 48 8b 47 08 49 c1 e4 04 4a 8b 1c 20 <48> 8b 7b 28 4c 89 8d 60 ff ff ff e8 e6 9d ef e0 f6 83 a0 00 00
[55479.918336] RIP  [<ffffffffa02a1bba>] __this_module+0x5afa/0x6ff0 [raid10]
[55479.918343]  RSP <ffff8800c1f87cc0>
[55479.918347] CR2: 0000000000000028
[55479.918553] ---[ end trace c99ced536f6f134e ]---
[55482.423557] BUG: unable to handle kernel paging request at ffff889800000000
[55482.423642] IP: [<ffffffff81100c4a>] handle_mm_fault+0xba/0xb90
[55482.423701] PGD 0
[55482.423755] Oops: 0000 [#2] SMP
[55482.423835] last sysfs file: /sys/devices/virtual/block/md3/md/metadata_version
[55482.423868] CPU 1
[55482.423895] Modules linked in: ocfs2_stack_o2cb nfs fscache aoe binfmt_misc ocfs2_dlmfs ocfs2_stackglue ocfs2_dlm ocfs2_nodemanager configfs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 dm_mod autofs4 dummy hid_a4tech usbhid hid ata_generic pata_acpi ide_pci_generic pata_atiixp ohci_hcd ssb mmc_core evdev edac_core k10temp hwmon atiixp i2c_piix4 edac_mce_amd ide_core r8169 shpchp pcspkr processor mii i2c_core ehci_hcd thermal button wmi pci_hotplug usbcore pcmcia pcmcia_core sg psmouse serio_raw sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libata scsi_mod [last unloaded: scsi_wait_scan]
[55482.426184]
[55482.426214] Pid: 15238, xid: #0, comm: smbd Tainted: G      D    2.6.34.1-3 #1 GA-MA785GMT-UD2H/GA-MA785GMT-UD2H
[55482.426248] RIP: 0010:[<ffffffff81100c4a>]  [<ffffffff81100c4a>] handle_mm_fault+0xba/0xb90
[55482.426308] RSP: 0000:ffff8800054bddb8  EFLAGS: 00010286
[55482.426338] RAX: 00003ffffffff000 RBX: 0000000000000001 RCX: 0000000000000011
[55482.426370] RDX: 0000009800000000 RSI: ffff8800cddbcf18 RDI: ffff88011e5b5c00
[55482.426401] RBP: ffff8800054bde48 R08: 00007fffd7750470 R09: 0000000000000000
[55482.426431] R10: ffff88011e5b5c00 R11: 0000000000000246 R12: 0000000000736647
[55482.426463] R13: ffff8800cddbcf18 R14: ffff889800000000 R15: ffff88011bb457c0
[55482.426494] FS:  00007f1af10fd720(0000) GS:ffff880001a80000(0000) knlGS:0000000000000000
[55482.426527] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[55482.426558] CR2: ffff889800000000 CR3: 00000000cc36a000 CR4: 00000000000006f0
[55482.426588] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[55482.426618] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[55482.426649] Process smbd (pid: 15238, threadinfo ffff8800054bc000, task ffff88011bb457c0)
[55482.426681] Stack:
[55482.426709]  0000000000000000 0000000040000000 0000000000000000 0000000000000000
[55482.426816] <0> ffff8801234cc6c0 ffff880100000000 0000000000000000 0000000200000000
[55482.426847] <0> ffff88011ed95908 00000000811c03f1 ffff8800054bde38 0000000000000002
[55482.426847] Call Trace:
[55482.426847]  [<ffffffff8141f0e5>] do_page_fault+0x145/0x440
[55482.426847]  [<ffffffff81082e79>] ? ktime_get_ts+0xa9/0xe0
[55482.426847]  [<ffffffff81147660>] ? poll_select_copy_remaining+0x130/0x250
[55482.426847]  [<ffffffff81148a84>] ? sys_select+0x54/0x1a0
[55482.426847]  [<ffffffff8141c0c4>] page_fault+0x24/0x30
[55482.426847] Code: 88 ff ff bb 01 00 00 00 48 c1 e8 1b 25 f8 0f 00 00 4e 8d 34 30 48 b8 00 f0 ff ff ff 3f 00 00 48 21 c2 49 01 d6 0f 84 ef 00 00 00 <49> 8b 16 48 85 d2 0f 84 e9 08 00 00 4c 89 e0 49 bb 00 00 00 00
[55482.426847] RIP  [<ffffffff81100c4a>] handle_mm_fault+0xba/0xb90
[55482.426847]  RSP <ffff8800054bddb8>
[55482.426847] CR2: ffff889800000000
[55482.426847] ---[ end trace c99ced536f6f134f ]---
[55482.429225] /home/users/builder/rpm/BUILD/kernel-2.6.34.1/linux-2.6.34/mm/memory.c:205: bad pgd ffff8800cc36a000(000000980000001c).
[55482.429304] BUG: unable to handle kernel paging request at 0000009800000064
[55482.429385] IP: [<ffffffff810ffc20>] unmap_vmas+0x1d0/0xa40
[55482.429442] PGD 1c00000c00
[55482.429496] Oops: 0000 [#3] SMP
[55482.429576] last sysfs file: /sys/devices/virtual/block/md3/md/metadata_version
[55482.429609] CPU 1
[55482.429635] Modules linked in: ocfs2_stack_o2cb nfs fscache aoe binfmt_misc ocfs2_dlmfs ocfs2_stackglue ocfs2_dlm ocfs2_nodemanager configfs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 dm_mod autofs4 dummy hid_a4tech usbhid hid ata_generic pata_acpi ide_pci_generic pata_atiixp ohci_hcd ssb mmc_core evdev edac_core k10temp hwmon atiixp i2c_piix4 edac_mce_amd ide_core r8169 shpchp pcspkr processor mii i2c_core ehci_hcd thermal button wmi pci_hotplug usbcore pcmcia pcmcia_core sg psmouse serio_raw sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libata scsi_mod [last unloaded: scsi_wait_scan]
[55482.431917]
[55482.431946] Pid: 15238, xid: #0, comm: smbd Tainted: G      D    2.6.34.1-3 #1 GA-MA785GMT-UD2H/GA-MA785GMT-UD2H
[55482.431979] RIP: 0010:[<ffffffff810ffc20>]  [<ffffffff810ffc20>] unmap_vmas+0x1d0/0xa40
[55482.432038] RSP: 0000:ffff8800054bd888  EFLAGS: 00010246
[55482.432067] RAX: 000000980000001c RBX: 0000001c00000c00 RCX: 0000000000000000
[55482.432098] RDX: ffff8800cc3a2000 RSI: 0000000000000000 RDI: 0000000000000000
[55482.432128] RBP: ffff8800054bd9a8 R08: ffffea0003d32000 R09: 0000000000000001
[55482.432158] R10: 0000000000000000 R11: 0000000000000000 R12: 00007f1aed2a2000
[55482.432189] R13: 0000000000333a36 R14: ffff8800bbf60508 R15: ffff8800bda31b48
[55482.432219] FS:  00007f1af10fd720(0000) GS:ffff880001a80000(0000) knlGS:0000000000000000
[55482.432252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[55482.432281] CR2: 0000009800000064 CR3: 00000000cc36a000 CR4: 00000000000006f0
[55482.432312] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[55482.432342] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[55482.432373] Process smbd (pid: 15238, threadinfo ffff8800054bc000, task ffff88011bb457c0)
[55482.432405] Stack:
[55482.432433]  ffffea0003d32000 0000000000000046 ffff8800054bd9b8 0000000000000000
[55482.432540] <0> ffff88011e5b5c00 ffff8800054bdfd8 0000000100002620 ffffffffffffffff
[55482.432549] <0> 0000000000000000 0000000000006440 ffff880001a86458 0000000000000000
[55482.432549] Call Trace:
[55482.432549]  [<ffffffff811067fc>] exit_mmap+0xdc/0x180
[55482.432549]  [<ffffffff81044de5>] mmput+0x45/0x100
[55482.432549]  [<ffffffff8104b744>] exit_mm+0x104/0x130
[55482.432549]  [<ffffffff8109d484>] ? acct_collect+0x154/0x1a0
[55482.432549]  [<ffffffff8122d7a7>] ? gr_acl_handle_exit+0x57/0xc0
[55482.432549]  [<ffffffff8104b8ba>] do_exit+0x14a/0x8b0
[55482.432549]  [<ffffffff81418c01>] ? printk+0x3c/0x43
[55482.432549]  [<ffffffff8104c33d>] do_group_exit+0x4d/0xb0
[55482.432549]  [<ffffffff8141cc7d>] oops_end+0x9d/0xe0
[55482.432549]  [<ffffffff8102b5a0>] no_context+0xf0/0x270
[55482.432549]  [<ffffffff81147a90>] ? pollwake+0x0/0x60
[55482.432549]  [<ffffffff8102b86e>] __bad_area_nosemaphore+0x14e/0x270
[55482.432549]  [<ffffffff8102b99e>] bad_area_nosemaphore+0xe/0x10
[55482.432549]  [<ffffffff8141f334>] do_page_fault+0x394/0x440
[55482.432549]  [<ffffffff81314d19>] ? sock_aio_write+0x159/0x210
[55482.432549]  [<ffffffff8141c0c4>] page_fault+0x24/0x30
[55482.432549]  [<ffffffff81100c4a>] ? handle_mm_fault+0xba/0xb90
[55482.432549]  [<ffffffff8141f0e5>] do_page_fault+0x145/0x440
[55482.432549]  [<ffffffff81082e79>] ? ktime_get_ts+0xa9/0xe0
[55482.432549]  [<ffffffff81147660>] ? poll_select_copy_remaining+0x130/0x250
[55482.432549]  [<ffffffff81148a84>] ? sys_select+0x54/0x1a0
[55482.432549]  [<ffffffff8141c0c4>] page_fault+0x24/0x30
[55482.432549] Code: 84 80 07 00 00 48 39 9d 50 ff ff ff 0f 86 ba 07 00 00 e8 24 fa 02 00 48 8b 55 80 48 89 d9 48 c1 e9 24 81 e1 f8 0f 00 00 48 8b 02 <48> 8b 50 48 48 01 d1 48 89 8d 58 ff ff ff 48 8b 4d b0 48 83 c1
[55482.432549] RIP  [<ffffffff810ffc20>] unmap_vmas+0x1d0/0xa40
[55482.432549]  RSP <ffff8800054bd888>
[55482.432549] CR2: 0000009800000064
[55482.435422] ---[ end trace c99ced536f6f1350 ]---
[55482.435452] Fixing recursive fault but reboot is needed!

please CC me on reply.

BR,
Pawel.
