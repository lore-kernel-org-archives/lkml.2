Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab2ABMsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 07:48:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:38800 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab2ABMsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 07:48:18 -0500
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH V2 0/2] Add TI TPS65217 PMIC driver support
Date: Mon, 2 Jan 2012 18:17:31 +0530
Message-ID: <1325508451-22418-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65217 power management IC supports various features, like
Battery charger, white LED driver along with basic regulator
Functionality.

This patch set adds support as an MFD device into the kernel
to facilitate adding additional drivers on top of it.

This device is used on one of AM335x platform (BeagleBone), and
details about board can be accessed at -
http://beagleboard.org/bone

Device Spec and related documents can be accessed from -
http://www.ti.com/product/tps65217b

Changes form V1:
	- Incorporated all Mark Brown's review commets
	  * MFD read/writes API's modifed to use regmap read/writes
	  * kzalloc() changed to devm_kzalloc()
	  * Converted voltage tables to function calls
	  * set_voltage() changed to set_voltage_sel()
	- cleaned-up the code little bit

AnilKumar Ch (2):
  MFD: TPS65217: Add new mfd device for TPS65217
  TPS65217: Add tps65217 regulator driver

 drivers/mfd/Kconfig                    |   15 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/tps65217.c                 |  199 ++++++++++++++
 drivers/regulator/Kconfig              |    9 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65217-regulator.c |  459 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65217.h           |  271 +++++++++++++++++++
 7 files changed, 955 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps65217.c
 create mode 100644 drivers/regulator/tps65217-regulator.c
 create mode 100644 include/linux/mfd/tps65217.h

