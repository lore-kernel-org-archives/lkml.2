Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2BWRBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:01:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49731 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2BWRBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:01:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bart.vanassche@gmail.com designates 10.216.138.34 as permitted sender) smtp.mail=bart.vanassche@gmail.com; dkim=pass header.i=bart.vanassche@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAO+b5-o54PzRsbvT73L5Wi9aKofKPK2e2YxcoLeVx4ffgZMTeQ@mail.gmail.com>
References: <CAO+b5-o54PzRsbvT73L5Wi9aKofKPK2e2YxcoLeVx4ffgZMTeQ@mail.gmail.com>
Date: Thu, 23 Feb 2012 17:01:15 +0000
Message-ID: <CAO+b5-rSEhhDbrgxc21C_7eA=7nsuqqc2HodWzZ4cxVQCwtYRw@mail.gmail.com>
Subject: ext4: List corruption complaint on 2.6.32.57
From: Bart Van Assche <bart.vanassche@gmail.com>
To: linux-ext4@kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Has anyone seen this call stack before ?

Thanks,

Bart.

------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x8f/0xa0()
Hardware name: P5Q DELUXE
list_add corruption. prev->next should be next (ffff88016a00c718), but was
ffff8801a876c300. (prev=ffff88016a00c718).
Modules linked in: ext4 jbd2 crc16 ib_srp scsi_transport_srp scsi_tgt
netconsole configfs snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device
af_packet rdma_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_sa ib_uverbs
ib_umad mlx4_ib ib_mad ib_core microcode cpufreq_conservative
cpufreq_userspace cpufreq_powersave acpi_cpufreq dm_mod
snd_hda_codec_atihdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm sr_mod snd_timer i2c_i801 intel_agp snd sg cdrom pcspkr
soundcore i2c_core agpgart mlx4_core button snd_page_alloc uhci_hcd ehci_hcd
sd_mod crc_t10dif usbcore edd ext3 mbcache jbd fan ata_generic ata_piix
pata_marvell ahci libata scsi_mod thermal processor thermal_sys hwmon [last
unloaded: scsi_transport_srp]
Pid: 4127, comm: fio Not tainted 2.6.32.57-debug #1
Call Trace:
 <IRQ>  [<ffffffff8105058b>] warn_slowpath_common+0x7b/0xc0
 [<ffffffff81050631>] warn_slowpath_fmt+0x41/0x50
 [<ffffffff811ef9ff>] __list_add+0x8f/0xa0
 [<ffffffffa037a544>] ext4_end_io_dio+0x94/0xb0 [ext4]
 [<ffffffff8116c275>] dio_complete+0xc5/0xf0
 [<ffffffff8116c316>] dio_bio_end_aio+0x76/0xd0
 [<ffffffff810881fd>] ? lock_release_holdtime+0x3d/0x180
 [<ffffffff81167add>] bio_endio+0x1d/0x40
 [<ffffffff811cebeb>] req_bio_endio+0xab/0x110
 [<ffffffff811cf5af>] blk_update_request+0xff/0x4b0
 [<ffffffff811cf784>] ? blk_update_request+0x2d4/0x4b0
 [<ffffffff811cf994>] blk_update_bidi_request+0x34/0x80
 [<ffffffff811d06bf>] blk_end_bidi_request+0x2f/0x80
 [<ffffffff811d0760>] blk_end_request+0x10/0x20
 [<ffffffffa00313df>] scsi_io_completion+0xaf/0x560 [scsi_mod]
 [<ffffffffa0028751>] scsi_finish_command+0xc1/0x130 [scsi_mod]
 [<ffffffff8108d83b>] ? mark_held_locks+0x6b/0xa0
 [<ffffffffa0031245>] scsi_softirq_done+0x145/0x170 [scsi_mod]
 [<ffffffff811d6425>] blk_done_softirq+0x85/0xa0
 [<ffffffff81059156>] __do_softirq+0xd6/0x230
 [<ffffffff8100d19c>] call_softirq+0x1c/0x30
 [<ffffffff8100ec4d>] do_softirq+0x8d/0xc0
 [<ffffffff810593d5>] irq_exit+0x95/0xa0
 [<ffffffff813a1735>] do_IRQ+0x75/0xf0
 [<ffffffff8100c993>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffffa037b9cb>] ? flush_aio_dio_completed_IO+0x4b/0x90 [ext4]
 [<ffffffffa037b9bc>] ? flush_aio_dio_completed_IO+0x3c/0x90 [ext4]
 [<ffffffffa0377228>] ? ext4_sync_file+0x98/0x300 [ext4]
 [<ffffffff8139ab5b>] ? __mutex_unlock_slowpath+0xcb/0x160
 [<ffffffff81161683>] ? vfs_fsync_range+0xa3/0xe0
 [<ffffffff8116170b>] ? generic_write_sync+0x4b/0x50
 [<ffffffff810e996e>] ? generic_file_aio_write+0xbe/0xe0
 [<ffffffffa037711c>] ? ext4_file_write+0x3c/0xb0 [ext4]
 [<ffffffff8108d9bd>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffffa03770e0>] ? ext4_file_write+0x0/0xb0 [ext4]
 [<ffffffff8117753c>] ? aio_rw_vect_retry+0x7c/0x200
 [<ffffffff811774c0>] ? aio_rw_vect_retry+0x0/0x200
 [<ffffffff81178890>] ? aio_run_iocb+0x60/0x150
 [<ffffffff81179e22>] ? sys_io_submit+0x222/0x6c0
 [<ffffffff8100c05b>] ? system_call_fastpath+0x16/0x1b
---[ end trace 38304a60b381bf96 ]---
------------[ cut here ]------------
