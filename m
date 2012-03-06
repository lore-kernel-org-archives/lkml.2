Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab2CFByb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:54:31 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62879 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192Ab2CFBya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:54:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.74.138 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330998862.3708.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: tps65217: Use DIV_ROUND_UP macro to
 calculate selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: AnilKumar Ch <anilkumar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 06 Mar 2012 09:54:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP macro for better readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65217-regulator.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
index 28a10ea..15f2fa0 100644
--- a/drivers/regulator/tps65217-regulator.c
+++ b/drivers/regulator/tps65217-regulator.c
@@ -82,11 +82,11 @@ static int tps65217_uv_to_vsel1(int uV, unsigned int *vsel)
 		return -EINVAL;
 
 	if (uV <= 1500000)
-		*vsel = (uV - 875001) / 25000;
+		*vsel = DIV_ROUND_UP(uV - 900000, 25000);
 	else if (uV <= 2900000)
-		*vsel = 24 + (uV - 1450001) / 50000;
+		*vsel = 24 + DIV_ROUND_UP(uV - 1500000, 50000);
 	else if (uV < 3300000)
-		*vsel = 52 + (uV - 2800001) / 100000;
+		*vsel = 52 + DIV_ROUND_UP(uV - 2900000, 100000);
 	else
 		*vsel = 56;
 
@@ -116,11 +116,11 @@ static int tps65217_uv_to_vsel2(int uV, unsigned int *vsel)
 		return -EINVAL;
 
 	if (uV <= 1900000)
-		*vsel = (uV - 1450001) / 50000;
+		*vsel = DIV_ROUND_UP(uV - 1500000, 50000);
 	else if (uV <= 2400000)
-		*vsel = 8 + (uV - 1800001) / 100000;
+		*vsel = 8 + DIV_ROUND_UP(uV - 1900000, 100000);
 	else
-		*vsel = 13 + (uV - 2350001) / 50000;
+		*vsel = 13 + DIV_ROUND_UP(uV - 2400000, 50000);
 
 	return 0;
 }
-- 
1.7.5.4



