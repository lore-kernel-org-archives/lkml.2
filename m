Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab0EaTkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:40:47 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:12219 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756922Ab0EaTkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:40:45 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 May 2010 15:40:45 EDT
Subject: Re: 2.6.35-rc1 fails to boot: OOPS in ir_register_class
From: Andy Walls <awalls@md.metrocast.net>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-media@vger.kernel.org
In-Reply-To: <AANLkTim9-8q3OyWlksc2OdeLqFF-nPgKukTXb6Gws0lt@mail.gmail.com>
References: <AANLkTim9-8q3OyWlksc2OdeLqFF-nPgKukTXb6Gws0lt@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 15:31:21 -0400
Message-ID: <1275334281.2261.38.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-05-31_03:2010-02-06,2010-05-31,2010-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1005310134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 07:25 +0200, Torsten Kaiser wrote:
> Trying to boot the new -rc1 it fails with the following OOPS:
> [    3.454804] IR NEC protocol handler initialized
> [    3.461310] IR RC5(x) protocol handler initialized
> [    3.467865] IR RC6 protocol handler initialized
> [    3.474070] IR JVC protocol handler initialized
> [    3.480257] IR Sony protocol handler initialized
> [    3.480259] Linux video capture interface: v2.00
> [    3.480722] bttv: driver version 0.9.18 loaded
> [    3.480724] bttv: using 8 buffers with 2080k (520 pages) each for capture
> [    3.507950] bttv: Bt8xx card found (0).
> [    3.513845] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 19
> [    3.521339] bttv 0000:05:06.0: PCI INT A -> Link[LNKC] -> GSI 19
> (level, low) -> IRQ 19
> [    3.531039] bttv0: Bt878 (rev 17) at 0000:05:06.0, irq: 19,
> latency: 64, mmio: 0xeefff000
> [    3.541062] bttv0: detected: Hauppauge WinTV [card=10], PCI
> subsystem ID is 0070:13eb
> [    3.550946] bttv0: using: Hauppauge (bt878) [card=10,autodetected]
> [    3.561433] bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
> [    3.593765] usb 2-6: new low speed USB device using ohci_hcd and address 2
> [    3.599016] tveeprom 4-0050: Hauppauge model 61344, rev D421, serial# 3902813
> [    3.599018] tveeprom 4-0050: tuner model is Philips FM1216 (idx 21, type 5)
> [    3.599021] tveeprom 4-0050: TV standards PAL(B/G) (eeprom 0x04)
> [    3.599022] tveeprom 4-0050: audio processor is MSP3415 (idx 6)
> [    3.599024] tveeprom 4-0050: has radio
> [    3.599025] bttv0: Hauppauge eeprom indicates model#61344
> [    3.599027] bttv0: tuner type=5
> [    3.609618] msp3400 4-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
> [    3.609620] msp3400 4-0040: msp3400 supports nicam, mode is autodetect
> [    3.621863] tuner 4-0061: chip found @ 0xc2 (bt878 #0 [sw])
> [    3.622168] tuner-simple 4-0061: creating new instance
> [    3.622170] tuner-simple 4-0061: type set to 5 (Philips PAL_BG
> (FI1216 and compatibles))
> [    3.622882] bttv0: registered device video0
> [    3.622940] bttv0: registered device vbi0
> [    3.622997] bttv0: registered device radio0
> [    3.632337] bttv0: PLL: 28636363 => 35468950 .. ok
> [    3.683096] Registered IR keymap rc-rc5-tv
> [    3.683110] BUG: unable to handle kernel NULL pointer dereference at (null)
> [    3.683113] IP: [<ffffffff813ebe79>] ir_register_class+0x59/0x160
> [    3.683122] PGD 0
> [    3.683124] Oops: 0000 [#1] SMP
> [    3.683125] last sysfs file:
> [    3.683127] CPU 2
> [    3.683129] Modules linked in:
> [    3.683130]
> [    3.683133] Pid: 1, comm: swapper Not tainted 2.6.35-rc1 #1 KFN5-D
> SLI/KFN5-D SLI
> [    3.683135] RIP: 0010:[<ffffffff813ebe79>]  [<ffffffff813ebe79>]
> ir_register_class+0x59/0x160
> [    3.683139] RSP: 0018:ffff88011ff09cd0  EFLAGS: 00010246
> [    3.683141] RAX: 0000000000000000 RBX: ffff88011f3c1a00 RCX: ffffffff81a5baa0
> [    3.683142] RDX: 0000000000000000 RSI: ffffffff817d24f0 RDI: ffff88011f3c1a00
> [    3.683144] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> [    3.683146] R10: 0000000000000000 R11: 0000000000000021 R12: ffffffff817d6960
> [    3.683147] R13: ffff88011f223000 R14: ffff88011f3c1a00 R15: ffff88011f3c1b40
> [    3.683150] FS:  00000000010f8870(0000) GS:ffff880080200000(0000)
> knlGS:0000000000000000
> [    3.683151] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    3.683153] CR2: 0000000000000000 CR3: 0000000001a05000 CR4: 00000000000006e0
> [    3.683155] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    3.683157] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    3.683159] Process swapper (pid: 1, threadinfo ffff88011ff08000,
> task ffff88007ff48000)
> [    3.683160] Stack:
> [    3.683162]  ffff88011f223000 ffffffff81a5ab30 ffff88011f223000
> ffffffff817d6960
> [    3.683164] <0> 0000000000000021 ffffffff813eb90a ffff880100000028
> ffffffff817d240e
> [    3.683166] <0> ffff88011f3c1b68 0000000000000282 ffff8800070b54e0
> ffff88011f35f100
> [    3.683169] Call Trace:
> [    3.683174]  [<ffffffff813eb90a>] ? __ir_input_register+0x2ba/0x350
> [    3.683178]  [<ffffffff8141730a>] ? ir_probe+0x36a/0x4f0
> [    3.683181]  [<ffffffff81416fa0>] ? ir_probe+0x0/0x4f0
> [    3.683185]  [<ffffffff813d9bca>] ? i2c_device_probe+0xea/0x120
> [    3.683188]  [<ffffffff813367aa>] ? driver_sysfs_add+0x5a/0x80
> [    3.683190]  [<ffffffff813368d3>] ? driver_probe_device+0x83/0x190
> [    3.683193]  [<ffffffff813d9c54>] ? i2c_device_match+0x54/0x70
> [    3.683195]  [<ffffffff81336d03>] ? __driver_attach+0x93/0xa0
> [    3.683197]  [<ffffffff81336c70>] ? __driver_attach+0x0/0xa0
> [    3.683201]  [<ffffffff81335bf8>] ? bus_for_each_dev+0x58/0x80
> [    3.683203]  [<ffffffff81335ea0>] ? bus_add_driver+0xb0/0x250
> [    3.683206]  [<ffffffff81336e4a>] ? driver_register+0x6a/0x130
> [    3.683209]  [<ffffffff812124a0>] ? __pci_register_driver+0x80/0xc0
> [    3.683212]  [<ffffffff813daa30>] ? i2c_register_driver+0x30/0xb0
> [    3.683217]  [<ffffffff81ae990d>] ? bttv_init_module+0x0/0xde
> [    3.683220]  [<ffffffff81ae9b09>] ? ir_init+0x0/0x14
> [    3.683224]  [<ffffffff810001d4>] ? do_one_initcall+0x34/0x190
> [    3.683227]  [<ffffffff81ac36d6>] ? kernel_init+0x143/0x1cd
> [    3.683230]  [<ffffffff81003194>] ? kernel_thread_helper+0x4/0x10
> [    3.683232]  [<ffffffff81ac3593>] ? kernel_init+0x0/0x1cd
> [    3.683235]  [<ffffffff81003190>] ? kernel_thread_helper+0x0/0x10
> [    3.683237] Code: c7 80 a5 ba 81 48 89 c3 e8 b5 8f e0 ff 85 c0 89
> c5 78 62 48 8b 93 78 01 00 00 48 c7 c1 a0 ba a5 81 48 c7 c6 f0 24 7d
> 81 48 89 df <8b> 12 48 c7 83 20 01 00 00 20 ba a5 81 85 d2 48 c7 c2 e0
> ba a5

Refer to the linux/drivers/media/IR/ir-sysfs.c:ir_register_class().

That Oops code disassembles to this:

  33:	48 89 c3             	mov    %rax,%rbx
  36:	e8 b5 8f e0 ff       	callq  0xffffffffffe08ff0  <--- devno = find_first_zero_bit()
  3b:	85 c0                	test   %eax,%eax           <--- if (unlikely(devno < 0))
  3d:	89 c5                	mov    %eax,%ebp
  3f:	78 62                	js     0xa3		   <--- return devno
  41:	48 8b 93 78 01 00 00 	mov    0x178(%rbx),%rdx    <--- %rdx = irdev->props
  48:	48 c7 c1 a0 ba a5 81 	mov    $0xffffffff81a5baa0,%rcx
  4f:	48 c7 c6 f0 24 7d 81 	mov    $0xffffffff817d24f0,%rsi
  56:	48 89 df             	mov    %rbx,%rdi
  59:	8b 12                	mov    (%rdx),%edx         <-------- Ooops here  %edx = irdev->props->driver_type
  5b:	48 c7 83 20 01 00 00 	movq   $0xffffffff81a5ba20,0x120(%rbx)

As best I can tell, in this oops irdev->props was NULL in
ir_register_class().

I don't know if ir_dev->props is always supposed to get set, but
__ir_input_register() appears to check for it being NULL and then allows
the call to ir_register_class() to happen.  Of note is that if one fixes
ir_register_class() to handle a NULL props pointer,  the next if()
statement in __ir_input_register() will then try to dereference the NULL
pointer and then Oops.


Regards,
Andy

