Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab1DROKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:10:09 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:58216 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1DROJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:09:43 -0400
X-ASG-Debug-ID: 1303135783-082b704b0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 04/14] input: set the long press detection in 88pm860x onkey
Subject: [PATCH 04/14] input: set the long press detection in 88pm860x onkey
Date: Mon, 18 Apr 2011 22:04:01 +0800
X-ASG-Orig-Subj: [PATCH 04/14] input: set the long press detection in 88pm860x onkey
Message-Id: <1303135451-26362-5-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011041801>
References: <2011041801>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303135783
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the long-press detection from onkey handler to probe function. Avoid
unnecessary I2C operation in onkey handler.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/88pm860x_onkey.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/88pm860x_onkey.c b/drivers/input/misc/88pm860x_onkey.c
index 3dca3c1..1abc77e 100644
--- a/drivers/input/misc/88pm860x_onkey.c
+++ b/drivers/input/misc/88pm860x_onkey.c
@@ -50,9 +50,6 @@ static irqreturn_t pm860x_onkey_handler(int irq, void *data)
 	ret &= ONKEY_STATUS;
 	input_report_key(info->idev, KEY_POWER, ret);
 	input_sync(info->idev);
-
-	/* Enable 8-second long onkey detection */
-	pm860x_set_bits(info->i2c, PM8607_WAKEUP, 3, LONG_ONKEY_EN);
 	return IRQ_HANDLED;
 }
 
@@ -105,6 +102,9 @@ static int __devinit pm860x_onkey_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, info);
+
+	/* Enable 8-second long onkey detection */
+	pm860x_set_bits(info->i2c, PM8607_WAKEUP, 3, LONG_ONKEY_EN);
 	return 0;
 
 out_irq:
-- 
1.5.6.5

