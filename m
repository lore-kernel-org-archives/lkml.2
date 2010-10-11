Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0JKJFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:05:18 -0400
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:40746 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0JKJFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:05:16 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCHv3 0/7] HSI framework and drivers
Date: Mon, 11 Oct 2010 12:06:21 +0300
Message-Id: <1286787988-29013-1-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

Here you have the third round of the HSI framework patches.

The patch series introduces the HSI framework, an SSI driver
for OMAP and a generic character device for HSI/SSI devices.

SSI, which is a legacy version of HSI, is used to connect the application
engine with the cellular modem on the Nokia N900.

In this round we have fixed:
- Locking issues in the HSI framework.
- Fixes on removal of controller's modules.
- Error path handling in the omap_ssi driver.
- Increase the robustness of hsi_char.
- Typos and cosmetics.
- Some unused parameters warnings. 

I would very glad to continue getting feedback about this proposal.

This patch series is based on 2.6.36-rc6.

Version 2 of the patch set: http://lkml.org/lkml/2010/5/7/233

Br,
Carlos Chinea

Andras Domokos (3):
  HSI CHAR: Add HSI char device driver
  HSI CHAR: Add HSI char device kernel configuration
  HSI CHAR: Update ioctl-number.txt

Carlos Chinea (4):
  HSI: Introducing HSI framework
  OMAP SSI: Introducing OMAP SSI driver
  OMAP SSI: Add OMAP SSI to the kernel configuration
  HSI: Add HSI API documentation

 Documentation/DocBook/device-drivers.tmpl |   17 +
 Documentation/ioctl/ioctl-number.txt      |    1 +
 arch/arm/mach-omap2/Makefile              |    3 +
 arch/arm/mach-omap2/ssi.c                 |  139 +++
 arch/arm/plat-omap/include/plat/ssi.h     |  204 ++++
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/hsi/Kconfig                       |   16 +
 drivers/hsi/Makefile                      |    5 +
 drivers/hsi/clients/Kconfig               |   13 +
 drivers/hsi/clients/Makefile              |    5 +
 drivers/hsi/clients/hsi_char.c            | 1090 +++++++++++++++++
 drivers/hsi/controllers/Kconfig           |   21 +
 drivers/hsi/controllers/Makefile          |    5 +
 drivers/hsi/controllers/omap_ssi.c        | 1836 +++++++++++++++++++++++++++++
 drivers/hsi/hsi.c                         |  516 ++++++++
 include/linux/Kbuild                      |    1 +
 include/linux/hsi/Kbuild                  |    1 +
 include/linux/hsi/hsi.h                   |  376 ++++++
 include/linux/hsi/hsi_char.h              |   66 +
 20 files changed, 4318 insertions(+), 0 deletions(-)
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
 create mode 100644 include/linux/hsi/Kbuild
 create mode 100644 include/linux/hsi/hsi.h
 create mode 100644 include/linux/hsi/hsi_char.h

