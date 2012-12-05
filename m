Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2LEPfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:35:09 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64862 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2LEPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:35:08 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] pwm: i.MX: eliminate build warning
Date: Wed,  5 Dec 2012 16:34:41 +0100
Message-Id: <1354721681-31843-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

compiling the i.MX pwm driver produces the following warning:
|drivers/pwm/pwm-imx.c: In function 'imx_pwm_probe':
|drivers/pwm/pwm-imx.c:281:7: warning: assignment discards qualifiers from pointer target type

Apply a 'const' attribute to the affected variable declaration.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/pwm/pwm-imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 8f26e9f..65a86bd 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -235,7 +235,7 @@ static int imx_pwm_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
 			of_match_device(imx_pwm_dt_ids, &pdev->dev);
-	struct imx_pwm_data *data;
+	const struct imx_pwm_data *data;
 	struct imx_chip *imx;
 	struct resource *r;
 	int ret = 0;
-- 
1.7.2.5

