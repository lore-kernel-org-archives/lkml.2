Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2DLLrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:47:04 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:41579 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab2DLLrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:47:01 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F86C0A9.6070707@cam.ac.uk>
Date: Thu, 12 Apr 2012 12:46:49 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Belisko Marek <marek.belisko@gmail.com>
CC: linux-iio@vger.kernel.org, andreas@kemnade.info,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: hmc5843 probe crash in 3.3.1 kernel
References: <CAAfyv37uMtnKMyfXg_-4RJj+_2Qt-CmMufqyr==qBAzaCtHjdQ@mail.gmail.com>
In-Reply-To: <CAAfyv37uMtnKMyfXg_-4RJj+_2Qt-CmMufqyr==qBAzaCtHjdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 11:27 PM, Belisko Marek wrote:
> Hi,
>
> I'm trying to use hmc5843 driver from iio subsystem and
> after:
>
> echo hmc5843 0x1e>  /sys/class/i2c-dev/i2c-2/device/new_device
>
> I've got following crash:
hmm. Nothing immediately jumps out looking at the probe function.  Will have
to strip the device accesses from the driver to chase this down so might 
take
a while if no one else gets to it first...

Thanks for the bug report.
>
> [   78.271820] device: '2-001e': device_add (null)
> [   78.276641] device: '2-001e': device_add
> [   78.285003] bus: 'i2c': add device 2-001e
> [   78.289916] PM: Adding info for i2c:2-001e
> [   78.297210] bus: 'i2c': driver_probe_device: matched device 2-001e
> with driver hmc5843
> [   78.307098] bus: 'i2c': really_probe: probing driver hmc5843 with
> device 2-001e
> [   78.321197] HMC5843 initialized
> [   78.331298] ------------[ cut here ]------------
> [   78.336151] kernel BUG at mm/slab.c:505!
> [   78.340240] Internal error: Oops - BUG: 0 [#1] PREEMPT
> [   78.345642] Modules linked in:
> [   78.348876] CPU: 0    Not tainted  (3.3.1-gta04+ #14)
> [   78.354187] PC is at kfree+0x84/0x144
> [   78.358032] LR is at kfree+0x20/0x144
> [   78.361877] pc : [<c00b408c>]    lr : [<c00b4028>]    psr: 400d0093
> [   78.361907] sp : de28bcd8  ip : c13791c0  fp : 00000090
> [   78.373901] r10: 0000000a  r9 : de282eac  r8 : c023629c
> [   78.379394] r7 : c09d6490  r6 : a00d0013  r5 : de282c00  r4 : de282c10
> [   78.386230] r3 : c0f00218  r2 : 00000400  r1 : c0eea000  r0 : c00b4028
> [   78.393066] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
> Segment user
> [   78.400634] Control: 10c5387d  Table: 9e240019  DAC: 00000015
> [   78.406646] Process sh (pid: 92, stack limit = 0xde28a2f0)
> [   78.412414] Stack: (0xde28bcd8 to 0xde28c000)
> [   78.416961] bcc0:
>      de282c10 de282c00
> [   78.425567] bce0: de282c10 ffffffea 00000005 c023629c de02ddc0
> c00b4798 dec00080 de02ddc0
> [   78.434143] bd00: c032f3ac dec00080 000080d0 00000001 de282c00
> de282c10 c048d578 00000005
> [   78.442718] bd20: de282eac 0000000a 00000090 c032fa70 00000001
> 00000000 00000001 de282c10
> [   78.451293] bd40: de282eac c0031634 200d0013 00000001 00000003
> 00000009 de282c10 c048d594
> [   78.459869] bd60: 00000000 600d0013 00000018 205b0007 38372020
> 3132332e 5d373931 c0060020
> [   78.468444] bd80: de26e600 00000001 00000000 de26e600 00000001
> c0065a84 de282c00 de282c48
> [   78.477020] bda0: 00000006 0048d62c de282c38 de282c00 de282c00
> de235c00 de235c20 00000001
> [   78.485595] bdc0: 00000000 c048d62c 00000000 de282c00 de282c00
> de235c00 de235c20 00000001
> [   78.494171] bde0: 00000000 c048d62c 00000000 c0330194 00000000
> de235c20 c048d62c de235c00
> [   78.502746] be00: c03300a8 de235c04 c078d714 de18fcd8 00000000
> c02cd008 de235c20 c0795f40
> [   78.511322] be20: c0238360 00000000 00000000 c02381d8 de1b8300
> de235c20 de235c20 de28be48
> [   78.519897] be40: c0238360 c0236be0 decdbed8 de7dad94 de235c20
> de235c20 de235c54 de235c20
> [   78.528503] be60: 00000000 c0238060 de235c20 c078d7bc de235c20
> c023781c de235c20 de235c28
> [   78.537078] be80: dee64cb0 c0236160 c047c554 de18fcd8 00000000
> c004b45c de235c20 de235cd8
> [   78.545654] bea0: c0edfa6c de235c00 dee64c68 de235c04 de235c20
> dee64cb8 c047c554 de18fcd8
> [   78.554229] bec0: 00000000 c02cd664 dee64c68 de28bef4 de287008
> dee64cb0 0000000d de287000
> [   78.562805] bee0: de287007 c02cd7bc 00000002 00000000 00000000
> 35636d68 00333438 00000000
> [   78.571380] bf00: 00000000 00000000 001e0000 00000000 00000000
> 00000000 00000000 0a10cec0
> [   78.579956] bf20: 00000002 de28bf80 0000000d dee62990 de18fcc0
> c0234d88 0000000d c010c354
> [   78.588531] bf40: 0000000d de1c3f28 00ad0ef8 de28bf80 0000000d
> de28a000 00000000 c00b7bf8
> [   78.597106] bf60: de1c3f28 00ad0ef8 de1c3f28 00ad0ef8 00000000
> 00000000 0000000d c00b7ed8
> [   78.605682] bf80: 00000000 00000000 0000000d 00000000 0007fa28
> 0000000d 00ad0ef8 00000004
> [   78.614257] bfa0: c000e544 c000e380 0007fa28 0000000d 00000001
> 00ad0ef8 0000000d 00000000
> [   78.622833] bfc0: 0007fa28 0000000d 00ad0ef8 00000004 00000001
> 00000020 00000002 00000000
> [   78.631408] bfe0: 00000000 be9c7624 0000ea05 b6e97bac 600d0010
> 00000001 00000000 00000000
> [   78.640014] [<c00b408c>] (kfree+0x84/0x144) from [<c023629c>]
> (device_add+0x558/0x5ac)
> [   78.648315] [<c023629c>] (device_add+0x558/0x5ac) from [<c032fa70>]
> (iio_device_register+0x8c8/0x990)
> [   78.658020] [<c032fa70>] (iio_device_register+0x8c8/0x990) from
> [<c0330194>] (hmc5843_probe+0xec/0x114)
> [   78.667877] [<c0330194>] (hmc5843_probe+0xec/0x114) from
> [<c02cd008>] (i2c_device_probe+0xc4/0xf8)
> [   78.677276] [<c02cd008>] (i2c_device_probe+0xc4/0xf8) from
> [<c02381d8>] (driver_probe_device+0x118/0x218)
> [   78.687316] [<c02381d8>] (driver_probe_device+0x118/0x218) from
> [<c0236be0>] (bus_for_each_drv+0x4c/0x84)
> [   78.697357] [<c0236be0>] (bus_for_each_drv+0x4c/0x84) from
> [<c0238060>] (device_attach+0x78/0xa4)
> [   78.706665] [<c0238060>] (device_attach+0x78/0xa4) from
> [<c023781c>] (bus_probe_device+0x28/0x9c)
> [   78.715972] [<c023781c>] (bus_probe_device+0x28/0x9c) from
> [<c0236160>] (device_add+0x41c/0x5ac)
> [   78.725189] [<c0236160>] (device_add+0x41c/0x5ac) from [<c02cd664>]
> (i2c_new_device+0xf8/0x19c)
> [   78.734313] [<c02cd664>] (i2c_new_device+0xf8/0x19c) from
> [<c02cd7bc>] (i2c_sysfs_new_device+0xb4/0x130)
> [   78.744262] [<c02cd7bc>] (i2c_sysfs_new_device+0xb4/0x130) from
> [<c0234d88>] (dev_attr_store+0x18/0x24)
> [   78.754119] [<c0234d88>] (dev_attr_store+0x18/0x24) from
> [<c010c354>] (sysfs_write_file+0x10c/0x140)
> [   78.763702] [<c010c354>] (sysfs_write_file+0x10c/0x140) from
> [<c00b7bf8>] (vfs_write+0xb0/0x178)
> [   78.772949] [<c00b7bf8>] (vfs_write+0xb0/0x178) from [<c00b7ed8>]
> (sys_write+0x3c/0x68)
> [   78.781341] [<c00b7ed8>] (sys_write+0x3c/0x68) from [<c000e380>]
> (ret_fast_syscall+0x0/0x3c)
> [   78.790191] Code: 1593301c e5932000 e3120080 1a000000 (e7f001f2)
> [   78.800231] ---[ end trace de6fea1e2d4d3e02 ]---
>
> Regards,
>
> marek

