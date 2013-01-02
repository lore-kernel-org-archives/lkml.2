Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3ABNZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:25:31 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33795 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3ABNZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:25:29 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <tony@atomide.com>, <paul@pwsan.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        Philip Avinash <avinashphilip@ti.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH 3/7] pwm: pwm-tiehrpwm: Update the clock handling of pwm-tiehrpwm driver
Date: Wed, 2 Jan 2013 18:54:50 +0530
Message-ID: <1357133094-30806-4-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
References: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock framework has changed and it's now better to invoke
clock_prepare_enable() and clk_disable_unprepare() rather than the
legacy clk_enable() and clk_disable() calls. This patch converts the
pwm-tiehrpwm driver to the new framework.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
---
In 3.8-rc1, common clock frame work support added to AM335x.

 drivers/pwm/pwm-tiehrpwm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index 72a6dd4..af6f162 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -341,7 +341,7 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 	configure_polarity(pc, pwm->hwpwm);
 
 	/* Enable TBCLK before enabling PWM device */
-	clk_enable(pc->tbclk);
+	clk_prepare_enable(pc->tbclk);
 
 	/* Enable time counter for free_run */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_FREE_RUN);
@@ -372,7 +372,7 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
 
 	/* Disabling TBCLK on PWM disable */
-	clk_disable(pc->tbclk);
+	clk_disable_unprepare(pc->tbclk);
 
 	/* Stop Time base counter */
 	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_STOP_NEXT);
-- 
1.7.9.5

