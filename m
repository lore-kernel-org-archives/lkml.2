Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab2AKKlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:41:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37112 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2AKKlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:41:36 -0500
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH V4 0/2] Add TI TPS65217 PMIC driver support
Date: Wed, 11 Jan 2012 16:11:26 +0530
Message-ID: <1326278486-27162-1-git-send-email-anilkumar@ti.com>
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

Changes form V3:
	- Incorporated all Mark Brown's review commets on V3
	  * changed non uniform step-size voltage range API to a table
	  * Implemented set_voltage for formula based regulators
	  * Implemented set_voltage_sel for table based regulators
	  * changed get_voltage to get_voltage_sel

Changes form V2:
	- Incorporated all Mark Brown's review commets on V2
	  * clear/set bit API's moved to MFD driver
	  * voltage range API's clean-up

Changes form V1:
	- Incorporated all Mark Brown's review commets
	  * MFD read/writes API's modifed to use regmap read/writes
	  * kzalloc() changed to devm_kzalloc()
	  * Converted voltage tables to function calls
	  * set_voltage() changed to set_voltage_sel()
	- cleaned-up the code little bit

AnilKumar Ch (2):
  MFD: TPS65217: Add new mfd device for TPS65217
  regulator: tps65217: Add tps65217 regulator driver

 drivers/mfd/Kconfig                    |   15 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/tps65217.c                 |  242 ++++++++++++++++
 drivers/regulator/Kconfig              |    9 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65217-regulator.c |  493 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65217.h           |  283 ++++++++++++++++++
 7 files changed, 1044 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps65217.c
 create mode 100644 drivers/regulator/tps65217-regulator.c
 create mode 100644 include/linux/mfd/tps65217.h

