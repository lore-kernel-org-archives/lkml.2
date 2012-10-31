Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab2JaSD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:03:59 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:35084 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059Ab2JaSD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:03:56 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH v2 0/4] cbus/retu drivers
Date: Wed, 31 Oct 2012 20:03:42 +0200
Message-Id: <1351706626-32186-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces drivers for CBUS access and Retu multifunction
chip found on Nokia Internet Tablets (770, N800, N810). It would be
nice get these patches applied as the functionality of these devices is
severely lacking without Retu. E.g. watchdog support is mandatory at
least on Nokia N800, you cannot currently run the mainline kernel for
longer than ~60 seconds (there is no way to disable the watchdog).

Drivers originate from linux-omap cbus branch and have been cleaned
up/rewritten around i2c and MFD core.

Patches have been tested on top of 3.7-rc3 with Nokia N800 (watchdog
feeding works, power off shuts down the device, power button triggers
IRQs and input events).

Changes since the first version (https://lkml.org/lkml/2012/9/3/265):
	- i2c-cbus:
		- use devres
		- improve comments
		- simplify and delete redundant code
		- refactoring & bug fixes on error handling
		- discard "input" parameter from cbus_send_bit/data()
	- retu-mfd:
		- use devres
		- use regmap
	- retu_wdt: use devres
	- retu-pwrbutton: use devres

Changes since the RFC version
(http://marc.info/?l=linux-omap&m=134618967116737&w=2):
        - added DT support for getting i2c-cbus GPIO pins
        - merged n8x0 board file changes into i2c-cbus patch
        - corrected typo in Kconfig for MFD_RETU
        - added power off functionality to retu-mfd
        - added IRQ functionality to retu-mfd
        - added power button key driver
        - some cleanups

Aaro Koskinen (4):
  i2c: introduce i2c-cbus driver
  mfd: introduce retu-mfd driver
  watchdog: introduce retu_wdt driver
  input: misc: introduce retu-pwrbutton

 arch/arm/mach-omap2/board-n8x0.c    |   42 +++++
 drivers/i2c/busses/Kconfig          |   10 ++
 drivers/i2c/busses/Makefile         |    1 +
 drivers/i2c/busses/i2c-cbus.c       |  300 +++++++++++++++++++++++++++++++++++
 drivers/input/misc/Kconfig          |   10 ++
 drivers/input/misc/Makefile         |    1 +
 drivers/input/misc/retu-pwrbutton.c |  118 ++++++++++++++
 drivers/mfd/Kconfig                 |    9 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/retu-mfd.c              |  264 ++++++++++++++++++++++++++++++
 drivers/watchdog/Kconfig            |   12 ++
 drivers/watchdog/Makefile           |    1 +
 drivers/watchdog/retu_wdt.c         |  178 +++++++++++++++++++++
 include/linux/i2c-cbus.h            |   27 +++
 include/linux/mfd/retu.h            |   22 +++
 15 files changed, 996 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-cbus.c
 create mode 100644 drivers/input/misc/retu-pwrbutton.c
 create mode 100644 drivers/mfd/retu-mfd.c
 create mode 100644 drivers/watchdog/retu_wdt.c
 create mode 100644 include/linux/i2c-cbus.h
 create mode 100644 include/linux/mfd/retu.h

-- 
1.7.2.5

