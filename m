Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1A0MWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:22:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52179 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab1A0MW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Qw6tJZb/pg7G25l7qN81IHNWAxYzvDNvf2NycRq2X/PDBs9lvEf1UG3dLbrovUNNlw
         sUIb/EH+C19RJP2f3mQzYt2d5dMIkKvdnbl9+ysA6M5ifeKG2GPHtd+tqZAmEBiQ1vuT
         izgHSyoKU5GI9CmV0pQyZdmYfB1Rd/tmirvRA=
MIME-Version: 1.0
Date: Thu, 27 Jan 2011 21:22:27 +0900
Message-ID: <AANLkTikJfWHOeakbVU_CXSeOOz=sCuJoyv6dZ431WjWB@mail.gmail.com>
Subject: i2c send inside ISR
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi there,

I am working on a driver, and I reached a problem.
problem: My driver is supposed to send I2C message whenever it
receives an interrupt. the interrupt is generated when a GPIO  is
detected to be FALLING EDGE of input voltage.
Now, when I am sending the i2c message, I am getting the error and
dump like the following:
Any suggestions???

some (may be ) useful info:

CPU: OMAP 3530
Kernel version: 2.6.32 (slightly old, but I have to live with this, as
my entire product is built on this)

Thanks in advance
Murali

*******************************************************************************************************************************************
BUG: scheduling while atomic: swapper/1/0x00010000

Pid: 1, comm:              swapper
CPU: 0    Not tainted  (2.6.32 #491)
PC is at __setup_irq+0x22c/0x2f0
LR is at default_enable+0x20/0x30
pc : [<c008815c>]    lr : [<c0088c64>]    psr: 60000013
sp : c7819ea0  ip : 00000005  fp : 00000000
r10: 00000000  r9 : c05067c0  r8 : c056baf4
r7 : 60000013  r6 : 000000b5  r5 : c79c99c0  r4 : c056bad4
r3 : 00000000  r2 : 00000000  r1 : 00200000  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 80004019  DAC: 00000017

PC: 0xc00880dc:
80dc  e5953004 e2133b02 15942024 13a03000 13822501 15842024 ea000008 e5942024
80fc  e0221001 e311000f 0a000003 e202200f e59f0108 e1a01006 eb0d02fc e3a03001
811c  e3530000 e5856014 e3a02000 e5885000 e5842030 e5842038 0a000007 e5943024
813c  e3130502 0a000004 e3c33502 e1a00004 e5843024 e1a01006 ebffff56 e121f007
815c  e5950020 e3500000 0a000000 ebff516e e1a01004 e1a00006 eb000637 e3a0a000
817c  e1a00006 e1a01005 e585a018 eb00068f ea000017 e3e0a00f e121f007 e5954020
819c  e3540000 0a000012 e5953024 e3a02000 e5852020 e3130002 1a000001 e1a00004
81bc  ebffa3ab e2843008 e1931f9f e2411001 e1832f91 e3320000 1afffffa e3510000

LR: 0xc0088be4:
8be4  c0088c20 c0088bf0 c0570030 e92d4070 e1a05000 ebfff9f7 e1a04000 e1a00005
8c04  e5943010 e1a0e00f e593f018 e5943024 e3833902 e5843024 e8bd8070 e92d4010
8c24  e1a04000 ebfff9eb e5903010 e1a00004 e1a0e00f e593f00c e3a00000 e8bd8010
8c44  e92d4070 e1a05000 ebfff9e2 e1a04000 e1a00005 e5943010 e1a0e00f e593f020
8c64  e5943024 e3c33902 e5843024 e8bd8070 e92d4010 e1a04001 ebfff9d6 e3500000
8c84  08bd8010 e10f3000 f10c0080 e5902024 e3540000 13822201 03c22201 e5802024
8ca4  e121f003 e8bd8010 e92d4070 e1a05001 e1a04000 ebfff9c7 e2502000 01a01004
8cc4  059f0048 0a000004 e5923010 e3530000 1a000004 e59f0038 e1a01004 eb0d0009

SP: 0xc7819e20:
9e20  c0568b54 0000001d 00000000 000000b5 60000013 c056baf4 c05067c0 00000000
9e40  00000000 c0034070 ffffffff fa200000 000000b5 c0034a30 00000000 00200000
9e60  00000000 00000000 c056bad4 c79c99c0 000000b5 60000013 c056baf4 c05067c0
9e80  00000000 00000000 00000005 c7819ea0 c0088c64 c008815c 60000013 ffffffff
9ea0  000000b5 c056bad4 c79c99c0 c79c99c0 000000b5 c056bad4 00000000 c033828c
9ec0  00000000 c00882f0 00000000 c063f600 00000000 c041f514 c03381b8 c7855c04
9ee0  00000000 00000000 00000000 c0338254 c05067c0 00000000 00000000 c7855c20
9f00  c7855c00 c02a0618 c7855c20 c7855c54 c05aa548 c05aa548 00000000 c01ea610

R4: 0xc056ba54:
ba54  00000000 00020200 00000001 00000000 00000000 00000000 00000000 00000000
ba74  00000000 00000000 c78395c0 00000000 000000b4 00000000 c05b9b00 c00892cc
ba94  c0564e28 00000000 00000000 c0564b58 00000000 00020200 00000001 00000000
bab4  00000000 00000000 00000000 00000000 00000000 00000000 c78394c0 00000000
bad4  000000b5 00000000 c05b9b04 c00891d8 c0564e28 00000000 00000000 c0564b58
baf4  c79c99c0 00024108 00000000 00000000 00000000 00000000 00000000 00000000
bb14  c056bb14 c056bb14 c78393c0 00000000 000000b6 00000000 c05b9b08 c00892cc
bb34  c0564e28 00000000 00000000 c0564b58 00000000 00020200 00000001 00000000

R5: 0xc79c9940:
9940  ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
9960  ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff ffffffff
9980  c7802c80 c79c9984 c79c9984 c006d4c0 c7819eec 00000000 c057c598 c7819f2c
99a0  c7996000 00000000 fffffffe 00000000 00000000 00000000 00000000 00000000
99c0  c033828c 00000000 c05067c0 00000000 00000000 000000b5 00000000 00000000
99e0  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9a00  c79cfc00 c79e2a08 c79e2a08 c782a800 c79e2a08 c057c578 c79cea88 00000002
9a20  00000003 00000000 00000000 00000000 00000000 00000000 00000000 00000000

R8: 0xc056ba74:
ba74  00000000 00000000 c78395c0 00000000 000000b4 00000000 c05b9b00 c00892cc
ba94  c0564e28 00000000 00000000 c0564b58 00000000 00020200 00000001 00000000
bab4  00000000 00000000 00000000 00000000 00000000 00000000 c78394c0 00000000
bad4  000000b5 00000000 c05b9b04 c00891d8 c0564e28 00000000 00000000 c0564b58
baf4  c79c99c0 00024108 00000000 00000000 00000000 00000000 00000000 00000000
bb14  c056bb14 c056bb14 c78393c0 00000000 000000b6 00000000 c05b9b08 c00892cc
bb34  c0564e28 00000000 00000000 c0564b58 00000000 00020200 00000001 00000000
bb54  00000000 00000000 00000000 00000000 00000000 00000000 c78392c0 00000000

R9: 0xc0506740:
6740  20433249 76697264 203a7265 000a6425 4d3e333c 4c415255 202d2049 55424544
6760  202d2047 454c4946 7325203a 4c202d20 3a454e49 20642520 4153482d 4920504d
6780  3a205152 20642520 6f73000a 2f646e75 2f636f73 65646f63 772f7363 3939386d
67a0  00632e33 73682826 5f706d61 74617473 682e7375 706d6173 74756d5f 00297865
67c0  4d415348 333c0050 52554d3e 20494c41 4544202d 20475542 4946202d 203a454c
67e0  2d207325 4e494c20 25203a45 722d2064 65757165 69207473 72207172 72757465
6800  3a64656e 20642520 333c000a 52554d3e 20494c41 4544202d 20475542 4946202d
6820  203a454c 2d207325 4e494c20 25203a45 202d2064 65636572 64657669 51524920
[<c003a938>] (unwind_backtrace+0x0/0xd8) from [<c005bb6c>]
(__schedule_bug+0x4c/0x68)
[<c005bb6c>] (__schedule_bug+0x4c/0x68) from [<c03c9164>] (schedule+0x50/0x2d0)
[<c03c9164>] (schedule+0x50/0x2d0) from [<c03c9674>]
(schedule_timeout+0x14c/0x180)
[<c03c9674>] (schedule_timeout+0x14c/0x180) from [<c03c9004>]
(wait_for_common+0xcc/0x15c)
[<c03c9004>] (wait_for_common+0xcc/0x15c) from [<c02a36a0>]
(omap_i2c_xfer+0x220/0x35c)
[<c02a36a0>] (omap_i2c_xfer+0x220/0x35c) from [<c02a07d8>]
(i2c_transfer+0x88/0x100)
[<c02a07d8>] (i2c_transfer+0x88/0x100) from [<c02a1114>]
(i2c_master_send+0x34/0x44)
[<c02a1114>] (i2c_master_send+0x34/0x44) from [<c03382d4>]
(hsamp_irq_handler+0x48/0x170)
[<c03382d4>] (hsamp_irq_handler+0x48/0x170) from [<c00878c8>]
(handle_IRQ_event+0x34/0xf4)
[<c00878c8>] (handle_IRQ_event+0x34/0xf4) from [<c0089268>]
(handle_level_irq+0x90/0xf4)
[<c0089268>] (handle_level_irq+0x90/0xf4) from [<c004ab98>]
(gpio_irq_handler+0x11c/0x14c)
[<c004ab98>] (gpio_irq_handler+0x11c/0x14c) from [<c0034070>]
(asm_do_IRQ+0x70/0x90)
[<c0034070>] (asm_do_IRQ+0x70/0x90) from [<c0034a30>] (__irq_svc+0x30/0x80)
Exception stack(0xc7819e58 to 0xc7819ea0)
9e40:                                                       00000000 00200000
9e60: 00000000 00000000 c056bad4 c79c99c0 000000b5 60000013 c056baf4 c05067c0
9e80: 00000000 00000000 00000005 c7819ea0 c0088c64 c008815c 60000013 ffffffff
[<c0034a30>] (__irq_svc+0x30/0x80) from [<c008815c>] (__setup_irq+0x22c/0x2f0)
[<c008815c>] (__setup_irq+0x22c/0x2f0) from [<c00882f0>]
(request_threaded_irq+0xd0/0x118)
[<c00882f0>] (request_threaded_irq+0xd0/0x118) from [<c0338254>]
(hsamp_i2c_probe+0x9c/0xd4)
[<c0338254>] (hsamp_i2c_probe+0x9c/0xd4) from [<c02a0618>]
(i2c_device_probe+0xb8/0xe0)
[<c02a0618>] (i2c_device_probe+0xb8/0xe0) from [<c01ea610>]
(driver_probe_device+0xc0/0x174)
[<c01ea610>] (driver_probe_device+0xc0/0x174) from [<c01ea724>]
(__driver_attach+0x60/0x84)
[<c01ea724>] (__driver_attach+0x60/0x84) from [<c01e9e8c>]
(bus_for_each_dev+0x48/0x84)
[<c01e9e8c>] (bus_for_each_dev+0x48/0x84) from [<c01e97e0>]
(bus_add_driver+0x9c/0x218)
[<c01e97e0>] (bus_add_driver+0x9c/0x218) from [<c01eaa10>]
(driver_register+0xa8/0x134)
[<c01eaa10>] (driver_register+0xa8/0x134) from [<c02a1264>]
(i2c_register_driver+0x40/0x8c)
[<c02a1264>] (i2c_register_driver+0x40/0x8c) from [<c0034334>]
(do_one_initcall+0x5c/0x1b4)
[<c0034334>] (do_one_initcall+0x5c/0x1b4) from [<c0008578>]
(kernel_init+0x98/0x110)
[<c0008578>] (kernel_init+0x98/0x110) from [<c0035e6c>]
(kernel_thread_exit+0x0/0x8)

*******************************************************************************************************************************************

-- 
न चोर हार्यं न च राजहार्यं
न भ्रातृभाज्यं न च भारकारी
व्ययी कृते वर्धत एव नित्यं
विद्या धनं सर्व धनं प्रधानं
Thieves cannot steal it, Kings cannot tax it,
Siblings cannot demand a share in it, and it does not weigh a lot,
The more you spend it, increases every day,
the wealth of knowledge is the PRIME WEALTH .
