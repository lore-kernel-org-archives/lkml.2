Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab1ERM4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 08:56:55 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:56300 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab1ERM4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 08:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pSuQnsnJIXdEIx3shCP9W4//2WdO3RqS3GGqKfucFLoKcQxFiLkMStgmZHHRKqPZYT
         hhIbthGmucAQF40Q37OxDmBseYqf8AFTcZqvb5csOXcfqPEYrn/DX1EJ8ALZh4E/dP76
         Dz7JOgnf6wdJEEMY12ph9Qjb4m4b8QlHskti4=
Subject: [PATCH] regulator: Fix off-by-one value range checking for
 mc13xxx_regulator_get_voltage
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 20:56:45 +0800
Message-ID: <1305723405.6172.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use val as array index,
thus the valid value rangae for val should be 0 .. n_voltages-1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13xxx-regulator-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 2bb5de1..bc27ab1 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -174,7 +174,7 @@ static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
 
-	BUG_ON(val > mc13xxx_regulators[id].desc.n_voltages);
+	BUG_ON(val >= mc13xxx_regulators[id].desc.n_voltages);
 
 	return mc13xxx_regulators[id].voltages[val];
 }
-- 
1.7.1



