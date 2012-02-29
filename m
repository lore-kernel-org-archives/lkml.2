Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031144Ab2B2QZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:25:33 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:37907 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030302Ab2B2QZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:25:29 -0500
From: Arun Murthy <arun.murthy@stericsson.com>
To: <cbou@mail.ru>, <dwmw2@infradead.org>, <linux-kernel@vger.kernel.org>
Cc: <arun.murthy@stericsson.com>, <karl.komierowski@stericsson.com>,
        <johan.palsson@stericsson.com>, <linus.walleij@linaro.org>
Subject: [PATCH 0/4] AB8500 Battery Management Driver
Date: Wed, 29 Feb 2012 21:54:24 +0530
Message-ID: <1330532668-5673-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Technical reference manual is available at
http://www.stericsson.com/developers/CD00291561_UM1031_AB8500_user_manual-rev5_CTDS_public.pdf

AB8500 battery driver consists of
	Generic charging algorithm(abx500-chargalg.c)
	Charger driver(ab8500-charger.c)
	Fuel Gauge driver(ab8500-fg.c)
	Battery temperature driver(ab8500-btemp.c)
The power supply class driver can act as a supply as well as supplicant. Any
state change in one power supply class driver can be notified to its
supplicants using notification mechanism provided by Power Supply Class frame
work. Each Power supply class driver lists its supplicant names in "supplied_to"
struct member, and each power_supply_changed() call issued by power supply class
driver will notify supplicants via external_power_changed callback.

Charging Algorithm:
	Hardware independent driver
	Enables/Disables charger and kicks charger watchdog
	Supports both AC/Mains and USB charging.
		Main charger takes precedense over USB charging
	Supports CCCV charging
	End Of Charge(EOC) detection
	Maintenance charging
	Safety checks and measurements taken
		charging safety timer expired
		charger & battery  temperature high/low
		charging watchdog expired
		charger & battery over voltage
		battery removal

Fuel Gauge:
	Voltage mode
		When current consumption is low, battery voltage is used to
		derive the battery capacity and also during start-up this
		mode is used.
	Fuel Gauge mode
		When current consumption is high or while charging fuel gauge
		is used to obtain accumulated charge. Using this and the known
		battery full charge, capacity is calculated.

Arun Murthy (4):
  power: abx500-chargalg: Add abx500 charging algorithm
  power: ab8500-charger: AB8500 charger driver
  power: ab8500-fg: A8500 fuel gauge driver
  power: ab8500-btemp: AB8500 battery temperature driver

 drivers/power/Kconfig                     |   12 +
 drivers/power/Makefile                    |    1 +
 drivers/power/ab8500_btemp.c              | 1123 ++++++++++++
 drivers/power/ab8500_charger.c            | 2789 +++++++++++++++++++++++++++++
 drivers/power/ab8500_fg.c                 | 2636 +++++++++++++++++++++++++++
 drivers/power/abx500_chargalg.c           | 1921 ++++++++++++++++++++
 include/linux/mfd/abx500.h                |  273 +++
 include/linux/mfd/abx500/ab8500-bm.h      |  554 ++++++
 include/linux/mfd/abx500/ux500_chargalg.h |   38 +
 9 files changed, 9347 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/ab8500_btemp.c
 create mode 100644 drivers/power/ab8500_charger.c
 create mode 100644 drivers/power/ab8500_fg.c
 create mode 100644 drivers/power/abx500_chargalg.c
 create mode 100644 include/linux/mfd/abx500/ab8500-bm.h
 create mode 100644 include/linux/mfd/abx500/ux500_chargalg.h

-- 
1.7.4.3

