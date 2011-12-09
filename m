Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1LIOTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:19:09 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:43085 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1LIOTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:19:07 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzc89bhzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 13,
Subject: [PATCH 00/06] DA9052 patch series
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Dajun <dajun.chen@diasemi.com>,
        <arnd@arndb.de>, <linaro-dev@lists.linaro.org>, <eric.miao@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 9 Dec 2011 19:45:24 +0530
Message-ID: <1323440124.23171.68.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-Originating-IP: [10.10.38.47]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿The following patch series adds initial support for the Dialog Semiconductor
DA9052/53 PMICs.

The DA9052/53 PMICs support many functionalities like GPIOs, regulators,
power-supply, touchscreen, rtc, backlight, etc. So these patches are applicable
to different sub-systems of the kernel separately.

This patch series adds support for MFD, Regulator, Battery and GPIO. Support
for rest of the devices will be added later.

All the other patches depend on the MFD module of the patch series. There is no
other interdependance of patches.

Ashish Jangam (6):
	[MFD]: Core module of DA9052/53 PMICs with I2C and regmap support.
	[MFD]: Incremental with ADC support. Battery patch also depends on this.
	[MFD]: Incremental with SPI support.
	GPIO: Incremental patch for DA9052/53 PMICs gpio driver.
	[REGULATOR]: Support for DA9052/53 PMICs regulators.
	[POWER]: Support for DA9052/53 battery.

 drivers/gpio/gpio-da9052.c           |   26 +-
 drivers/mfd/Kconfig                  |   28 ++
 drivers/mfd/Makefile                 |    5 +
 drivers/mfd/da9052-core.c            |  553 ++++++++++++++++++++++++
 drivers/mfd/da9052-i2c.c             |  144 +++++++
 drivers/mfd/da9052-spi.c             |  121 ++++++
 drivers/power/Kconfig                |    7 +
 drivers/power/Makefile               |    1 +
 drivers/power/da9052-battery.c       |  615 +++++++++++++++++++++++++++
 drivers/regulator/Kconfig            |    7 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9052-regulator.c |  600 ++++++++++++++++++++++++++
 include/linux/mfd/da9052/da9052.h    |  173 ++++++++
 include/linux/mfd/da9052/gpio.h      |   46 ++
 include/linux/mfd/da9052/pdata.h     |   40 ++
 include/linux/mfd/da9052/reg.h       |  778 ++++++++++++++++++++++++++++++++++
 16 files changed, 3122 insertions(+), 23 deletions(-)
 create mode 100644 drivers/mfd/da9052-core.c
 create mode 100644 drivers/mfd/da9052-i2c.c
 create mode 100644 drivers/mfd/da9052-spi.c
 create mode 100644 drivers/power/da9052-battery.c
 create mode 100644 drivers/regulator/da9052-regulator.c
 create mode 100644 include/linux/mfd/da9052/da9052.h
 create mode 100644 include/linux/mfd/da9052/gpio.h
 create mode 100644 include/linux/mfd/da9052/pdata.h
 create mode 100644 include/linux/mfd/da9052/reg.h


