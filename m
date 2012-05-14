Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2ENLkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:40:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23978 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2ENLkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:40:04 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-03-4fb0ef12d5fe
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v4 0/2] MAX77693: add initial MAX77693 MFD driver
Date: Mon, 14 May 2012 20:39:52 +0900
Message-id: <1336995592-1505-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77693 is sub PMIC(Power Management IC) working
with other main PMIC. It has several features:
-PMIC
-MUIC(Micro USB Interface Controller)
-Camera flash LED control
-Haptic motor control

This patch adds initial basis for several devices.
It is tested on TRATS board.

v4
- Use regmap_update_bits to update max77693 register
- Add max_register field to struct regmap_config for debugfs
- Use devm_regmap_init_i2c() to register regmap instaad of
  regmap_init_i2c()
- Fix typo and remove unnecessary code
- Set irq domain for MAX77693 interrupts regardless of max77693->irq

v3
- Add support irq domain for MAX77693 interrupts
- Apply regmap for i2c

v2
- with comments from Mark
- use devm_kzalloc rather than kzalloc
- print device ID read from device

Chanwoo Choi (2):
  MFD: MAX77693: add MAX77693 MFD driver
  MFD: MAX77693: add IRQ handler

 drivers/mfd/Kconfig                  |   12 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77693-irq.c           |  309 ++++++++++++++++++++++++++++++++++
 drivers/mfd/max77693.c               |  249 +++++++++++++++++++++++++++
 include/linux/mfd/max77693-private.h |  217 ++++++++++++++++++++++++
 include/linux/mfd/max77693.h         |   36 ++++
 6 files changed, 824 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77693-irq.c
 create mode 100644 drivers/mfd/max77693.c
 create mode 100644 include/linux/mfd/max77693-private.h
 create mode 100644 include/linux/mfd/max77693.h

