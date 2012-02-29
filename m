Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966029Ab2B2GcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:32:06 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:45016 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab2B2GcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:32:04 -0500
Date: Wed, 29 Feb 2012 09:31:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vincenzo Frascino <vincenzo.frascino@st.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Viresh Kumar <viresh.kumar@st.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] thermal: spear13xx: checking for NULL instead of IS_ERR()
Message-ID: <20120229063151.GA18031@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F4DC65F.0065,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thermal_zone_device_register() never returns NULL, on error it returns
and ERR_PTR().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index 880bf28..7352cf8 100644
--- a/drivers/thermal/spear_thermal.c
+++ b/drivers/thermal/spear_thermal.c
@@ -149,9 +149,9 @@ static int spear_thermal_probe(struct platform_device *pdev)
 
 	spear_thermal = thermal_zone_device_register("spear_thermal", 0,
 				stdev, &ops, 0, 0, 0, 0);
-	if (!spear_thermal) {
+	if (IS_ERR(spear_thermal)) {
 		dev_err(&pdev->dev, "thermal zone device is NULL\n");
-		ret = -EINVAL;
+		ret = PTR_ERR(spear_thermal);
 		goto disable_clk;
 	}
 
