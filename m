Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0KEHXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:23:51 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39625 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0KEHXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:23:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AOsjANg1HE9dU2naT/ChRWmONwnafFyC9ZWb6jwMsx+Y8aMnST8ouk56KcQ7GXRDd3
         NlT71Y3nJXt1GxtYriBEnq9KhTDlOu232SptAt4uqBaFNRa240XtzKda0iTleK6ugzFB
         TPmnAFm+fHTjX1T88yGO/a+RnHi5O7lvQkMD4=
Subject: [PATCH 3/3] regulator: Return proper error for regulator_register()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1288941912.16201.1.camel@mola>
References: <1288941912.16201.1.camel@mola>
Content-Type: text/plain
Date: Fri, 05 Nov 2010 15:27:17 +0800
Message-Id: <1288942037.16201.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0dd9a57..59a7119 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2346,6 +2346,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 	if (init_data->supply_regulator && init_data->supply_regulator_dev) {
 		dev_err(dev,
 			"Supply regulator specified by both name and dev\n");
+		ret = -EINVAL;
 		goto scrub;
 	}
 
@@ -2364,6 +2365,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
 		if (!found) {
 			dev_err(dev, "Failed to find supply %s\n",
 				init_data->supply_regulator);
+			ret = -ENODEV;
 			goto scrub;
 		}
 
-- 
1.7.2



