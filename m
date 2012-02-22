Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2BVUdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 15:33:44 -0500
Received: from sun.mmic.net ([199.166.219.7]:51611 "EHLO sun.mmic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab2BVUdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 15:33:43 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Feb 2012 15:33:43 EST
From: gallard@mmic.net
Date: Wed, 22 Feb 2012 15:28:38 -0500
X-Mailer: Axigen WebMail
To: linux-kernel@vger.kernel.org
Message-ID: <1329942518678226500@mmic.net>
Subject: kernel trace dump when plugging IO Gear GUWAVKIT2
Importance: Normal
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Debian Wheezy distrib with kernel 3.2, I got the following in /var/log/messages
---------------
Feb 22 15:10:42 V17A kernel: [72063.448069] usb 1-4: new high-speed USB device number 6 using ehci_hcd
Feb 22 15:10:42 V17A kernel: [72063.581734] usb 1-4: New USB device found, idVendor=13cf, idProduct=1200
Feb 22 15:10:42 V17A kernel: [72063.581737] usb 1-4: New USB device strings: Mfr=2, Product=1, SerialNumber=3
Feb 22 15:10:42 V17A kernel: [72063.581740] usb 1-4: Product: Wireless USB Dongle
Feb 22 15:10:42 V17A kernel: [72063.581742] usb 1-4: Manufacturer:  
Feb 22 15:10:42 V17A kernel: [72063.581744] usb 1-4: SerialNumber: 123456789
Feb 22 15:10:44 V17A mtp-probe: checking bus 1, device 6: "/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4"
Feb 22 15:10:44 V17A mtp-probe: bus: 1, device: 6 was not an MTP device
Feb 22 15:10:44 V17A kernel: [72064.781638] ------------[ cut here ]------------
Feb 22 15:10:44 V17A kernel: [72064.781646] WARNING: at /build/buildd-linux-2.6_3.2.4-1-i386-61WrTr/linux-2.6-3.2.4/debian/build/source_i386_none/kernel/timer.c:1011 del_timer_sync+0x22/0x33()
Feb 22 15:10:44 V17A kernel: [72064.781650] Hardware name: Vostro 1720
Feb 22 15:10:44 V17A kernel: [72064.781652] Modules linked in: hwa_rc(+) uwb rt2800usb rt2800lib crc_ccitt rt2x00usb rt2x00lib ath9k_htc ath9k_common ath9k_hw ath mperf cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace parport_pc ppdev lp parport rfcomm bnep bluetooth crc16 binfmt_misc uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc loop firewire_sbp2 joydev snd_hda_codec_idt arc4 b43 mac80211 snd_hda_intel snd_hda_codec cfg80211 dell_laptop iTCO_wdt snd_hwdep snd_pcm snd_seq snd_timer psmouse snd_seq_device rfkill bcma pcspkr dcdbas evdev snd iTCO_vendor_support serio_raw i915 i2c_i801 ac rng_core battery power_supply drm_kms_helper drm i2c_algo_bit i2c_core soundcore snd_page_alloc video processor button thermal_sys ext3 jbd mbcache sr_mod sd_mod crc_t10dif cdrom uhci_hcd ahci libahci libata firewire_ohci ssb sdhci_pci sdhci mmc_core firewire_core crc_itu_t pcmcia pcmcia_core r8169 mii ehci_hcd scsi_mod usbcore usb_common [last unloaded: scsi_wait_scan]
Feb 22 15:10:44 V17A kernel: [72064.781725] Pid: 0, comm: swapper/0 Not tainted 3.2.0-1-686-pae #1
Feb 22 15:10:44 V17A kernel: [72064.781728] Call Trace:
Feb 22 15:10:44 V17A kernel: [72064.781733]  [<c1038328>] ? warn_slowpath_common+0x68/0x79
Feb 22 15:10:44 V17A kernel: [72064.781736]  [<c1042074>] ? del_timer_sync+0x22/0x33
Feb 22 15:10:44 V17A kernel: [72064.781739]  [<c1038346>] ? warn_slowpath_null+0xd/0x10
Feb 22 15:10:44 V17A kernel: [72064.781743]  [<c1042074>] ? del_timer_sync+0x22/0x33
Feb 22 15:10:44 V17A kernel: [72064.781750]  [<fb15f9cc>] ? uwb_rc_neh_grok+0x262/0x2cb [uwb]
Feb 22 15:10:44 V17A kernel: [72064.781755]  [<f93a472f>] ? hwarc_neep_cb+0x42/0xd4 [hwa_rc]
Feb 22 15:10:44 V17A kernel: [72064.781767]  [<f825c6eb>] ? usb_hcd_giveback_urb+0x63/0x93 [usbcore]
Feb 22 15:10:44 V17A kernel: [72064.781773]  [<f8274a42>] ? ehci_urb_done+0x5a/0x67 [ehci_hcd]
Feb 22 15:10:44 V17A kernel: [72064.781780]  [<f8274d4d>] ? qh_completions+0x2fe/0x37f [ehci_hcd]
Feb 22 15:10:44 V17A kernel: [72064.781786]  [<f82763b0>] ? ehci_work+0x1f8/0x6c4 [ehci_hcd]
Feb 22 15:10:44 V17A kernel: [72064.781796]  [<f85c034e>] ? __ata_qc_complete+0xc7/0xcb [libata]
Feb 22 15:10:44 V17A kernel: [72064.781806]  [<f85c050e>] ? ata_qc_complete_multiple+0x85/0x8a [libata]
Feb 22 15:10:44 V17A kernel: [72064.781812]  [<f8276d58>] ? ehci_irq+0x1ab/0x1cb [ehci_hcd]
Feb 22 15:10:44 V17A kernel: [72064.781816]  [<c1058b75>] ? tick_handle_oneshot_broadcast+0xc7/0xde
Feb 22 15:10:44 V17A kernel: [72064.781826]  [<f825c321>] ? usb_hcd_irq+0x2c/0x5b [usbcore]
Feb 22 15:10:44 V17A kernel: [72064.781830]  [<c1077340>] ? handle_irq_event_percpu+0x47/0x158
Feb 22 15:10:44 V17A kernel: [72064.781834]  [<c1079015>] ? handle_level_irq+0x62/0x62
Feb 22 15:10:44 V17A kernel: [72064.781837]  [<c1077472>] ? handle_irq_event+0x21/0x37
Feb 22 15:10:44 V17A kernel: [72064.781840]  [<c1079015>] ? handle_level_irq+0x62/0x62
Feb 22 15:10:44 V17A kernel: [72064.781844]  [<c1079075>] ? handle_fasteoi_irq+0x60/0x78
Feb 22 15:10:44 V17A kernel: [72064.781846]  <IRQ>  [<c100cd5f>] ? do_IRQ+0x2e/0x76
Feb 22 15:10:44 V17A kernel: [72064.781854]  [<c12be230>] ? common_interrupt+0x30/0x38
Feb 22 15:10:44 V17A kernel: [72064.781861]  [<f85a51d0>] ? arch_local_irq_enable+0x2/0x7 [processor]
Feb 22 15:10:44 V17A kernel: [72064.781867]  [<f85a5d7a>] ? acpi_idle_enter_simple+0xee/0x133 [processor]
Feb 22 15:10:44 V17A kernel: [72064.781874]  [<c120443e>] ? cpuidle_idle_call+0xcc/0x142
Feb 22 15:10:44 V17A kernel: [72064.781878]  [<c100b22a>] ? cpu_idle+0x8b/0xaf
Feb 22 15:10:44 V17A kernel: [72064.781883]  [<c1412708>] ? start_kernel+0x32a/0x32f
Feb 22 15:10:44 V17A kernel: [72064.781885] ---[ end trace a2e3f5e5daba782f ]---
Feb 22 15:10:44 V17A kernel: [72064.782383] ------------[ cut here ]------------
Feb 22 15:10:44 V17A kernel: [72064.782388] WARNING: at /build/buildd-linux-2.6_3.2.4-1-i386-61WrTr/linux-2.6-3.2.4/debian/build/source_i386_none/kernel/timer.c:1011 del_timer_sync+0x22/0x33()
Feb 22 15:10:44 V17A kernel: [72064.782391] Hardware name: Vostro 1720
Feb 22 15:10:44 V17A kernel: [72064.782392] Modules linked in: hwa_rc(+) uwb rt2800usb rt2800lib crc_ccitt rt2x00usb rt2x00lib ath9k_htc ath9k_common ath9k_hw ath mperf cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace parport_pc ppdev lp parport rfcomm bnep bluetooth crc16 binfmt_misc uinput fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc loop firewire_sbp2 joydev snd_hda_codec_idt arc4 b43 mac80211 snd_hda_intel snd_hda_codec cfg80211 dell_laptop iTCO_wdt snd_hwdep snd_pcm snd_seq snd_timer psmouse snd_seq_device rfkill bcma pcspkr dcdbas evdev snd iTCO_vendor_support serio_raw i915 i2c_i801 ac rng_core battery power_supply drm_kms_helper drm i2c_algo_bit i2c_core soundcore snd_page_alloc video processor button thermal_sys ext3 jbd mbcache sr_mod sd_mod crc_t10dif cdrom uhci_hcd ahci libahci libata firewire_ohci ssb sdhci_pci sdhci mmc_core firewire_core crc_itu_t pcmcia pcmcia_core r8169 mii ehci_hcd scsi_mod usbcore usb_common [last unloaded: scsi_wait_scan]
Feb 22 15:10:44 V17A kernel: [72064.782450] Pid: 0, comm: swapper/0 Tainted: G        W    3.2.0-1-686-pae #1
--------------------------
I got that sequence 5 times.
I'm not knowledgeable enough to decode that trace dump but I suppose it is a driver bug.

Good luck
Gilles Allard
