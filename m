Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab0DFX1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:27:13 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:57731 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757632Ab0DFX1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:27:05 -0400
Date: Wed, 7 Apr 2010 01:26:59 +0200
To: "David S. Miller" <davem@davemloft.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Alan Cox <alan@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-ide: hda: possibly failed opcode: 0x25 on Alpha with
 2.6.34-rc3
Message-ID: <20100406232659.GA4788@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
X-Originating-IP: 160.45.64.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear IDE maintainers,

I recently installed Debian unstable on an old digital personal
workstation 433au alpha (Miata) [1] with the default kernel 2.6.32
from Debian unstable. There were no obvious problems except for the
tulip network driver which produced a lot of noise [2]. Joe Perches was
so kind to provide a patch to reduce the noise. I applied the patch
against 2.6.34-rc3 and rebuilt the kernel with the 2.6.32 Debian
config using "make oldconfig". The kernel build took around 18 hours ;).

Anyway, after rebooting the machine into the new kernel (2.6.34-rc3), the
IDE driver obviously triggered a lot of errors [3] resulting in the kernel
not being able to mount the root partition.

The error message is always the same:

hda: possibly failed opcode: 0x25
drive not ready for command
status error: status=0x5a { DriveReady SeekComplete DataRequest Index }

But please see the screenshots in [3].

The system finally dropped into a busybox. I issued a "reboot" and tried
to reboot into the Debian stock 2.6.32 kernel. However, after the IDE problem
with 2.6.34-rc3, aboot was unable to read the bootsector. When I powercycled
the machine, I could reboot properly into 2.6.32 without any problems. I
already checked the IDE cabling, the harddisk is new, btw. The problem
reproduces every time I boot into 2.6.34-rc3.

It looks like that some changes in the IDE driver between 2.6.32 and
2.6.34-rc3 somehow messed up the code on Alpha. I didn't test the
whole thing on 2.6.33.2 yet, however the machine is busy right now
building that kernel so I can try tomorrow.

The lspci output of the hardware looks like this:

test-adrian1:~# lspci
00:03.0 Ethernet controller: Digital Equipment Corporation DECchip 21142/43 (rev 30)
00:07.0 ISA bridge: Contaq Microsystems 82c693
00:07.1 IDE interface: Contaq Microsystems 82c693
00:07.2 IDE interface: Contaq Microsystems 82c693
00:07.3 USB Controller: Contaq Microsystems 82c693
00:0b.0 VGA compatible controller: Matrox Graphics, Inc. MGA 2064W [Millennium] (rev 01)
00:14.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03)
01:04.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)
01:09.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller

If you need anymore verbose or debug output, please let me know.

Regards,

Adrian

[1] http://en.wikipedia.org/wiki/Digital_Personal_Workstation
[2] http://lkml.org/lkml/2010/4/5/104
[3] http://users.physik.fu-berlin.de/~glaubitz/alpha-crash/
