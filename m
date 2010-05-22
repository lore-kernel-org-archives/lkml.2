Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935692Ab0EVBRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 21:17:23 -0400
Received: from internal.actusa.net ([208.83.100.16]:53632 "EHLO
	internal.actusa.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0EVBRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 21:17:20 -0400
X-Greylist: delayed 872 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2010 21:17:20 EDT
Message-ID: <4BF72D34.60701@actusa.net>
Date: Fri, 21 May 2010 18:02:44 -0700
From: Stuart Sheldon <stu@actusa.net>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stuart Sheldon <stu@actusa.net>
Subject: Possible NFS bug in 2.6.34...
X-Enigmail-Version: 0.96.0
OpenPGP: id=C3252192;
	url=http://www.actusa.net/~stu/StuartSheldon.asc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi all,

Got the following on a 64bit intel NFS client while a process was
running heavy read and writes to a large (40G) file on a 64bit Intel NFS
server. Both client and server were running 2.6.34 from kernel.org.

Basically, the client never recovered, and had to be power cycled to
correct the issue.

Here is the mount info:

drbd:/data/export on /home type nfs
(rw,rsize=32768,wsize=32768,nfsvers=3,bg,intr,addr=xxx.xx.xx.xxx)

Here's the log:

May 21 16:50:55 tovirtcore1 kernel: BUG: soft lockup - CPU#3 stuck for
61s! [qemu-system-x86:6340]
May 21 16:50:55 tovirtcore1 kernel: Modules linked in: tun nfs lockd
nfs_acl auth_rpcgss sunrpc 8021q bridge stp kvm_intel kvm parport_pc
i2c_i801 rtc_cmos rtc_core rtc_lib parport psmouse i2c_core evdev
serio_raw button processor intel_agp pcspkr ext3 jbd mbcache dm_mirror
dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod sd_mod
ide_pci_generic ide_core ata_generic pata_marvell ata_piix ohci1394
ieee1394 uhci_hcd ehci_hcd pata_acpi firewire_ohci firewire_core
crc_itu_t libata e1000 scsi_mod e1000e usbcore thermal [last unloaded:
scsi_wait_scan]
May 21 16:50:55 tovirtcore1 kernel: CPU 3
May 21 16:50:55 tovirtcore1 kernel: Modules linked in: tun nfs lockd
nfs_acl auth_rpcgss sunrpc 8021q bridge stp kvm_intel kvm parport_pc
i2c_i801 rtc_cmos rtc_core rtc_lib parport psmouse i2c_core evdev
serio_raw button processor intel_agp pcspkr ext3 jbd mbcache dm_mirror
dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod sd_mod
ide_pci_generic ide_core ata_generic pata_marvell ata_piix ohci1394
ieee1394 uhci_hcd ehci_hcd pata_acpi firewire_ohci firewire_core
crc_itu_t libata e1000 scsi_mod e1000e usbcore thermal [last unloaded:
scsi_wait_scan]
May 21 16:50:55 tovirtcore1 kernel:
May 21 16:50:55 tovirtcore1 kernel: Pid: 6340, comm: qemu-system-x86 Not
tainted 2.6.34-0-xeon-actusa #1 DQ965GF/
May 21 16:50:55 tovirtcore1 kernel: RIP: 0010:[<ffffffff8107005a>]
[<ffffffff8107005a>] clear_page_dirty_for_io+0xb2/0xb8
May 21 16:50:55 tovirtcore1 kernel: RSP: 0000:ffff8801ecf0fc38  EFLAGS:
00000246
May 21 16:50:55 tovirtcore1 kernel: RAX: 0000000000000000 RBX:
ffff880227586eb0 RCX: 0000000000000000
May 21 16:50:55 tovirtcore1 kernel: RDX: 0000000000000000 RSI:
ffff880227586fa8 RDI: ffffea00059c5700
May 21 16:50:55 tovirtcore1 kernel: RBP: ffffffff8100314e R08:
8000000000000000 R09: 0000000000000000
May 21 16:50:55 tovirtcore1 kernel: R10: ffff8801ecf0fb48 R11:
ffff8801ecf0fbc0 R12: 0000000000000010
May 21 16:50:55 tovirtcore1 kernel: R13: ffffffff81041afb R14:
ffffffffffffff10 R15: 0e00000000000000
May 21 16:50:55 tovirtcore1 kernel: FS:  000000004469f950(0063)
GS:ffff880001780000(0000) knlGS:0000000000000000
May 21 16:50:55 tovirtcore1 kernel: CS:  0010 DS: 002b ES: 002b CR0:
000000008005003b
May 21 16:50:55 tovirtcore1 kernel: CR2: 00000000006cd3d8 CR3:
000000022aff3000 CR4: 00000000000026e0
May 21 16:50:55 tovirtcore1 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 21 16:50:55 tovirtcore1 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 21 16:50:55 tovirtcore1 kernel: Process qemu-system-x86 (pid: 6340,
threadinfo ffff8801ecf0e000, task ffff88022bddc090)
May 21 16:50:55 tovirtcore1 kernel: Stack:
May 21 16:50:55 tovirtcore1 kernel: 0000000000000000 ffffea00059c5700
ffffea00059c5700 ffffffffa02e7bcd
May 21 16:50:55 tovirtcore1 kernel: <0> 0000000000000000
0000000000000000 0000000000000001 0000000000000000
May 21 16:50:55 tovirtcore1 kernel: <0> 0000000000000000
0000000000000000 0000000000000000 00000002cfb52000
May 21 16:50:55 tovirtcore1 kernel: Call Trace:
May 21 16:50:55 tovirtcore1 kernel: [<ffffffffa02e7bcd>] ?
nfs_wb_page+0x57/0x8c [nfs]
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff81072025>] ?
invalidate_inode_pages2_range+0x140/0x25c
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8102b4c7>] ?
default_wake_function+0x0/0x9
May 21 16:50:55 tovirtcore1 kernel: [<ffffffffa02ddbc6>] ?
nfs_revalidate_mapping+0x66/0xf3 [nfs]
May 21 16:50:55 tovirtcore1 kernel: [<ffffffffa02dc40f>] ?
nfs_file_read+0x92/0xd5 [nfs]
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8109203b>] ?
do_sync_read+0xb0/0xf2
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8103aa24>] ?
__send_signal+0x1cd/0x1ea
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8103acf2>] ?
kill_pid_info+0x31/0x3b
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8103ae9a>] ?
sys_kill+0x72/0x140
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff81092a38>] ?
vfs_read+0xaa/0x146
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff81092b2b>] ?
sys_pread64+0x57/0x77
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8100286b>] ?
system_call_fastpath+0x16/0x1b
May 21 16:50:55 tovirtcore1 kernel: Code: 60 48 83 ce ff 0f bd 15 c5 e8
2f 00 0f 44 d0 8d 14 d5 08 00 00 00 e8 56 be 0b 00 53 9d ba 01 00 00 00
eb 07 f0 0f ba 33 04 19 d2 <5e> 89 d0 5b 5d c3 55 48 89 fd 53 48 83 ec
08 f0 0f ba 2f 00 19
May 21 16:50:55 tovirtcore1 kernel: Call Trace:
May 21 16:50:55 tovirtcore1 kernel: [<ffffffffa02e7bcd>] ?
nfs_wb_page+0x57/0x8c [nfs]
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff81072025>] ?
invalidate_inode_pages2_range+0x140/0x25c
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8102b4c7>] ?
default_wake_function+0x0/0x9
May 21 16:50:55 tovirtcore1 kernel: [<ffffffffa02ddbc6>] ?
nfs_revalidate_mapping+0x66/0xf3 [nfs]
May 21 16:50:55 tovirtcore1 kernel: [<ffffffffa02dc40f>] ?
nfs_file_read+0x92/0xd5 [nfs]
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8109203b>] ?
do_sync_read+0xb0/0xf2
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8103aa24>] ?
__send_signal+0x1cd/0x1ea
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8103acf2>] ?
kill_pid_info+0x31/0x3b
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8103ae9a>] ?
sys_kill+0x72/0x140
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff81092a38>] ?
vfs_read+0xaa/0x146
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff81092b2b>] ?
sys_pread64+0x57/0x77
May 21 16:50:55 tovirtcore1 kernel: [<ffffffff8100286b>] ?
system_call_fastpath+0x16/0x1b

If you need any additional info, let me know

Please contact me off list, as I am not currently subscribed.

Thanks!

Stuart Sheldon
stu@actusa.net

- --
If you took all the girls I knew When I was single And brought
them all together for one night I know theyd never match My sweet
imagination And everything looks worse in black and white
               -- Paul Simon - "Kodachrome Lyrics"
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJL9y0vAAoJEFKVLITDJSGSvG4P/0/xmbTpTfk09/8klFyA57wt
7FLK+K+AMmwPjUawOmYUWO/epvHEGIWBIaYPgdIG7Hf6kyUKpWgHt2OUlSXu8E7i
U+0/MVRk9BLlltAl/hyV2eAQMG6pZ7FNoMmTEneC0kMsvyQyb5d2Bo7jjwlRswcs
w66q1QrlpsahXK+g20zZiEJ0PKeKoJFSc0USELSp7tkLivuAYt6rRR7ktpV6sQx8
TX/lBVfL7ODMm1viF+w4RKyE7p+zbBgD/wDvjoTyMf8e0JGaccCV+UA5yZLlFEt7
A3CocYXp6d9u+VorURaADU81MQhyqIaSW+477IqZhRRYJH1s0eglcySKyE9S0JyD
+MPMb7ZMQEEuoELgxqFobbnDV1XPIQr1YijoMQNQl800KdxwCIVKZRcCw+WqBzmf
9VglG4mJsx6hKjL/vlIuyrS0CJjMKsO+7U9bg2q9lsUgmAIgbpjmiXZ6Ehn81KGI
oCClBG0ra/hSJlj9sKK99q743+apCY4EWh99jmZBRBhjJ6QP8C9Gjz245AoOQK8A
2UnqFgvJsdqnKsAUB6SosoeWoemPmt4Igv/AMKGVuUmJ6KiB48dAysWSw6SyAHNc
3/fwh5Q38WXFhgDk9rxIbbc8+wsIGKdHL0O/gmk125nhj732+Eox+OTmthz+c8mi
2laWo2vyrh6YD+XO8e03
=zrlb
-----END PGP SIGNATURE-----
