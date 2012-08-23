Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab2HWLFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:05:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37087 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab2HWLEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:04:55 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH 0/5] Support for TSC/ADC MFD driver
Date: Thu, 23 Aug 2012 16:18:05 +0530
Message-ID: <1345718886-15737-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.1
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

Patil, Rachna (5):
  input: TSC: ti_tscadc: Rename the existing touchscreen driver
  MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
  input: TSC: ti_tsc: Convert TSC into a MFDevice
  IIO : ADC: tiadc: Add support of TI's ADC driver
  MFD: ti_tscadc: Add check on number of i/p channels

 drivers/iio/adc/Kconfig               |    7 +
 drivers/iio/adc/Makefile              |    1 +
 drivers/iio/adc/ti_adc.c              |  219 ++++++++++++++
 drivers/input/touchscreen/Kconfig     |    4 +-
 drivers/input/touchscreen/Makefile    |    2 +-
 drivers/input/touchscreen/ti_tsc.c    |  358 ++++++++++++++++++++++
 drivers/input/touchscreen/ti_tscadc.c |  522 ---------------------------------
 drivers/mfd/Kconfig                   |    9 +
 drivers/mfd/Makefile                  |    1 +
 drivers/mfd/ti_tscadc.c               |  218 ++++++++++++++
 include/linux/mfd/ti_tscadc.h         |  146 +++++++++
 include/linux/platform_data/ti_adc.h  |    9 +
 12 files changed, 971 insertions(+), 525 deletions(-)
 create mode 100644 drivers/iio/adc/ti_adc.c
 create mode 100644 drivers/input/touchscreen/ti_tsc.c
 delete mode 100644 drivers/input/touchscreen/ti_tscadc.c
 create mode 100644 drivers/mfd/ti_tscadc.c
 create mode 100644 include/linux/mfd/ti_tscadc.h
 create mode 100644 include/linux/platform_data/ti_adc.h

