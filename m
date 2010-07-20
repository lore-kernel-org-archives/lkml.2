Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab0GTG5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 02:57:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40252 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab0GTG5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 02:57:09 -0400
Date: Tue, 20 Jul 2010 15:57:06 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 0/3] MAX8998 changes for RTC
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, akpm@linux-foundation.org, a.zummo@towertech.it,
        gortmaker@yahoo.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com
Message-id: <4C4548C2.8030506@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 20 Jul 2010 06:57:07.0124 (UTC)
 FILETIME=[C4600F40:01CB27D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This patchset is to support the RTC provided by the Maxim 8998 chip. For
this first, needs i2c interface changes and interrupts support of 
max8998 mfd driver.

This patchset was created from below patch:
[PATCH v2] regulator: MAX8998: set_voltage bugfix. ramp_up delay and min/max voltage

Joonyoung Shim (3):
      mfd: MAX8998: Use struct i2c_client to argument on i2c operation functions
      mfd: MAX8998: Add interrupts support
      rtc: Add MAX8998 rtc driver

 drivers/mfd/Kconfig                 |    2 +-
 drivers/mfd/Makefile                |    2 +-
 drivers/mfd/max8998-irq.c           |  255 +++++++++++++++++++++++++++++
 drivers/mfd/max8998.c               |   75 +++++++--
 drivers/regulator/max8998.c         |   21 ++-
 drivers/rtc/Kconfig                 |   10 ++
 drivers/rtc/Makefile                |    1 +
 drivers/rtc/rtc-max8998.c           |  299 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8998-private.h |  106 +++++++++---
 include/linux/mfd/max8998.h         |   11 +-
 10 files changed, 725 insertions(+), 57 deletions(-)
 create mode 100644 drivers/mfd/max8998-irq.c
 create mode 100644 drivers/rtc/rtc-max8998.c
