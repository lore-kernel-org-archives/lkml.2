Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2DKTPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:15:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab2DKTPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:15:32 -0400
Date: Wed, 11 Apr 2012 15:15:27 -0400
From: Dave Jones <davej@redhat.com>
To: borislav.petkov@amd.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: microcode driver sysfs warning since 3.3
Message-ID: <20120411191527.GA24468@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, borislav.petkov@amd.com,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had a number of users report the following trace recently..

backtrace:
:WARNING: at fs/sysfs/group.c:138 sysfs_remove_group+0xfa/0x100()
:Hardware name:  
:sysfs group ffffffffa0199130 not found for kobject 'cpu1'
:Modules linked in: fuse binfmt_misc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6
nf_conntrack_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 xt_state nf_conntrack
ip6table_filter ip6_tables arc4 rt73usb rt2x00usb rt2x00lib mac80211 cfg80211
rfkill crc_itu_t snd_intel8x0 snd_ac97_codec edac_core ac97_bus snd_pcm
snd_page_alloc edac_mce_amd snd_timer k8temp microcode serio_raw snd soundcore
i2c_nforce2 uinput ata_generic pata_acpi sata_nv pata_amd nouveau mxm_wmi wmi
video drm_kms_helper ttm drm i2c_core [last unloaded: scsi_wait_scan]
:Pid: 1704, comm: pm-suspend Not tainted 3.3.0-0.rc3.git7.2.fc17.x86_64 #1
:Call Trace:
: [<ffffffff81060bef>] warn_slowpath_common+0x7f/0xc0
: [<ffffffff81060ce6>] warn_slowpath_fmt+0x46/0x50
: [<ffffffff8123663b>] ? sysfs_get_dirent+0x5b/0x80
: [<ffffffff8123877a>] sysfs_remove_group+0xfa/0x100
: [<ffffffffa019764a>] mc_cpu_callback+0xda/0x129 [microcode]
: [<ffffffff816a265e>] notifier_call_chain+0x6e/0x110
: [<ffffffff8109182e>] __raw_notifier_call_chain+0xe/0x10
: [<ffffffff81062c60>] __cpu_notify+0x20/0x40
: [<ffffffff81679494>] _cpu_down+0x84/0x2d0
: [<ffffffff81691ba3>] ? printk+0x51/0x53
: [<ffffffff81062ee4>] disable_nonboot_cpus+0xa4/0x150
: [<ffffffff810b509d>] suspend_devices_and_enter+0x38d/0x4a0
: [<ffffffff810b5346>] enter_state+0x196/0x1d0
: [<ffffffff810b387a>] state_store+0xba/0x130
: [<ffffffff8131eecf>] kobj_attr_store+0xf/0x20
: [<ffffffff812347b6>] sysfs_write_file+0xe6/0x160
: [<ffffffff811bb44f>] vfs_write+0xaf/0x190
: [<ffffffff811bb78d>] sys_write+0x4d/0x90
: [<ffffffff816a6f29>] system_call_fastpath+0x16/0x1b

The latest report was against 3.3.1.

https://bugzilla.redhat.com/show_bug.cgi?id=797559

	Dave

