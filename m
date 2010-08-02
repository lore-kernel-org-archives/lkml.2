Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0HBHem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:34:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52711 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0HBHel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:34:41 -0400
Date: Mon, 02 Aug 2010 16:34:40 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 0/3] MAX8998 changes for RTC
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, akpm@linux-foundation.org, a.zummo@towertech.it,
        p_gortmaker@yahoo.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com
Message-id: <4C567510.4070903@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
X-OriginalArrivalTime: 02 Aug 2010 07:34:40.0085 (UTC)
 FILETIME=[2A9D6050:01CB3215]
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
 drivers/rtc/rtc-max8998.c           |  299 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8998-private.h |  106 +++++++++---
 include/linux/mfd/max8998.h         |   11 +-
 10 files changed, 725 insertions(+), 56 deletions(-)
 create mode 100644 drivers/mfd/max8998-irq.c
 create mode 100644 drivers/rtc/rtc-max8998.c
