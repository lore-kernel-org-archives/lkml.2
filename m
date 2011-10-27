Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1J0H6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:58:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39109 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1J0H6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:58:50 -0400
From: Rajendra Nayak <rnayak@ti.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <tony@atomide.com>,
        <lrg@ti.com>, <b-cousson@ti.com>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@freescale.com>,
        Rajendra Nayak <rnayak@ti.com>
Subject: [PATCH v3 0/4] Device tree support for regulators
Date: Thu, 27 Oct 2011 13:26:21 +0530
Message-ID: <1319702185-16108-1-git-send-email-rnayak@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Grant,

v3 is based on the latest devicetree/next and is tested
(with twl adaptaions, which will be posted seperately)
on the OMAP4 panda and OMAP4 sdp boards.

The patches can be found here:
git://gitorious.org/omap-pm/linux.git for-dt/regulator

major changes in v3:
-1- Dropped "regulator: twl: Remove hardcoded board constraints from driver"
from the series.
-2- Added of_node as an additional paramter to regulator_register()
mainly done in new patch added,
"regulator: pass additional of_node to regulator_register()"
-3- Dropped some of the generic regulator bindings to be revisted later.

Thanks to Shawn Guo for bringing out the issue with the previous
series which did not handle cases of regulator drivers implemented
with one virtual device modeling all regulators.

regards,
Rajendra

Rajendra Nayak (4):
  regulator: helper routine to extract regulator_init_data
  regulator: adapt fixed regulator driver to dt
  regulator: pass additional of_node to regulator_register()
  regulator: map consumer regulator based on device tree

 .../bindings/regulator/fixed-regulator.txt         |   25 ++++++
 .../devicetree/bindings/regulator/regulator.txt    |   32 ++++++++
 drivers/regulator/88pm8607.c                       |    2 +-
 drivers/regulator/Kconfig                          |    7 ++
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/aat2870-regulator.c              |    2 +-
 drivers/regulator/ab3100.c                         |    2 +-
 drivers/regulator/ab8500.c                         |    2 +-
 drivers/regulator/ad5398.c                         |    2 +-
 drivers/regulator/bq24022.c                        |    2 +-
 drivers/regulator/core.c                           |   82 ++++++++++++++++---
 drivers/regulator/da903x.c                         |    2 +-
 drivers/regulator/db8500-prcmu.c                   |    2 +-
 drivers/regulator/dummy.c                          |    2 +-
 drivers/regulator/fixed.c                          |   59 ++++++++++++++-
 drivers/regulator/isl6271a-regulator.c             |    2 +-
 drivers/regulator/lp3971.c                         |    2 +-
 drivers/regulator/lp3972.c                         |    2 +-
 drivers/regulator/max1586.c                        |    2 +-
 drivers/regulator/max8649.c                        |    2 +-
 drivers/regulator/max8660.c                        |    2 +-
 drivers/regulator/max8925-regulator.c              |    2 +-
 drivers/regulator/max8952.c                        |    2 +-
 drivers/regulator/max8997.c                        |    2 +-
 drivers/regulator/max8998.c                        |    2 +-
 drivers/regulator/mc13783-regulator.c              |    2 +-
 drivers/regulator/mc13892-regulator.c              |    2 +-
 drivers/regulator/of_regulator.c                   |   66 ++++++++++++++++
 drivers/regulator/pcap-regulator.c                 |    2 +-
 drivers/regulator/pcf50633-regulator.c             |    2 +-
 drivers/regulator/tps6105x-regulator.c             |    3 +-
 drivers/regulator/tps65023-regulator.c             |    2 +-
 drivers/regulator/tps6507x-regulator.c             |    2 +-
 drivers/regulator/tps6524x-regulator.c             |    2 +-
 drivers/regulator/tps6586x-regulator.c             |    2 +-
 drivers/regulator/tps65910-regulator.c             |    2 +-
 drivers/regulator/tps65912-regulator.c             |    2 +-
 drivers/regulator/twl-regulator.c                  |    2 +-
 drivers/regulator/wm831x-dcdc.c                    |    8 +-
 drivers/regulator/wm831x-isink.c                   |    2 +-
 drivers/regulator/wm831x-ldo.c                     |    6 +-
 drivers/regulator/wm8350-regulator.c               |    2 +-
 drivers/regulator/wm8400-regulator.c               |    2 +-
 drivers/regulator/wm8994-regulator.c               |    2 +-
 include/linux/regulator/driver.h                   |    4 +-
 include/linux/regulator/of_regulator.h             |   20 +++++
 sound/soc/codecs/sgtl5000.c                        |    2 +-
 47 files changed, 325 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/fixed-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/regulator.txt
 create mode 100644 drivers/regulator/of_regulator.c
 create mode 100644 include/linux/regulator/of_regulator.h

