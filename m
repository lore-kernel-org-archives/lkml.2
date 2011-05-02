Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab1EBJ7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:59:18 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:42937 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab1EBJ7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:59:16 -0400
Date: Mon, 2 May 2011 12:59:13 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Warning at block/genhd.c:1556 disk_clear_events
Message-ID: <alpine.SOC.1.00.1105021255400.6200@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just tried 2.6.39-rc5-00130-g3fd9952 on amd64 with sata disks attached 
to sata_nv. This warning happened 1 hour after boot with normal desktop 
usage. What udisks-daemon did, I do not know - I do not remember 
inserting any USB disksk to the system.

------------[ cut here ]------------
WARNING: at block/genhd.c:1556 disk_clear_events+0x111/0x120()
Hardware name: System Product Name
Modules linked in: ip6table_filter ip6_tables iptable_filter ip_tables 
ebtable_nat ebtables x_tables powernow_k8 mperf cpufreq_powersave 
cpufreq_stats cpufreq_conservative cpufreq_userspace cpufreq_ondemand 
freq_table parport_pc ppdev lp parport bnep rfcomm bluetooth rfkill 
crc16 snd_hrtimer binfmt_misc uinput fuse nfsd nfs lockd auth_rpcgss 
nfs_acl sunrpc bridge ipv6 stp llc w83627ehf hwmon_vid kvm_amd kvm 
firewire_sbp2 loop snd_hda_codec_realtek usb_storage usbhid hid 
usb_libusual uas snd_hda_intel option snd_hda_codec usb_wwan nouveau 
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm fbcon tileblit font ttm 
bitblit snd_seq_dummy usbserial fbcon_rotate fbcon_cw fbcon_ud fbcon_ccw 
softcursor drm_kms_helper snd_seq_oss snd_seq_midi snd_rawmidi sg 
snd_seq_midi_event sr_mod cdrom ohci_hcd nv_tco drm i2c_nforce2 snd_seq 
snd_timer snd_seq_device snd fb fbdev ata_generic i2c_algo_bit 
cfbcopyarea cfbimgblt pata_acpi k8temp ssb pcmcia ehci_hcd firewire_ohci 
usbcore edac_core cfbfillrect soundcore firewire_core i2c_core hwmon 
pcmcia_core floppy pata_amd rtc_cmos snd_page_alloc crc_itu_t rtc_core 
fan thermal pcspkr evdev processor button rtc_lib
Pid: 6213, comm: udisks-daemon Not tainted 2.6.39-rc5-00130-g3fd9952 #57
Call Trace:
 [<ffffffff81039c7b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8118e571>] ? disk_clear_events+0x111/0x120
 [<ffffffff81106460>] ? check_disk_change+0x30/0x80
 [<ffffffff81238af3>] ? sd_open+0xc3/0x1e0
 [<ffffffff811076f3>] ? __blkdev_get+0x93/0x380
 [<ffffffff81107a3f>] ? blkdev_get+0x5f/0x250
 [<ffffffff81032de7>] ? sub_preempt_count.part.158+0x47/0x80
 [<ffffffff8133ff30>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffff81107c30>] ? blkdev_get+0x250/0x250
 [<ffffffff810d4a11>] ? __dentry_open+0x191/0x340
 [<ffffffff8133ff30>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffff810e4523>] ? do_last.isra.37+0x2a3/0x6c0
 [<ffffffff810e1f0a>] ? path_init+0x30a/0x3d0
 [<ffffffff810e4fa4>] ? path_openat+0xc4/0x3b0
 [<ffffffff8102d770>] ? check_preempt_wakeup+0x100/0x150
 [<ffffffff810e52d5>] ? do_filp_open+0x45/0xb0
 [<ffffffff81032d89>] ? get_parent_ip+0x9/0x20
 [<ffffffff81032de7>] ? sub_preempt_count.part.158+0x47/0x80
 [<ffffffff8133ff30>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffff810f1464>] ? alloc_fd+0xe4/0x130
 [<ffffffff810d5e25>] ? do_sys_open+0xf5/0x1d0
 [<ffffffff81340cfb>] ? system_call_fastpath+0x16/0x1b
---[ end trace eb5b85f9cc10782f ]---

-- 
Meelis Roos (mroos@linux.ee)
