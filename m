Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967904Ab2ERJcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:32:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13858 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967180Ab2ERJcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:32:32 -0400
X-AuditID: cbfee61b-b7bb6ae0000006fb-0b-4fb6172f0d46
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <trg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH v3 0/3] Add initial support for MAXIM 77686 mfd chip
Date: Fri, 18 May 2012 18:32:16 +0900
Message-id: <1337333539-18371-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for MAX77686 which is a multifunction device including
regulator and rtc. It also includes drivers supporting rtc and regulator.
All drivers are based on MAX8997 driver and use regmap to access to registers.
To manage IRQs occured by max77686, It supports IRQ domain.

v3:
Changes in mfd core:
- Remove APIs accessing to register ( e.g. max77686_read_reg() )
  to use regmap's API directly over all related drivers.

Changes in regulator driver:
- Convert get_voltage to get_voltage_sel
- Convert set_voltage to set_voltage_sel
- Implement set_voltage_time_sel
- Register regulators unconditionally
- kzalloc -> devm_kzalloc
- Remove unneccessary printk
- Keep probing whether pdata exists or not
- Use regmap API to access to PMIC register.

Changes in rtc driver:
- Use regmap API to access to RTC register.

v2:
http://thread.gmane.org/gmane.linux.kernel/1295479

This patch set is tested on TRATS boards.

Jonghwa Lee (3):
  mfd: MAX77686: Add Maxim 77686 mfd driver
  regulator: MAX77686: Add Maxim 77686 regulator driver
  rtc: MAX77686: Add Maxim 77686 rtc driver

 drivers/mfd/Kconfig                  |   11 +
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77686-irq.c           |  327 ++++++++++++++
 drivers/mfd/max77686.c               |  156 +++++++
 drivers/regulator/Kconfig            |    8 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/max77686.c         |  783 ++++++++++++++++++++++++++++++++++
 drivers/rtc/Kconfig                  |   20 +
 drivers/rtc/Makefile                 |    4 +-
 drivers/rtc/rtc-max77686.c           |  668 +++++++++++++++++++++++++++++
 include/linux/mfd/max77686-private.h |  247 +++++++++++
 include/linux/mfd/max77686.h         |  117 +++++
 12 files changed, 2342 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/max77686-irq.c
 create mode 100644 drivers/mfd/max77686.c
 create mode 100644 drivers/regulator/max77686.c
 create mode 100644 drivers/rtc/rtc-max77686.c
 create mode 100644 include/linux/mfd/max77686-private.h
 create mode 100644 include/linux/mfd/max77686.h

-- 
1.7.4.1

