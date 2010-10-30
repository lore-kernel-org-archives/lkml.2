Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0J3UI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 16:08:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59583 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab0J3UIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 16:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=I7bBJUKi8e0s+eNHwrboVY3QxB9ni7+xLoEoP/XwkmQs3moLtDwIv/LOq9R24f8Gi8
         eVvlklOLfvhHoHH1kEbcZv76a0VrrziY4FnPdJXBpgycl+wWOyVT95GFUtBQC/cmyU+O
         d8Y4JqicM6hGDurwHaCnbdQguNiOJa3nGFCvc=
Date: Sat, 30 Oct 2010 22:07:51 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org
Subject: [2.6.36-09452-g2d10d87] BUG: unable to handle kernel NULL pointer
 dereference at (null)
Message-ID: <20101030200751.GA2866@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am testing Linus' git kernel from today 2.6.36-09452-g2d10d87
and I get the following BUG: when I plug in the WinTV Nova-T USB
stick to watch television:


[27002.897127] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[27002.897207] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[27002.897564] DVB: registering new adapter (Hauppauge Nova-T Stick)
[27003.096909] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[27003.134119] BUG: unable to handle kernel NULL pointer dereference at           (null)
[27003.134236] IP: [<ffffffff813ac9f3>] i2c_transfer+0x23/0xd0
[27003.134317] PGD 70fbc067 PUD 70d27067 PMD 0 
[27003.134391] Oops: 0000 [#1] SMP 
[27003.134447] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1.3/2-1.3.3/manufacturer
[27003.134555] CPU 0 
[27003.134585] Modules linked in: snd_seq snd_seq_device vfat fat snd_hda_codec_idt snd_hda_intel iwlagn snd_hda_codec sky2 uvcvideo i2c_i801 snd_hwdep evdev
[27003.134848] 
[27003.134876] Pid: 20, comm: khubd Not tainted 2.6.36-09452-g2d10d87 #1 VAIO/VGN-FZ240E
[27003.134967] RIP: 0010:[<ffffffff813ac9f3>]  [<ffffffff813ac9f3>] i2c_transfer+0x23/0xd0
[27003.135034] RSP: 0018:ffff88007ca757f0  EFLAGS: 00010286
[27003.135034] RAX: 00000000ffffffa1 RBX: ffff8800757eb418 RCX: 00000000ffffffff
[27003.135034] RDX: 0000000000000000 RSI: ffff88007ca75850 RDI: ffff8800757eb418
[27003.135034] RBP: ffff88007ca75830 R08: ffff88007ca74000 R09: ffff88007ca72578
[27003.135034] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88007c800140
[27003.135034] R13: ffff88007ca75850 R14: 0000000000000002 R15: ffff8800757eb418
[27003.135034] FS:  0000000000000000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
[27003.135034] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[27003.135034] CR2: 0000000000000000 CR3: 0000000070de9000 CR4: 00000000000006f0
[27003.135034] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[27003.135034] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[27003.135034] Process khubd (pid: 20, threadinfo ffff88007ca74000, task ffff88007ca72540)
[27003.135034] Stack:
[27003.135034]  ffffffff8104ec60 ffff88007ca72540 ffff8800ffffffff ffff88007bd42a40
[27003.135034]  ffff88007c800140 0000000000000080 ffffffff81a68f00 ffff8800757eb418
[27003.135034]  ffff88007ca75880 ffffffff813ec7e4 ffff88007c800140 0000002200000080
[27003.135034] Call Trace:
[27003.135034]  [<ffffffff8104ec60>] ? process_timeout+0x0/0x10
[27003.135034]  [<ffffffff813ec7e4>] dib0070_read_reg+0x54/0x80
[27003.135034]  [<ffffffff8104ecc8>] ? msleep+0x18/0x20
[27003.135034]  [<ffffffff813ed544>] dib0070_attach+0xb4/0x4f0
[27003.135034]  [<ffffffff810769aa>] ? __symbol_get+0x2a/0xb0
[27003.135034]  [<ffffffff813f5cd2>] dib7070p_tuner_attach+0x62/0x150
[27003.135034]  [<ffffffff813f20c7>] dvb_usb_adapter_frontend_init+0x87/0x100
[27003.135034]  [<ffffffff813f150d>] dvb_usb_device_init+0x35d/0x6c0
[27003.135034]  [<ffffffff813f49b3>] dib0700_probe+0x63/0xe0
[27003.135034]  [<ffffffff8138243b>] ? usb_match_id+0x3b/0x70
[27003.135034]  [<ffffffff813825b3>] usb_probe_interface+0xb3/0x150
[27003.135034]  [<ffffffff81322329>] driver_probe_device+0x89/0x1a0
[27003.135034]  [<ffffffff813224e0>] ? __device_attach+0x0/0x60
[27003.135034]  [<ffffffff8132252b>] __device_attach+0x4b/0x60
[27003.135034]  [<ffffffff81321014>] bus_for_each_drv+0x64/0x90
[27003.135034]  [<ffffffff813221e1>] device_attach+0x91/0xa0
[27003.135034]  [<ffffffff813219c5>] bus_probe_device+0x25/0x40
[27003.135034]  [<ffffffff8131f808>] device_add+0x4a8/0x580
[27003.135034]  [<ffffffff81327fff>] ? device_pm_init+0x3f/0x60
[27003.135034]  [<ffffffff81381435>] usb_set_configuration+0x3e5/0x690
[27003.135034]  [<ffffffff811359dd>] ? sysfs_do_create_link+0xdd/0x210
[27003.135034]  [<ffffffff81389b7f>] generic_probe+0x3f/0xa0
[27003.135034]  [<ffffffff813817b5>] usb_probe_device+0x15/0x20
[27003.135034]  [<ffffffff81322329>] driver_probe_device+0x89/0x1a0
[27003.135034]  [<ffffffff813224e0>] ? __device_attach+0x0/0x60
[27003.135034]  [<ffffffff8132252b>] __device_attach+0x4b/0x60
[27003.135034]  [<ffffffff81321014>] bus_for_each_drv+0x64/0x90
[27003.135034]  [<ffffffff813221e1>] device_attach+0x91/0xa0
[27003.135034]  [<ffffffff813219c5>] bus_probe_device+0x25/0x40
[27003.135034]  [<ffffffff8131f808>] device_add+0x4a8/0x580
[27003.135034]  [<ffffffff8137a831>] usb_new_device+0x71/0xe0
[27003.135034]  [<ffffffff8137b280>] hub_thread+0x9e0/0x1090
[27003.135034]  [<ffffffff8105f3f0>] ? autoremove_wake_function+0x0/0x40
[27003.135034]  [<ffffffff8137a8a0>] ? hub_thread+0x0/0x1090
[27003.135034]  [<ffffffff8105eee6>] kthread+0x96/0xa0
[27003.135034]  [<ffffffff81003ad4>] kernel_thread_helper+0x4/0x10
[27003.135034]  [<ffffffff8105ee50>] ? kthread+0x0/0xa0
[27003.135034]  [<ffffffff81003ad0>] ? kernel_thread_helper+0x0/0x10
[27003.135034] Code: 0f 1f 84 00 00 00 00 00 55 b8 a1 ff ff ff 48 89 e5 41 57 41 56 41 89 d6 41 55 49 89 f5 41 54 53 48 89 fb 48 83 ec 18 48 8b 57 10 <48> 83 3a 00 74 75 65 48 8b 04 25 88 b5 00 00 f7 80 44 e0 ff ff 
[27003.135034] RIP  [<ffffffff813ac9f3>] i2c_transfer+0x23/0xd0
[27003.135034]  RSP <ffff88007ca757f0>
[27003.135034] CR2: 0000000000000000
[27003.205419] ---[ end trace 69e89a1609d21813 ]---


Is this already known? I remember that the previous kernel 2.6.36-06794-g12ba8d1
did not have this problem, so I can try to bisect it if necessary.

