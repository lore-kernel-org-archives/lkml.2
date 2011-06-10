Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab1FJNoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:44:13 -0400
Received: from smtp.nokia.com ([147.243.1.48]:39589 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab1FJNms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:42:48 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, sre@debian.org, linus.walleij@linaro.org,
        govindraj.ti@gmail.com, pawel.szyszuk@stericsson.com,
        sjur.brandeland@stericsson.com, peter_henn@gmx.de
Subject: [RFC PATCHv5 0/7] HSI framework and drivers
Date: Fri, 10 Jun 2011 16:38:37 +0300
Message-Id: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

Here you have the fifth round of the HSI framework patches.

The patch series introduces the HSI framework, an SSI driver
for OMAP and a generic character device for HSI/SSI devices.

SSI, which is a legacy version of HSI, is used to connect the application
engine with the cellular modem on the Nokia N900.

In this round we have added/fixed:

- hsi_char has undergone refactoring and poll support has been removed.
- Fix RX hwbreak handling in omap_ssi
- Add functions for clients to query the controllers and port id.

TODO:

- Move OMAP SSI to use omap hwmod and new pm functions.
- Add aio support to hsi_char.
- Add automatic character device node registration for hsi_char.
- Add priority support in the HSI framework.

I would very glad to continue getting feedback about this proposal.

This patch series is based on 3.0-rc1.

Version 4 of the patch set: https://lkml.org/lkml/2010/12/14/73

Notes: 
 - checkpatch still reports a false positive on patch 1/7.
 - sparse error in hsi_char.c:128:1: error: Syntax error in unary expression,
	due to a bug in the BUILD_BUG_ON_ZERO macro for __CHECKER__ option.
	See https://lkml.org/lkml/2011/5/28/180

Andras Domokos (3):
  HSI: hsi_char: Add HSI char device driver
  HSI: hsi_char: Add HSI char device kernel configuration
  HSI: hsi_char: Update ioctl-number.txt

Carlos Chinea (4):
  HSI: hsi: Introducing HSI framework
  HSI: omap_ssi: Introducing OMAP SSI driver
  HSI: omap_ssi: Add OMAP SSI to the kernel configuration
  HSI: Add HSI API documentation

 Documentation/DocBook/device-drivers.tmpl |   17 +
 Documentation/ioctl/ioctl-number.txt      |    1 +
 arch/arm/mach-omap2/Makefile              |    2 +
 arch/arm/mach-omap2/ssi.c                 |  134 +++
 arch/arm/plat-omap/include/plat/ssi.h     |  204 ++++
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/hsi/Kconfig                       |   20 +
 drivers/hsi/Makefile                      |    6 +
 drivers/hsi/clients/Kconfig               |   13 +
 drivers/hsi/clients/Makefile              |    5 +
 drivers/hsi/clients/hsi_char.c            |  804 +++++++++++++
 drivers/hsi/controllers/Kconfig           |   23 +
 drivers/hsi/controllers/Makefile          |    5 +
 drivers/hsi/controllers/omap_ssi.c        | 1852 +++++++++++++++++++++++++++++
 drivers/hsi/hsi.c                         |  496 ++++++++
 drivers/hsi/hsi_boardinfo.c               |   64 +
 drivers/hsi/hsi_core.h                    |   37 +
 include/linux/Kbuild                      |    1 +
 include/linux/hsi/Kbuild                  |    1 +
 include/linux/hsi/hsi.h                   |  412 +++++++
 include/linux/hsi/hsi_char.h              |   65 +
 22 files changed, 4165 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/ssi.c
 create mode 100644 arch/arm/plat-omap/include/plat/ssi.h
 create mode 100644 drivers/hsi/Kconfig
 create mode 100644 drivers/hsi/Makefile
 create mode 100644 drivers/hsi/clients/Kconfig
 create mode 100644 drivers/hsi/clients/Makefile
 create mode 100644 drivers/hsi/clients/hsi_char.c
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/hsi.c
 create mode 100644 drivers/hsi/hsi_boardinfo.c
 create mode 100644 drivers/hsi/hsi_core.h
 create mode 100644 include/linux/hsi/Kbuild
 create mode 100644 include/linux/hsi/hsi.h
 create mode 100644 include/linux/hsi/hsi_char.h

