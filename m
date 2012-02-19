Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab2BSTkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 14:40:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50949 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913Ab2BSTkn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 14:40:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of przemyslaw@pawelczyk.it designates 10.60.20.101 as permitted sender) smtp.mail=przemyslaw@pawelczyk.it
MIME-Version: 1.0
In-Reply-To: <20120218182436.GB1905@moon>
References: <CAN8=baycwqAkTJxNpNzaO9G=TbEXeiEYCvWxiwvS+NpLRZi3xw@mail.gmail.com>
	<20120218173950.GA12595@albatros>
	<20120218182436.GB1905@moon>
Date: Sun, 19 Feb 2012 20:40:42 +0100
Message-ID: <CAN8=bawR0H6y-2qONGdG7CvfgphyeEt1v30YONPf5LaXRdgi+w@mail.gmail.com>
Subject: Re: [BUG] task->nsproxy was unexpectedly NULL (caught in exit_shm)
From: =?UTF-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, lkml <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few minutes ago I was closing a tab in Chrome and I heard BEEP!
This time my mouse and keyboard stopped responding in X, have to ssh
from notebook to read log.
(I was using Synergy today, so maybe it is related.)


[14498.686122] chrome[2336] general protection ip:21cafad51d9a
sp:7fff74f13410 error:0
[14519.038834] BUG: Bad page map in process chrome
pte:800000010238c067 pmd:12de61067
[14519.038849] page:ffffea000387c6a0 count:0 mapcount:-1 mapping:
    (null) index:0x23bd65b39
[14519.038855] page flags: 0x200000000000014(referenced|dirty)
[14519.038866] addr:00007fecb619c000 vm_flags:080000fb anon_vma:
   (null) mapping:ffff8800802b11d8 index:2ae
[14519.038879] vma->vm_ops->fault: shm_fault+0x0/0x18
[14519.038886] vma->vm_file->f_op->mmap: shm_mmap+0x0/0x55
[14519.038894] Pid: 9108, comm: chrome Tainted: P    B      O 3.2.0-1-amd64 #1
[14519.038899] Call Trace:
[14519.038913]  [<ffffffff810cd3d5>] ? print_bad_pte+0x1a5/0x1bd
[14519.038920]  [<ffffffff810cd035>] ? pte_pfn+0x5/0xe
[14519.038928]  [<ffffffff810ceff6>] ? unmap_vmas+0x49f/0x694
[14519.038936]  [<ffffffff81036d5f>] ? cpumask_next+0x16/0x18
[14519.038946]  [<ffffffff810d4297>] ? exit_mmap+0x93/0xe1
[14519.038956]  [<ffffffff810446e2>] ? mmput+0x56/0xf8
[14519.038964]  [<ffffffff8104985f>] ? exit_mm+0x117/0x122
[14519.038975]  [<ffffffff81340732>] ? _raw_spin_lock_irq+0xa/0x14
[14519.038983]  [<ffffffff81049ab0>] ? do_exit+0x246/0x732
[14519.038992]  [<ffffffff8104a21c>] ? do_group_exit+0x74/0x9e
[14519.039001]  [<ffffffff81055b5b>] ? get_signal_to_deliver+0x46d/0x48f
[14519.039012]  [<ffffffff8100ddd3>] ? do_signal+0x38/0x610
[14519.039024]  [<ffffffff8106f2dc>] ? sys_futex+0x138/0x148
[14519.039032]  [<ffffffff8100e3e1>] ? do_notify_resume+0x25/0x68
[14519.039041]  [<ffffffff813459e0>] ? int_signal+0x12/0x17
[14519.061778] ------------[ cut here ]------------

[14519.061786] kernel BUG at
/home/blank/debian/kernel/release/linux-2.6/linux-2.6-3.2.4/debian/build/source_amd64_none/mm/filemap.c:135!
[14519.061789] invalid opcode: 0000 [#1] SMP
[14519.061792] CPU 1
[14519.061793] Modules linked in: pci_stub vboxpci(O) vboxnetadp(O)
vboxnetflt(O) vboxdrv(O) powernow_k8 mperf cpufreq_stats
cpufreq_conservative cpufreq_userspace cpufreq_powersave parport_pc
ppdev lp parport binfmt_misc nfsd nfs lockd fscache auth_rpcgss
nfs_acl sunrpc kvm_amd kvm fuse ext2 loop snd_hda_codec_hdmi
snd_hda_intel snd_hda_codec snd_intel8x0 snd_ac97_codec ac97_bus
snd_hwdep nvidia(P) snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi
k8temp snd_rawmidi snd_seq_midi_event snd_seq evdev pcspkr edac_core
edac_mce_amd i2c_nforce2 snd_timer snd_seq_device i2c_core snd
soundcore snd_page_alloc processor button ext3 jbd mbcache btrfs
zlib_deflate crc32c libcrc32c dm_mirror dm_region_hash dm_log usbhid
dm_mod sr_mod hid cdrom sd_mod crc_t10dif ohci_hcd ata_generic ahci
libahci pata_jmicron sata_nv pata_amd thermal floppy libata fan
thermal_sys ehci_hcd forcedeth scsi_mod usbcore usb_common [last
unloaded: scsi_wait_scan]
[14519.061852]
[14519.061855] Pid: 2171, comm: Xorg Tainted: P    B      O
3.2.0-1-amd64 #1 Unknow Unknow/KN9 Series(NF-CK804)
[14519.061859] RIP: 0010:[<ffffffff810b4473>]  [<ffffffff810b4473>]
__delete_from_page_cache+0x5b/0xc8
[14519.061868] RSP: 0018:ffff88012f50dc28  EFLAGS: 00010046
[14519.061870] RAX: 0000000000000000 RBX: ffffea00038b46a0 RCX: 00000000fffffff0
[14519.061872] RDX: 0000000000000017 RSI: 0000000000000017 RDI: 00000000fffffff4
[14519.061875] RBP: ffff8800802b11d8 R08: 000000000000002e R09: 0000000000000002
[14519.061877] R10: 000000000000000d R11: 000000000000000d R12: ffff8800802b11f0
[14519.061879] R13: 0000000000000000 R14: ffffffffffffffff R15: 0000000000000000
[14519.061882] FS:  00007f589e4be880(0000) GS:ffff880137d00000(0000)
knlGS:0000000000000000
[14519.061885] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14519.061887] CR2: 00007f6fec16b548 CR3: 000000012f725000 CR4: 00000000000006e0
[14519.061890] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[14519.061892] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[14519.061895] Process Xorg (pid: 2171, threadinfo ffff88012f50c000,
task ffff88013133d200)
[14519.061897] Stack:
[14519.061898]  000000000000000d ffffea00038b46a0 0000000000000000
ffffffff810b45e3
[14519.061902]  ffffea00038b46a0 ffff8800802b11d8 ffff8800802b11d8
ffffffff810bda39
[14519.061906]  00000000000002bb ffff8800802b1098 00000000000002ae
ffffffff810c6451
[14519.061910] Call Trace:
[14519.061914]  [<ffffffff810b45e3>] ? delete_from_page_cache+0x31/0x57
[14519.061919]  [<ffffffff810bda39>] ? truncate_inode_page+0x65/0x6b
[14519.061924]  [<ffffffff810c6451>] ? shmem_truncate_range+0x110/0x355
[14519.061928]  [<ffffffff810c67b7>] ? shmem_evict_inode+0x48/0xd7
[14519.061932]  [<ffffffff8110b1f8>] ? evict+0x96/0x148
[14519.061937]  [<ffffffff81108613>] ? dentry_kill+0x10f/0x12b
[14519.061940]  [<ffffffff8110886a>] ? dput+0xe2/0xee
[14519.061943]  [<ffffffff810f99c2>] ? fput+0x17a/0x1a1
[14519.061947]  [<ffffffff810d2ec8>] ? remove_vma+0x3a/0x6b
[14519.061950]  [<ffffffff810d40a7>] ? do_munmap+0x2da/0x2f3
[14519.061955]  [<ffffffff81158b72>] ? sys_shmdt+0x97/0x121
[14519.061960]  [<ffffffff81345712>] ? system_call_fastpath+0x16/0x1b
[14519.061962] Code: be 09 00 00 00 48 89 df e8 4e 54 01 00 48 8b 03
a9 00 00 08 00 74 0d be 17 00 00 00 48 89 df e8 37 54 01 00 8b 43 18
85 c0 78 02 <0f> 0b 48 8b 03 a8 10 74 5f 48 8b 85 80 00 00 00 f6 40 20
01 75
[14519.061991] RIP  [<ffffffff810b4473>] __delete_from_page_cache+0x5b/0xc8
[14519.061995]  RSP <ffff88012f50dc28>
[14519.061998] ---[ end trace 2d2427cb6602dc70 ]---


Regards.

-- 
Przemysław Pawełczyk
