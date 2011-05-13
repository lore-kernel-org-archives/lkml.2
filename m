Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800Ab1EMVaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 17:30:17 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47991 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759588Ab1EMVaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 17:30:14 -0400
MIME-Version: 1.0
Date: Fri, 13 May 2011 16:30:11 -0500
Message-ID: <BANLkTikVsZcvVLE=w53R3HZEMboVuSnihA@mail.gmail.com>
Subject: [PATCHv3 0/4] Initial support for TPS65912 PMIC
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the initial version of the TPS65912 PMIC, a power managment IC
for multimedia products.

The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
voltage to main processor and other components. The chip includes a
GPIO module.

Changes from V2:
- include regulator id fix
- correct irq handler comment
- use correct platform data struct at probe
- free memory allocated
- fix initialisations at spi read/write functions.

Margarita Olaya Cabrera (4):
  mfd: tps65912: Add new mfd device
  tps65912: irq: add interrupt controller
  tps65912: gpio: add gpio driver
  tps65912: add regulator driver

 drivers/gpio/Kconfig                   |    6 +
 drivers/gpio/Makefile                  |    1 +
 drivers/gpio/tps65912-gpio.c           |  159 +++++++
 drivers/mfd/Kconfig                    |    8 +
 drivers/mfd/Makefile                   |    1 +
 drivers/mfd/tps65912-irq.c             |  225 +++++++++
 drivers/mfd/tps65912.c                 |  441 +++++++++++++++++
 drivers/regulator/Kconfig              |    6 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65912-regulator.c |  809 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65912.h           |  329 +++++++++++++
 11 files changed, 1986 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/tps65912-gpio.c
 create mode 100644 drivers/mfd/tps65912-irq.c
 create mode 100644 drivers/mfd/tps65912.c
 create mode 100644 drivers/regulator/tps65912-regulator.c
 create mode 100644 include/linux/mfd/tps65912.h
