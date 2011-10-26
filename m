Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1JZWDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 18:03:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:20299 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab1JZWDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 18:03:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,411,1315206000"; 
   d="scan'208";a="67355577"
Subject: Re: 3.1-rc9 and 3.1 wifi problem , problem continues with 3.1
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: werner <w.landgraf@ru.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "dave.taht@gmail.com" <dave.taht@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "arend@broadcom.com" <arend@broadcom.com>,
        "toralf.foerster@gmx.de" <toralf.foerster@gmx.de>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "larry.finger@gmail.com" <larry.finger@gmail.com>
In-Reply-To: <web-633781994@zbackend1.aha.ru>
References: <web-633781994@zbackend1.aha.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Oct 2011 14:11:28 -0700
Message-ID: <1319663488.31823.88.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-26 at 14:47 -0700, werner wrote:
> As reported, with 3.1-rc9 the wifi of a friend's laptop 
> didnt work at all.  With 3.0.4 it's working normally.
> 
> The problem continues with 3.1
> 
> Now I take some files for identify the problem.  Below see 
> lsmod and dmesg , and enclosed is hwinfo and syslog of 
> that laptop as it was running with 3.1 just as wifi didn't 
> work.      For comparison, on syslog you can see the 
> previous boots (I separated them by blank lines), all with 
> 3.0.4 , when wifi was working.
> 
> I hope that's now enough information to fix that problem.
> 
> The driver fail to enable msi, here is in the syslog
"Oct 26 11:39:29 darkstar kernel: hda-intel: unable to grab IRQ 0,
disabling device
Oct 26 11:39:29 darkstar kernel: snd_hda_intel: probe of 0000:01:00.1
failed with error -16
Oct 26 11:39:29 darkstar kernel: iwlagn 0000:03:00.0: pci_enable_msi
failed
"

Thanks
Wey


> 
> 
> ============= lsmod ========================
> Module                  Size  Used by
> bnep                    7766  2
> rfcomm                 25786  3
> hidp                   10944  2
> bluetooth             120537  16 bnep,rfcomm,hidp
> snd_usb_audio          67370  0
> snd_usbmidi_lib        13290  1 snd_usb_audio
> snd_rawmidi            12740  1 snd_usbmidi_lib
> snd_seq_device          3765  1 snd_rawmidi
> tpm_tis                 6429  0
> tpm                     9267  1 tpm_tis
> tpm_bios                3680  1 tpm
> i2c_i801                6737  0
> iTCO_wdt                9371  0
> iTCO_vendor_support     1329  1 iTCO_wdt
> iwlagn                175521  0
> mac80211              172429  1 iwlagn
> cfg80211              123540  2 iwlagn,mac80211
> uvcvideo               50646  0
> rtc_cmos                7122  0
> snd_hda_codec_realtek   194904  1
> snd_hda_intel          17064  7
> snd_hda_codec          55426  2 
> snd_hda_codec_realtek,snd_hda_intel
> snd_hwdep               4142  2 
> snd_usb_audio,snd_hda_codec
> snd_pcm                52489  5 
> snd_usb_audio,snd_hda_intel,snd_hda_codec
> snd_timer              13192  3 snd_pcm
> snd                    36610  20 
> snd_usb_audio,snd_usbmidi_lib,snd_rawmidi,snd_seq_device,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
> soundcore               3803  1 snd
> snd_page_alloc          5101  2 snd_hda_intel,snd_pcm
> 
> 
> 
> ================= dmesg (only last part which is visible) 
> ===================
> ... plenty tests deleted ...
> 
> Testing event system raw_syscalls: OK
> Running tests on all trace events:
> Testing all events: OK
> kmemleak: Kernel memory leak detector initialized
> kmemleak: Automatic memory scanning thread started
> kAFS: Red Hat AFS client v0.1 registering.
> FS-Cache: Netfs 'afs' registered for caching
> raid6test: testing the 4-disk case...
> raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D) 
>  OK
> 
> ... plenty raid tests deleted
> 
> raid6test: complete (257 tests, 0 failures)
> register_blkdev: cannot get major 3 for hd
> drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
> md: Waiting for all devices to be available before 
> autodetect
> md: If you don't use raid, use raid=noautodetect
> md: Autodetecting RAID arrays.
> md: Scanned 0 and added 0 devices.
> md: autorun ...
> md: ... autorun DONE.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (sda1): mounted filesystem with ordered data mode
> VFS: Mounted root (ext3 filesystem) readonly on device 
> 8:1.
> devtmpfs: mounted
> Freeing unused kernel memory: 1004k freed
> Write protecting the kernel text: 15588k
> Write protecting the kernel read-only data: 4744k
> udevd (5746): /proc/5746/oom_adj is deprecated, please use 
> /proc/5746/oom_score_adj instead.
> snd_hda_intel 0000:00:1b.0: power state changed by ACPI to 
> D0
> snd_hda_intel 0000:00:1b.0: power state changed by ACPI to 
> D0
> ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 10
> snd_hda_intel 0000:00:1b.0: PCI INT A -> Link[LNKF] -> GSI 
> 10 (level, low) -> IRQ 10
> snd_hda_intel 0000:00:1b.0: setting latency timer to 64
> hda_codec: ALC269: BIOS auto-probing.
> input: HDA Digital PCBeep as 
> /devices/pci0000:00/0000:00:1b.0/input/input10
> input: HDA Intel Mic as 
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> input: HDA Intel Headphone as 
> /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 0 (level, 
> low) -> IRQ 0
> hda-intel: unable to grab IRQ 0, disabling device
> snd_hda_intel 0000:01:00.1: PCI INT B disabled
> snd_hda_intel: probe of 0000:01:00.1 failed with error -16
> rtc_cmos 00:08: RTC can wake from S4
> rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet 
> irqs
> uvcvideo: Found UVC 1.00 device CNF8015 (04f2:b112)
> input: CNF8015 as 
> /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input13
> usbcore: registered new interface driver uvcvideo
> USB Video Class driver (1.1.1)
> cfg80211: Calling CRDA to update world regulatory domain
> Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
> Copyright(c) 2003-2011 Intel Corporation
> iwlagn 0000:03:00.0: PCI INT A -> Link[LNKB] -> GSI 11 
> (level, low) -> IRQ 11
> iwlagn 0000:03:00.0: setting latency timer to 64
> iTCO_vendor_support: vendor-support=0
> iwlagn 0000:03:00.0: pci_resource_len = 0x00002000
> iwlagn 0000:03:00.0: pci_resource_base = fa07c000
> iwlagn 0000:03:00.0: HW Revision ID = 0x0
> iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
> iwlagn 0000:03:00.0: pci_enable_msi failed
> iwlagn 0000:03:00.0: PCI INT A disabled
> iTCO_wdt: Found a ICH9M TCO device (Version=2, 
> TCOBASE=0x0460)
> iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> i801_smbus 0000:00:1f.3: PCI INT C -> Link[LNKD] -> GSI 10 
> (level, low) -> IRQ 10
> EXT3-fs (sda1): using internal journal
> usbcore: registered new interface driver snd-usb-audio
> ---
> Professional hosting for everyone - http://www.host.ru


