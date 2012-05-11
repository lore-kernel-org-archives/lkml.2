Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab2EKGgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:36:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8826 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117Ab2EKGgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:36:35 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-b5-4facb3728cb1
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <trg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 0/3] mfd: MAX77686: Add initial support for MAXIMG 77686 mfd
 chip
Date: Fri, 11 May 2012 15:36:14 +0900
Message-id: <1336718177-9258-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds suppport for MAX77686 which is a multifunction device including
regulator and rtc. It also contains drivers supporting rtc and regulator.
All drivers ard based on MAX8997 dirvers and use regmap to access to the inner registers.
To manage IRQs occuered by max77686, it supports IRQ domain.

First patch is for mfd core driver ,second patch is for regulator,
and third is for rtc.

It is tested on TRATS boards.

Jonghwa Lee (3):
  mfd: MAX77686: Add Maxim 77686 mfd driver
  regulator: MAX77686: Add Maxim 77686 regulator driver
  rtc: MAX77686: Add Maxim 77686 rtc driver

 drivers/mfd/Kconfig                  |    2 +-
 drivers/mfd/Makefile                 |    2 +-
 drivers/mfd/max77686-irq.c           |  109 ++---
 drivers/mfd/max77686.c               |  193 +--------
 drivers/regulator/Kconfig            |    8 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/max77686.c         |  809 ++++++++++++++++++++++++++++++++++
 drivers/rtc/Kconfig                  |   10 +
 drivers/rtc/Makefile                 |    5 +-
 drivers/rtc/rtc-max77686.c           |  667 ++++++++++++++++++++++++++++
 include/linux/mfd/max77686-private.h |   54 +--
 include/linux/mfd/max77686.h         |   23 +-
 12 files changed, 1577 insertions(+), 306 deletions(-)
 create mode 100644 drivers/regulator/max77686.c
 create mode 100644 drivers/rtc/rtc-max77686.c

-- 
1.7.4.1

