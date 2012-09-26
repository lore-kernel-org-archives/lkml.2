Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2IZFiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:38:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33209 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab2IZFis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:38:48 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH v4 0/5] Support for TSC/ADC MFD driver
Date: Wed, 26 Sep 2012 10:50:09 +0530
Message-ID: <1348636814-14129-1-git-send-email-rachna@ti.com>
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

Changes in v4:
	Renamed the drivers from ti_xxx to ti_am335x_xxx.
	For consistency with other drivers renamed idev to indio_dev
	in IIO ADC driver.
	Replaced suspend/resume callbacks with dev_pm_ops.

Patil, Rachna (5):
  input: TSC: ti_tscadc: Rename the existing touchscreen driver
  MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
  input: TSC: ti_tsc: Convert TSC into a MFDevice
  IIO : ADC: tiadc: Add support of TI's ADC driver
  MFD: ti_tscadc: add suspend/resume functionality

 drivers/iio/adc/Kconfig                            |    7 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/ti_am335x_adc.c                    |  258 ++++++++++++++++
 drivers/input/touchscreen/Kconfig                  |    4 +-
 drivers/input/touchscreen/Makefile                 |    2 +-
 .../touchscreen/{ti_tscadc.c => ti_am335x_tsc.c}   |  319 ++++++--------------
 drivers/mfd/Kconfig                                |    9 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/ti_am335x_tscadc.c                     |  259 ++++++++++++++++
 .../linux/input/{ti_tscadc.h => ti_am335x_tsc.h}   |    4 +-
 include/linux/mfd/ti_am335x_tscadc.h               |  151 +++++++++
 include/linux/platform_data/ti_am335x_adc.h        |   14 +
 12 files changed, 801 insertions(+), 228 deletions(-)
 create mode 100644 drivers/iio/adc/ti_am335x_adc.c
 rename drivers/input/touchscreen/{ti_tscadc.c => ti_am335x_tsc.c} (55%)
 create mode 100644 drivers/mfd/ti_am335x_tscadc.c
 rename include/linux/input/{ti_tscadc.h => ti_am335x_tsc.h} (88%)
 create mode 100644 include/linux/mfd/ti_am335x_tscadc.h
 create mode 100644 include/linux/platform_data/ti_am335x_adc.h

