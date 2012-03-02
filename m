Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab2CBIWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:22:09 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61621 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2CBIWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:22:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.195.99 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330676521.31023.1.camel@phoenix>
Subject: [PATCH 2/3] regulator: max1586: Use DIV_ROUND_UP macro to calculate
 selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 02 Mar 2012 16:22:01 +0800
In-Reply-To: <1330676454.31023.0.camel@phoenix>
References: <1330676454.31023.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 40e7a4d..282d2ee 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -76,8 +76,8 @@ static int max1586_v3_set(struct regulator_dev *rdev, int min_uV, int max_uV,
 	if (min_uV < max1586->min_uV)
 		min_uV = max1586->min_uV;
 
-	*selector = ((min_uV - max1586->min_uV) * MAX1586_V3_MAX_VSEL +
-			range_uV - 1) / range_uV;
+	*selector = DIV_ROUND_UP((min_uV - max1586->min_uV) *
+				 MAX1586_V3_MAX_VSEL, range_uV);
 	if (max1586_v3_calc_voltage(max1586, *selector) > max_uV)
 		return -EINVAL;
 
-- 
1.7.5.4



