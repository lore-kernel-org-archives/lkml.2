Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab2DZRmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:42:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42496 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540Ab2DZRlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:41:46 -0400
From: Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <khilman@ti.com>, <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>
CC: <j-pihet@ti.com>, <j-keerthy@ti.com>
Subject: [PATCH V3 08/10] ARM: OMAP2+: SmartReflex: Create per-opp debugfs node for errminlimit
Date: Thu, 26 Apr 2012 23:10:39 +0530
Message-ID: <1335462041-4949-9-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Pihet <j-pihet@ti.com>

Remove the global errminlimit debugfs entry and create per-voltage
entries from the data tables.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Signed-off-by: J Keerthy <j-keerthy@ti.com>
---
 arch/arm/mach-omap2/smartreflex.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 20075de..515041c 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -979,8 +979,6 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 			&sr_info->err_weight);
 	(void) debugfs_create_x32("errmaxlimit", S_IRUGO, sr_info->dbg_dir,
 			&sr_info->err_maxlimit);
-	(void) debugfs_create_x32("errminlimit", S_IRUGO, sr_info->dbg_dir,
-			&sr_info->err_minlimit);
 
 	nvalue_dir = debugfs_create_dir("nvalue", sr_info->dbg_dir);
 	if (IS_ERR_OR_NULL(nvalue_dir)) {
@@ -1005,6 +1003,11 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 				sr_info->nvalue_table[i].volt_nominal);
 		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
 				&(sr_info->nvalue_table[i].nvalue));
+		snprintf(name, sizeof(name), "errminlimit_%lu",
+			 sr_info->nvalue_table[i].volt_nominal);
+		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
+				&(sr_info->nvalue_table[i].errminlimit));
+
 	}
 
 	return ret;
-- 
1.7.5.4

