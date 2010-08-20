Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0HTB74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:59:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46232 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0HTB7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RN/KTwc7aFTpEu4nzUtwKRMcIk4rekqNLABTQKvlsVdiI4ssaRnXmWiyHPWeTcd75W
         9YvfApsSZhxjmj+ODEqMxvzHCKF4bA0IxcX4d4LS9J5e0UXfvAcjb4yeLF81VdENz6KZ
         mRELRz+VlzA4J3c445RKxUZoey0kwKM8Xq8i4=
Subject: [PATCH 4/4] regulator/wm8994-regulator: fix potential NULL
	dereference
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
In-Reply-To: <1282269518.31048.2.camel@mola>
References: <1282269518.31048.2.camel@mola>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 10:02:41 +0800
Message-Id: <1282269761.31048.8.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata is dereferenced earlier than tested for being NULL.
Thus move the dereference of "pdata" below the check for NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/wm8994-regulator.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 03713bc..3ecc81f 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -202,15 +202,15 @@ static __devinit int wm8994_ldo_probe(struct platform_device *pdev)
 {
 	struct wm8994 *wm8994 = dev_get_drvdata(pdev->dev.parent);
 	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
-	int id = pdev->id % ARRAY_SIZE(pdata->ldo);
 	struct wm8994_ldo *ldo;
-	int ret;
-
-	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
+	int id, ret;
 
 	if (!pdata)
 		return -ENODEV;
 
+	id = pdev->id % ARRAY_SIZE(pdata->ldo);
+	dev_dbg(&pdev->dev, "Probing LDO%d\n", id + 1);
+
 	ldo = kzalloc(sizeof(struct wm8994_ldo), GFP_KERNEL);
 	if (ldo == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate private data\n");
-- 
1.7.2



