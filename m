Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2IBKmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:42:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2IBKlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:41:08 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mfd: twl: Move PWM driver to PWM framework
Date: Sun,  2 Sep 2012 12:40:56 +0200
Message-Id: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:2qWIG1cBH5tBeOfu7fVZYrbdVKxpQtV4Zw7uske3BEo
 y/Ve+2ZRlYPTJBymj4FOhBh82beafk4iuWjsHXVoIso3kkWVFh
 CxCzqXG5GVqZUjc7e5cMWzOPigZqwIEQubiyyGrYDNRdUgnzzI
 pjfAt/nFhOY868f3nZh5cDAmqrjwYobjRZ/g47aBPdTzrwf5Ge
 BI1Y9q06Jok1YkVs7XQWbQcFNr4VRaMcL4ECT4Co6aZPrv02TY
 nQ9aaMA+qQmOKwQAsm7rhjYCHBnu4PfskO0E3ESuI3PzlffDBj
 sJdhElactWoK7mtRct6MSc9IjM7B8jqh4I0QP4LQ+WdXQiBjk2
 ylAPm7i8SvBCS3N8Xz4Av95pPM+TZ2G8VQqwR6LSgriL4yFHYb
 dw6TkT6XOBBduOeyFrJnee/ZMjtAEE0qZ0pA9FVWyud0kupzDT
 guSCk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This mini series replaces the twl_has_*() macros by the equivalent
standard IS_ENABLED() macro and moves the PWM driver to the PWM
framework.

I'll take the second patch through the PWM tree but would like to have
some Acked-bys from people that know and have the hardware and can
verify that I haven't broken anything.

Thierry

Thierry Reding (2):
  mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
  pwm: Move TWL6030 PWM driver to PWM framework

 drivers/mfd/Kconfig       |  10 ---
 drivers/mfd/Makefile      |   1 -
 drivers/mfd/twl-core.c    | 124 ++++++++-----------------------
 drivers/mfd/twl6030-pwm.c | 165 -----------------------------------------
 drivers/pwm/Kconfig       |   9 +++
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-twl6030.c | 184 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 226 insertions(+), 268 deletions(-)
 delete mode 100644 drivers/mfd/twl6030-pwm.c
 create mode 100644 drivers/pwm/pwm-twl6030.c

-- 
1.7.12

