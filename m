Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab1EXSIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:08:23 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:57725 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756297Ab1EXSIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:08:20 -0400
X-ASG-Debug-ID: 1306260498-01de28096b62480001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDBF40E.7020003@fusionio.com>
Date: Tue, 24 May 2011 20:08:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Start of removal of legacy parallel interfaces for 3.0
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Start of removal of legacy parallel interfaces for 3.0
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306260498
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

With the 3.0 kernel approaching, now is a great time to get rid of some
legacy bagage. And what better part to start with than the old IDE code.
Parallel interfaces are so 1990's, we can't be seen with those on a
fancy new kernel version.

Next pull will remove parallel SCSI too, about time that old dog got put
to sleep as well.

  git://git.kernel.dk/linux-2.6-block.git for-2.6.40/parallel-io

Jens Axboe (1):
      ide: remove crufty legacy IDE support

 arch/arm/include/asm/ide.h               |   23 -
 arch/h8300/kernel/setup.c                |   10 -
 arch/m32r/platforms/m32104ut/io.c        |   32 -
 arch/m32r/platforms/m32700ut/io.c        |   66 -
 arch/m32r/platforms/mappi2/io.c          |   66 -
 arch/m32r/platforms/mappi3/io.c          |   95 --
 arch/m32r/platforms/opsput/io.c          |   66 -
 arch/m68k/include/asm/ide.h              |   66 -
 arch/mips/include/asm/ide.h              |   13 -
 arch/mips/include/asm/mach-generic/ide.h |  138 --
 arch/parisc/include/asm/ide.h            |   57 -
 arch/powerpc/include/asm/ide.h           |   17 -
 arch/sh/boards/mach-cayman/setup.c       |   32 -
 arch/sparc/include/asm/ide.h             |   97 --
 arch/tile/include/asm/ide.h              |   25 -
 drivers/Kconfig                          |    4 -
 drivers/ide/Kconfig                      |  891 -------------
 drivers/ide/Makefile                     |  119 --
 drivers/ide/aec62xx.c                    |  330 -----
 drivers/ide/ali14xx.c                    |  249 ----
 drivers/ide/alim15x3.c                   |  602 ---------
 drivers/ide/amd74xx.c                    |  347 -----
 drivers/ide/at91_ide.c                   |  366 ------
 drivers/ide/atiixp.c                     |  211 ---
 drivers/ide/au1xxx-ide.c                 |  601 ---------
 drivers/ide/buddha.c                     |  237 ----
 drivers/ide/cmd640.c                     |  846 ------------
 drivers/ide/cmd64x.c                     |  448 -------
 drivers/ide/cs5520.c                     |  168 ---
 drivers/ide/cs5530.c                     |  295 -----
 drivers/ide/cs5535.c                     |  220 ----
 drivers/ide/cs5536.c                     |  317 -----
 drivers/ide/cy82c693.c                   |  230 ----
 drivers/ide/delkin_cb.c                  |  193 ---
 drivers/ide/dtc2278.c                    |  154 ---
 drivers/ide/falconide.c                  |  178 ---
 drivers/ide/gayle.c                      |  202 ---
 drivers/ide/hpt366.c                     | 1548 ----------------------
 drivers/ide/ht6560b.c                    |  382 ------
 drivers/ide/icside.c                     |  693 ----------
 drivers/ide/ide-4drives.c                |   64 -
 drivers/ide/ide-acpi.c                   |  610 ---------
 drivers/ide/ide-atapi.c                  |  728 -----------
 drivers/ide/ide-cd.c                     | 1811 --------------------------
 drivers/ide/ide-cd.h                     |  126 --
 drivers/ide/ide-cd_ioctl.c               |  478 -------
 drivers/ide/ide-cd_verbose.c             |  359 ------
 drivers/ide/ide-cs.c                     |  364 ------
 drivers/ide/ide-devsets.c                |  191 ---
 drivers/ide/ide-disk.c                   |  791 ------------
 drivers/ide/ide-disk.h                   |   29 -
 drivers/ide/ide-disk_ioctl.c             |   32 -
 drivers/ide/ide-disk_proc.c              |  175 ---
 drivers/ide/ide-dma-sff.c                |  334 -----
 drivers/ide/ide-dma.c                    |  552 --------
 drivers/ide/ide-eh.c                     |  441 -------
 drivers/ide/ide-floppy.c                 |  543 --------
 drivers/ide/ide-floppy.h                 |   39 -
 drivers/ide/ide-floppy_ioctl.c           |  304 -----
 drivers/ide/ide-floppy_proc.c            |   45 -
 drivers/ide/ide-gd.c                     |  451 -------
 drivers/ide/ide-gd.h                     |   42 -
 drivers/ide/ide-generic.c                |  149 ---
 drivers/ide/ide-h8300.c                  |  109 --
 drivers/ide/ide-io-std.c                 |  260 ----
 drivers/ide/ide-io.c                     |  892 -------------
 drivers/ide/ide-ioctls.c                 |  288 -----
 drivers/ide/ide-iops.c                   |  531 --------
 drivers/ide/ide-legacy.c                 |   57 -
 drivers/ide/ide-lib.c                    |  170 ---
 drivers/ide/ide-park.c                   |  149 ---
 drivers/ide/ide-pci-generic.c            |  203 ---
 drivers/ide/ide-pio-blacklist.c          |   94 --
 drivers/ide/ide-pm.c                     |  248 ----
 drivers/ide/ide-pnp.c                    |  111 --
 drivers/ide/ide-probe.c                  | 1608 -----------------------
 drivers/ide/ide-proc.c                   |  790 ------------
 drivers/ide/ide-scan-pci.c               |  111 --
 drivers/ide/ide-sysfs.c                  |  125 --
 drivers/ide/ide-tape.c                   | 2075 ------------------------------
 drivers/ide/ide-taskfile.c               |  674 ----------
 drivers/ide/ide-timings.c                |  211 ---
 drivers/ide/ide-xfer-mode.c              |  265 ----
 drivers/ide/ide.c                        |  415 ------
 drivers/ide/ide_platform.c               |  147 ---
 drivers/ide/it8172.c                     |  166 ---
 drivers/ide/it8213.c                     |  216 ----
 drivers/ide/it821x.c                     |  715 ----------
 drivers/ide/jmicron.c                    |  176 ---
 drivers/ide/macide.c                     |  140 --
 drivers/ide/ns87415.c                    |  349 -----
 drivers/ide/opti621.c                    |  178 ---
 drivers/ide/palm_bk3710.c                |  400 ------
 drivers/ide/pdc202xx_new.c               |  562 --------
 drivers/ide/pdc202xx_old.c               |  361 ------
 drivers/ide/piix.c                       |  474 -------
 drivers/ide/pmac.c                       | 1728 -------------------------
 drivers/ide/q40ide.c                     |  167 ---
 drivers/ide/qd65xx.c                     |  446 -------
 drivers/ide/qd65xx.h                     |  144 --
 drivers/ide/rapide.c                     |  106 --
 drivers/ide/rz1000.c                     |   99 --
 drivers/ide/sc1200.c                     |  355 -----
 drivers/ide/scc_pata.c                   |  889 -------------
 drivers/ide/serverworks.c                |  449 -------
 drivers/ide/setup-pci.c                  |  664 ----------
 drivers/ide/sgiioc4.c                    |  631 ---------
 drivers/ide/siimage.c                    |  845 ------------
 drivers/ide/sis5513.c                    |  636 ---------
 drivers/ide/sl82c105.c                   |  365 ------
 drivers/ide/slc90e66.c                   |  180 ---
 drivers/ide/tc86c001.c                   |  269 ----
 drivers/ide/triflex.c                    |  142 --
 drivers/ide/trm290.c                     |  374 ------
 drivers/ide/tx4938ide.c                  |  221 ----
 drivers/ide/tx4939ide.c                  |  642 ---------
 drivers/ide/umc8672.c                    |  183 ---
 drivers/ide/via82cxxx.c                  |  537 --------
 drivers/misc/lkdtm.c                     |   21 -
 include/linux/ide.h                      | 1558 ----------------------
 120 files changed, 0 insertions(+), 44213 deletions(-)
 delete mode 100644 arch/arm/include/asm/ide.h
 delete mode 100644 arch/m68k/include/asm/ide.h
 delete mode 100644 arch/mips/include/asm/ide.h
 delete mode 100644 arch/mips/include/asm/mach-generic/ide.h
 delete mode 100644 arch/parisc/include/asm/ide.h
 delete mode 100644 arch/powerpc/include/asm/ide.h
 delete mode 100644 arch/sparc/include/asm/ide.h
 delete mode 100644 arch/tile/include/asm/ide.h
 delete mode 100644 drivers/ide/Kconfig
 delete mode 100644 drivers/ide/Makefile
 delete mode 100644 drivers/ide/aec62xx.c
 delete mode 100644 drivers/ide/ali14xx.c
 delete mode 100644 drivers/ide/alim15x3.c
 delete mode 100644 drivers/ide/amd74xx.c
 delete mode 100644 drivers/ide/at91_ide.c
 delete mode 100644 drivers/ide/atiixp.c
 delete mode 100644 drivers/ide/au1xxx-ide.c
 delete mode 100644 drivers/ide/buddha.c
 delete mode 100644 drivers/ide/cmd640.c
 delete mode 100644 drivers/ide/cmd64x.c
 delete mode 100644 drivers/ide/cs5520.c
 delete mode 100644 drivers/ide/cs5530.c
 delete mode 100644 drivers/ide/cs5535.c
 delete mode 100644 drivers/ide/cs5536.c
 delete mode 100644 drivers/ide/cy82c693.c
 delete mode 100644 drivers/ide/delkin_cb.c
 delete mode 100644 drivers/ide/dtc2278.c
 delete mode 100644 drivers/ide/falconide.c
 delete mode 100644 drivers/ide/gayle.c
 delete mode 100644 drivers/ide/hpt366.c
 delete mode 100644 drivers/ide/ht6560b.c
 delete mode 100644 drivers/ide/icside.c
 delete mode 100644 drivers/ide/ide-4drives.c
 delete mode 100644 drivers/ide/ide-acpi.c
 delete mode 100644 drivers/ide/ide-atapi.c
 delete mode 100644 drivers/ide/ide-cd.c
 delete mode 100644 drivers/ide/ide-cd.h
 delete mode 100644 drivers/ide/ide-cd_ioctl.c
 delete mode 100644 drivers/ide/ide-cd_verbose.c
 delete mode 100644 drivers/ide/ide-cs.c
 delete mode 100644 drivers/ide/ide-devsets.c
 delete mode 100644 drivers/ide/ide-disk.c
 delete mode 100644 drivers/ide/ide-disk.h
 delete mode 100644 drivers/ide/ide-disk_ioctl.c
 delete mode 100644 drivers/ide/ide-disk_proc.c
 delete mode 100644 drivers/ide/ide-dma-sff.c
 delete mode 100644 drivers/ide/ide-dma.c
 delete mode 100644 drivers/ide/ide-eh.c
 delete mode 100644 drivers/ide/ide-floppy.c
 delete mode 100644 drivers/ide/ide-floppy.h
 delete mode 100644 drivers/ide/ide-floppy_ioctl.c
 delete mode 100644 drivers/ide/ide-floppy_proc.c
 delete mode 100644 drivers/ide/ide-gd.c
 delete mode 100644 drivers/ide/ide-gd.h
 delete mode 100644 drivers/ide/ide-generic.c
 delete mode 100644 drivers/ide/ide-h8300.c
 delete mode 100644 drivers/ide/ide-io-std.c
 delete mode 100644 drivers/ide/ide-io.c
 delete mode 100644 drivers/ide/ide-ioctls.c
 delete mode 100644 drivers/ide/ide-iops.c
 delete mode 100644 drivers/ide/ide-legacy.c
 delete mode 100644 drivers/ide/ide-lib.c
 delete mode 100644 drivers/ide/ide-park.c
 delete mode 100644 drivers/ide/ide-pci-generic.c
 delete mode 100644 drivers/ide/ide-pio-blacklist.c
 delete mode 100644 drivers/ide/ide-pm.c
 delete mode 100644 drivers/ide/ide-pnp.c
 delete mode 100644 drivers/ide/ide-probe.c
 delete mode 100644 drivers/ide/ide-proc.c
 delete mode 100644 drivers/ide/ide-scan-pci.c
 delete mode 100644 drivers/ide/ide-sysfs.c
 delete mode 100644 drivers/ide/ide-tape.c
 delete mode 100644 drivers/ide/ide-taskfile.c
 delete mode 100644 drivers/ide/ide-timings.c
 delete mode 100644 drivers/ide/ide-xfer-mode.c
 delete mode 100644 drivers/ide/ide.c
 delete mode 100644 drivers/ide/ide_platform.c
 delete mode 100644 drivers/ide/it8172.c
 delete mode 100644 drivers/ide/it8213.c
 delete mode 100644 drivers/ide/it821x.c
 delete mode 100644 drivers/ide/jmicron.c
 delete mode 100644 drivers/ide/macide.c
 delete mode 100644 drivers/ide/ns87415.c
 delete mode 100644 drivers/ide/opti621.c
 delete mode 100644 drivers/ide/palm_bk3710.c
 delete mode 100644 drivers/ide/pdc202xx_new.c
 delete mode 100644 drivers/ide/pdc202xx_old.c
 delete mode 100644 drivers/ide/piix.c
 delete mode 100644 drivers/ide/pmac.c
 delete mode 100644 drivers/ide/q40ide.c
 delete mode 100644 drivers/ide/qd65xx.c
 delete mode 100644 drivers/ide/qd65xx.h
 delete mode 100644 drivers/ide/rapide.c
 delete mode 100644 drivers/ide/rz1000.c
 delete mode 100644 drivers/ide/sc1200.c
 delete mode 100644 drivers/ide/scc_pata.c
 delete mode 100644 drivers/ide/serverworks.c
 delete mode 100644 drivers/ide/setup-pci.c
 delete mode 100644 drivers/ide/sgiioc4.c
 delete mode 100644 drivers/ide/siimage.c
 delete mode 100644 drivers/ide/sis5513.c
 delete mode 100644 drivers/ide/sl82c105.c
 delete mode 100644 drivers/ide/slc90e66.c
 delete mode 100644 drivers/ide/tc86c001.c
 delete mode 100644 drivers/ide/triflex.c
 delete mode 100644 drivers/ide/trm290.c
 delete mode 100644 drivers/ide/tx4938ide.c
 delete mode 100644 drivers/ide/tx4939ide.c
 delete mode 100644 drivers/ide/umc8672.c
 delete mode 100644 drivers/ide/via82cxxx.c
 delete mode 100644 include/linux/ide.h

-- 
Jens Axboe

