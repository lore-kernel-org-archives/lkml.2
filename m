Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2IMK73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:59:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48175 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab2IMK71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:59:27 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH v3 0/5] Support for TSC/ADC MFD driver
Date: Thu, 13 Sep 2012 16:10:14 +0530
Message-ID: <1347532819-505-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a MFD core driver which registers
touchscreen and ADC as its client drivers.
The existing touchscreen has been modified to work as
a MFD client driver and a new ADC driver has been added
in the IIO subsystem.

There are 8 analog input lines, which can be used as:
1. 8 general purpose ADC channels
2. 4 wire TS, with 4 general purpose ADC channels
3. 5 wire TS, with 3 general purpose ADC channels

This patch set has been tested on AM335x EVM.

These set of patches are based on top of Touchscreen patch
set submitted.
Subject: [PATCH 0/4] input: TSC: ti_tscadc: TI Touchscreen driver updates [1]

[1] http://www.spinics.net/lists/linux-input/msg22107.html

Changes in v2:
	Dropped one patch send in the last version after
	receiving internal comments. I have merged the changes
	into existing patches.
	Also added a new patch to support suspend/resume feature.
	Fixed review comments by Matthias Kaehlcke.

Changes in v3:
	Addressed review comments by Jonathan Cameron.
	Improved ADC driver with more readable labels,
	spaces and comments.

Patil, Rachna (5):
  input: TSC: ti_tscadc: Rename the existing touchscreen driver
  MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
  input: TSC: ti_tsc: Convert TSC into a MFDevice
  IIO : ADC: tiadc: Add support of TI's ADC driver
  MFD: ti_tscadc: add suspend/resume functionality

 drivers/iio/adc/Kconfig                            |    7 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/ti_adc.c                           |  255 ++++++++++++++++
 drivers/input/touchscreen/Kconfig                  |    4 +-
 drivers/input/touchscreen/Makefile                 |    2 +-
 .../input/touchscreen/{ti_tscadc.c => ti_tsc.c}    |  310 ++++++--------------
 drivers/mfd/Kconfig                                |    9 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/ti_tscadc.c                            |  251 ++++++++++++++++
 include/linux/input/{ti_tscadc.h => ti_tsc.h}      |    4 +-
 include/linux/mfd/ti_tscadc.h                      |  151 ++++++++++
 include/linux/platform_data/ti_adc.h               |   14 +
 12 files changed, 781 insertions(+), 228 deletions(-)
 create mode 100644 drivers/iio/adc/ti_adc.c
 rename drivers/input/touchscreen/{ti_tscadc.c => ti_tsc.c} (55%)
 create mode 100644 drivers/mfd/ti_tscadc.c
 rename include/linux/input/{ti_tscadc.h => ti_tsc.h} (90%)
 create mode 100644 include/linux/mfd/ti_tscadc.h
 create mode 100644 include/linux/platform_data/ti_adc.h

