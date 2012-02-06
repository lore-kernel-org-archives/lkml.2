Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2BFMn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:43:26 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:26500
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755008Ab2BFMnY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:43:24 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzc89bhzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 00/07] DA9052 patch series
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <linux-kernel@vger.kernel.org>
CC: Dajun <dajun.chen@diasemi.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-watchdog@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 6 Feb 2012 18:05:55 +0530
Message-ID: <1328531755.30549.67.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-Originating-IP: [10.10.38.47]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿﻿The following patch series adds support for the various features of
Dialog Semiconductor DA9052/53 PMICs.

The DA9052/53 PMICs support many functionalities like GPIOs, regulators,
power-supply, touchscreen, rtc, backlight, etc. So these patches are
applicable to different sub-systems of the kernel separately.

This patch series adds support for ADC functionality in MFD, HWMON,
LEDS, Backlight, Watchdog, RTC and TSI. Support for rest of the devices
will be added later.

The HWMON patch depends on the patch for ADC functionality in MFD
module.

Ashish Jangam (7):
	[MFD]: Incremental ADC support. HWMON patch also depends on this
	[HWMON]: HWMON driver for DA9052/53 PMICs.
	[LEDS]: Support for DA9052/53 LEDS.
	[Backlight]: Support for DA9052/53 white LED / backlight.
	[Watchdog]: Watchdog driver for DA9052/53 PMICs.
	[RTC]: RTC driver for DA9052/53 PMICs.
	[TSI]: Support for Touch screen interface for DA9052/53 PMICs.

 Documentation/hwmon/da9052                     |   59 ++++
 Documentation/watchdog/watchdog-parameters.txt |    5 +
 drivers/hwmon/Kconfig                          |   10 +
 drivers/hwmon/Makefile                         |    1 +
 drivers/hwmon/da9052-hwmon.c                   |  343
+++++++++++++++++++++++
 drivers/input/touchscreen/Kconfig              |    7 +
 drivers/input/touchscreen/Makefile             |    1 +
 drivers/input/touchscreen/da9052_tsi.c         |  353
++++++++++++++++++++++++
 drivers/leds/Kconfig                           |    8 +
 drivers/leds/Makefile                          |    1 +
 drivers/leds/leds-da9052.c                     |  214 ++++++++++++++
 drivers/mfd/da9052-core.c                      |  134 +++++++++
 drivers/rtc/Kconfig                            |    7 +
 drivers/rtc/Makefile                           |    1 +
 drivers/rtc/rtc-da9052.c                       |  293
++++++++++++++++++++
 drivers/video/backlight/Kconfig                |    6 +
 drivers/video/backlight/Makefile               |    1 +
 drivers/video/backlight/da9052_bl.c            |  187 +++++++++++++
 drivers/watchdog/Kconfig                       |    6 +
 drivers/watchdog/Makefile                      |    1 +
 drivers/watchdog/da9052_wdt.c                  |  333
++++++++++++++++++++++
 include/linux/mfd/da9052/da9052.h              |   17 ++
 22 files changed, 1988 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/da9052
 create mode 100644 drivers/hwmon/da9052-hwmon.c
 create mode 100644 drivers/input/touchscreen/da9052_tsi.c
 create mode 100644 drivers/leds/leds-da9052.c
 create mode 100644 drivers/rtc/rtc-da9052.c
 create mode 100644 drivers/video/backlight/da9052_bl.c
 create mode 100644 drivers/watchdog/da9052_wdt.c


