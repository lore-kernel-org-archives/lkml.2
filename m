Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab0GVIvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:51:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:34779 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab0GVIvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:51:20 -0400
Date: Thu, 22 Jul 2010 18:51:11 +1000
From: Neil Brown <neilb@suse.de>
To: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org, Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: [2.6.34.1] OOPS in raid10 module.
Message-ID: <20100722185111.693401fe@notabene>
In-Reply-To: <201007220758.47974.pluto@agmk.net>
References: <201007220758.47974.pluto@agmk.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 07:58:47 +0200
Paweł Sikora <pluto@agmk.net> wrote:

> hi,
> 
> i'm testing an raid10 with ata-over-ethernet backend.
> there're 13 slave machines and each one exports 2 partitions
> via vbladed as /dev/etherd/e[1-13].[0-1].
> there's also a master which assembles /dev/etherd/... into raid10.
> 
> everything seems to work fine until first failure event.
> mdadm monitor sent to me 4 emails about failure of e13.1, e12.0,
> e13.0, e12.1 and master oopsed.
> 
> # cat /proc/mdstat
> Personalities : [raid1] [raid0] [raid10]
> md3 : active raid10 etherd/e13.0[26](F) etherd/e12.1[27](F) etherd/e12.0[28](F) etherd/e11.1[22] etherd/e11.0[21] etherd/e10.1[20] etherd/e10.0[19] etherd/e9.1[18] etherd/e9.0[17] etherd/e8.1[16] etherd/e8.0[15] etherd/e7.1[14] etherd/e7.0[13] etherd/e6.1[12] etherd/e6.0[11] etherd/e5.1[10] etherd/e5.0[9] etherd/e4.1[8] etherd/e4.0[7] etherd/e3.1[6] etherd/e3.0[5] etherd/e2.1[4] etherd/e2.0[3] etherd/e1.1[2] etherd/e1.0[1] etherd/e13.1[29](F)
>       419045952 blocks 64K chunks 2 near-copies [26/22] [_UUUUUUUUUUUUUUUUUUUUUU___]
> 
> md2 : active raid10 sda4[0] sdd4[3] sdc4[2] sdb4[1]
>       960943872 blocks 64K chunks 2 far-copies [4/4] [UUUU]
> 
> md1 : active raid0 sda3[0] sdd3[3] sdc3[2] sdb3[1]
>       1953117952 blocks 64k chunks
> 
> md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
>       4000064 blocks [4/4] [UUUU]
> 
> 
> # aoe-stat 
>      e10.0        33.008GB   eth0 up            
>      e10.1        33.008GB   eth0 up            
>       e1.0        33.008GB   eth0 up            
>      e11.0        33.008GB   eth0 up            
>      e11.1        33.008GB   eth0 up            
>       e1.1        33.008GB   eth0 up            
>      e12.0         0.000GB   eth0 down,closewait
>      e12.1         0.000GB   eth0 down,closewait
>      e13.0         0.000GB   eth0 down,closewait
>      e13.1         0.000GB   eth0 down,closewait
>       e2.0        33.008GB   eth0 up            
>       e2.1        33.008GB   eth0 up            
>       e3.0        33.008GB   eth0 up            
>       e3.1        33.008GB   eth0 up            
>       e4.0        33.008GB   eth0 up            
>       e4.1        33.008GB   eth0 up            
>       e5.0        33.008GB   eth0 up            
>       e5.1        33.008GB   eth0 up            
>       e6.0        33.008GB   eth0 up            
>       e6.1        33.008GB   eth0 up            
>       e7.0        33.008GB   eth0 up            
>       e7.1        33.008GB   eth0 up            
>       e8.0        33.008GB   eth0 up            
>       e8.1        33.008GB   eth0 up            
>       e9.0        33.008GB   eth0 up            
>       e9.1        33.008GB   eth0 up
> 
> 
> (...)
> [55479.917878] RAID10 conf printout:
> [55479.917880]  --- wd:22 rd:26
> [55479.917881]  disk 1, wo:0, o:1, dev:etherd/e1.0
> [55479.917882]  disk 2, wo:0, o:1, dev:etherd/e1.1
> [55479.917883]  disk 3, wo:0, o:1, dev:etherd/e2.0
> [55479.917885]  disk 4, wo:0, o:1, dev:etherd/e2.1
> [55479.917886]  disk 5, wo:0, o:1, dev:etherd/e3.0
> [55479.917887]  disk 6, wo:0, o:1, dev:etherd/e3.1
> [55479.917888]  disk 7, wo:0, o:1, dev:etherd/e4.0
> [55479.917889]  disk 8, wo:0, o:1, dev:etherd/e4.1
> [55479.917890]  disk 9, wo:0, o:1, dev:etherd/e5.0
> [55479.917891]  disk 10, wo:0, o:1, dev:etherd/e5.1
> [55479.917892]  disk 11, wo:0, o:1, dev:etherd/e6.0
> [55479.917893]  disk 12, wo:0, o:1, dev:etherd/e6.1
> [55479.917895]  disk 13, wo:0, o:1, dev:etherd/e7.0
> [55479.917896]  disk 14, wo:0, o:1, dev:etherd/e7.1
> [55479.917897]  disk 15, wo:0, o:1, dev:etherd/e8.0
> [55479.917898]  disk 16, wo:0, o:1, dev:etherd/e8.1
> [55479.917899]  disk 17, wo:0, o:1, dev:etherd/e9.0
> [55479.917900]  disk 18, wo:0, o:1, dev:etherd/e9.1
> [55479.917901]  disk 19, wo:0, o:1, dev:etherd/e10.0
> [55479.917902]  disk 20, wo:0, o:1, dev:etherd/e10.1
> [55479.917904]  disk 21, wo:0, o:1, dev:etherd/e11.0
> [55479.917905]  disk 22, wo:0, o:1, dev:etherd/e11.1
> [55479.917927] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [55479.917934] IP: [<ffffffffa02a1bba>] __this_module+0x5afa/0x6ff0 [raid10]
> [55479.917942] PGD 11e8f9067 PUD 11e8f8067 PMD 0
> [55479.917948] Oops: 0000 [#1] SMP
> [55479.917952] last sysfs file: /sys/devices/virtual/block/md3/md/metadata_version
> [55479.917957] CPU 0
> [55479.917959] Modules linked in: ocfs2_stack_o2cb nfs fscache aoe binfmt_misc ocfs2_dlmfs ocfs2_stackglue ocfs2_dlm ocfs2_nodemanager configfs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs sch_sfq iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter xt_TCPMSS xt_tcpudp iptable_mangle ip_tables ip6table_filter ip6_tables x_tables ext4 jbd2 crc16 raid10 raid0 dm_mod autofs4 dummy hid_a4tech usbhid hid ata_generic pata_acpi ide_pci_generic pata_atiixp ohci_hcd ssb mmc_core evdev edac_core k10temp hwmon atiixp i2c_piix4 edac_mce_amd ide_core r8169 shpchp pcspkr processor mii i2c_core ehci_hcd thermal button wmi pci_hotplug usbcore pcmcia pcmcia_core sg psmouse serio_raw sd_mod crc_t10dif raid1 md_mod ext3 jbd mbcache ahci libata scsi_mod [last unloaded: scsi_wait_scan]
> [55479.918056]
> [55479.918059] Pid: 6318, xid: #0, comm: md3_raid10 Not tainted 2.6.34.1-3 #1 GA-MA785GMT-UD2H/GA-MA785GMT-UD2H
> [55479.918065] RIP: 0010:[<ffffffffa02a1bba>]  [<ffffffffa02a1bba>] __this_module+0x5afa/0x6ff0 [raid10]
> [55479.918072] RSP: 0018:ffff8800c1f87cc0  EFLAGS: 00010212
> [55479.918078] RAX: ffff8800c68d7200 RBX: 0000000000000000 RCX: ffff880120b5bb08
> [55479.918083] RDX: 0000000000000008 RSI: ffff8800c1f87d00 RDI: ffff880120b5ba80
> [55479.918089] RBP: ffff8800c1f87d60 R08: 00000000ffffff02 R09: ffff8800bd40b580
> [55479.918095] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000180
> [55479.918101] R13: 0000000000000014 R14: ffff880120b5ba80 R15: 0000000000000000
> [55479.918106] FS:  00007fd76c1667a0(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
> [55479.918114] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [55479.918119] CR2: 0000000000000028 CR3: 000000011e58e000 CR4: 00000000000006f0
> [55479.918125] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [55479.918130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [55479.918136] Process md3_raid10 (pid: 6318, threadinfo ffff8800c1f86000, task ffff8801210c3a80)
> [55479.918144] Stack:
> [55479.918147]  ffff8800c1f87cf0 0000000805486c00 ffff880005486c00 0000000000000000
> [55479.918155] <0> ffff8800c1f87e80 0000000000000000 ffff8800c1f87d00 ffffffffa00a6b33
> [55479.918166] <0> ffff8800c1f87d30 ffffffffa00a8336 ffff8800c1f87d30 ffff880005486c00
> [55479.918179] Call Trace:
> [55479.918187]  [<ffffffffa00a6b33>] ? md_wakeup_thread+0x23/0x30 [md_mod]
> [55479.918195]  [<ffffffffa00a8336>] ? md_set_array_sectors+0x606/0xc90 [md_mod]
> [55479.918202]  [<ffffffffa02a285c>] __this_module+0x679c/0x6ff0 [raid10]
> [55479.918210]  [<ffffffff81040030>] ? default_wake_function+0x0/0x10
> [55479.918218]  [<ffffffffa00acf73>] md_register_thread+0x1a3/0x270 [md_mod]
> [55479.918225]  [<ffffffff810693a0>] ? autoremove_wake_function+0x0/0x40
> [55479.918232]  [<ffffffffa00acf20>] ? md_register_thread+0x150/0x270 [md_mod]
> [55479.918239]  [<ffffffff81068e8e>] kthread+0x8e/0xa0
> [55479.918245]  [<ffffffff81003c94>] kernel_thread_helper+0x4/0x10
> [55479.918252]  [<ffffffff8141bed1>] ? restore_args+0x0/0x30
> [55479.918258]  [<ffffffff81068e00>] ? kthread+0x0/0xa0
> [55479.918263]  [<ffffffff81003c90>] ? kernel_thread_helper+0x0/0x10
> [55479.918268] Code: c0 49 63 41 30 44 8b ae 98 03 00 00 48 8d 75 a0 89 95 6c ff ff ff 48 8d 04 40 4d 63 64 c1 58 48 8b 47 08 49 c1 e4 04 4a 8b 1c 20 <48> 8b 7b 28 4c 89 8d 60 ff ff ff e8 e6 9d ef e0 f6 83 a0 00 00
> [55479.918336] RIP  [<ffffffffa02a1bba>] __this_module+0x5afa/0x6ff0 [raid10]
> [55479.918343]  RSP <ffff8800c1f87cc0>
> [55479.918347] CR2: 0000000000000028
> [55479.918553] ---[ end trace c99ced536f6f134e ]---

This is a very strange stack trae.  I would not expect to see __this_module
in there at all, and I would expect to see raid10d, but don't.

So I cannot even guess where anything is going wrong.

Given the other oops message you included, I wonder if something is
corrupting memory and md/raid10 is just getting caught in the cross-fire.

It might be worth checking how you go at accessing all the etherd devices
without use md.  Maybe just 26 'dd' commands in parallel writing to them, or
reading from them.

Or maybe make a RAID0 over all of them and exercise a filesystem on that.

Sorry I cannot be more helpful.

NeilBrown

