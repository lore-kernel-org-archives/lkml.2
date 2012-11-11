Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2KKPOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:14:44 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3241 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2KKPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:14:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 11 Nov 2012 07:14:39 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/2] tps80031: Add mfd and regulator driver
Date: Sun, 11 Nov 2012 20:41:59 +0530
Message-ID: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series supports mfd core and regulator driver for the
Texas Instruments TPS80031/ TPS80032 Fully Integrated Power
Management with Power Path and Battery Charger. The device
provides five configurable step-down converters, 11 general
purpose LDOs, USB OTG Module, ADC, RTC, 2 PWM, System Voltage
Regulator/Battery Charger with Power Path from USB, 32K
clock generator.

Changes from V1:
- remove the volatle api.
- add regmap irq regardless of client->irq.
- Correct the irq cleanups.
- remove usage of irq_base.
- remove suspend/resume
- Correct acroym and ES nomenclature.
- Rewrite dcdc get voltage apis.
- Remove -1 and +1 in vsel.
- Correct the vbus ops for sw and hw based.

Changes from V2:
- Merge the header change from regulator pathc to mfd patch.
- Remove the change on 2/2 (for regulator) on header and moved in patch 1/2.

Laxman Dewangan (2):
  mfd: add TI TPS80031 mfd core driver
  regulator: tps80031: add regulator driver for tps80031

 drivers/mfd/Kconfig                    |   14 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/tps80031.c                 |  545 ++++++++++++++++++++++
 drivers/regulator/Kconfig              |    9 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps80031-regulator.c |  789 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps80031.h           |  632 +++++++++++++++++++++++++
 7 files changed, 1991 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps80031.c
 create mode 100644 drivers/regulator/tps80031-regulator.c
 create mode 100644 include/linux/mfd/tps80031.h

