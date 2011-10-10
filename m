Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab1JJQVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:21:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45263 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab1JJQVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:21:11 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <lrg@ti.com>, <b-cousson@ti.com>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH v2 0/5] Device tree support for regulators
Date: Mon, 10 Oct 2011 21:49:33 +0530
Message-ID: <1318263578-7407-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Grant,

I have reworked the regulator-dt-suppport series based
on your reviews and also split it so I remove any dependency
with the omap specific dt conversion for i2c/twl.
So this latest series is based on mainline 3.1-rc9.

I will post the twl-regulator driver adaptation to dt and
the omap-panda/omap-sdp board regulator data being
passed from dt as a seperate series.

changes in v2:
-1- removed the int to u32 convertions as -ve voltages do exist
-2- merged patches to support fixed voltage regulator dt adaptation
-3- added support for regulator_get() without a device associated (ex: cpufreq)
-4- used same binding for regulator<->consumer and regulator<->parent mapping

regards,
Rajendra

Rajendra Nayak (5):
  regulator: twl: Remove hardcoded board constraints from driver
  dt: add empty dt helpers for non-dt build
  regulator: helper routine to extract regulator_init_data
  regulator: adapt fixed regulator driver to dt
  regulator: map consumer regulator based on device tree

 .../bindings/regulator/fixed-regulator.txt         |   24 +++++
 .../devicetree/bindings/regulator/regulator.txt    |   44 +++++++++
 drivers/regulator/Kconfig                          |    8 ++
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/core.c                           |   91 ++++++++++++++++---
 drivers/regulator/fixed.c                          |   58 ++++++++++++
 drivers/regulator/of_regulator.c                   |   93 ++++++++++++++++++++
 drivers/regulator/twl-regulator.c                  |    8 --
 include/linux/of.h                                 |   19 ++++
 include/linux/regulator/driver.h                   |    2 +
 include/linux/regulator/of_regulator.h             |   21 +++++
 11 files changed, 346 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/fixed-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/regulator.txt
 create mode 100644 drivers/regulator/of_regulator.c
 create mode 100644 include/linux/regulator/of_regulator.h

