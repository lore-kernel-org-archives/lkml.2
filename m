Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab0JKU5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:57:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38061 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab0JKU5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:57:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 11 Oct 2010 22:56:58 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
To: linux-usb@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.9f585ea47331a2a2@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have got a monitor with built-in hub to which a keyboard, mouse, and
card reader are connected.  At one occasion when I switched the monitor
off, the following oops happened.

I have updated from 2.6.36-rc4 to 2.6.36-rc7 on Saturday evening.  I.e.
it may be a regression after 2.6.36-rc4, but isn't necessarily so.

Oct 11 22:16:30 stein -- MARK --
Oct 11 22:29:21 stein kernel: usb 1-1.2: USB disconnect, address 14
Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input0, status -71
Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -71
Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input1, status -71
Oct 11 22:29:21 stein kernel: hub 1-1:1.0: hub_port_status failed (err = -71)
Oct 11 22:29:21 stein kernel: hub 1-1:1.0: connect-debounce failed, port 2 disabled
Oct 11 22:29:21 stein kernel: usb 1-1: USB disconnect, address 12
Oct 11 22:29:21 stein kernel: usb 1-1.1: USB disconnect, address 13
Oct 11 22:29:21 stein kernel: usb 1-1.1.1: USB disconnect, address 16
Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -71
Oct 11 22:29:21 stein kernel: usb 1-1.3: USB disconnect, address 15
Oct 11 22:29:21 stein kernel: ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5
Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input0, status -108
Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -19
Oct 11 22:29:21 stein kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
Oct 11 22:29:21 stein kernel: IP: [<ffffffff8129dbd8>] ehci_clear_tt_buffer_complete+0x31/0x72
Oct 11 22:29:21 stein kernel: PGD 16b51f067 PUD 16b520067 PMD 0 
Oct 11 22:29:21 stein kernel: Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Oct 11 22:29:21 stein kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:02.0/0000:02:00.0/0000:03:02.0/0000:05:00.0/fw3/fw3.0/model_name
Oct 11 22:29:21 stein kernel: CPU 3 
Oct 11 22:29:21 stein kernel: Modules linked in: firedtv dvb_core ieee1394 firewire_ohci firewire_core crc_itu_t usb_storage cpufreq_ondemand powernow_k8 freq_table mperf nfsd lockd sunrpc exportfs snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ext4 jbd2 crc16 sr_mod yenta_socket snd_hda_codec_atihdmi cdrom snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm pcmcia_core k10temp pcmcia_rsrc snd_timer pata_atiixp snd sg snd_page_alloc r8169 mii thermal processor
Oct 11 22:29:21 stein kernel: 
Oct 11 22:29:21 stein kernel: Pid: 25071, comm: kworker/3:3 Not tainted 2.6.36-rc7 #8 M3A78-EM/System Product Name
Oct 11 22:29:21 stein kernel: RIP: 0010:[<ffffffff8129dbd8>]  [<ffffffff8129dbd8>] ehci_clear_tt_buffer_complete+0x31/0x72
Oct 11 22:29:21 stein kernel: RSP: 0018:ffff880208f13d10  EFLAGS: 00010002
Oct 11 22:29:21 stein kernel: RAX: 0000000000000282 RBX: 0000000000000000 RCX: ffff8801f3539e80
Oct 11 22:29:21 stein kernel: RDX: 0000000000003101 RSI: ffffffff81ca6de0 RDI: ffff88021fc67608
Oct 11 22:29:21 stein kernel: RBP: ffff880208f13d40 R08: ffffffff81ca6de0 R09: 0000000000000000
Oct 11 22:29:21 stein kernel: R10: ffffffff8129dbd5 R11: ffffffff8129379d R12: ffff88021fc673f0
Oct 11 22:29:21 stein kernel: R13: ffff88021fc67608 R14: 0000000000000282 R15: ffff88021fc675e8
Oct 11 22:29:21 stein kernel: FS:  00007f2b5188c700(0000) GS:ffff880002b80000(0000) knlGS:00000000f6ac7700
Oct 11 22:29:21 stein kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct 11 22:29:21 stein kernel: CR2: 0000000000000060 CR3: 000000016b51e000 CR4: 00000000000006e0
Oct 11 22:29:21 stein kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 11 22:29:21 stein kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 11 22:29:21 stein kernel: Process kworker/3:3 (pid: 25071, threadinfo ffff880208f12000, task ffff8801f3539e80)
Oct 11 22:29:21 stein kernel: Stack:
Oct 11 22:29:21 stein kernel: 0000000008f13d20 ffff88020ad4ca18 0000000000000282 ffff88020e2bca88
Oct 11 22:29:21 stein kernel: <0> ffff88020e2d37a8 ffff88020e2d38a0 ffff880208f13da0 ffffffff8128cc12
Oct 11 22:29:21 stein kernel: <0> 0000000000000000 0000000000000000 ffff8802000003e8 ffff88020e2d38d0
Oct 11 22:29:21 stein kernel: Call Trace:
Oct 11 22:29:21 stein kernel: [<ffffffff8128cc12>] hub_tt_work+0xd9/0x11c
Oct 11 22:29:21 stein kernel: [<ffffffff81045efa>] process_one_work+0x258/0x402
Oct 11 22:29:21 stein kernel: [<ffffffff81045e98>] ? process_one_work+0x1f6/0x402
Oct 11 22:29:21 stein kernel: [<ffffffff810476f0>] ? worker_thread+0x0/0x311
Oct 11 22:29:21 stein kernel: [<ffffffff8128cb39>] ? hub_tt_work+0x0/0x11c
Oct 11 22:29:21 stein kernel: [<ffffffff810476f0>] ? worker_thread+0x0/0x311
Oct 11 22:29:21 stein kernel: [<ffffffff810478cb>] worker_thread+0x1db/0x311
Oct 11 22:29:21 stein kernel: [<ffffffff810476f0>] ? worker_thread+0x0/0x311
Oct 11 22:29:21 stein kernel: [<ffffffff8104b54c>] kthread+0x81/0x89
Oct 11 22:29:21 stein kernel: [<ffffffff81002dd4>] kernel_thread_helper+0x4/0x10
Oct 11 22:29:21 stein kernel: [<ffffffff8102db9f>] ? finish_task_switch+0x69/0xa9
Oct 11 22:29:21 stein kernel: [<ffffffff81341000>] ? restore_args+0x0/0x30
Oct 11 22:29:21 stein kernel: [<ffffffff8104b4cb>] ? kthread+0x0/0x89
Oct 11 22:29:21 stein kernel: [<ffffffff81002dd0>] ? kernel_thread_helper+0x0/0x10
Oct 11 22:29:21 stein kernel: Code: 4c 8d bf f8 01 00 00 41 56 41 55 4c 8d af 18 02 00 00 41 54 49 89 fc 4c 89 ef 53 48 83 ec 08 48 8b 5e 20 e8 2f 28 0a 00 49 89 c6 <80> 63 60 fe 80 7b 49 03 75 20 48 8d 43 18 48 39 43 18 74 16 41 
Oct 11 22:29:21 stein kernel: RIP  [<ffffffff8129dbd8>] ehci_clear_tt_buffer_complete+0x31/0x72
Oct 11 22:29:21 stein kernel: RSP <ffff880208f13d10>
Oct 11 22:29:21 stein kernel: CR2: 0000000000000060
Oct 11 22:29:21 stein kernel: ---[ end trace 3730347d8bf09403 ]---
Oct 11 22:29:21 stein kernel: note: kworker/3:3[25071] exited with preempt_count 1
Oct 11 22:35:03 stein syslog-ng[3980]: syslog-ng starting up; version='3.1.2'

-- 
Stefan Richter
-=====-==-=- =-=- -=-==
http://arcgraph.de/sr/

