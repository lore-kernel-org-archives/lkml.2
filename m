Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab2INLoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:44:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2INLoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:44:30 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Julian Andres Klode <jak@jak-linux.org>
Cc: Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: nvec: Update for recent MFD core changes
Date: Fri, 14 Sep 2012 13:44:24 +0200
Message-Id: <1347623064-28348-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:8cSakcVsYzK9PzxhQLWdz+BPi6uT4Szb9tw2alQ0KGq
 vzTnWdRoibsT+XP/sna8EGaAmIHmJ47xC34K9/6+OAcCitNpqQ
 fRX0BRJrcM/D4QUEJy/Puk6uOkuMnHtwvZ/wUnWzs9wMEXcCk+
 TCS/0/1U+XIVef7yRN44TSiSmDkUlDR1KAIOOWanCVz7hhNSQR
 x4w4Q3Ddz74fJivF5zeXN9KOLN/RKH32uaE/KQStYywxFR4t3K
 JNQo5ZbZc1ctVkUJGI7WApQoiSfK4FqxGPhLmmsHG8jHXT5b5R
 2pCLprARsRV8Au8ukgs53J1sS2ZCaRoKUinAG7+KQ7E4ZPmDji
 Wwx4wSNn/5RPpet2I6m11LtB02HyOXothzBQsIBbo35UGsMrxm
 m8ZAphCCt+lFlzzAuxNjBX2XT0r5VwCgUpE5H1JvMS/Jzu+5ZY
 E0fdn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd_add_devices() was recently changed to receive the IRQ domain through
an additional parameter but this driver wasn't updated accordingly.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/staging/nvec/nvec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index b0972d0..24d8eeb 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -837,7 +837,7 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 	}
 
 	ret = mfd_add_devices(nvec->dev, -1, nvec_devices,
-			      ARRAY_SIZE(nvec_devices), base, 0);
+			      ARRAY_SIZE(nvec_devices), base, 0, NULL);
 	if (ret)
 		dev_err(nvec->dev, "error adding subdevices\n");
 
-- 
1.7.12

