Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1BPHpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:45:03 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:36224 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1BPHpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:45:00 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 00/12] unicore32 subsystem: additional architecture files and machine related files
Date: Wed, 16 Feb 2011 15:44:48 +0800
Message-ID: <014101cbcdad$64295de0$2c7c19a0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrVOaoPQpEzAORjuJEQiaxkO0xg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Wed, 16 Feb 2011 15:48:57 +0800

The whole subsystem code could be fetched from:
  git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
  with branch name: unicore32.

Previous patch set adds the core architecture support for UniCore32 ISA, 
and this patch set add  additional architecture files and machine related files. 

Patch 1 adds pm related files, including hibernate and sleep supports.
Patch 2 implements support for float point unit, which using UniCore-F64 FPU hardware in UniCore32 ISA.
Patch 3 adds ptrace support.
Patch 4 implements low-level debug libraries with On-Chip-Debugger hardware support.
Patch 5 implements low-level uaccess libraries.
Patch 6 implements the rest low-level libraries.
Patch 7 implements booting process, including uncompression process.

Patch 8 adds machine related core files, also including build infrastructure.
Patch 9 adds all hardware registers definitions.
Patch 10 implements arch-specific pci bus driver.
Patch 11 implements arch-specific ps2 driver.
Patch 12 adds MAINTAINER list for unicore32 architecture and pkunity soc drivers.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

GuanXuetao (12):
  unicore32 additional architecture files: pm related files
  unicore32 additional architecture files: float point handling
  unicore32 additional architecture files: ptrace handling
  unicore32 additional architecture files: low-level lib: ocd debug
  unicore32 additional architecture files: low-level lib: uaccess
  unicore32 additional architecture files: low-level lib: misc
  unicore32 additional architecture files: boot process
  unicore32 machine related files: core files
  unicore32 machine related files: hardware registers
  unicore32 machine related files: pci bus handling
  unicore32 machine related files: ps2 driver
  unicore32: ADD MAINTAINER for unicore32 architecture

 MAINTAINERS                                   |   14 +
 arch/unicore32/Kconfig.puv3                   |  125 ++++++++
 arch/unicore32/boot/Makefile                  |   47 +++
 arch/unicore32/boot/compressed/Makefile       |   68 ++++
 arch/unicore32/boot/compressed/head.S         |  204 +++++++++++++
 arch/unicore32/boot/compressed/misc.c         |  126 ++++++++
 arch/unicore32/boot/compressed/piggy.S.in     |    6 +
 arch/unicore32/boot/compressed/vmlinux.lds.in |   61 ++++
 arch/unicore32/include/asm/assembler.h        |  131 ++++++++
 arch/unicore32/include/asm/bitops.h           |   47 +++
 arch/unicore32/include/asm/checksum.h         |   41 +++
 arch/unicore32/include/asm/delay.h            |   52 ++++
 arch/unicore32/include/asm/fpstate.h          |   26 ++
 arch/unicore32/include/asm/fpu-ucf64.h        |   53 ++++
 arch/unicore32/include/asm/futex.h            |  143 +++++++++
 arch/unicore32/include/asm/io.h               |   52 ++++
 arch/unicore32/include/asm/mutex.h            |   20 ++
 arch/unicore32/include/asm/pci.h              |   46 +++
 arch/unicore32/include/asm/ptrace.h           |  133 ++++++++
 arch/unicore32/include/asm/suspend.h          |   30 ++
 arch/unicore32/include/asm/uaccess.h          |   47 +++
 arch/unicore32/include/mach/PKUnity.h         |  104 +++++++
 arch/unicore32/include/mach/bitfield.h        |   24 ++
 arch/unicore32/include/mach/hardware.h        |   45 +++
 arch/unicore32/include/mach/ocd.h             |   36 +++
 arch/unicore32/include/mach/pm.h              |   43 +++
 arch/unicore32/include/mach/regs-ac97.h       |   32 ++
 arch/unicore32/include/mach/regs-dmac.h       |   81 +++++
 arch/unicore32/include/mach/regs-gpio.h       |   70 +++++
 arch/unicore32/include/mach/regs-i2c.h        |   63 ++++
 arch/unicore32/include/mach/regs-intc.h       |   28 ++
 arch/unicore32/include/mach/regs-nand.h       |   79 +++++
 arch/unicore32/include/mach/regs-ost.h        |   92 ++++++
 arch/unicore32/include/mach/regs-pci.h        |   94 ++++++
 arch/unicore32/include/mach/regs-pm.h         |  126 ++++++++
 arch/unicore32/include/mach/regs-ps2.h        |   20 ++
 arch/unicore32/include/mach/regs-resetc.h     |   34 ++
 arch/unicore32/include/mach/regs-rtc.h        |   37 +++
 arch/unicore32/include/mach/regs-sdc.h        |  156 ++++++++++
 arch/unicore32/include/mach/regs-spi.h        |   98 ++++++
 arch/unicore32/include/mach/regs-uart.h       |    3 +
 arch/unicore32/include/mach/regs-umal.h       |  229 ++++++++++++++
 arch/unicore32/include/mach/regs-unigfx.h     |  200 ++++++++++++
 arch/unicore32/include/mach/uncompress.h      |   34 ++
 arch/unicore32/kernel/clock.c                 |  388 ++++++++++++++++++++++++
 arch/unicore32/kernel/cpu-ucv2.c              |   93 ++++++
 arch/unicore32/kernel/debug-macro.S           |   89 ++++++
 arch/unicore32/kernel/debug.S                 |   85 ++++++
 arch/unicore32/kernel/early_printk.c          |   59 ++++
 arch/unicore32/kernel/fpu-ucf64.c             |  126 ++++++++
 arch/unicore32/kernel/hibernate.c             |  160 ++++++++++
 arch/unicore32/kernel/hibernate_asm.S         |  117 +++++++
 arch/unicore32/kernel/pci.c                   |  404 +++++++++++++++++++++++++
 arch/unicore32/kernel/pm.c                    |  123 ++++++++
 arch/unicore32/kernel/ptrace.c                |  149 +++++++++
 arch/unicore32/kernel/puv3-core.c             |  270 +++++++++++++++++
 arch/unicore32/kernel/puv3-nb0916.c           |  175 +++++++++++
 arch/unicore32/kernel/puv3-smw0919.c          |  115 +++++++
 arch/unicore32/kernel/sleep.S                 |  202 ++++++++++++
 arch/unicore32/lib/Makefile                   |   27 ++
 arch/unicore32/lib/clear_user.S               |   57 ++++
 arch/unicore32/lib/copy_from_user.S           |  108 +++++++
 arch/unicore32/lib/copy_page.S                |   39 +++
 arch/unicore32/lib/copy_template.S            |  214 +++++++++++++
 arch/unicore32/lib/copy_to_user.S             |   96 ++++++
 arch/unicore32/lib/delay.S                    |   51 +++
 arch/unicore32/lib/findbit.S                  |   98 ++++++
 arch/unicore32/lib/strncpy_from_user.S        |   45 +++
 arch/unicore32/lib/strnlen_user.S             |   42 +++
 drivers/input/serio/i8042-unicore32io.h       |   70 +++++
 drivers/input/serio/i8042.h                   |    2 +
 drivers/pci/Makefile                          |    1 +
 72 files changed, 6605 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/Kconfig.puv3
 create mode 100644 arch/unicore32/boot/Makefile
 create mode 100644 arch/unicore32/boot/compressed/Makefile
 create mode 100644 arch/unicore32/boot/compressed/head.S
 create mode 100644 arch/unicore32/boot/compressed/misc.c
 create mode 100644 arch/unicore32/boot/compressed/piggy.S.in
 create mode 100644 arch/unicore32/boot/compressed/vmlinux.lds.in
 create mode 100644 arch/unicore32/include/asm/assembler.h
 create mode 100644 arch/unicore32/include/asm/bitops.h
 create mode 100644 arch/unicore32/include/asm/checksum.h
 create mode 100644 arch/unicore32/include/asm/delay.h
 create mode 100644 arch/unicore32/include/asm/fpstate.h
 create mode 100644 arch/unicore32/include/asm/fpu-ucf64.h
 create mode 100644 arch/unicore32/include/asm/futex.h
 create mode 100644 arch/unicore32/include/asm/io.h
 create mode 100644 arch/unicore32/include/asm/mutex.h
 create mode 100644 arch/unicore32/include/asm/pci.h
 create mode 100644 arch/unicore32/include/asm/ptrace.h
 create mode 100644 arch/unicore32/include/asm/suspend.h
 create mode 100644 arch/unicore32/include/asm/uaccess.h
 create mode 100644 arch/unicore32/include/mach/PKUnity.h
 create mode 100644 arch/unicore32/include/mach/bitfield.h
 create mode 100644 arch/unicore32/include/mach/hardware.h
 create mode 100644 arch/unicore32/include/mach/ocd.h
 create mode 100644 arch/unicore32/include/mach/pm.h
 create mode 100644 arch/unicore32/include/mach/regs-ac97.h
 create mode 100644 arch/unicore32/include/mach/regs-dmac.h
 create mode 100644 arch/unicore32/include/mach/regs-gpio.h
 create mode 100644 arch/unicore32/include/mach/regs-i2c.h
 create mode 100644 arch/unicore32/include/mach/regs-intc.h
 create mode 100644 arch/unicore32/include/mach/regs-nand.h
 create mode 100644 arch/unicore32/include/mach/regs-ost.h
 create mode 100644 arch/unicore32/include/mach/regs-pci.h
 create mode 100644 arch/unicore32/include/mach/regs-pm.h
 create mode 100644 arch/unicore32/include/mach/regs-ps2.h
 create mode 100644 arch/unicore32/include/mach/regs-resetc.h
 create mode 100644 arch/unicore32/include/mach/regs-rtc.h
 create mode 100644 arch/unicore32/include/mach/regs-sdc.h
 create mode 100644 arch/unicore32/include/mach/regs-spi.h
 create mode 100644 arch/unicore32/include/mach/regs-uart.h
 create mode 100644 arch/unicore32/include/mach/regs-umal.h
 create mode 100644 arch/unicore32/include/mach/regs-unigfx.h
 create mode 100644 arch/unicore32/include/mach/uncompress.h
 create mode 100644 arch/unicore32/kernel/clock.c
 create mode 100644 arch/unicore32/kernel/cpu-ucv2.c
 create mode 100644 arch/unicore32/kernel/debug-macro.S
 create mode 100644 arch/unicore32/kernel/debug.S
 create mode 100644 arch/unicore32/kernel/early_printk.c
 create mode 100644 arch/unicore32/kernel/fpu-ucf64.c
 create mode 100644 arch/unicore32/kernel/hibernate.c
 create mode 100644 arch/unicore32/kernel/hibernate_asm.S
 create mode 100644 arch/unicore32/kernel/pci.c
 create mode 100644 arch/unicore32/kernel/pm.c
 create mode 100644 arch/unicore32/kernel/ptrace.c
 create mode 100644 arch/unicore32/kernel/puv3-core.c
 create mode 100644 arch/unicore32/kernel/puv3-nb0916.c
 create mode 100644 arch/unicore32/kernel/puv3-smw0919.c
 create mode 100644 arch/unicore32/kernel/sleep.S
 create mode 100644 arch/unicore32/lib/Makefile
 create mode 100644 arch/unicore32/lib/clear_user.S
 create mode 100644 arch/unicore32/lib/copy_from_user.S
 create mode 100644 arch/unicore32/lib/copy_page.S
 create mode 100644 arch/unicore32/lib/copy_template.S
 create mode 100644 arch/unicore32/lib/copy_to_user.S
 create mode 100644 arch/unicore32/lib/delay.S
 create mode 100644 arch/unicore32/lib/findbit.S
 create mode 100644 arch/unicore32/lib/strncpy_from_user.S
 create mode 100644 arch/unicore32/lib/strnlen_user.S
 create mode 100644 drivers/input/serio/i8042-unicore32io.h


