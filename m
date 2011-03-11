Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1CKCev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:34:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46357 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1CKCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:34:48 -0500
Date: Fri, 11 Mar 2011 11:34:42 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v5 0/4] MAX8997/8966 MFD (including PMIC&RTC) Initial Release
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1299810886-19684-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 11 Mar 2011 02:34:46.0493 (UTC)
 FILETIME=[E2E3E0D0:01CBDF94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997/8966 has
- PMIC
- RTC
- MUIC (usb switch)
- Flash control
- Haptic control
- Fuel Gauge (MAX17042 compatible)
- Battery charger control

This patch adds an initial driver for Maxim Semiconductor 8997/8966's
PMIC function.

In this initial release, PMIC (as set of regulators) and RTC drivers are
included.

The changes from previous patch
v5
with comments from Mark
	- Style updated for PMIC
	- Revised side-effect calculation
	In the range given, choose a setting without side-effect
	then, choose a setting with the least side-effect if allowed.
Added comments on FUEL-GAUGE issue in IRQ

v4
with comments from Randy:
	- Spelling errors in Kconfig
with comments from Minsung Kim:
	- RTC month bit error.

v3
with comments from Joe:
	- Style updated for IRQ and RTC
with comments from Mark
	- Style updated for RTC and PMIC
Merged support for RTC and IRQ

v2
with comments from Samuel:
	- Style updated for MFD
with comments from Mark:
	- Updated API for next and 2.6.38
	- Style updated for regulators
Support for hibernation
Support for bulk register access
Corrected register names
Added RTC/IRQ registers
LDO access bug fixed
Support for regulator suspend state control

MyungJoo Ham (4):
  MAX8997/8966 MFD Driver Initial Release (PMIC+RTC+MUIC+Haptic+...)
  MAX8997/8966 PMIC Regulator Driver Initial Release
  MAX8997/8966 MFD: Add IRQ control feature
  MAX8997/8966 RTC Driver Initial Release

 drivers/mfd/Kconfig                 |   12 +
 drivers/mfd/Makefile                |    1 +
 drivers/mfd/max8997-irq.c           |  346 ++++++++++
 drivers/mfd/max8997.c               |  427 ++++++++++++
 drivers/regulator/Kconfig           |    9 +
 drivers/regulator/Makefile          |    1 +
 drivers/regulator/max8997.c         | 1213 +++++++++++++++++++++++++++++++++++
 drivers/rtc/Kconfig                 |   10 +
 drivers/rtc/Makefile                |    1 +
 drivers/rtc/rtc-max8997.c           |  445 +++++++++++++
 include/linux/mfd/max8997-private.h |  359 +++++++++++
 include/linux/mfd/max8997.h         |  120 ++++
 12 files changed, 2944 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max8997-irq.c
 create mode 100644 drivers/mfd/max8997.c
 create mode 100644 drivers/regulator/max8997.c
 create mode 100644 drivers/rtc/rtc-max8997.c
 create mode 100644 include/linux/mfd/max8997-private.h
 create mode 100644 include/linux/mfd/max8997.h

