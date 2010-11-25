Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0KYBeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:34:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34465 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755238Ab0KYBeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:34:18 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1+wPnkW13mw9jDBIq5MhWncsSrcUBp9nD2pBrepqo
	U+l1XoyzYF8KZp
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: Patch "block: fix accounting bug on cross partition merges" has been added to the 2.6.36-stable tree
Date: Thu, 25 Nov 2010 02:34:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-1.slh.1-aptosid-686; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        stable@kernel.org
References: <12904636664174@site>
In-Reply-To: <12904636664174@site>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201011250234.10424.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thursday 25 November 2010, gregkh@suse.de wrote: 
> This is a note to let you know that I've just added the patch titled
> 
>     block: fix accounting bug on cross partition merges
> 
> to the 2.6.36-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      block-fix-accounting-bug-on-cross-partition-merges.patch
> and it can be found in the queue-2.6.36 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@kernel.org> know about it.
> 
> 
> From 7681bfeeccff5efa9eb29bf09249a3c400b15327 Mon Sep 17 00:00:00 2001
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Date: Tue, 19 Oct 2010 09:05:00 +0200
> Subject: block: fix accounting bug on cross partition merges
[...]

This patch, as part of the current -stable queue-2.6.36, throws the 
attached NULL pointer dereference upon unplugging usb_storage devices. 
My test case is plugging in an USB flash drive, letting it settle a 
few seconds and - without having it mounted or touched in any other 
way - removing it again (X doesn't need to be running). I can reproduce
this reliably with several different flash drives and on different 
ia32 and x86_64 systems running current Debian/ unstable userland:

x86_64 (AMD CPU):
[  125.041034] usb 1-4: new high speed USB device using ehci_hcd and address 5
[  125.167103] usb 1-4: New USB device found, idVendor=0930, idProduct=6545
[  125.167111] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  125.167118] usb 1-4: Product: USB Flash Memory
[  125.167123] usb 1-4: SerialNumber: 0DC0D77160A25918
[  125.201275] Initializing USB Mass Storage driver...
[  125.201554] scsi6 : usb-storage 1-4:1.0
[  125.201953] usbcore: registered new interface driver usb-storage
[  125.201958] USB Mass Storage support registered.
[  126.232761] scsi 6:0:0:0: Direct-Access              USB Flash Memory 5.00 PQ: 0 ANSI: 0 CCS
[  126.234239] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  126.428102] sd 6:0:0:0: [sdb] 1956864 512-byte logical blocks: (1.00 GB/955 MiB)
[  126.429105] sd 6:0:0:0: [sdb] Write Protect is off
[  126.429111] sd 6:0:0:0: [sdb] Mode Sense: 23 00 00 00
[  126.429117] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  126.434082] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  126.474358]  sdb: sdb1
[  126.477081] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[  126.477203] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[  160.223809] usb 1-4: USB disconnect, address 5
[  160.224168] BUG: unable to handle kernel NULL pointer dereference at 0000000000000340
[  160.224322] IP: [<ffffffff811b203a>] disk_replace_part_tbl+0x2a/0x80
[  160.224445] PGD 7a245067 PUD 7a244067 PMD 0 
[  160.224538] Oops: 0000 [#1] PREEMPT SMP 
[  160.224625] last sysfs file: /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
[  160.224755] CPU 0 
[  160.224792] Modules linked in: usb_storage cpufreq_stats cpufreq_ondemand cpufreq_powersave cpufreq_conservative cpufreq_performance ppdev lp af_packet fuse nls_utf8 ntfs powernow_k8 freq_table mperf arc4 ecb ath9k ir_lirc_codec lirc_dev tda18218 ir_sony_decoder af9013 ir_jvc_decoder mac80211 ir_rc6_decoder snd_intel8x0 snd_ac97_codec ac97_bus ir_rc5_decoder radeon ath9k_common ath9k_hw dvb_usb_af9015 ath dvb_usb rtc_cmos ttm snd_pcm drm_kms_helper ir_nec_decoder cfg80211 drm rtc_core tpm_tis dvb_core snd_seq pcspkr rtc_lib tpm rfkill k8temp snd_timer ir_core parport_pc psmouse tpm_bios evdev serio_raw led_class parport i2c_algo_bit snd_seq_device button processor snd soundcore snd_page_alloc shpchp edac_core pci_hotplug edac_mce_amd i2c_nforce2 i2c_core ext4 mbcache jbd2 crc16 dm_mod btrfs zlib_deflate crc32c libcrc32c sg sr_mod cdrom sd_mod usbhid ata_generic hid pata_acpi ohci_hcd sata_nv pata_amd ssb libata mmc_core ehci_hcd pcmcia usbcore floppy e1000 firewire_ohci fan firewire_core thermal crc_itu_t scsi_mod pcmcia_core forcedeth nls_base [last unloaded: scsi_wait_scan]
[  160.227178] 
[  160.227178] Pid: 682, comm: khubd Not tainted 2.6.36-1.slh.1-aptosid-amd64 #1 MS-7185/MS-7185
[  160.227178] RIP: 0010:[<ffffffff811b203a>]  [<ffffffff811b203a>] disk_replace_part_tbl+0x2a/0x80
[  160.227178] RSP: 0018:ffff88003774dae0  EFLAGS: 00010286
[  160.227178] RAX: 0000000000000000 RBX: ffff88007cb50ec0 RCX: 0000000000000040
[  160.227178] RDX: 0000000000000051 RSI: 0000000000000000 RDI: ffff88007c9f9400
[  160.227178] RBP: 0000000000000000 R08: ffffffff814d4fd8 R09: ffffffff811c1130
[  160.227178] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  160.227178] R13: ffffffffa0ac26e0 R14: ffffffffa0ac2748 R15: 0000000000000000
[  160.227178] FS:  00007fcf9962f700(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
[  160.227178] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  160.227178] CR2: 0000000000000340 CR3: 000000007a23e000 CR4: 00000000000006f0
[  160.227178] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  160.227178] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  160.227178] Process khubd (pid: 682, threadinfo ffff88003774c000, task ffff88007ca942e0)
[  160.227178] Stack:
[  160.227178]  0000000000000000 ffff88007c9f9400 ffffffff8150cc20 ffffffff811b210b
[  160.227178] <0> 0000000000000000 ffffffff8126b52a ffff88007c9f9470 ffffffff811c04e3
[  160.227178] <0> ffff88007c9f94a8 ffffffff811c04a0 0000000000000286 ffffffff811c1713
[  160.227178] Call Trace:
[  160.227178]  [<ffffffff811b210b>] ? disk_release+0x1b/0x30
[  160.227178]  [<ffffffff8126b52a>] ? device_release+0x1a/0x80
[  160.227178]  [<ffffffff811c04e3>] ? kobject_release+0x43/0xb0
[  160.227178]  [<ffffffff811c04a0>] ? kobject_release+0x0/0xb0
[  160.227178]  [<ffffffff811c1713>] ? kref_put+0x33/0x70
[  160.227178]  [<ffffffffa0314570>] ? sg_device_destroy+0x60/0xa0 [sg]
[  160.227178]  [<ffffffffa0314510>] ? sg_device_destroy+0x0/0xa0 [sg]
[  160.227178]  [<ffffffff811c1713>] ? kref_put+0x33/0x70
[  160.227178]  [<ffffffff8126bf4a>] ? device_del+0xba/0x1c0
[  160.227178]  [<ffffffff8126c059>] ? device_unregister+0x9/0x20
[  160.227178]  [<ffffffffa000cf7d>] ? __scsi_remove_device+0xad/0xc0 [scsi_mod]
[  160.227178]  [<ffffffffa0009a84>] ? scsi_forget_host+0x54/0x80 [scsi_mod]
[  160.227178]  [<ffffffffa0001fc1>] ? scsi_remove_host+0x61/0x100 [scsi_mod]
[  160.227178]  [<ffffffffa0abf240>] ? quiesce_and_remove_host+0x60/0xb0 [usb_storage]
[  160.227178]  [<ffffffffa0abf345>] ? usb_stor_disconnect+0x15/0x20 [usb_storage]
[  160.227178]  [<ffffffffa00bf246>] ? usb_unbind_interface+0x66/0x1b0 [usbcore]
[  160.227178]  [<ffffffff8126e8ff>] ? __device_release_driver+0x6f/0xf0
[  160.227178]  [<ffffffff8126ea55>] ? device_release_driver+0x25/0x40
[  160.227178]  [<ffffffff8126dd8e>] ? bus_remove_device+0x9e/0xe0
[  160.227178]  [<ffffffff8126bfb0>] ? device_del+0x120/0x1c0
[  160.227178]  [<ffffffffa00bbfc8>] ? usb_disable_device+0x68/0x120 [usbcore]
[  160.227178]  [<ffffffffa00b68af>] ? usb_disconnect+0x8f/0x130 [usbcore]
[  160.227178]  [<ffffffffa00b7719>] ? hub_thread+0x479/0x11b0 [usbcore]
[  160.227178]  [<ffffffff810416d0>] ? __dequeue_entity+0x40/0x50
[  160.227178]  [<ffffffff8106b740>] ? autoremove_wake_function+0x0/0x30
[  160.227178]  [<ffffffffa00b72a0>] ? hub_thread+0x0/0x11b0 [usbcore]
[  160.227178]  [<ffffffffa00b72a0>] ? hub_thread+0x0/0x11b0 [usbcore]
[  160.227178]  [<ffffffff8106b276>] ? kthread+0x96/0xa0
[  160.227178]  [<ffffffff8100bce4>] ? kernel_thread_helper+0x4/0x10
[  160.227178]  [<ffffffff8106b1e0>] ? kthread+0x0/0xa0
[  160.227178]  [<ffffffff8100bce0>] ? kernel_thread_helper+0x0/0x10
[  160.227178] Code: 00 48 83 ec 18 48 89 5c 24 08 48 89 6c 24 10 48 8b 5f 38 48 8b af d0 02 00 00 48 85 db 48 89 77 38 74 4e 48 c7 43 18 00 00 00 00 <48> 8b bd 40 03 00 00 e8 3a ae 1d 00 48 89 ef e8 b2 6d ff ff 48 
[  160.227178] RIP  [<ffffffff811b203a>] disk_replace_part_tbl+0x2a/0x80
[  160.227178]  RSP <ffff88003774dae0>
[  160.227178] CR2: 0000000000000340
[  160.615286] ---[ end trace a932a28f5152163d ]---



i386 (Intel CPU):
[   49.420017] usb 1-5: new high speed USB device using ehci_hcd and address 4
[   49.539578] usb 1-5: New USB device found, idVendor=0ea0, idProduct=2168
[   49.539585] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   49.539588] usb 1-5: Product: Mass storage    
[   49.539591] usb 1-5: Manufacturer: USB     
[   49.539594] usb 1-5: SerialNumber: 1D7A160C3FB576C6
[   49.590718] Initializing USB Mass Storage driver...
[   49.590946] scsi2 : usb-storage 1-5:1.0
[   49.591562] usbcore: registered new interface driver usb-storage
[   49.591567] USB Mass Storage support registered.
[   50.598755] scsi 2:0:0:0: Direct-Access     SHARKOON USB2.0 Drive     2.00 PQ: 0 ANSI: 2
[   50.601613] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   51.658219] ready
[   51.658848] sd 2:0:0:0: [sdb] 256000 512-byte logical blocks: (131 MB/125 MiB)
[   51.659603] sd 2:0:0:0: [sdb] Write Protect is off
[   51.659611] sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   51.659615] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   51.664973] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   51.666514]  sdb: sdb1
[   51.669373] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   51.669468] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   81.733729] usb 1-5: USB disconnect, address 4
[   81.734045] BUG: unable to handle kernel NULL pointer dereference at 000001c0
[   81.734166] IP: [<c0263ab1>] disk_replace_part_tbl+0x21/0x70
[   81.734256] *pde = 00000000 
[   81.734312] Oops: 0000 [#1] PREEMPT SMP 
[   81.734408] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5:1.0/host2/target2:0:0/2:0:0:0/block/sdb/size
[   81.734520] Modules linked in: usb_storage af_packet rt73usb crc_itu_t arc4 ecb rt2500usb rt2x00usb rt2x00lib snd_intel8x0 snd_ac97_codec ac97_bus p54usb tpm_tis snd_pcm p54common tpm rtc_cmos i915 drm_kms_helper drm i2c_i801 led_class rtc_core tpm_bios intel_agp rng_core avmfritz parport_pc mISDNipac processor i2c_algo_bit rtc_lib mac80211 i2c_core container button evdev parport psmouse video snd_seq pcspkr output serio_raw mISDN_core snd_timer snd_seq_device usbhid hid snd cfg80211 shpchp soundcore rfkill pci_hotplug snd_page_alloc ext4 mbcache jbd2 crc16 dm_mod sg sr_mod sd_mod cdrom ata_generic pata_acpi ata_piix libata uhci_hcd ehci_hcd usbcore scsi_mod e100 floppy mii thermal nls_base [last unloaded: scsi_wait_scan]
[   81.735009] 
[   81.735009] Pid: 553, comm: khubd Not tainted 2.6.36-1.slh.1-aptosid-686 #1 D1521/SCENIC P300
[   81.735009] EIP: 0060:[<c0263ab1>] EFLAGS: 00010286 CPU: 0
[   81.735009] EIP is at disk_replace_part_tbl+0x21/0x70
[   81.735009] EAX: de70c400 EBX: d7713e00 ECX: d7713dc0 EDX: 00000000
[   81.735009] ESI: 00000000 EDI: 00000000 EBP: e0017d20 ESP: d74a7db0
[   81.735009]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   81.735009] Process khubd (pid: 553, ti=d74a6000 task=df071920 task.ti=d74a6000)
[   81.735009] Stack:
[   81.735009]  de70c400 c0509988 c0263b68 00000000 c03060b6 d764b740 00000000 e043731c
[   81.735009] <0> 00000000 de70c458 c026f727 de70c474 c026f6f0 de4554b8 c02706ba d764b700
[   81.735009] <0> 00000292 e0433495 c0223778 dd7f3d50 d764b72c e0433450 c02706ba de4555e8
[   81.735009] Call Trace:
[   81.735009]  [<c0263b68>] ? disk_release+0x18/0x30
[   81.735009]  [<c03060b6>] ? device_release+0x16/0x80
[   81.735009]  [<c026f727>] ? kobject_release+0x37/0x90
[   81.735009]  [<c026f6f0>] ? kobject_release+0x0/0x90
[   81.735009]  [<c02706ba>] ? kref_put+0x2a/0x60
[   81.735009]  [<e0433495>] ? sg_device_destroy+0x45/0x70 [sg]
[   81.735009]  [<c0223778>] ? sysfs_hash_and_remove+0x78/0x80
[   81.735009]  [<e0433450>] ? sg_device_destroy+0x0/0x70 [sg]
[   81.735009]  [<c02706ba>] ? kref_put+0x2a/0x60
[   81.735009]  [<c030690d>] ? device_del+0x9d/0x180
[   81.735009]  [<c03069f8>] ? device_unregister+0x8/0x10
[   81.735009]  [<e000992b>] ? __scsi_remove_device+0x8b/0xa0 [scsi_mod]
[   81.735009]  [<e0006aef>] ? scsi_forget_host+0x5f/0x70 [scsi_mod]
[   81.735009]  [<dffffb61>] ? scsi_remove_host+0x51/0xd0 [scsi_mod]
[   81.735009]  [<e07a7f6b>] ? quiesce_and_remove_host+0x5b/0xa0 [usb_storage]
[   81.735009]  [<e07a8050>] ? usb_stor_disconnect+0x10/0x20 [usb_storage]
[   81.735009]  [<e005bbe8>] ? usb_unbind_interface+0x38/0x130 [usbcore]
[   81.735009]  [<c0308d8d>] ? __device_release_driver+0x4d/0xb0
[   81.735009]  [<c0308e9d>] ? device_release_driver+0x1d/0x30
[   81.735009]  [<c030842b>] ? bus_remove_device+0x7b/0xb0
[   81.735009]  [<c030695f>] ? device_del+0xef/0x180
[   81.735009]  [<e0058e8d>] ? usb_disable_device+0x4d/0xf0 [usbcore]
[   81.735009]  [<e0054308>] ? usb_disconnect+0x78/0x100 [usbcore]
[   81.735009]  [<e0054fad>] ? hub_thread+0x3dd/0xfa0 [usbcore]
[   81.735009]  [<c01518f0>] ? autoremove_wake_function+0x0/0x40
[   81.735009]  [<e0054bd0>] ? hub_thread+0x0/0xfa0 [usbcore]
[   81.735009]  [<c0151574>] ? kthread+0x74/0x80
[   81.735009]  [<c0151500>] ? kthread+0x0/0x80
[   81.735009]  [<c0103cb6>] ? kernel_thread_helper+0x6/0x10
[   81.735009] Code: 36 22 01 00 83 c4 0c c3 66 90 83 ec 08 89 1c 24 89 74 24 04 8b 58 30 8b b0 a8 01 00 00 85 db 89 50 30 74 3e c7 43 0c 00 00 00 00 <8b> 86 c0 01 00 00 e8 f4 60 1a 00 89 f0 e8 4d 7a ff ff 8b 86 c0 
[   81.735009] EIP: [<c0263ab1>] disk_replace_part_tbl+0x21/0x70 SS:ESP 0068:d74a7db0
[   81.735009] CR2: 00000000000001c0
[   81.924511] ---[ end trace af3a9b8b1414ddab ]---

Reverting just this patch and keeping the rest of queue-2.6.36 (except
drm-i915-die-i915_probe_agp-die.patch, which doesn't apply) fixes the 
regression for me.

Regards
	Stefan Lippers-Hollmann
