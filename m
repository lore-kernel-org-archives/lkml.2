Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2BZVYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 16:24:08 -0500
Received: from nef2.ens.fr ([129.199.96.40]:4987 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab2BZVXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 16:23:55 -0500
X-Greylist: delayed 2650 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Feb 2012 16:23:55 EST
From: =?ISO-8859-1?Q?=C9ric?= Brunet <Eric.Brunet@lps.ens.fr>
To: linux-kernel@vger.kernel.org
Subject: Warning: linux-kernel@vger.kernel.org
Date: Sun, 26 Feb 2012 21:39:42 +0100
Message-ID: <7192272.NNT62nsNzk@romarin>
Organization: UPMC LPS-ENS
User-Agent: KMail/4.8.0 (Linux/3.2.7-1.fc16.x86_64; KDE/4.8.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Sun, 26 Feb 2012 21:39:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just got a warning on my laptop while resuming from sleep, followed by a 
general protection fault.

Note that I experience problems with resume on this computer since circa 2.6.38;
from time to time, the computer would free at resume or up to twenty seconds later
with very rarely a warning and/or a bug in the log which occured around
sysfs_remove_battery, as below.

Today, I saved dmesg and asked for a shutdown, the computer froze during the shutdown.

Thanks for any insight,

	Éric Brunet

[ 8797.718312] PM: resume of devices complete after 1152.682 msecs
[ 8797.719226] PM: Finishing wakeup.
[ 8797.722389] Restarting tasks ... 
[ 8797.732182] usb 5-1: usbfs: process 981 (ifdhandler) did not claim interface 1 before use
[ 8797.750904] done.
[ 8797.822108] ------------[ cut here ]------------
[ 8797.822133] WARNING: at fs/sysfs/file.c:498 sysfs_attr_ns+0x93/0xa0()
[ 8797.822139] Hardware name: Latitude E4200                  
[ 8797.822148] sysfs: kobject BAT0 without dirent
[ 8797.822164] Modules linked in: ppdev parport_pc lp parport ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables arc4 uvcvideo videodev dell_wmi media sparse_keymap v4l2_compat_ioctl32 joydev snd_hda_codec_hdmi snd_hda_codec_idt dell_laptop microcode dcdbas iTCO_wdt iTCO_vendor_support i2c_i801 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device iwlwifi snd_pcm mac80211 cfg80211 snd_timer snd rfkill soundcore snd_page_alloc e1000e binfmt_misc firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci mmc_core wmi i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 8797.822332] Pid: 11581, comm: kworker/0:1 Not tainted 3.2.7-1.fc16.x86_64 #1
[ 8797.822338] Call Trace:
[ 8797.822360]  [<ffffffff8106dd4f>] warn_slowpath_common+0x7f/0xc0
[ 8797.822373]  [<ffffffff8106de46>] warn_slowpath_fmt+0x46/0x50
[ 8797.822390]  [<ffffffff815dfebf>] ? schedule+0x3f/0x60
[ 8797.822401]  [<ffffffff811eaaf3>] sysfs_attr_ns+0x93/0xa0
[ 8797.822408]  [<ffffffff811eab24>] sysfs_remove_file+0x24/0x50
[ 8797.822427]  [<ffffffff8138f707>] device_remove_file+0x17/0x20
[ 8797.822442]  [<ffffffff8133bd76>] sysfs_remove_battery+0x33/0x54
[ 8797.822454]  [<ffffffff8133c5bb>] acpi_battery_notify+0x46/0xaa
[ 8797.822469]  [<ffffffff813105b4>] ? acpi_os_wait_events_complete+0x23/0x23
[ 8797.822482]  [<ffffffff813137cf>] acpi_device_notify+0x19/0x1b
[ 8797.822497]  [<ffffffff8131f6d3>] acpi_ev_notify_dispatch+0x67/0x7e
[ 8797.822509]  [<ffffffff813105db>] acpi_os_execute_deferred+0x27/0x34
[ 8797.822522]  [<ffffffff81089ddd>] process_one_work+0x11d/0x470
[ 8797.822534]  [<ffffffff8108b1df>] worker_thread+0x15f/0x350
[ 8797.822542]  [<ffffffff8108b080>] ? manage_workers+0x230/0x230
[ 8797.822556]  [<ffffffff8108fb9c>] kthread+0x8c/0xa0
[ 8797.822569]  [<ffffffff815ebef4>] kernel_thread_helper+0x4/0x10
[ 8797.822582]  [<ffffffff8108fb10>] ? kthread_worker_fn+0x190/0x190
[ 8797.822594]  [<ffffffff815ebef0>] ? gs_change+0x13/0x13
[ 8797.822603] ---[ end trace 0e3fca3e2b6ca63e ]---
[ 8797.826165] video LNXVIDEO:00: Restoring backlight state
[ 8797.878619] dell_wmi: Received unknown WMI event (0x11)
[ 8798.150427] general protection fault: 0000 [#1] SMP 
[ 8798.151010] CPU 0 
[ 8798.151010] Modules linked in: ppdev parport_pc lp parport ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables arc4 uvcvideo videodev dell_wmi media sparse_keymap v4l2_compat_ioctl32 joydev snd_hda_codec_hdmi snd_hda_codec_idt dell_laptop microcode dcdbas iTCO_wdt iTCO_vendor_support i2c_i801 snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device iwlwifi snd_pcm mac80211 cfg80211 snd_timer snd rfkill soundcore snd_page_alloc e1000e binfmt_misc firewire_ohci firewire_core crc_itu_t sdhci_pci sdhci mmc_core wmi i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[ 8798.151010] 
[ 8798.151010] Pid: 11839, comm: cat Tainted: G        W    3.2.7-1.fc16.x86_64 #1 Dell Inc. Latitude E4200                  /02GMRH
[ 8798.151010] RIP: 0010:[<ffffffff81165afa>]  [<ffffffff81165afa>] kmem_cache_alloc+0x5a/0x140
[ 8798.151010] RSP: 0018:ffff8800a5883a98  EFLAGS: 00010206
[ 8798.151010] RAX: 0000000000000000 RBX: ffffffff81a8b860 RCX: 00000000000029f3
[ 8798.151010] RDX: 00000000000029f2 RSI: 0000000000016e80 RDI: ffff8800b7635000
[ 8798.151010] RBP: ffff8800a5883ae8 R08: ffff8800bce16e80 R09: 0000000000000140
[ 8798.151010] R10: 00000000000c3500 R11: 0000000000000001 R12: ffff8800b7635000
[ 8798.151010] R13: 40ffff8800b368e7 R14: ffffffff811eb711 R15: 00000000000080d0
[ 8798.151010] FS:  00007f0291eec700(0000) GS:ffff8800bce00000(0000) knlGS:0000000000000000
[ 8798.151010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8798.151010] CR2: 00000000018e8000 CR3: 000000007219c000 CR4: 00000000000406f0
[ 8798.151010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8798.151010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8798.151010] Process cat (pid: 11839, threadinfo ffff8800a5882000, task ffff88007a702e40)
[ 8798.151010] Stack:
[ 8798.151010]  ffff8800a5883ac8 ffffffff811eb0ce ffff8800b368e751 ffff8800a5883b60
[ 8798.151010]  0000000000000000 ffffffff81a8b860 0000000000000002 ffffffff81800270
[ 8798.151010]  0000000000000000 00000000000081a4 ffff8800a5883b38 ffffffff811eb711
[ 8798.151010] Call Trace:
[ 8798.151010]  [<ffffffff811eb0ce>] ? sysfs_link_sibling+0xde/0x110
[ 8798.151010]  [<ffffffff811eb711>] sysfs_new_dirent+0x51/0x120
[ 8798.151010]  [<ffffffff811ebd2c>] ? sysfs_add_one+0x2c/0xf0
[ 8798.151010]  [<ffffffff811eacca>] sysfs_add_file_mode+0x6a/0xe0
[ 8798.151010]  [<ffffffff811ed8fe>] internal_create_group+0xce/0x1e0
[ 8798.151010]  [<ffffffff811eda43>] sysfs_create_group+0x13/0x20
[ 8798.312800]  [<ffffffff8148d283>] cpufreq_governor_dbs+0x3a3/0x440
[ 8798.312800]  [<ffffffff8148a297>] __cpufreq_governor+0x77/0x190
[ 8798.312800]  [<ffffffff8148a51b>] __cpufreq_set_policy+0x16b/0x280
[ 8798.312800]  [<ffffffff8148bbda>] store_scaling_governor+0xea/0x1f0
[ 8798.312800]  [<ffffffff8148b980>] ? cpufreq_update_policy+0x150/0x150
[ 8798.312800]  [<ffffffff8148adf6>] store+0x66/0xb0
[ 8798.312800]  [<ffffffff811ea3df>] sysfs_write_file+0xef/0x170
[ 8798.312800]  [<ffffffff81179053>] vfs_write+0xb3/0x180
[ 8798.312800]  [<ffffffff8117937a>] sys_write+0x4a/0x90
[ 8798.312800]  [<ffffffff815e9d82>] system_call_fastpath+0x16/0x1b
[ 8798.312800] Code: 00 4d 8b 04 24 65 4c 03 04 25 30 da 00 00 49 8b 50 08 4d 8b 28 4d 85 ed 0f 84 d8 00 00 00 49 63 44 24 20 49 8b 34 24 48 8d 4a 01 <49> 8b 5c 05 00 4c 89 e8 65 48 0f c7 0e 0f 94 c0 84 c0 74 c2 4d 
[ 8798.312800] RIP  [<ffffffff81165afa>] kmem_cache_alloc+0x5a/0x140
[ 8798.312800]  RSP <ffff8800a5883a98>
[ 8798.385325] usb 3-1: new full-speed USB device number 5 using uhci_hcd
[ 8798.416251] ---[ end trace 0e3fca3e2b6ca63f ]---
[ 8798.455115] hub 3-0:1.0: unable to enumerate USB device on port 1

