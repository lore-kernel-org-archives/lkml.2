Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2KGP0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:26:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2KGP0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:26:17 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH] pwm: lpc32xx - Fix the PWM polarity
Date: Wed,  7 Nov 2012 16:25:55 +0100
Message-Id: <1352301955-15960-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de>
References: <20121106181939.61c50233@avionic-0020.adnet.avionic-design.de>
X-Provags-ID: V02:K0:hLoqvDnsBxBIMZ7TxOmTCq195B2cYP5IIvlZdmOKSQ7
 NLv84FROms87vPuovw9ygeM7sPQjj1RCDAq2ThleYWomIbLcAa
 AjDvLpy4LvkKvJEw4zcVSd3f3nFirnnuNIVHOcX0Oy06UAKhfX
 G+VtV3xD0kdOCMHgoaVi2AY6LlRG38IpDokZOt/1hr/lxOXi9r
 L4utqFM+2Dn1RtFLjJ6ID1hdALAS6UfG2vns2Hn4w5Sy9x/qcz
 dQAYMFnhjIEKZvvp3hU3JIB0Dt84pk8vgUXDfjF6Ob0vjUzRMT
 aKeiWd4yVikGhJHpYhgKKREt2vfdOTgYn+C3ifjkEsXT42Haf8
 eq9PFcblg4VWrrMeYFMs1Klm+5NS+z7FcFRizcG92YdreTutHy
 H6GEeKvZtYftp/6hfjov4UXcy6qstozJ8hspFq+4aqVUez0FDw
 WbGv3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/pwm/pwm-lpc32xx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index adb87f0..0dc278d 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -51,7 +51,11 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	c = 256 * duty_ns;
 	do_div(c, period_ns);
-	duty_cycles = c;
+	if (c == 0)
+		c = 256;
+	if (c > 255)
+		c = 255;
+	duty_cycles = 256 - c;
 
 	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
 		lpc32xx->base + (pwm->hwpwm << 2));
-- 
1.7.0.4

