Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2GYLos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:44:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37810 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab2GYLnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:43:20 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <vaibhav.bedia@ti.com>,
        <gururaja.hebbar@ti.com>, "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2 0/2] PWM driver support for EHRPWM & ECAP
Date: Wed, 25 Jul 2012 16:58:17 +0530
Message-ID: <1343215699-4575-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for PWM driver support for EHRPWM
and ECAP modules which has been present on AM335x SOC. AM335X SOC has 3
instances of ECAP & EHRPWM.

EHRPWM device can be used to generate PWM waveforms. It has 2 channels
of PWM output and each can be configured for different duty cycle and
polarity.

ECAP device can be used as either Capture or APWM mode. In APWM mode,
ECAP can generate PWM waveform.

Patch #1 adds Generic PWM driver support for simple APWM functionality
of ECAP ECAP hardware.

Patch #2 adds  PWM driver support for EHRPWM device.

This patch series is based on new PWM framework maintained at [1].

1. https://gitorious.org/linux-pwm/linux-pwm/trees/for-next

Since v1:
	- Alphabetically placed in Kconfig and Makefile
	- Removes unused MACROS
	- Starts using TI prefix for ecap & ehrpwm modules to avoid
	  confusion.
	- Starts using platform_get_resource() instead of
	  platform_get_resource_byname()
	- Removes dev_info messages of PWM device Initialized.
	- Add const qualifier on struct pwm_ops definition.
	- Removes platform_drvdata check on platform_driver_remove.
	- Starts checking pwmchip_remove() return value.
	- Kept back MACRO definitions which are related to give more
	  readability

Philip, Avinash (2):
  pwm: pwm-tiecap: PWM driver support for ECAP APWM
  pwm: pwm-tiehrpwm: PWM driver support for EHRPWM

 drivers/pwm/Kconfig        |   22 +++
 drivers/pwm/Makefile       |    2 +
 drivers/pwm/pwm-tiecap.c   |  232 +++++++++++++++++++++++++
 drivers/pwm/pwm-tiehrpwm.c |  411 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 667 insertions(+), 0 deletions(-)
 create mode 100644 drivers/pwm/pwm-tiecap.c
 create mode 100644 drivers/pwm/pwm-tiehrpwm.c

