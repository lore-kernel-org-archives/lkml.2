Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab0J0PrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:47:23 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:41413 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0J0PrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:47:21 -0400
Date: Wed, 27 Oct 2010 17:47:15 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1815316554.20101027174715@eikelenboom.it>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>
Subject: Re: [em28xx] BUG: unable to handle kernel paging request at ffff880478a16ff8 IP: [<ffffffff81436cf1>] ir_g_keycode_from_table+0x4d/0xb1
In-Reply-To: <452198851.20101027120954@eikelenboom.it>
References: <452198851.20101027120954@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Sorry for the noise, it seems to be all ready fixed by pulling in your pull request for 2.6.37-rc1:
http://lkml.indiana.edu/hypermail/linux/kernel/1010.3/01594.html

--
Sander


Wednesday, October 27, 2010, 12:09:54 PM, you wrote:

> Hi Mauro,

> When plugging in my em28xx based grabber in a USB2.0 port i get this stack trace (complete boot log attached)
> Kernel used: Linus tree commit 12ba8d1e9262ce81a695795410bd9ee5c9407ba1 (pull of todays 2.6.37 merge window tree)

> [   43.628015] u 2-4: new high sed USB device usg ehci_hcd and address 2
> [   43.755974] u 2-4: New USB dece found, idVend=2304, idProduct208
> [   43.7626] usb 2-4: New USB device stris: Mfr=2, Produc1, SerialNumber=
> [   43.769828] b 2-4: Product: PCTV USB2 PAL
> [   43.774013usb 2-4: Manufacturer: Pinnacle Systems GmbH
> [   43.779540] em28xx: New device Pinnacle Systems GmbH PCTV USB2 PAL @ 480 Mbps (2304:0208, interface 0, class 0)
> [   43.789721] em28xx #0: chip ID is em2820 (or em2710)
> [   43.894981] e8xx #0: i2c eepr 00: 1a eb 67 9504 23 08 02 10 001e 03 98 1e 6a 2e
> [   43.903147] em28xx #0: i2c prom 10:
>  00 00 0 57 6e 00 00 00 8e 00 00 00 07 00 00 00
> [   43.911317] em28xx #0: i2c eeprom 20: 16 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   43.919456] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00
> [   43.927620] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   43.935751] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   43.943907] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2e 03 50 00 69 00
> [   43.952066] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
> [   43.960227] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 20 00 47 00
> [   43.968385] em28xx #0: i2c eeprom 90: 6d 00 62 00 48 00 00 00 1e 03 50 00 43 00 54 00
> [   43.976531] em28xx #0: i2c eeprom a0: 56 00 20 00 55 00 53 00 42 00 32 00 20 00 50 00
> [   43.984687] em28xx #0: i2c eeprom b0: 41 00 4c 00 00 00 06 03 31 00 00 00 00 00 00 00
> [   43.992834] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   44.000990] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   44.009143] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   44.017288] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 07 56 d9 35 01 ed 0b f8
> [   44.025436] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x0fd77740
> [   44.031957] em28xx #0: EEPROM info:
> [   44.035449] em28xx #0:       AC97 audio (5 sample rates)
> [   44.040241] em28xx #0:       500mA max power
> [   44.043996] em28xx #0:       Table at 0x06, strings=0x1e98, 0x2e6a, 0x0000
> [   44.051400] Registered IR keymap rc-pinnacle-grey
> [   44.056170] input: i2c IR (i2c IR (EM28XX Pinnacle as /devices/virtual/rc/rc0/input4
> [   44.063962] rc0: i2c IR (i2c IR (EM28XX Pinnacle as /devices/virtual/rc/rc0
> [   44.070928] ir-kbd-i2c: i2c IR (i2c IR (EM28XX Pinnacle detected at i2c-17/17-0047/ir0 [em28xx #0]
> [   44.079894] em28xx #0: Identified as Pinnacle PCTV USB 2 (card=3)
> [   44.086509] BUG: unable to handle kernel paging request at ffff880478a16ff8
> [   44.087061] IP: [<ffffffff81436cf1>] ir_g_keycode_from_table+0x4d/0xb1
> [   44.087061] PGD 1c04063 PUD 0 
> [   44.087061] Oops: 0000 [#1] SMP 
> [   44.087061] last sysfs file: /sys/devices/virtual/rc/rc0/input4/capabilities/sw
> [   44.087061] CPU 1 
> [   44.087061] Modules linked in: [last unloaded: scsi_wait_scan]
> [   44.087061] 
> [   44.087061] Pid: 494, comm: kworker/1:1 Not tainted 2.6.36+ #2 P5Q-EM DO/System Product Name
> [   44.087061] RIP: 0010:[<ffffffff81436cf1>]  [<ffffffff81436cf1>] ir_g_keycode_from_table+0x4d/0xb1
> [   44.087061] RSP: 0000:ffff880079d61da0  EFLAGS: 00010817
> [   44.087061] RAX: 000000007fffffff RBX: ffff880078a72800 RCX: 0000000000000000
> [   44.087061] RDX: 000000007fffffff RSI: 0000000000000282 RDI: 00000000ffffffff
> [   44.157005] RBP: ffff880079d61dc0 R08: ffff880078a17000 R09: 0000000000000029
> [   44.157005] R10: ffff880079d61db0 R11: dead000000200200 R12: ffff880078a729b0
> [   44.157005] R13: 0000000000000000 R14: ffff880078a70c00 R15: ffff88007ca96700
> [   44.157005] FS:  0000000000000000(0000) GS:ffff88007ca80000(0000) knlGS:0000000000000000
> [   44.157005] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   44.157005] CR2: ffff880478a16ff8 CR3: 00000000780c3000 CR4: 00000000000406e0
> [   44.157005] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   44.157005] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   44.157005] Process kworker/1:1 (pid: 494, threadinfo ffff880079d60000, task ffff88007c3d9650)
> [   44.157005] Stack:
> [   44.157005]  ffff880078a72800 0000000000000000 0000000000000064 ffff880078a70c00
> [   44.157005] <0> ffff880079d61e10 ffffffff81436f51 ffff880079d61e10 ffffffff81459259
> [   44.157005] <0> 0000000000000000 ffff880078bf1140 ffff880078bf1100 0000000000000064
> [   44.157005] Call Trace:
> [   44.157005]  [<ffffffff81436f51>] ir_keydown+0x34/0x138
> [   44.157005]  [<ffffffff81459259>] ? em28xx_get_key_pinnacle_usb_grey+0x28/0xa3
> [   44.157005]  [<ffffffff8145cbda>] ir_work+0x99/0xb6
> [   44.157005]  [<ffffffff8105fb52>] process_one_work+0x1d5/0x2d2
> [   44.157005]  [<ffffffff8145cb41>] ? ir_work+0x0/0xb6
> [   44.157005]  [<ffffffff8105ff2d>] worker_thread+0x146/0x277
> [   44.157005]  [<ffffffff8105fde7>] ? worker_thread+0x0/0x277
> [   44.157005]  [<ffffffff810645f7>] kthread+0x81/0x89
> [   44.157005]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
> [   44.157005]  [<ffffffff81064576>] ? kthread+0x0/0x89
> [   44.157005]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
> [   44.157005] Code: 00 00 48 89 c3 4c 89 e7 e8 a5 5e 20 00 44 8b 8b 94 01 00 00 4c 8b 83 88 01 00 00 48 89 c6 31 c9 41 
> 8d 79 ff 8d 14 0f d1 ea 89 d0 <45> 39 2c c0 73 05 8d 4a 01 eb 0c 77 07 44 39 ca 72 0b eb 10 8d 
> [   44.157005] RIP  [<ffffffff81436cf1>] ir_g_keycode_from_table+0x4d/0xb1
> [   44.157005]  RSP <ffff880079d61da0>
> [   44.157005] CR2: ffff880478a16ff8
> [   44.157005] ---[ end trace 2988a93430a1c9ca ]---
> [   44.351618] BUG: unable to handle kernel paging request at fffffffffffffff8
> [   44.352583] IP: [<ffffffff81064258>] kthread_data+0xb/0x11
> [   44.352583] PGD 1c05067 PUD 1c06067 PMD 0 
> [   44.352583] Oops: 0000 [#2] SMP 
> [   44.352583] last sysfs file: /sys/devices/virtual/rc/rc0/input4/capabilities/sw
> [   44.352583] CPU 1 
> [   44.352583] Modules linked in: [last unloaded: scsi_wait_scan]
> [   44.352583] 
> [   44.352583] Pid: 494, comm: kworker/1:1 Tainted: G      D     2.6.36+ #2 P5Q-EM DO/System Product Name
> [   44.352583] RIP: 0010:[<ffffffff81064258>]  [<ffffffff81064258>] kthread_data+0xb/0x11
> [   44.352583] RSP: 0000:ffff880079d61908  EFLAGS: 00010096
> [   44.352583] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88007c3d9650
> [   44.352583] RDX: 0000000000000040 RSI: 0000000000000001 RDI: ffff88007c3d9650
> [   44.352583] RBP: ffff880079d61908 R08: ffff88007ca96380 R09: ffff880079d15958
> [   44.352583] R10: dead000000200200 R11: 0000000000000000 R12: ffff880079d61a18
> [   44.352583] R13: ffff88007ca93200 R14: ffff88007c380000 R15: ffff88007c3d98d0
> [   44.352583] FS:  0000000000000000(0000) GS:ffff88007ca80000(0000) knlGS:0000000000000000
> [   44.352583] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   44.352583] CR2: fffffffffffffff8 CR3: 0000000001c03000 CR4: 00000000000406e0
> [   44.352583] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   44.352583] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   44.352583] Process kworker/1:1 (pid: 494, threadinfo ffff880079d60000, task ffff88007c3d9650)
> [   44.352583] Stack:
> [   44.352583]  ffff880079d61928 ffffffff81061820 ffff88007c3ebba0 ffff880079d61fd8
> [   44.352583] <0> ffff880079d619e8 ffffffff8163b347 ffff88007ca8fa60 ffff880079d60010
> [   44.352583] <0> 0000000000013200 ffff880079d61fd8 ffff880079d61fd8 0000000000013200
> [   44.352583] Call Trace:
> [   44.352583]  [<ffffffff81061820>] wq_worker_sleeping+0x10/0x8f
> [   44.352583]  [<ffffffff8163b347>] schedule+0x1c5/0x67a
> [   44.352583]  [<ffffffff810688e6>] ? switch_task_namespaces+0x18/0x4c
> [   44.352583]  [<ffffffff8104df71>] do_exit+0x7dc/0x7ea
> [   44.352583]  [<ffffffff8163e029>] oops_end+0xc7/0xcf
> [   44.352583]  [<ffffffff81032ed3>] no_context+0x1f3/0x202
> [   44.352583]  [<ffffffff810f169a>] ? virt_to_head_page+0x9/0x30
> [   44.352583]  [<ffffffff8103309d>] __bad_area_nosemaphore+0x1bb/0x1e1
> [   44.352583]  [<ffffffff813e3ed2>] ? urb_destroy+0x23/0x27
> [   44.352583]  [<ffffffff811f92b2>] ? kref_put+0x43/0x4f
> [   44.352583]  [<ffffffff813e3c22>] ? usb_free_urb+0x15/0x17
> [   44.352583]  [<ffffffff813e4c8f>] ? usb_start_wait_urb+0x12b/0x13a
> [   44.352583]  [<ffffffff810f2bc1>] ? __kmalloc+0x160/0x16f
> [   44.352583]  [<ffffffff810f169a>] ? virt_to_head_page+0x9/0x30
> [   44.352583]  [<ffffffff810330d1>] bad_area_nosemaphore+0xe/0x10
> [   44.352583]  [<ffffffff8164056d>] do_page_fault+0x238/0x43b
> [   44.352583]  [<ffffffff81457832>] ? em28xx_read_reg_req_len+0x133/0x18e
> [   44.352583]  [<ffffffff814578ab>] ? em28xx_read_reg_req+0x1e/0x28
> [   44.352583]  [<ffffffff8163d415>] page_fault+0x25/0x30
> [   44.352583]  [<ffffffff81436cf1>] ? ir_g_keycode_from_table+0x4d/0xb1
> [   44.352583]  [<ffffffff81436f51>] ir_keydown+0x34/0x138
> [   44.352583]  [<ffffffff81459259>] ? em28xx_get_key_pinnacle_usb_grey+0x28/0xa3
> [   44.352583]  [<ffffffff8145cbda>] ir_work+0x99/0xb6
> [   44.352583]  [<ffffffff8105fb52>] process_one_work+0x1d5/0x2d2
> [   44.352583]  [<ffffffff8145cb41>] ? ir_work+0x0/0xb6
> [   44.352583]  [<ffffffff8105ff2d>] worker_thread+0x146/0x277
> [   44.352583]  [<ffffffff8105fde7>] ? worker_thread+0x0/0x277
> [   44.352583]  [<ffffffff810645f7>] kthread+0x81/0x89
> [   44.352583]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
> [   44.352583]  [<ffffffff81064576>] ? kthread+0x0/0x89
> [   44.352583]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10
> [   44.352583] Code: 41 5d 41 5e c9 c3 90 55 65 48 8b 04 25 40 cc 00 00 48 8b 80 20 03 00 00 48 89 e5 8b 40 f0 c9 c3 48 
> 8b 87 20 03 00 00 55 48 89 e5 <48> 8b 40 f8 c9 c3 55 48 83 c7 40 48 89 e5 e8 71 9f fd ff c9 c3 
> [   44.352583] RIP  [<ffffffff81064258>] kthread_data+0xb/0x11
> [   44.352583]  RSP <ffff880079d61908>
> [   44.352583] CR2: fffffffffffffff8
> [   44.352583] ---[ end trace 2988a93430a1c9cb ]---
> [   44.352583] Fixing recursive fault but reboot is needed!





-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

