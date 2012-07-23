Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab2GWBql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:46:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54507 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633Ab2GWBnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:50 -0400
Message-Id: <20120723010655.171702749@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Shuah Khan <shuah.khan@hp.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 024/108] iommu/amd: Fix missing iommu_shutdown initialization in passthrough
 mode
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuah Khan <shuah.khan@hp.com>

commit f2f12b6fc032c7b1419fd6db84e2868b5f05a878 upstream.

The iommu_shutdown callback is not initialized when the AMD
IOMMU driver runs in passthrough mode. Fix that by moving
the callback initialization before the check for
passthrough mode.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 542024b..c04ddca 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1641,6 +1641,8 @@ static int __init amd_iommu_init(void)
 
 	register_syscore_ops(&amd_iommu_syscore_ops);
 
+	x86_platform.iommu_shutdown = disable_iommus;
+
 	if (iommu_pass_through)
 		goto out;
 
@@ -1649,7 +1651,6 @@ static int __init amd_iommu_init(void)
 	else
 		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
 
-	x86_platform.iommu_shutdown = disable_iommus;
 out:
 	return ret;
 


