Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2KHNbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:31:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38568 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab2KHNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:31:36 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/3] pwm: Drivers for twl4030/6030 PWMs and LEDs
Date: Thu, 8 Nov 2012 14:31:27 +0100
Message-ID: <1352381490-30009-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Changes cince v1:
- The turn on/off sequence has been corrected for twl4030 PWMs as suggested by
  Grazvydas Ignotas
- Comment section added to the new drivers to describe what they are controlling

The series has been tested (with additional, pending patches):
Zoom2 for twl4030 PWM0 (keypad light), PWM1 (LCD backlight)
BeagleBoard for twl4030 LEDB (PWMB - pmu_stat led)
OMAP4 Blaze (SDP4430) for twl6030 PWM1 (keypad light), PWM2 (LCD backlight) and
LED (charging indication led).

Intro mail from v1:

The currently available pwm-twl6030.c driver only supports TWL6030's Charging
indication LED.
Remove this driver and add two new ones which implements support for all PWM
driven outputs:
pwm-twl driver supports twl4030 (PWM 0/1) and twl6030 (PWM 1/2) instances
pwm-twl-led driver supports twl4030 (PWM driven LED A/B ports) and twl6030's
Charging indication LED (PWM driven).

Regards,
Peter
---
Peter Ujfalusi (3):
  pwm: Remove pwm-twl6030 driver
  pwm: New driver to support PWMs on TWL4030/6030 series of PMICs
  pwm: New driver to support PWM driven LEDs on TWL4030/6030 series of
    PMICs

 drivers/pwm/Kconfig       |  19 ++-
 drivers/pwm/Makefile      |   3 +-
 drivers/pwm/pwm-twl-led.c | 295 ++++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/pwm-twl.c     | 322 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/pwm-twl6030.c | 184 --------------------------
 5 files changed, 634 insertions(+), 189 deletions(-)
 create mode 100644 drivers/pwm/pwm-twl-led.c
 create mode 100644 drivers/pwm/pwm-twl.c
 delete mode 100644 drivers/pwm/pwm-twl6030.c

-- 
1.8.0

