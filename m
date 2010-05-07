Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0EGPPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:15:55 -0400
Received: from smtp.nokia.com ([192.100.105.134]:28481 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab0EGPPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:15:52 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCHv2 0/7] HSI framework and drivers
Date: Fri,  7 May 2010 18:18:30 +0300
Message-Id: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 07 May 2010 15:15:45.0702 (UTC) FILETIME=[2AAB4460:01CAEDF8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

Here you have the second round of the HSI framework patches.
 
The patch series introduces the HSI framework, an SSI driver
for OMAP and a generic character device for HSI/SSI devices.

SSI, which is a legacy version of HSI, is used to connect the application
engine with the cellular modem on the Nokia N900.

In this round we have addressed the issues raised by Randy Dunlap.
We have also added two new patches which adds the HSI API to the kernel-doc
and updates the ioctl-number.txt file.

I would very glad to continue getting feedback about this proposal.

This patch series is based on 2.6.34-rc6.

The original post: http://lkml.org/lkml/2010/4/23/210

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
 arch/arm/plat-omap/include/plat/ssi.h     |  196 ++++
 drivers/Kconfig                           |    2 +
 drivers/Makefile                          |    1 +
 drivers/hsi/Kconfig                       |   16 +
 drivers/hsi/Makefile                      |    5 +
 drivers/hsi/clients/Kconfig               |   13 +
 drivers/hsi/clients/Makefile              |    5 +
 drivers/hsi/clients/hsi_char.c            | 1053 ++++++++++++++++++
 drivers/hsi/controllers/Kconfig           |   13 +
 drivers/hsi/controllers/Makefile          |    5 +
 drivers/hsi/controllers/omap_ssi.c        | 1694 +++++++++++++++++++++++++++++
 drivers/hsi/hsi.c                         |  489 +++++++++
 include/linux/Kbuild                      |    1 +
 include/linux/hsi/Kbuild                  |    1 +
 include/linux/hsi/hsi.h                   |  369 +++++++
 include/linux/hsi/hsi_char.h              |   66 ++
 20 files changed, 4089 insertions(+), 0 deletions(-)
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

