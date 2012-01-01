Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2AARXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 12:23:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42716 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2AARXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 12:23:00 -0500
MIME-Version: 1.0
Date: Sun, 1 Jan 2012 17:22:58 +0000
X-Google-Sender-Auth: lcyC5FNr6VdXuBKTae8MrnYsRK8
Message-ID: <CAO+b5-pig48acSXAYKH09QHCL9EtzTis=mpn=OnE=cvCv+0EzA@mail.gmail.com>
Subject: block: WARN_ON_ONCE(ev->block <= 0) triggered in __disk_unblock_events()
From: Bart Van Assche <bvanassche@acm.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In a workload that involves a lot of scsi_remove_hosts() calls (srp-ha
patch set stress test) I get the call stack below after about 30 to 50
iterations. Is this a known issue ? Does this indicate a race
condition in the block layer ? I can trigger this issue not only with
3.2-rc7 but also with 3.1.6. I haven't tried any other kernel versions
yet.

Thanks,

Bart.

------------[ cut here ]------------
WARNING: at block/genhd.c:1466 __disk_unblock_events+0xf5/0x110()
Hardware name: P5Q DELUXE
Modules linked in: ib_srp scsi_transport_srp scsi_tgt snd_pcm_oss
snd_mixer_oss snd_seq snd_seq_device af_packet rdma_ucm rdma_cm iw_cm
ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad mlx4_ib ib_mad ib_core
microcode cpufreq_conservative cpufreq_userspace cpufreq_powersave
acpi_cpufreq mperf dm_mod snd_hda_codec_hdmi snd_hda_codec_analog
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd sr_mod sg
mlx4_core intel_agp cdrom i2c_i801 intel_gtt soundcore agpgart
i2c_core pcspkr snd_page_alloc button uhci_hcd sd_mod crc_t10dif
ehci_hcd usbcore usb_common edd ext3 mbcache jbd
 fan ata_generic ata_piix pata_marvell ahci libahci libata scsi_mod
thermal processor thermal_sys hwmon
Pid: 4133, comm: edd_id Not tainted 3.2.0-rc7+ #1
Call Trace:
 [<ffffffff8104669f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810466fa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811e8fd5>] __disk_unblock_events+0xf5/0x110
 [<ffffffff811eae5a>] disk_unblock_events+0x1a/0x20
 [<ffffffff8117c980>] __blkdev_get+0x1b0/0x430
 [<ffffffff8117cfb0>] ? blkdev_get+0x3b0/0x3b0
 [<ffffffff8117cc53>] blkdev_get+0x53/0x3b0
 [<ffffffff813e8d7b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff8117cfb0>] ? blkdev_get+0x3b0/0x3b0
 [<ffffffff8117d012>] blkdev_open+0x62/0x80
 [<ffffffff81142b22>] __dentry_open+0x212/0x390
 [<ffffffff813e8d7b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff811cf840>] ? devcgroup_seq_read+0x160/0x160
 [<ffffffff81143e01>] nameidata_to_filp+0x71/0x80
 [<ffffffff81152966>] do_last+0xb6/0x7e0
 [<ffffffff81154578>] path_openat+0xd8/0x420
 [<ffffffff8110b9c3>] ? might_fault+0x53/0xb0
 [<ffffffff811549e9>] do_filp_open+0x49/0xa0
 [<ffffffff813e8d7b>] ? _raw_spin_unlock+0x2b/0x50
 [<ffffffff811617c4>] ? alloc_fd+0xf4/0x150
 [<ffffffff81143f11>] do_sys_open+0x101/0x1e0
 [<ffffffff81144010>] sys_open+0x20/0x30
 [<ffffffff813f0e6b>] system_call_fastpath+0x16/0x1b
---[ end trace 1afaff519afd7a94 ]---
