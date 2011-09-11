Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab1IKCzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 22:55:16 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33802 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1IKCzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 22:55:15 -0400
Date: Sat, 10 Sep 2011 23:55:09 -0300
From: =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier 
	<fredlwm@fredlwm.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Floppy: drive, floppy or driver problem ?
Message-ID: <20110911025509.GB18956@pervalidus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried 'dd if=/dev/fd0 of=foo.img' on a few floppy drives, and the first 
returned

Sep 10 21:53:58 pervalidus kernel: ------------[ cut here ]------------
Sep 10 21:53:58 pervalidus kernel: WARNING: at /usr/local/src/kernel/linux-3.0/drivers/block/floppy.c:1041 setup_rw_floppy+0x1ab/0x276 [floppy]()
Sep 10 21:53:58 pervalidus kernel: Hardware name: GA-MA69VM-S2
Sep 10 21:53:58 pervalidus kernel: floppy_disable_hlt() scheduled for removal in 2012
Sep 10 21:53:58 pervalidus kernel: Modules linked in: vboxpci vboxnetadp vboxnetflt vboxdrv af_packet fuse btrfs zlib_deflate lzo_decompress lzo_compress cryptomgr aead crc32c libcrc32c crypto_hash crypto_algapi it87 hwmon_vid ipt_LOG xt_tcpudp iptable_filter ip_tables x_tables cpufreq_ondemand powernow_k8 freq_table mperf joydev usbhid hid tuner_simple tuner_types snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus tuner tvaudio ir_lirc_codec radeon snd_pcm snd_seq_device snd_timer ttm lirc_dev tda7432 bttv videobuf_dma_sg videobuf_core btcx_risc rc_core 8250_pnp snd_page_alloc snd_util_mem tveeprom snd_hwdep snd v4l2_common evdev ohci_hcd videodev floppy parport_pc 8250 processor i2c_piix4 serial_core drm_kms_helper drm agpgart backlight ehci_hcd k8temp parport r8169 thermal_sys sr_mod sg i2c_algo_bit psmouse cfbcopyarea soundcore cfbimgblt emu10k1_gp cdrom hwmon cfbfillrect mii button gameport v4l2_compat_ioctl32 i2c_core usbcore loop
Sep 10 21:53:58 pervalidus kernel: Pid: 0, comm: kworker/0:0 Not tainted 3.0.3 #1
Sep 10 21:53:58 pervalidus kernel: Call Trace:
Sep 10 21:53:58 pervalidus kernel: <IRQ>  [<ffffffff81032f73>] warn_slowpath_common+0x80/0x98
Sep 10 21:53:58 pervalidus kernel: [<ffffffff8103301f>] warn_slowpath_fmt+0x41/0x43
Sep 10 21:53:58 pervalidus kernel: [<ffffffffa02b675d>] setup_rw_floppy+0x1ab/0x276 [floppy]
Sep 10 21:53:58 pervalidus kernel: [<ffffffff8103d0d3>] run_timer_softirq+0x16e/0x200
Sep 10 21:53:58 pervalidus kernel: [<ffffffffa02b65b2>] ? fd_watchdog+0xa2/0xa2 [floppy]
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81054659>] ? clockevents_program_event+0x89/0x8b
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81037b66>] __do_softirq+0x83/0x10d
Sep 10 21:53:58 pervalidus kernel: [<ffffffff810556be>] ? tick_program_event+0x1a/0x1c
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81274f0c>] call_softirq+0x1c/0x30
Sep 10 21:53:58 pervalidus kernel: [<ffffffff8100410e>] do_softirq+0x33/0x69
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81037e21>] irq_exit+0x3f/0xaf
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81018094>] smp_apic_timer_interrupt+0x77/0x85
Sep 10 21:53:58 pervalidus kernel: [<ffffffff812749d3>] apic_timer_interrupt+0x13/0x20
Sep 10 21:53:58 pervalidus kernel: <EOI>  [<ffffffff8104e0af>] ? sched_clock_local+0x12/0x75
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81009196>] ? default_idle+0x22/0x37
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81009190>] ? default_idle+0x1c/0x37
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81009287>] amd_e400_idle+0xd1/0xd8
Sep 10 21:53:58 pervalidus kernel: [<ffffffff8104d968>] ? atomic_notifier_call_chain+0xf/0x11
Sep 10 21:53:58 pervalidus kernel: [<ffffffff81001258>] cpu_idle+0x56/0x7e
Sep 10 21:53:58 pervalidus kernel: [<ffffffff8126eb31>] start_secondary+0x19a/0x19f
Sep 10 21:53:58 pervalidus kernel: ---[ end trace f9cc19006a146c05 ]---
Sep 10 21:54:09 pervalidus kernel: floppy0: data CRC error: track 18, head 1, sector 14, size 2
Sep 10 21:54:10 pervalidus kernel: floppy0: data CRC error: track 18, head 1, sector 14, size 2
Sep 10 21:54:10 pervalidus kernel: end_request: I/O error, dev fd0, sector 679
Sep 10 21:54:10 pervalidus kernel: Buffer I/O error on device fd0, logical block 84

With the others, some didn't return any error, while others returned the 
same errors from the last four lines.

But I then retried with the first floppy, and it didn't return anything in 
two runs.

Anyway, looking in my logs, I also got it once in the past:

Aug 25 19:29:51 pervalidus kernel: ------------[ cut here ]------------
Aug 25 19:29:51 pervalidus kernel: WARNING: at /usr/local/src/kernel/linux-3.0/drivers/block/floppy.c:1041 setup_rw_floppy+0x1ab/0x276 [floppy]()
Aug 25 19:29:51 pervalidus kernel: Hardware name: GA-MA69VM-S2
Aug 25 19:29:51 pervalidus kernel: floppy_disable_hlt() scheduled for removal in 2012
Aug 25 19:29:51 pervalidus kernel: Modules linked in: ext2 vboxpci vboxnetadp vboxnetflt vboxdrv af_packet fuse btrfs zlib_deflate lzo_decompress lzo_compress cryptomgr aead crc32c libcrc32c crypto_hash crypto_algapi it87 hwmon_vid ipt_LOG xt_tcpudp iptable_filter ip_tables x_tables cpufreq_ondemand powernow_k8 freq_table mperf radeon ttm tuner_simple joydev tuner_types usbhid hid tuner drm_kms_helper tvaudio tda7432 snd_emu10k1 drm snd_rawmidi snd_ac97_codec agpgart ac97_bus snd_pcm backlight bttv i2c_algo_bit videobuf_dma_sg ir_lirc_codec videobuf_core snd_seq_device lirc_dev btcx_risc rc_core snd_timer snd_page_alloc tveeprom 8250_pnp snd_util_mem ohci_hcd evdev snd_hwdep v4l2_common 8250 parport_pc sr_mod ehci_hcd snd videodev i2c_piix4 floppy emu10k1_gp processor cfbcopyarea serial_core parport r8169 cfbimgblt cdrom gameport thermal_sys sg k8temp usbcore psmouse button soundcore v4l2_compat_ioctl32 cfbfillrect mii i2c_core hwmon loop
Aug 25 19:29:51 pervalidus kernel: Pid: 0, comm: kworker/0:0 Not tainted 3.0.3 #1
Aug 25 19:29:51 pervalidus kernel: Call Trace:
Aug 25 19:29:51 pervalidus kernel: <IRQ>  [<ffffffff81032f73>] warn_slowpath_common+0x80/0x98
Aug 25 19:29:51 pervalidus kernel: [<ffffffff8103301f>] warn_slowpath_fmt+0x41/0x43
Aug 25 19:29:51 pervalidus kernel: [<ffffffffa01ea75d>] setup_rw_floppy+0x1ab/0x276 [floppy]
Aug 25 19:29:51 pervalidus kernel: [<ffffffff8103d0d3>] run_timer_softirq+0x16e/0x200
Aug 25 19:29:51 pervalidus kernel: [<ffffffffa01ea5b2>] ? fd_watchdog+0xa2/0xa2 [floppy]
Aug 25 19:29:51 pervalidus kernel: [<ffffffff81054659>] ? clockevents_program_event+0x89/0x8b
Aug 25 19:29:51 pervalidus kernel: [<ffffffff81037b66>] __do_softirq+0x83/0x10d
Aug 25 19:29:51 pervalidus kernel: [<ffffffff810556be>] ? tick_program_event+0x1a/0x1c
Aug 25 19:29:51 pervalidus kernel: [<ffffffff81274f0c>] call_softirq+0x1c/0x30
Aug 25 19:29:51 pervalidus kernel: [<ffffffff8100410e>] do_softirq+0x33/0x69
Aug 25 19:29:51 pervalidus kernel: [<ffffffff81037e21>] irq_exit+0x3f/0xaf
Aug 25 19:29:51 pervalidus kernel: [<ffffffff81018094>] smp_apic_timer_interrupt+0x77/0x85
Aug 25 19:29:51 pervalidus kernel: [<ffffffff812749d3>] apic_timer_interrupt+0x13/0x20
Aug 25 19:29:51 pervalidus kernel: <EOI>  [<ffffffff81009196>] ? default_idle+0x22/0x37
Aug 25 19:29:51 pervalidus kernel: [<ffffffff81009190>] ? default_idle+0x1c/0x37
Aug 25 19:29:51 pervalidus kernel: [<ffffffff81009287>] amd_e400_idle+0xd1/0xd8
Aug 25 19:29:51 pervalidus kernel: [<ffffffff8104d968>] ? atomic_notifier_call_chain+0xf/0x11
Aug 25 19:29:51 pervalidus kernel: [<ffffffff81001258>] cpu_idle+0x56/0x7e
Aug 25 19:29:51 pervalidus kernel: [<ffffffff8126eb31>] start_secondary+0x19a/0x19f
Aug 25 19:29:51 pervalidus kernel: ---[ end trace c68e72245970734b ]---

Is it a bug somewhare, or a hardware problem ?
