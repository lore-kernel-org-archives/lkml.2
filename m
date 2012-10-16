Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab2JPHmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:42:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34667 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab2JPHm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:42:27 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH RESEND 0/8] TI Touchscreen driver updates and Support for TSC/ADC MFD driver
Date: Tue, 16 Oct 2012 12:55:37 +0530
Message-ID: <1350372345-27108-1-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a cumulative set of [1] and [2] sent earlier.
I have merged the patch set so that the MFD patches apply without
any issues.

Also Note that there are no code changes in either of the patch set,
only rebased on top of linux-next to make sure that all the patches
apply without any conflicts.

This patch set has been tested on AM335x EVM.

[1] "[PATCH 0/4] input: TSC: ti_tscadc: TI Touchscreen driver updates"
(http://www.spinics.net/lists/linux-input/msg22107.html)

[2] "[PATCH v5 0/4] Support for TSC/ADC MFD driver"
(http://www.spinics.net/lists/linux-input/msg22832.html)

Patil, Rachna (8):
  input: TSC: ti_tscadc: Correct register usage
  input: TSC: ti_tscadc: Add Step configuration as platform data
  input: TSC: ti_tscadc: set FIFO0 threshold Interrupt
  input: TSC: ti_tscadc: Remove definition of End Of Interrupt register
  input: TSC: ti_tscadc: Rename the existing touchscreen driver
  MFD: ti_tscadc: Add support for TI's TSC/ADC MFDevice
  input: TSC: ti_tsc: Convert TSC into a MFDevice
  IIO : ADC: tiadc: Add support of TI's ADC driver

 drivers/iio/adc/Kconfig                     |    7 +
 drivers/iio/adc/Makefile                    |    1 +
 drivers/iio/adc/ti_am335x_adc.c             |  260 ++++++++++++++
 drivers/input/touchscreen/Kconfig           |    6 +-
 drivers/input/touchscreen/Makefile          |    2 +-
 drivers/input/touchscreen/ti_am335x_tsc.c   |  398 ++++++++++++++++++++++
 drivers/input/touchscreen/ti_tscadc.c       |  486 ---------------------------
 drivers/mfd/Kconfig                         |   11 +
 drivers/mfd/Makefile                        |    1 +
 drivers/mfd/ti_am335x_tscadc.c              |  277 +++++++++++++++
 include/linux/input/ti_am335x_tsc.h         |   23 ++
 include/linux/input/ti_tscadc.h             |   17 -
 include/linux/mfd/ti_am335x_tscadc.h        |  152 +++++++++
 include/linux/platform_data/ti_am335x_adc.h |   14 +
 14 files changed, 1148 insertions(+), 507 deletions(-)
 create mode 100644 drivers/iio/adc/ti_am335x_adc.c
 create mode 100644 drivers/input/touchscreen/ti_am335x_tsc.c
 delete mode 100644 drivers/input/touchscreen/ti_tscadc.c
 create mode 100644 drivers/mfd/ti_am335x_tscadc.c
 create mode 100644 include/linux/input/ti_am335x_tsc.h
 delete mode 100644 include/linux/input/ti_tscadc.h
 create mode 100644 include/linux/mfd/ti_am335x_tscadc.h
 create mode 100644 include/linux/platform_data/ti_am335x_adc.h

