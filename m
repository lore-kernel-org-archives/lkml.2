Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602Ab0HNJDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 05:03:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39026 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab0HNJDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 05:03:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kr+Mc1xkgXWdyZ/CjUK/Y598s5VPo4f1U15ZYv1eELrviIk3bc5bqx1RYYByqMWKgz
         ISWf5klFrHUcSSq9aPMdq7AKKRAbTwa+KY9+39CN7i9SNHVOtygObemFzl5nIGIU8dDC
         1GR7sd7zCIC/QR4XReezbdb7PY4hFm33VuL1A=
Date: Sat, 14 Aug 2010 11:03:16 +0200
From: Dan Carpenter <error27@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] regulator/ab8500: move dereference below the check for NULL
Message-ID: <20100814090316.GX645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
	Sundar R Iyer <sundar.iyer@stericsson.com>,
	Linus Walleij <linus.walleij@stericsson.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I moved the dereference of "ab8500" below the check for NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index dc3f1a4..cc7cbaf 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -344,13 +344,14 @@ static inline struct ab8500_regulator_info *find_regulator_info(int id)
 static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
 {
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
-	struct ab8500_platform_data *pdata = dev_get_platdata(ab8500->dev);
+	struct ab8500_platform_data *pdata;
 	int i, err;
 
 	if (!ab8500) {
 		dev_err(&pdev->dev, "null mfd parent\n");
 		return -EINVAL;
 	}
+	pdata = dev_get_platdata(ab8500->dev);
 
 	/* register all regulators */
 	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
