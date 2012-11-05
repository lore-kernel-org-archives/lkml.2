Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2KEQss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:48:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2KEQsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:48:46 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH] pwm: lpc32xx - Fix the PWM polarity
Date: Mon,  5 Nov 2012 17:48:45 +0100
Message-Id: <1352134125-22405-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V02:K0:RnZs0P8mj4ZvF0Nj6wnDBPB707oOoeglZ8CDRNcY509
 mjkoHnONHtSmhtp9TOCDMqfdBrrd5OmprSpTrB8UCrPYYOr2aJ
 mYUJTdN0yXQhUnmRwU0oZvRWmm+E1l5Dkt43wXZzoNMutEVnyV
 Fa+8IOAteeNsEYSc9tSKMsbHgFd5Si9jU0gelGiJm9Hnuup//E
 kD+WDko36tDphYbqpGvgiARuDfdcuSorOqGZ0vmoYBySkDnRRk
 wOptjff/+oEJikQRypjHr/VUiDTX1AQUSRr0QhhsmKFbZjtF+M
 BU4yJ+zlCdI9dBOwCPz/TNTCr28uU5KnIt0XWhdwKsL4TRi6CE
 l6neAUBPT0fV7TJQwCMfG9wgyu3xEZk0EDHFWKWtO+OX4Mq+9N
 TnEnPct9VCuixbpaBghhkRFitWerCEJhBm4fza2ja2BTVvsszE
 RfbZz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/pwm/pwm-lpc32xx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index adb87f0..a2704b8 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -51,7 +51,11 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	c = 256 * duty_ns;
 	do_div(c, period_ns);
-	duty_cycles = c;
+	if (c > 255)
+		c = 255;
+	if (c < 1)
+		c = 1;
+	duty_cycles = 256 - c;
 
 	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
 		lpc32xx->base + (pwm->hwpwm << 2));
-- 
1.7.0.4

