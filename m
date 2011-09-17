Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1IQJZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 05:25:24 -0400
Received: from mail.agmk.net ([91.192.224.71]:59019 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab1IQJZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 05:25:22 -0400
From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x23f/0x250()
Date: Sat, 17 Sep 2011 11:23:03 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc6; KDE/4.7.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109171123.03622.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during ethernet cable reconnection on laptop the 3.1-rc6 kernel sometimes produces a warning:

(...)
[12747.670460] atl1c 0000:05:00.0: atl1c: eth0 NIC Link is Down
[12977.239187] atl1c 0000:05:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
[12982.460404] ------------[ cut here ]------------
[12982.460415] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x23f/0x250()
[12982.460418] Hardware name: N73SV
[12982.460420] NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
[12982.460422] Modules linked in: cryptd aes_x86_64 aes_generic udf crc_itu_t loop i915 drm_kms_helper drm i2c_algo_bit binfmt_misc sch_sfq ext2 raid1 vboxnetflt vboxdrv coretemp snd_hda_codec_hdmi usbhid hid uvcvideo snd_hda_codec_realtek videodev v4l2_compat_ioctl32 media ath3k btusb bluetooth arc4 ath9k mac80211 snd_hda_intel snd_hda_codec ath9k_common ath9k_hw joydev asus_nb_wmi snd_hwdep snd_pcm ath asus_wmi snd_timer ehci_hcd xhci_hcd sparse_keymap pci_hotplug atl1c usbcore mxm_wmi mei(C) psmouse iTCO_wdt snd i2c_i801 sg hwmon cfg80211 sr_mod cdrom soundcore i2c_core rfkill snd_page_alloc iTCO_vendor_support serio_raw pcspkr wmi video thermal button battery intel_agp intel_gtt ac processor evdev ext4 jbd2 crc16 mbcache dm_mod sd_mod crc_t10dif raid10 md_mod ahci libahci libata scsi_mod [last unloaded: scsi_wait_scan]
[12982.460491] Pid: 0, comm: swapper Tainted: G         C  3.1.0-rc6 #28
[12982.460492] Call Trace:
[12982.460494]  <IRQ>  [<ffffffff810428ca>] warn_slowpath_common+0x7a/0xb0
[12982.460502]  [<ffffffff810429a1>] warn_slowpath_fmt+0x41/0x50
[12982.460507]  [<ffffffff81340a4f>] dev_watchdog+0x23f/0x250
[12982.460512]  [<ffffffff8105202c>] run_timer_softirq+0x11c/0x3a0
[12982.460516]  [<ffffffff81219dd4>] ? timerqueue_add+0x74/0xc0
[12982.460520]  [<ffffffff81340810>] ? qdisc_reset+0x50/0x50
[12982.460524]  [<ffffffff81067394>] ? enqueue_hrtimer+0x34/0xc0
[12982.460528]  [<ffffffff8101ce48>] ? lapic_next_event+0x18/0x20
[12982.460532]  [<ffffffff810497b0>] __do_softirq+0xa0/0x200
[12982.460536]  [<ffffffff8107424a>] ? tick_program_event+0x1a/0x20
[12982.460541]  [<ffffffff81429aac>] call_softirq+0x1c/0x30
[12982.460545]  [<ffffffff81003f9d>] do_softirq+0x4d/0x80
[12982.460549]  [<ffffffff81049b6e>] irq_exit+0x8e/0xb0
[12982.460552]  [<ffffffff8101d4a9>] smp_apic_timer_interrupt+0x69/0xa0
[12982.460555]  [<ffffffff814285cb>] apic_timer_interrupt+0x6b/0x70
[12982.460557]  <EOI>  [<ffffffff81265d63>] ? intel_idle+0xc3/0x110
[12982.460565]  [<ffffffff81265d42>] ? intel_idle+0xa2/0x110
[12982.460569]  [<ffffffff81301131>] cpuidle_idle_call+0xc1/0x280
[12982.460573]  [<ffffffff81001205>] cpu_idle+0xb5/0x110
[12982.460577]  [<ffffffff81400ebe>] rest_init+0x72/0x74
[12982.460582]  [<ffffffff8189fb8b>] start_kernel+0x38f/0x39a
[12982.460586]  [<ffffffff8189f322>] x86_64_start_reservations+0x132/0x136
[12982.460590]  [<ffffffff8189f416>] x86_64_start_kernel+0xf0/0xf7
[12982.460592] ---[ end trace 1535c49bec959fd1 ]---
[12982.494277] atl1c 0000:05:00.0: irq 43 for MSI/MSI-X
[12982.494494] atl1c 0000:05:00.0: atl1c: eth0 NIC Link is Up<1000 Mbps Full Duplex>
