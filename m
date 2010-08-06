Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935297Ab0HFC2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:28:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64522 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935257Ab0HFC17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:27:59 -0400
Date: Fri, 06 Aug 2010 11:27:57 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v3 0/3] MAX8998 changes for RTC
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, akpm@linux-foundation.org, a.zummo@towertech.it,
        p_gortmaker@yahoo.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com
Message-id: <4C5B732D.8000301@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 06 Aug 2010 02:27:57.0270 (UTC)
 FILETIME=[FB55A760:01CB350E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This patchset is to support the RTC provided by the Maxim 8998 chip. For
this first, needs i2c interface changes and interrupts support of
max8998 mfd driver.

Changes since v1:
 - Fix missing braces of 3/3 patch from v1 review.
 - The rest is same with v1.

Changes since v2:
 - add missing free_irq and rtc_valid_tm on rtc driver of 3/3 patch
 - The rest is same with v2.

Joonyoung Shim (3):
      mfd: MAX8998: Use struct i2c_client to argument on i2c operation functions
      mfd: MAX8998: Add interrupts support
      rtc: Add MAX8998 rtc driver

 drivers/mfd/Kconfig                 |    2 +-
 drivers/mfd/Makefile                |    2 +-
 drivers/mfd/max8998-irq.c           |  255 +++++++++++++++++++++++++++++
 drivers/mfd/max8998.c               |   78 +++++++--
 drivers/regulator/max8998.c         |   17 ++-
 drivers/rtc/Kconfig                 |   10 ++
 drivers/rtc/Makefile                |    1 +
 drivers/rtc/rtc-max8998.c           |  300 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8998-private.h |  106 +++++++++---
 include/linux/mfd/max8998.h         |   11 +-
 10 files changed, 726 insertions(+), 56 deletions(-)
 create mode 100644 drivers/mfd/max8998-irq.c
 create mode 100644 drivers/rtc/rtc-max8998.c
