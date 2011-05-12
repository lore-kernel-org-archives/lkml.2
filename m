Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab1ELSlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:41:49 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:43273 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688Ab1ELSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:41:44 -0400
MIME-Version: 1.0
Date: Thu, 12 May 2011 13:41:41 -0500
Message-ID: <BANLkTino4xWYZOA1Yjy8u5usn43MmWtO5Q@mail.gmail.com>
Subject: [PATCHv2 0/4] Initial TPS65912 PMIC driver
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

This is the initial version of the TPS65912 PMIC, a power management
IC for multimedia products.

The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
voltage to main processor and other components. The chip includes a
GPIO module.

Changes from V1:
- tps65912 depends on I2C or SPI
- group tps65912 in makefile with others tps
- move read/write, reg_read and reg_write to the core file
- cleanup the header file
- add first irq support then gpio
- move tps65912-gpio to drivers/gpio directory
- remove and replace by calculations the voltages tables
- use clear and set bits in regulator driver

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
 drivers/mfd/tps65912.c                 |  429 +++++++++++++++++
 drivers/regulator/Kconfig              |    6 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps65912-regulator.c |  810 ++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65912.h           |  329 +++++++++++++
 11 files changed, 1975 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/tps65912-gpio.c
 create mode 100644 drivers/mfd/tps65912-irq.c
 create mode 100644 drivers/mfd/tps65912.c
 create mode 100644 drivers/regulator/tps65912-regulator.c
 create mode 100644 include/linux/mfd/tps65912.h
