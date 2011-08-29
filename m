Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1H2Nn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 09:43:26 -0400
Received: from krak.alatek.krakow.pl ([46.170.108.42]:3994 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1H2NnV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 09:43:21 -0400
X-Greylist: delayed 1267 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 09:43:21 EDT
From: Pawel Sikora <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Cc: kamal@canonical.com, keithp@keithp.com
Subject: Re: Linux 3.1-rc4
Date: Mon, 29 Aug 2011 15:22:10 +0200
Message-ID: <2352775.A2sX9R5EWV@pawels>
User-Agent: KMail/4.7.0  (Linux/2.6.38.8-3; KDE/4.7.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the recent -rc4 fix ( Kamal Mostafa / i915: do not setup intel_backlight twice ) fixes an oops
described in https://bugzilla.kernel.org/show_bug.cgi?id=40892#c1 but the core error
"[drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed" still exists.

moreover there's a next crash in framebuffer code:

(...)
Aug 29 10:51:55 vmx kernel: [   30.385071] Console: switching to colour frame buffer device 80x30
Aug 29 10:51:55 vmx kernel: [   30.385576] uvesafb: framebuffer at 0xb0000000, mapped to 0xffffc90006b00000, using 6144k, total 65472k
Aug 29 10:51:55 vmx kernel: [   30.385578] fb0: VESA VGA frame buffer device
Aug 29 15:10:54 vmx kernel: [22759.779325] [drm] Initialized drm 1.1.0 20060810
Aug 29 15:10:54 vmx kernel: [22759.845909] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Aug 29 15:10:54 vmx kernel: [22759.845914] i915 0000:00:02.0: setting latency timer to 64
Aug 29 15:10:54 vmx kernel: [22759.945397] mtrr: type mismatch for b0000000,10000000 old: write-back new: write-combining
Aug 29 15:10:54 vmx kernel: [22759.945401] [drm] MTRR allocation failed.  Graphics performance may suffer.
Aug 29 15:10:54 vmx kernel: [22759.951892] i915 0000:00:02.0: irq 44 for MSI/MSI-X
Aug 29 15:10:54 vmx kernel: [22759.951955] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Aug 29 15:10:54 vmx kernel: [22759.951958] [drm] Driver supports precise vblank timestamp query.
Aug 29 15:10:54 vmx kernel: [22759.953550] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
Aug 29 15:10:54 vmx kernel: [22759.955680] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
Aug 29 15:10:54 vmx kernel: [22759.955848] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
Aug 29 15:10:54 vmx kernel: [22759.955851] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
Aug 29 15:10:54 vmx kernel: [22760.519819] fbcon: inteldrmfb (fb1) is primary device
Aug 29 15:10:54 vmx kernel: [22760.519824] fbcon: Remapping primary device, fb1, to tty 1-63
Aug 29 15:10:55 vmx kernel: [22761.103384] fb1: inteldrmfb frame buffer device
Aug 29 15:10:55 vmx kernel: [22761.103385] drm: registered panic notifier
Aug 29 15:10:55 vmx kernel: [22761.103401] BUG: unable to handle kernel paging request at 000000104a69c2f8
Aug 29 15:10:55 vmx kernel: [22761.103403] IP: [<ffffffff81265d02>] fb_flashcursor+0x42/0x150
Aug 29 15:10:55 vmx kernel: [22761.103409] PGD 332bca067 PUD 0
Aug 29 15:10:55 vmx kernel: [22761.103412] Oops: 0000 [#1] SMP
Aug 29 15:10:55 vmx kernel: [22761.103414] CPU 0
Aug 29 15:10:55 vmx kernel: [22761.103415] Modules linked in: i915(+) drm_kms_helper drm i2c_algo_bit binfmt_misc uvesafb sch_sfq ext2 raid1 cryptd aes_x86_64 aes_generic ecb 
uvcvideo videodev snd_hda_codec_hdmi v4l2_compat_ioctl32 media ath3k arc4 btusb bluetooth snd_hda_codec_realtek ath9k mac80211 asus_nb_wmi asus_wmi sparse_keymap pci_hotplug 
ath9k_common ath9k_hw snd_hda_intel hwmon i2c_i801 joydev ath atl1c xhci_hcd ehci_hcd snd_hda_codec mxm_wmi i2c_core usbcore mei(C) iTCO_wdt wmi sr_mod sg ac psmouse intel_agp 
intel_gtt cdrom iTCO_vendor_support processor battery button evdev snd_hwdep snd_pcm snd_timer cfg80211 snd soundcore pcspkr serio_raw rfkill snd_page_alloc video thermal ext4 
jbd2 crc16 mbcache dm_mod sd_mod crc_t10dif raid10 md_mod ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
Aug 29 15:10:55 vmx kernel: [22761.103446]
Aug 29 15:10:55 vmx kernel: [22761.103449] Pid: 11, comm: kworker/0:1 Tainted: G         C  3.1.0-rc4-dirty #3 ASUSTeK Computer Inc. N73SV/N73SV
Aug 29 15:10:55 vmx kernel: [22761.103452] RIP: 0010:[<ffffffff81265d02>]  [<ffffffff81265d02>] fb_flashcursor+0x42/0x150
Aug 29 15:10:55 vmx kernel: [22761.103456] RSP: 0018:ffff88033b7bddb0  EFLAGS: 00010217
Aug 29 15:10:55 vmx kernel: [22761.103457] RAX: 0000000219191917 RBX: ffff8803430398f0 RCX: 0000000000000000
Aug 29 15:10:55 vmx kernel: [22761.103459] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffffffff81815fb0
Aug 29 15:10:55 vmx kernel: [22761.103461] RBP: ffff88033b7bde00 R08: ffff88033b7bc000 R09: ffff88034fa0f440
Aug 29 15:10:55 vmx kernel: [22761.103463] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88034fa0c980
Aug 29 15:10:55 vmx kernel: [22761.103464] R13: ffff880333e601d0 R14: ffffffff81265cc0 R15: ffff880339f137c8
Aug 29 15:10:55 vmx kernel: [22761.103467] FS:  0000000000000000(0000) GS:ffff88034fa00000(0000) knlGS:0000000000000000
Aug 29 15:10:55 vmx kernel: [22761.103469] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 29 15:10:55 vmx kernel: [22761.103471] CR2: 000000104a69c2f8 CR3: 00000003369da000 CR4: 00000000000406f0

BR,
Paweł.

