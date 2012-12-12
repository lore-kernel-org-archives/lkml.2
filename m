Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab2LLJKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:10:21 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33623 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab2LLJKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 04:10:18 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-leds@vger.kernel.org>
Subject: [PATCH v4 6/7] leds: leds-pwm: Simplify cleanup code
Date: Wed, 12 Dec 2012 10:04:51 +0100
Message-ID: <1355303092-15523-7-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
References: <1355303092-15523-1-git-send-email-peter.ujfalusi@ti.com>
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
1.8.0

