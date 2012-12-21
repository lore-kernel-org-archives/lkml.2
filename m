Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab2LUJpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:45:20 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59178 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2LUJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:44:30 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v5 6/7] leds: leds-pwm: Simplify cleanup code
Date: Fri, 21 Dec 2012 10:44:00 +0100
Message-ID: <1356083041-29179-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356083041-29179-1-git-send-email-peter.ujfalusi@ti.com>
References: <1356083041-29179-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code looks more nicer if we use:

while (i--)

instead:
if (i > 0)
	for (i = i - 1; i >= 0; i--)

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/leds/leds-pwm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index c767837..46f4e44 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -104,10 +104,8 @@ static int led_pwm_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	if (i > 0) {
-		for (i = i - 1; i >= 0; i--)
-			led_classdev_unregister(&priv->leds[i].cdev);
-	}
+	while (i--)
+		led_classdev_unregister(&priv->leds[i].cdev);
 
 	return ret;
 }
-- 
1.8.0.2

