Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1EDSGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:06:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47789 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab1EDSGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:06:17 -0400
Date: Wed, 4 May 2011 20:06:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Borislav Petkov <bp@amd64.org>, John W Linville <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        chaoming_li@realsil.com.cn,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
Message-ID: <20110504180605.GB12126@gere.osrc.amd.com>
References: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net>
 <20110503150105.GC18648@gere.osrc.amd.com>
 <4DC05F9C.2070802@lwfinger.net>
 <20110504170131.GA12126@gere.osrc.amd.com>
 <4DC18AE5.4010708@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC18AE5.4010708@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 12:20:37PM -0500, Larry Finger wrote:
> You are very welcome. I'm glad to hear that it works for you. That
> driver missed the 2.6.39 merge window due to an ASPM problem that
> crashed my computer without any possibility of seeing what caused
> the blowup. I was somewhat afraid that others would get similar
> results even though Realsil did not see the problem.

Right, so I saw the oops below while playing with the driver earlier
but I attribute it to the fact that radio was switched off in the BIOS
(rfkill show said "Hard blocked: yes" for the wireless device). After
changing that I'm running smoothly so far. I'll keep you posted if I see
anything while using it in the next weeks.

Thanks.

--
May  4 18:27:20 gere avahi-daemon[976]: Withdrawing workstation service for wlan0.
May  4 18:27:20 gere kernel: [ 1109.575431] rtl8192se 0000:03:00.0: PCI INT A disabled
May  4 18:27:27 gere kernel: [ 1116.452554] rtl8192se 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
May  4 18:27:27 gere kernel: [ 1116.458855] rtl8192se 0000:03:00.0: setting latency timer to 64
May  4 18:27:27 gere kernel: [ 1116.486730] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
May  4 18:27:27 gere kernel: [ 1116.487028] IP: [<ffffffffa02fd9aa>] rtl_reg_notifier+0x3a/0xe0 [rtlwifi]
May  4 18:27:27 gere kernel: [ 1116.487028] PGD 13d3f2067 PUD 13b92f067 PMD 0 
May  4 18:27:27 gere kernel: [ 1116.487028] Oops: 0000 [#1] PREEMPT SMP 
May  4 18:27:27 gere kernel: [ 1116.487028] last sysfs file: /sys/devices/pci0000:00/0000:00:07.0/0000:03:00.0/ieee80211/phy3/uevent
May  4 18:27:27 gere kernel: [ 1116.487028] CPU 1 
May  4 18:27:27 gere kernel: [ 1116.487028] Modules linked in: rtl8192se(+) nls_utf8 nls_cp437 arc4 ipv6 fuse vfat fat loop btusb bluetooth usbhid snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel option usb_wwan usb_storage snd_hda_codec snd_hwdep snd_pcm usbserial thinkpad_acpi snd_seq snd_timer ohci_hcd snd_seq_device snd pcspkr ehci_hcd rtlwifi soundcore thermal nvram snd_page_alloc usbcore edac_core video processor evdev mac80211 ac thermal_sys cfg80211 battery rfkill k8temp button i2c_piix4 [last unloaded: rtl8192se]
May  4 18:27:27 gere kernel: [ 1116.523056] 
May  4 18:27:27 gere kernel: [ 1116.523056] Pid: 2387, comm: modprobe Not tainted 2.6.39-rc5-wl+ #15 LENOVO 01972NG/INVALID
May  4 18:27:27 gere kernel: [ 1116.523056] RIP: 0010:[<ffffffffa02fd9aa>]  [<ffffffffa02fd9aa>] rtl_reg_notifier+0x3a/0xe0 [rtlwifi]
May  4 18:27:27 gere kernel: [ 1116.523056] RSP: 0018:ffff88013d1a3b18  EFLAGS: 00010246
May  4 18:27:27 gere kernel: [ 1116.523056] RAX: ffff88013d211be0 RBX: ffff88013d210180 RCX: 00000000000001a0
May  4 18:27:27 gere kernel: [ 1116.523056] RDX: 000000000000000d RSI: 0000000000000000 RDI: 0000000000000000
May  4 18:27:27 gere kernel: [ 1116.523056] RBP: ffff88013d1a3b28 R08: 00000000000009bc R09: 0000000000000994
May  4 18:27:27 gere kernel: [ 1116.523056] R10: 000000000000000e R11: ffffffffa03077f4 R12: 0000000000000000
May  4 18:27:27 gere kernel: [ 1116.523056] R13: ffff88013d210180 R14: 0000000000000000 R15: 0000000000000001
May  4 18:27:27 gere kernel: [ 1116.523056] FS:  00007f6219dbb700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
May  4 18:27:27 gere kernel: [ 1116.523056] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May  4 18:27:27 gere kernel: [ 1116.523056] CR2: 0000000000000004 CR3: 000000013d3e7000 CR4: 00000000000006e0
May  4 18:27:27 gere kernel: [ 1116.523056] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May  4 18:27:27 gere kernel: [ 1116.523056] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May  4 18:27:27 gere kernel: [ 1116.523056] Process modprobe (pid: 2387, threadinfo ffff88013d1a2000, task ffff88013b945eb0)
May  4 18:27:27 gere kernel: [ 1116.523056] Stack:
May  4 18:27:27 gere kernel: [ 1116.523056]  0000000000000000 0000000000000031 ffff88013d1a3b98 ffffffffa003d134
May  4 18:27:27 gere kernel: [ 1116.523056]  ffffffffa00584c0 0000000000000000 0000000000000002 ffffffff00000000
May  4 18:27:27 gere kernel: [ 1116.523056]  ffffea0004521d50 000000009552559e ffff88013e4010d0 ffff88013d210180
May  4 18:27:27 gere kernel: [ 1116.523056] Call Trace:
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffffa003d134>] wiphy_update_regulatory+0x324/0x510 [cfg80211]
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffffa003a0ac>] wiphy_register+0x1cc/0x340 [cfg80211]
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff811052cf>] ? __kmalloc+0x11f/0x1d0
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffffa009c31d>] ieee80211_register_hw+0x18d/0x530 [mac80211]
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffffa0303a1b>] rtl_pci_probe+0x1773/0x19ef [rtlwifi]
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff811e3e2f>] local_pci_probe+0x5f/0xd0
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff811e44f8>] pci_device_probe+0x88/0xb0
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff8135419a>] ? driver_sysfs_add+0x7a/0xb0
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff81354496>] driver_probe_device+0x96/0x1b0
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff81354653>] __driver_attach+0xa3/0xb0
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff813545b0>] ? driver_probe_device+0x1b0/0x1b0
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff8135347e>] bus_for_each_dev+0x5e/0x90
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff8135411e>] driver_attach+0x1e/0x20
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff81353c95>] bus_add_driver+0xc5/0x270
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffffa0097000>] ? 0xffffffffa0096fff
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff81354c26>] driver_register+0x76/0x140
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffffa0097000>] ? 0xffffffffa0096fff
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff811e4796>] __pci_register_driver+0x56/0xd0
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffffa0097023>] rtl92se_module_init+0x23/0x59 [rtl8192se]
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff810002d4>] do_one_initcall+0x44/0x180
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff8108242a>] sys_init_module+0xba/0x200
May  4 18:27:27 gere kernel: [ 1116.523056]  [<ffffffff8147536b>] system_call_fastpath+0x16/0x1b
May  4 18:27:27 gere kernel: [ 1116.523056] Code: 24 08 66 66 66 66 90 48 89 fb 49 89 f4 e8 7f d5 db ff 48 8b 40 38 f6 80 8b 27 00 00 08 75 49 48 8b bb 90 00 00 00 e8 96 fc ff ff 
May  4 18:27:27 gere kernel: <41>[ 1116.523056]  83 7c 24 04 03 74 0e 31 c0 48 8b 1c 24 4c 8b 64 24 08 c9 c3 
May  4 18:27:27 gere kernel: [ 1116.523056] RIP  [<ffffffffa02fd9aa>] rtl_reg_notifier+0x3a/0xe0 [rtlwifi]
May  4 18:27:27 gere kernel: [ 1116.523056]  RSP <ffff88013d1a3b18>
May  4 18:27:27 gere kernel: [ 1116.523056] CR2: 0000000000000004
May  4 18:27:27 gere kernel: [ 1116.524232] ---[ end trace 9da2e30d01853e47 ]---

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
