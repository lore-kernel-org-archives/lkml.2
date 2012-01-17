Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab2AQNa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:30:29 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:1711
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389Ab2AQNa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:30:27 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzzz2dhc1ahc1bh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-FB-SS: 13,
Subject: [PATCH 00/07] DA9052 patch series
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <linux-kernel@vger.kernel.org>
CC: Dajun <dajun.chen@diasemi.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 18:55:48 +0530
Message-ID: <1326806748.3542.338.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series adds support for the features of Dialog Semiconductor
DA9052/53 PMICs.

The DA9052/53 PMICs support many functionalities like GPIOs, regulators,
power-supply, touchscreen, rtc, backlight, etc. So these patches are applicable
to different sub-systems of the kernel separately.

This patch series adds support for RTC, HWMON, Watchdog, Touch screen interface,
Backlight, LEDs and On-Key.

All of these patches depend on the MFD module for DA9052/53. There is no
other interdependence of patches.

Ashish Jangam (7):
	[RTC]: RTC module of DA9052/53 PMICs with time and alarm support.
	[HWMON]: Support for ADC of DA9052/53 PMICs.
	[Watchdog]: Watchdog support for DA9052/53 PMICs.
	[Touchscreen]: Driver for touch screen interface of DA9052/53 PMICs.
	[Backlight]: Backlight module for DA9052/53 PMICs.
	[LEDS]: Support for DA9052/53 LEDs.
	[On-Key]: Support for DA9052/53 on-key.

 drivers/hwmon/Kconfig                  |   10 +
 drivers/hwmon/Makefile                 |    1 +
 drivers/hwmon/da9052-hwmon.c           |  347 ++++++++++++++++++++++++++++++
 drivers/input/misc/Kconfig             |   10 +
 drivers/input/misc/Makefile            |    1 +
 drivers/input/misc/da9052_onkey.c      |  180 ++++++++++++++++
 drivers/input/touchscreen/Kconfig      |    7 +
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/da9052_tsi.c |  364 ++++++++++++++++++++++++++++++++
 drivers/leds/Kconfig                   |    8 +
 drivers/leds/Makefile                  |    1 +
 drivers/leds/leds-da9052.c             |  219 +++++++++++++++++++
 drivers/rtc/Kconfig                    |    7 +
 drivers/rtc/Makefile                   |    1 +
 drivers/rtc/rtc-da9052.c               |  308 +++++++++++++++++++++++++++
 drivers/video/backlight/Kconfig        |    6 +
 drivers/video/backlight/Makefile       |    1 +
 drivers/video/backlight/da9052_bl.c    |  196 +++++++++++++++++
 drivers/watchdog/Kconfig               |    6 +
 drivers/watchdog/Makefile              |    1 +
 drivers/watchdog/da9052_wdt.c          |  343 ++++++++++++++++++++++++++++++
 21 files changed, 2018 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/da9052-hwmon.c
 create mode 100644 drivers/input/misc/da9052_onkey.c
 create mode 100644 drivers/input/touchscreen/da9052_tsi.c
 create mode 100644 drivers/leds/leds-da9052.c
 create mode 100644 drivers/rtc/rtc-da9052.c
 create mode 100644 drivers/video/backlight/da9052_bl.c
 create mode 100644 drivers/watchdog/da9052_wdt.c


