Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab2C3MSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:18:24 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:48590 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759370Ab2C3MST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:18:19 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 20/76] thermal: spear13xx: checking for NULL instead of IS_ERR()
Date: Fri, 30 Mar 2012 06:13:23 -0400
Message-id: <03ee62f0b9919535a1be02f72fe8153255a7fda0.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

thermal_zone_device_register() never returns NULL, on error it returns and
ERR_PTR().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/thermal/spear_thermal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
index be94413..c2e32df 100644
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
 
-- 
1.7.10.rc2.19.gfae9d

