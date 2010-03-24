Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0CXRnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:43:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48472 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab0CXRnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:43:14 -0400
X-Authority-Analysis: v=1.0 c=1 a=5SghZyjZWH8A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=GVpMQjGw0-VwntJhepIA:9 a=9k75PDL8zT0a4g0o56dQOqA9ptQA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [BUG] lockdep_init_map error in sysfs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 24 Mar 2010 13:43:12 -0400
Message-ID: <1269452592.2957.2852.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting this in latest Linus tree:

BUG: key ffff88002ede4870 not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xe6/0x576()
Hardware name: Precision WorkStation 470    
Modules linked in: radeon ttm drm_kms_helper drm i2c_algo_bit autofs4 hidp rfcomm l2cap crc16 bluetooth ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 sbs sbshc battery ac snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss sg snd_mixer_oss e1000 snd_pcm snd_timer button snd floppy serio_raw e752x_edac i2c_i801 ata_generic iTCO_wdt iTCO_vendor_support i2c_core shpchp edac_core pcspkr soundcore snd_page_alloc dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd
Pid: 3335, comm: Xorg Not tainted 2.6.34-rc1 #2533
Call Trace:
 [<ffffffff81056a88>] warn_slowpath_common+0x7c/0x94
 [<ffffffff81056ab4>] warn_slowpath_null+0x14/0x16
 [<ffffffff81087536>] lockdep_init_map+0xe6/0x576
 [<ffffffff811830d1>] ? sysfs_new_dirent+0x8f/0x104
 [<ffffffff811824fe>] sysfs_add_file_mode+0x66/0xae
 [<ffffffff81182557>] sysfs_add_file+0x11/0x13
 [<ffffffff81184a0b>] sysfs_create_bin_file+0x5f/0x68
 [<ffffffff812a5fb3>] _request_firmware+0x613/0x623
 [<ffffffff812a603e>] request_firmware+0x13/0x15
 [<ffffffffa04a9c03>] radeon_cp_init+0xd0a/0xf07 [radeon]
 [<ffffffff813d1e27>] ? _lock_kernel+0x10e/0x1b3
 [<ffffffffa0473608>] drm_ioctl+0x290/0x364 [drm]
 [<ffffffffa04a8ef9>] ? radeon_cp_init+0x0/0xf07 [radeon]
 [<ffffffff81130537>] vfs_ioctl+0x32/0xa6
 [<ffffffff81130af6>] do_vfs_ioctl+0x4c2/0x508
 [<ffffffff8112252d>] ? fget_light+0x53/0x17e
 [<ffffffff8107fb15>] ? current_kernel_time+0x2d/0x55
 [<ffffffff8100c4ea>] ? sysret_check+0x2e/0x69
 [<ffffffff81130b98>] sys_ioctl+0x5c/0x9a
 [<ffffffff8100c4b2>] system_call_fastpath+0x16/0x1b
---[ end trace f0b271065a87e572 ]---


-- Steve


