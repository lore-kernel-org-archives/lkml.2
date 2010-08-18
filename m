Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab0HRDez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 23:34:55 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59657 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0HRDet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 23:34:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=bg0tTKbOqDcVkLSYnnX2JbLDOIp0qbEECEExTe1dF6pKZbbcEf5VWc6ie5SlLEqK/v
         4QNjUzXYeLCT6gn2bTdC9/o3QnQUeONpnB2or2LDyzA+iP3UwJ49R4fZoH00olndllat
         g61rqXgvn3huIxWMB0Q82Db7VFA5uO1Hqen94=
Subject: [PATCH] regulator: max1586 - improve the logic of choosing selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain
Date: Wed, 18 Aug 2010 11:37:21 +0800
Message-Id: <1282102641.20985.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little bit improvement in the logic of choosing selector.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max1586.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 8867c27..559cfa2 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -121,14 +121,14 @@ static int max1586_v6_set(struct regulator_dev *rdev, int min_uV, int max_uV)
 	if (max_uV < MAX1586_V6_MIN_UV || max_uV > MAX1586_V6_MAX_UV)
 		return -EINVAL;
 
-	if (min_uV >= 3000000)
-		selector = 3;
-	if (min_uV < 3000000)
-		selector = 2;
-	if (min_uV < 2500000)
-		selector = 1;
 	if (min_uV < 1800000)
 		selector = 0;
+	else if (min_uV < 2500000)
+		selector = 1;
+	else if (min_uV < 3000000)
+		selector = 2;
+	else if (min_uV >= 3000000)
+		selector = 3;
 
 	if (max1586_v6_calc_voltage(selector) > max_uV)
 		return -EINVAL;
-- 
1.7.2



