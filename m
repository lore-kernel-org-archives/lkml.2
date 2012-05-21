Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab2EUJv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:51:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43378 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab2EUJv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:51:57 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-41-4fba103ba57c
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Oritz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Gridwodd <lrg@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH v4 0/3] Add initial support for MAXIM 77686 mfd chip
Date: Mon, 21 May 2012 18:51:44 +0900
Message-id: <1337593907-6615-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t9jQV1rgV3+Btt/m1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M88s3MBVcFqpomj+FvYFxL18XIyeHhICJxIoLD5ggbDGJC/fW
	s3UxcnEICUxnlHi8oYcVwlnJJPHk60N2kCo2AR2J//tugtkiAgoSm3ufgRUxC5xmkri7dgkz
	SEJYwEVi787HYEUsAqoSN6fvZAGxeQXcJfadXsYOsU5BYsG9t2wTGLkXMDKsYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAj24jOpHYwrGywOMQpwMCrx8M58utNfiDWxrLgy9xCjBAezkgjv
	3YdAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rx2i3f4CwmkJ5akZqemFqQWwWSZODilGhgX/T94
	U+Hs5DNrar1v5xn//TL3+bGZU1inLQ5akaIsxf9Kd5pE7DnOvxmPKnTjq2TLq/887n7IEeMU
	27lEOfGWRRFvnNf6xTvu13GvrdoUe1xS3dtffLaT8T1W77pXDs/Xur38Pe/uakdjtTOvLH5y
	HQ1Pn7Yl+OqKygKrNr15jms2vtjS4S6lxFKckWioxVxUnAgAWktG5t4BAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for MAX77686 which is a multifunction device including
regulator and rtc. It also includes drivers supporting rtc and regulator.
All drivers are based on MAX8997 driver and use regmap to access to registers.
To manage IRQs occured by max77686, It supports IRQ domain.

Changes in patchset v4
- Use common regulator API for all regulator_ops.
- Replace regulator's infomation (minimum value, step, number of available 
  voltage levels) to regulator_desc structure.

Changes in patchset v3
In mfd core:
- Remove APIs accessing to register ( e.g. max77686_read_reg() )
  to use regmap's API directly over all related drivers.

In regulator driver:
- Convert get_voltage to get_voltage_sel
- Convert set_voltage to set_voltage_sel
- Implement set_voltage_time_sel
- Register regulators unconditionally
- kzalloc -> devm_kzalloc
- Remove unneccessary printk
- Keep probing whether pdata exists or not
- Use regmap API to access to PMIC register.

In rtc driver:
- Use regmap API to access to RTC register.

Changes in patcset v2:
http://thread.gmane.org/gmane.linux.kernel/1295479

This patch set is tested on TRATS boards.
Jonghwa Lee (3):
  mfd: MAX77686: Add Maxim 77686 mfd driver
  regulator: MAX77686: Add Maxim 77686 regulator driver
  rtc: MAX77686: Add Maxim 77686 rtc driver

 drivers/mfd/Kconfig                  |   11 +
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77686-irq.c           |  309 ++++++++++++++++
 drivers/mfd/max77686.c               |  156 ++++++++
 drivers/regulator/Kconfig            |    8 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/max77686.c         |  438 +++++++++++++++++++++++
 drivers/rtc/Kconfig                  |   10 +
 drivers/rtc/Makefile                 |    1 +
 drivers/rtc/rtc-max77686.c           |  645 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/max77686-private.h |  247 +++++++++++++
 include/linux/mfd/max77686.h         |  117 ++++++
 12 files changed, 1944 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77686-irq.c
 create mode 100644 drivers/mfd/max77686.c
 create mode 100644 drivers/regulator/max77686.c
 create mode 100644 drivers/rtc/rtc-max77686.c
 create mode 100644 include/linux/mfd/max77686-private.h
 create mode 100644 include/linux/mfd/max77686.h

-- 
1.7.4.1

