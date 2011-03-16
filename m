Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab1CPCCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:02:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34162 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1CPCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:02:15 -0400
Date: Wed, 16 Mar 2011 10:39:09 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v6 0/2] MAX8997/8966 MFD: Add RTC and IRQ
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>, Joe Perches <joe@perches.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1300239551-21285-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 16 Mar 2011 01:39:11.0914 (UTC)
 FILETIME=[F36440A0:01CBE37A]
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

This patch series is meant to add an initial driver for Maxim
Semiconductor 8997/8966's PMIC function.

However, as the first two parts (MFD and PMIC) are applied, we have
removed the frist two parts from the patch series. 

The changes from previous patch
v6
with comments from Samuel
	- IRQ register bit values use macros
corrected GPIO interrupt handling
RTC configuration bit values use macros
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

MyungJoo Ham (2):
  MAX8997/8966 MFD: Add IRQ control feature
  MAX8997/8966 RTC Driver Initial Release

 drivers/mfd/Makefile                |    2 +-
 drivers/mfd/max8997-irq.c           |  377 +++++++++++++++++++++++++++
 drivers/rtc/Kconfig                 |   10 +
 drivers/rtc/Makefile                |    1 +
 drivers/rtc/rtc-max8997.c           |  476 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997-private.h |   21 ++
 include/linux/mfd/max8997.h         |   12 +-
 7 files changed, 895 insertions(+), 4 deletions(-)
 create mode 100644 drivers/mfd/max8997-irq.c
 create mode 100644 drivers/rtc/rtc-max8997.c

