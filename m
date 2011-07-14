Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243Ab1GNRhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:37:11 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52328 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab1GNRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:37:09 -0400
MIME-Version: 1.0
Date: Thu, 14 Jul 2011 18:37:08 +0100
X-Google-Sender-Auth: mNQUHk9qIAYOsSuVq9n5c9RkaLA
Message-ID: <CAGq3pz4LHRkCqaJfqoMYe-=mn+s5CVZipab7bd8F3z+ou3xxVA@mail.gmail.com>
Subject: MTD-related kobject badness during linux-next boot
From: Daniel Drake <dsd@laptop.org>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Booting linux-next 20110707 on OLPC XO-1 I get:

[    0.965646] CAFE NAND 0000:00:0c.0: enabling device (0000 -> 0002)
[    0.984187] NAND device: Manufacturer ID: 0xad, Chip ID: 0xdc
(Hynix NAND 512MiB 3,3V 8-bit)
[    1.001115] 2 NAND chips detected
[    1.144358] Searching for RedBoot partition table in cafe_nand at offset 0x0
[    1.162364] No RedBoot partition table detected in cafe_nand
[    1.172947] kobject (cd8d40dc): tried to init an initialized
object, something is seriously wrong.
[    1.184111] Pid: 1, comm: swapper Not tainted 3.0.0-rc6-next-20110707+ #100
[    1.198384] Call Trace:
[    1.207741]  [<c05301a0>] ? kobject_init+0x24/0x6b
[    1.212420]  [<c0578c49>] ? device_initialize+0x18/0x56
[    1.227060]  [<c057960a>] ? device_register+0x8/0x10
[    1.241052]  [<c059104a>] ? add_mtd_device+0x17a/0x1f1
[    1.244949]  [<c0591128>] ? mtd_device_parse_register+0x67/0x7c
[    1.259536]  [<c06c6522>] ? cafe_nand_probe+0x5c9/0x686
[    1.263228]  [<c0546697>] ? pci_device_probe+0x52/0xb0
[    1.276828]  [<c057ad8b>] ? driver_probe_device+0x8a/0x109
[    1.290960]  [<c057ae4a>] ? __driver_attach+0x40/0x5b
[    1.294236]  [<c057a370>] ? bus_for_each_dev+0x37/0x60
[    1.307430] Switching to clocksource tsc
[    1.316560]  [<c057ab33>] ? driver_attach+0x14/0x17
[    1.329149]  [<c057ae0a>] ? driver_probe_device+0x109/0x109
[    1.362236] Switched to NOHz mode on CPU #0
[    1.390945]  [<c057a867>] ? bus_add_driver+0x88/0x1b1
[    1.422422]  [<c0530945>] ? kset_find_obj_hinted+0x6f/0x94
[    1.453723]  [<c07ef640>] ? start_kernel+0x293/0x293
[    1.483790]  [<c0803af6>] ? nand_base_init+0x12/0x12
[    1.513128]  [<c057b1ca>] ? driver_register+0x73/0xc6
[    1.541936]  [<c0803af6>] ? nand_base_init+0x12/0x12
[    1.570298]  [<c07ef640>] ? start_kernel+0x293/0x293
[    1.598567]  [<c0803af6>] ? nand_base_init+0x12/0x12
[    1.626318]  [<c0546ea3>] ? __pci_register_driver+0x2c/0x81
[    1.654298]  [<c07ef640>] ? start_kernel+0x293/0x293
[    1.680913]  [<c0803af6>] ? nand_base_init+0x12/0x12
[    1.706828]  [<c0401065>] ? do_one_initcall+0x65/0x104
[    1.733304]  [<c07ef640>] ? start_kernel+0x293/0x293
[    1.758893]  [<c07ef6a5>] ? kernel_init+0x65/0xda
[    1.783437]  [<c06cd9d6>] ? kernel_thread_helper+0x6/0xd

I think this is a recent regression but I haven't been testing enough
recent kernels to know exactly when it appeared.

This seems to cause shutdown to fail as well, as device_shutdown()
gets in an infinite loop trying to shut down mtd1.

Any ideas?

Thanks,
Daniel
