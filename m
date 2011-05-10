Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1EJH1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:27:13 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:48255 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab1EJH1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:27:12 -0400
Date: Tue, 10 May 2011 10:27:09 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Warning at block/genhd.c:1556 disk_clear_events
In-Reply-To: <alpine.SOC.1.00.1105021255400.6200@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1105101024550.10566@math.ut.ee>
References: <alpine.SOC.1.00.1105021255400.6200@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just tried 2.6.39-rc5-00130-g3fd9952 on amd64 with sata disks attached 
> to sata_nv. This warning happened 1 hour after boot with normal desktop 
> usage. What udisks-daemon did, I do not know - I do not remember 
> inserting any USB disksk to the system.

Got another one from 2.6.39-rc6-00068-g8b06161 around the 
time (or up to 10 min later) when I left the computer for the evening 
and locked the screen. No USB insertions or removals at that time - last 
USB disk event was disk removal more than 5 hours before, so itäs 
probably SATA disk or ATA CD.

Added trace to https://bugzilla.kernel.org/show_bug.cgi?id=34662

 ------------[ cut here ]------------
WARNING: at block/genhd.c:1556 disk_clear_events+0x111/0x120()
Hardware name: System Product Name
Modules linked in: nls_iso8859_1 nls_cp437 vfat fat ip6table_filter 
ip6_tables
iptable_filter ip_tables powernow_k8 mperf cpufreq_powersave ebtable_nat
cpufreq_stats ebtables x_tables cpufreq_conservative cpufreq_userspace
cpufreq_ondemand freq_table parport_pc ppdev lp parport bnep rfcomm 
bluetooth
rfkill crc16 snd_hrtimer uinput binfmt_misc fuse nfsd nfs lockd 
auth_rpcgss
nfs_acl sunrpc bridge ipv6 stp llc w83627ehf hwmon_vid kvm_amd kvm
firewire_sbp2 loop snd_hda_codec_realtek usb_storage usb_libusual uas 
option
usbhid hid usb_wwan snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi nouveau 
fbcon ttm
tileblit snd_rawmidi snd_seq_midi_event sg snd_seq font bitblit 
fbcon_rotate
fbcon_cw fbcon_ud fbcon_ccw softcursor drm_kms_helper usbserial sr_mod
snd_timer snd_seq_device drm fb ohci_hcd fbdev ehci_hcd ssb nv_tco snd
i2c_algo_bit cdrom k8temp ata_generic pata_acpi firewire_ohci 
i2c_nforce2
firewire_core soundcore hwmon usbcore i2c_core pcmcia pata_amd crc_itu_t
snd_page_alloc cfbcopyarea cfbimgblt cfbfillrect edac_core pcmcia_core 
floppy
evdev rtc_cmos rtc_core rtc_lib pcspkr processor fan thermal button
Pid: 8052, comm: udisks-daemon Not tainted 2.6.39-rc6-00068-g8b06161 #62
Call Trace:
 [<ffffffff81039d3b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff8118e5b1>] ? disk_clear_events+0x111/0x120
 [<ffffffff81106540>] ? check_disk_change+0x30/0x80
 [<ffffffff81238b73>] ? sd_open+0xc3/0x1e0
 [<ffffffff811077d3>] ? __blkdev_get+0x93/0x380
 [<ffffffff81107b1f>] ? blkdev_get+0x5f/0x250
 [<ffffffff81032e97>] ? sub_preempt_count.part.158+0x47/0x80
 [<ffffffff81340030>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffff81107d10>] ? blkdev_get+0x250/0x250
 [<ffffffff810d4af1>] ? __dentry_open+0x191/0x340
 [<ffffffff81340030>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffff810e4603>] ? do_last.isra.37+0x2a3/0x6c0
 [<ffffffff810e1fea>] ? path_init+0x30a/0x3d0
 [<ffffffff810e5084>] ? path_openat+0xc4/0x3b0
 [<ffffffff813407ce>] ? common_interrupt+0xe/0x13
 [<ffffffff810e53b5>] ? do_filp_open+0x45/0xb0
 [<ffffffff81032e39>] ? get_parent_ip+0x9/0x20
 [<ffffffff81032e97>] ? sub_preempt_count.part.158+0x47/0x80
 [<ffffffff81340030>] ? _raw_spin_unlock+0x10/0x30
 [<ffffffff810f1544>] ? alloc_fd+0xe4/0x130
 [<ffffffff810d5f05>] ? do_sys_open+0xf5/0x1d0
 [<ffffffff81340dfb>] ? system_call_fastpath+0x16/0x1b
---[ end trace 709acec9ff7b6b7a ]---

-- 
Meelis Roos (mroos@linux.ee)
