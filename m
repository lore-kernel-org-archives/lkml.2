Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab1D1DXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:23:37 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46619 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1D1DXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qM4IiDGH8I0fqCke4BA+nnANn3hcAJuVtaXzDffTMkTgoAd8i1QGDp2tU3M9+QDkVG
         GTF7gx94FM0A4DCmgRRh5dpdvPzWtIVJWtGTSF91bsdgiukQiOyO4LrawfjLWdI94XBZ
         gdJ0wa2ooISr5Yywvmem1XPIXXfs90kqLrhGc=
Subject: [PATCH] Input: omap-keypad - fix a wrong free_irq() parameter
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Timo =?ISO-8859-1?Q?Ter=E4s?= <ext-timo.teras@nokia.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 11:23:26 +0800
Message-ID: <1303961006.8127.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, free_irq() was using NULL rather than the
driver data as the data pointer so free_irq() wouldn't have matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/omap-keypad.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 0e2a19c..f23a743 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -413,7 +413,7 @@ static int __devinit omap_kp_probe(struct platform_device *pdev)
 	return 0;
 err5:
 	for (i = irq_idx - 1; i >=0; i--)
-		free_irq(row_gpios[i], NULL);
+		free_irq(row_gpios[i], omap_kp);
 err4:
 	input_unregister_device(omap_kp->input);
 	input_dev = NULL;
@@ -444,11 +444,11 @@ static int __devexit omap_kp_remove(struct platform_device *pdev)
 			gpio_free(col_gpios[i]);
 		for (i = 0; i < omap_kp->rows; i++) {
 			gpio_free(row_gpios[i]);
-			free_irq(gpio_to_irq(row_gpios[i]), NULL);
+			free_irq(gpio_to_irq(row_gpios[i]), omap_kp);
 		}
 	} else {
 		omap_writew(1, OMAP1_MPUIO_BASE + OMAP_MPUIO_KBD_MASKIT);
-		free_irq(omap_kp->irq, NULL);
+		free_irq(omap_kp->irq, omap_kp);
 	}
 
 	del_timer_sync(&omap_kp->timer);
-- 
1.7.1



