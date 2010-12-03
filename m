Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0LCPhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:37:16 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:42737 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707Ab0LCPhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:37:14 -0500
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, <dmitry.torokhov@gmail.com>,
        <sameo@linux.intel.com>, <ben-linux@fluff.org>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sundar Iyer <sundar.iyer@stericsson.com>
Subject: [PATCH 00/20] ux500: platform data, TC3589x keypad driver
Date: Fri, 3 Dec 2010 20:35:33 +0530
Message-ID: <1291388753-14662-1-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These set of patches add platform data to most of our mainlined
input drivers. Also included herein is

 - Changing TC35892 MFD core to also plug in more variants
 - revised version for the TC3589X keypad driver
 - Minor i2c fixes, cleanups
 - Minor arch specific code cleanups

(Apologies in advance to the i2c people for including them into
this big list; but these patches preferably need to be in through
single route)

Rabin Vincent (1):
  nomadik-gpio: allow sleep mode dir/pull to differ from normal mode

Sundar Iyer (19):
  mfd/ab8500: remove spi support
  mach-ux500: deprecate spi support for ab8500
  mach-ux500: move keymaps to new file
  mach-ux500: add STMPE1601 platform data
  mfd/tc35892: rename tc35892 header to tc3589x
  mfd/tc35892: rename tc35892 core driver to tc3589x
  mfd/tc3589x: rename tc35892 structs/registers to tc359x
  mfd/tc3589x: add block identifier for multiple child devices
  input/tc3589x: add tc3589x keypad support
  mfd/tc3589x: fix random interrupt misses
  mfd/tc3589x: undo gpio module reset during chip init
  mfd/tc3589x: add suspend/resume support
  plat-nomadik/gpio: add expander gpio pins enumeration
  mach-ux500: add touchscreen interfaces platform data
  i2c/nomadik: add adapter name for updated sanity checkings
  mach-ux500: add TC35893 keypad platform data
  mach-ux500: explicit enable MTU TCR in the kernel
  mach-ux500: clean up checkpatch spits
  i2c/nomadik: some checkpatch warnings

 arch/arm/mach-ux500/Makefile                       |    2 +
 arch/arm/mach-ux500/board-mop500-keypads.c         |  229 ++++++++++
 arch/arm/mach-ux500/board-mop500-touchscreen.c     |  170 ++++++++
 arch/arm/mach-ux500/board-mop500.c                 |  164 +-------
 arch/arm/mach-ux500/board-mop500.h                 |    3 +-
 arch/arm/mach-ux500/clock.c                        |  167 +++-----
 arch/arm/mach-ux500/devices-db8500.c               |    2 +-
 arch/arm/mach-ux500/include/mach/gpio.h            |   28 ++
 .../mach-ux500/include/mach/irqs-board-mop500.h    |   13 +-
 arch/arm/plat-nomadik/gpio.c                       |   50 ++-
 arch/arm/plat-nomadik/include/plat/pincfg.h        |   70 +++-
 drivers/gpio/Kconfig                               |    8 +-
 drivers/gpio/Makefile                              |    2 +-
 drivers/gpio/tc35892-gpio.c                        |  389 -----------------
 drivers/gpio/tc3589x-gpio.c                        |  389 +++++++++++++++++
 drivers/i2c/busses/i2c-nomadik.c                   |   35 +-
 drivers/input/keyboard/Kconfig                     |   10 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/tc3589x-keypad.c            |  440 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |   14 +-
 drivers/mfd/Makefile                               |    4 +-
 drivers/mfd/ab8500-spi.c                           |  143 -------
 drivers/mfd/tc35892.c                              |  345 ---------------
 drivers/mfd/tc3589x.c                              |  438 +++++++++++++++++++
 include/linux/mfd/tc35892.h                        |  136 ------
 include/linux/mfd/tc3589x.h                        |  195 +++++++++
 26 files changed, 2130 insertions(+), 1317 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-keypads.c
 create mode 100644 arch/arm/mach-ux500/board-mop500-touchscreen.c
 delete mode 100644 drivers/gpio/tc35892-gpio.c
 create mode 100644 drivers/gpio/tc3589x-gpio.c
 create mode 100644 drivers/input/keyboard/tc3589x-keypad.c
 delete mode 100644 drivers/mfd/ab8500-spi.c
 delete mode 100644 drivers/mfd/tc35892.c
 create mode 100644 drivers/mfd/tc3589x.c
 delete mode 100644 include/linux/mfd/tc35892.h
 create mode 100644 include/linux/mfd/tc3589x.h

-- 
1.7.2.dirty

