Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2LUQVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:21:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LUQVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:21:15 -0500
Message-ID: <1356106865.4547.60.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.6.11-rt24 (apocalypse release)c
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Fri, 21 Dec 2012 17:21:05 +0100
In-Reply-To: <alpine.LFD.2.02.1212211413200.3148@ionos>
References: <alpine.LFD.2.02.1212211413200.3148@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:12XPV342usSLMyFbiVsvdEVJFc58wT4Ubw0zhO/OAQ6
 EUtSNF9Rw/dhFCHmvtTeKFUd4qeq2TLu7eAe3N74iC103PKiZL
 eOAlG8ppA3nMRixqn5pX10bgfJ/XjjeefQS9pwhyki6OT01MmA
 lKpioBvujkUevZ14XadzHgdDyMUzQVRn0fwd9U0k6C2qD92KkH
 JBV5UpJSpM84mbNT21dCfBveQu42E9aj/00StOZp1aNC7E9vta
 ChYimF8w1/80OrPbrhwDzTxSoGDwzFbwAjn/4FOTvAqB82lc8p
 mmtC0g5sH9mVtp9eS0a5Bmjjvr0Bo0CtWjpNzFbvZvTDQDfjqA
 Ffc2pNZ/+ZUpxNWDDQ0zgmYzQ3v54u/cTa8+GYcyThTx5L/1rX
 W2Qjr+lKn29jQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 14:50 +0100, Thomas Gleixner wrote: 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.11-rt24 release. 3.6.9-rt21, 3.6.10-rt22
> and 3.6.11-rt23 are not announced updates to the respective 3.6.y
> stable releases without any RT changes
> 
> Changes since 3.6.11-rt23:
> 
>    * Fix the scheduler bug really. Thanks to Mike for noticing the
>      issue. It turned out that there are a few more corner cases
>      hidden in that code. See the 3 separate patches in the quilt
>      queue for details.
> 
>    * Fix a livelock issue in the block layer. Thanks to Steve for
>      debugging it.
> 
> Known issues:
> 
>    * There is still a possibility to get false positives from the NOHZ
>      idle softirq pending detector. It's rather complex to fix and I
>      have postponed it for a separate release. The warnings are
>      harmless and can be ignored for now.
> 
> For those who are going to vanish today due to their firm believe in
> the Mayan Apocalypse it's the last release ever and I can assure you
> it's the best one as well. You just won't have enough time to verify
> that.
> 
> For all others this is just the last release of 2012.
> 
> 
> The delta patch against 3.6.11-rt23 is appended below and can be found
> here:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11-rt23-rt24.patch.xz
> 
> The RT patch against 3.6.11 can be found here:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-rt24.patch.xz
> 
> The split quilt queue is available at:
> 
>   http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11-rt24.tar.xz
> 
> 
> Thanks to all of you who have contributed with patches, bugreports,
> testing ...! Special thanks to Steven for running the stable series!

Just got this apocalypse day hiccup.


[ 4577.585902] BUG: soft lockup - CPU#34 stuck for 23s! [bash:7313]
[ 4577.585924] Modules linked in: nfsv3 nfs_acl nfs fscache lockd sunrpc autofs4 ipmi_devintf ipmi_si ipmi_msghandler edd af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq mperf fuse loop dm_mod sg ipv6 coretemp kvm_intel hpwdt iTCO_wdt iTCO_vendor_support sr_mod cdrom kvm netxen_nic shpchp container i7core_edac hpilo joydev hid_generic rtc_cmos lpc_ich bnx2 pci_hotplug crc32c_intel serio_raw edac_core microcode mfd_core pcspkr acpi_power_meter button ext3 jbd mbcache usbhid hid radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore thermal usb_common processor thermal_sys hwmon scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh ata_generic ata_piix libata hpsa cciss scsi_mod
[ 4577.585926] CPU 34 
[ 4577.585926] Pid: 7313, comm: bash Not tainted 3.6.11-rt24-rt_trace #6 Hewlett-Packard ProLiant DL980 G7
[ 4577.585930] RIP: 0010:[<ffffffff81481fa2>]  [<ffffffff81481fa2>] _raw_spin_lock+0x32/0x40
[ 4577.585931] RSP: 0018:ffff88026ce819b8  EFLAGS: 00000a87
[ 4577.585932] RAX: 000000000000c160 RBX: ffff88026ce81a38 RCX: ffff8802717ec140
[ 4577.585933] RDX: 00000000000066ee RSI: ffff88026ce81fd8 RDI: ffff880200444f40
[ 4577.585934] RBP: ffff88026ce819b8 R08: 0000000000000003 R09: 0000000000000007
[ 4577.585935] R10: ffff88026bf58000 R11: 0000000000000000 R12: ffff88027702c0c0
[ 4577.585936] R13: 0000000000000000 R14: ffffffff811a26ac R15: ffff88026ce81978
[ 4577.585937] FS:  00007f00c58d1700(0000) GS:ffff88027ea40000(0000) knlGS:0000000000000000
[ 4577.585938] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4577.585939] CR2: 00000000006be8a0 CR3: 0000000262413000 CR4: 00000000000007e0
[ 4577.585941] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4577.585942] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4577.585943] Process bash (pid: 7313, threadinfo ffff88026ce80000, task ffff8802717ec140)
[ 4577.585944] Stack:
[ 4577.585953]  ffff88026ce81a98 ffffffff81481366 0000000000001000 0000000000113800
[ 4577.585957]  ffff88027702c0c0 ffff8802690cd520 ffff88026ce81a18 ffffffff811a3d06
[ 4577.585961]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[ 4577.585961] Call Trace:
[ 4577.585964]  [<ffffffff81481366>] rt_spin_lock_slowlock+0x36/0x320
[ 4577.585967]  [<ffffffff811a3d06>] ? __getblk+0x26/0x50
[ 4577.585970]  [<ffffffff81481c97>] rt_spin_lock+0x27/0x30
[ 4577.585973]  [<ffffffff8112583d>] activate_page+0x8d/0x130
[ 4577.585976]  [<ffffffff8112592b>] mark_page_accessed+0x4b/0x60
[ 4577.585978]  [<ffffffff811a2a88>] __find_get_block+0xc8/0x210
[ 4577.585981]  [<ffffffff811a3d06>] __getblk+0x26/0x50
[ 4577.585988]  [<ffffffffa034253c>] __ext3_get_inode_loc+0x10c/0x390 [ext3]
[ 4577.585995]  [<ffffffffa0343610>] ext3_iget+0x90/0x4d0 [ext3]
[ 4577.586002]  [<ffffffffa034b338>] ext3_lookup+0xa8/0x120 [ext3]
[ 4577.586005]  [<ffffffff8117a365>] lookup_real+0x25/0x60
[ 4577.586007]  [<ffffffff8117aa09>] __lookup_hash+0x39/0x50
[ 4577.586010]  [<ffffffff8117ee85>] path_lookupat+0x7b5/0x870
[ 4577.586013]  [<ffffffff8108057b>] ? migrate_enable+0xfb/0x230
[ 4577.586016]  [<ffffffff8117ef75>] do_path_lookup+0x35/0xd0
[ 4577.586018]  [<ffffffff8117fc13>] user_path_at_empty+0x83/0xb0
[ 4577.586021]  [<ffffffff81077aaf>] ? lg_local_unlock+0x1f/0x30
[ 4577.586024]  [<ffffffff8118f881>] ? mntput_no_expire+0x51/0x1a0
[ 4577.586026]  [<ffffffff811742b5>] ? cp_new_stat+0x105/0x120
[ 4577.586029]  [<ffffffff8117fc51>] user_path_at+0x11/0x20
[ 4577.586031]  [<ffffffff8117452b>] vfs_fstatat+0x4b/0x90
[ 4577.586034]  [<ffffffff8117469b>] vfs_stat+0x1b/0x20
[ 4577.586036]  [<ffffffff811746c4>] sys_newstat+0x24/0x50
[ 4577.586040]  [<ffffffff81489869>] system_call_fastpath+0x16/0x1b
[ 4577.586053] Code: 66 90 65 48 8b 04 25 48 99 00 00 83 80 44 e0 ff ff 01 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 d0 74 0e 0f 1f 40 00 f3 90 <0f> b7 07 66 39 c2 75 f6 c9 c3 0f 1f 40 00 55 48 89 e5 66 66 66 
[ 4578.002993] BUG: soft lockup - CPU#43 stuck for 22s! [syslog-ng:4245]
[ 4578.003041] Modules linked in: nfsv3 nfs_acl nfs fscache lockd sunrpc autofs4 ipmi_devintf ipmi_si ipmi_msghandler edd af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave pcc_cpufreq mperf fuse loop dm_mod sg ipv6 coretemp kvm_intel hpwdt iTCO_wdt iTCO_vendor_support sr_mod cdrom kvm netxen_nic shpchp container i7core_edac hpilo joydev hid_generic rtc_cmos lpc_ich bnx2 pci_hotplug crc32c_intel serio_raw edac_core microcode mfd_core pcspkr acpi_power_meter button ext3 jbd mbcache usbhid hid radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore thermal usb_common processor thermal_sys hwmon scsi_dh_rdac scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh ata_generic ata_piix libata hpsa cciss scsi_mod
[ 4578.003045] CPU 43 
[ 4578.003046] Pid: 4245, comm: syslog-ng Not tainted 3.6.11-rt24-rt_trace #6 Hewlett-Packard ProLiant DL980 G7
[ 4578.003059] RIP: 0010:[<ffffffff81481fa2>]  [<ffffffff81481fa2>] _raw_spin_lock+0x32/0x40
[ 4578.003060] RSP: 0018:ffff880273ac9ae8  EFLAGS: 00000297
[ 4578.003061] RAX: 0000000000000001 RBX: ffff880273ac8000 RCX: ffff880271e66580
[ 4578.003062] RDX: 0000000000000000 RSI: ffff880273ac9fd8 RDI: ffff880200564f40
[ 4578.003063] RBP: ffff880273ac9ae8 R08: ffff880273ac9b58 R09: 0000000000001000
[ 4578.003064] R10: 00000000fffff1d9 R11: 0000000000000080 R12: ffff880271e66580
[ 4578.003065] R13: 0000000000000002 R14: ffffffff8106e347 R15: ffff880273ac9a58
[ 4578.003067] FS:  00007f892a42c700(0000) GS:ffff88027eb60000(0000) knlGS:0000000000000000
[ 4578.003068] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4578.003069] CR2: ffffffffff600400 CR3: 00000002673f4000 CR4: 00000000000007e0
[ 4578.003070] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4578.003071] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4578.003073] Process syslog-ng (pid: 4245, threadinfo ffff880273ac8000, task ffff880271e66580)
[ 4578.003073] Stack:
[ 4578.003078]  ffff880273ac9bc8 ffffffff81481366 ffff8802709f8c78 ffff8802709f8ed0
[ 4578.003083]  fffffdc06b578800 0000000000001000 ffffffffa03446b0 ffffea000764af88
[ 4578.003087]  00000240000001d9 ffff8802702c7520 ffff8802022c0c10 ffff88021cc47240
[ 4578.003088] Call Trace:
[ 4578.003094]  [<ffffffff81481366>] rt_spin_lock_slowlock+0x36/0x320
[ 4578.003109]  [<ffffffffa03446b0>] ? ext3_get_blocks_handle+0x760/0x760 [ext3]
[ 4578.003112]  [<ffffffff81481c97>] rt_spin_lock+0x27/0x30
[ 4578.003119]  [<ffffffff8112583d>] activate_page+0x8d/0x130
[ 4578.003122]  [<ffffffff8112592b>] mark_page_accessed+0x4b/0x60
[ 4578.003132]  [<ffffffff81115756>] generic_perform_write+0xf6/0x1e0
[ 4578.003138]  [<ffffffff81137acb>] ? bdi_wakeup_thread_delayed+0x3b/0x50
[ 4578.003142]  [<ffffffff811158a5>] generic_file_buffered_write+0x65/0xa0
[ 4578.003147]  [<ffffffff81118356>] __generic_file_aio_write+0x1b6/0x390
[ 4578.003157]  [<ffffffff81165973>] ? kmem_cache_free+0x1b3/0x310
[ 4578.003159]  [<ffffffff811185a7>] generic_file_aio_write+0x77/0xe0
[ 4578.003165]  [<ffffffff8116edc9>] do_sync_write+0xa9/0xf0
[ 4578.003168]  [<ffffffff8116f3cb>] vfs_write+0xcb/0x130
[ 4578.003170]  [<ffffffff8116f525>] sys_write+0x55/0x90
[ 4578.003175]  [<ffffffff81489869>] system_call_fastpath+0x16/0x1b
[ 4578.003190] Code: 66 90 65 48 8b 04 25 48 99 00 00 83 80 44 e0 ff ff 01 b8 00 00 01 00 f0 0f c1 07 89 c2 c1 ea 10 66 39 d0 74 0e 0f 1f 40 00 f3 90 <0f> b7 07 66 39 c2 75 f6 c9 c3 0f 1f 40 00 55 48 89 e5 66 66 66 

repeat....

