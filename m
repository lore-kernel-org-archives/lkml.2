Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab0LWLMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:12:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58300 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab0LWLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:12:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=raEO3K4l7VOvOYQvwHFDkkNMyWkL3zGdkIhz8EPTVGEooZGA+S26Aw0CZ46MDrwsZC
         XJhDnnJSy36aOZrm54rMZteVkrHu03zkMIctkgWwiIRkhbaP5wzWvNE5iFHciHxYUVZH
         7554tE8LzuP5/TLPtoJAuJgNWMWJ2jvUJsZXM=
From: Richard Genoud <richard.genoud@gmail.com>
To: spi-devel-general@lists.sourceforge.net
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH 1/2] spi_imx.c: CSPI3 irq is 0 on imx25
Date: Thu, 23 Dec 2010 12:12:09 +0100
Message-Id: <1293102730-32528-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On imx25 soc, MX25_INT_CSPI3 is 0
(cf arch/arm/plat-mxc/include/mach/mx25.h).
So, the test (spi_imx->irq <= 0) returned an error
for this platform.
This patch corrects this behaviour.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/spi/spi_imx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 55a38e2..793ae99 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -847,7 +847,7 @@ static int __devinit spi_imx_probe(struct platform_device *pdev)
 	}
 
 	spi_imx->irq = platform_get_irq(pdev, 0);
-	if (spi_imx->irq <= 0) {
+	if (spi_imx->irq < 0) {
 		ret = -EINVAL;
 		goto out_iounmap;
 	}
-- 
1.7.1

