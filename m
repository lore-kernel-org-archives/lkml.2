Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030234Ab2CITpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:45:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964841Ab2CITpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:45:34 -0500
Message-Id: <20120309190202.425318888@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, James <angweiyang@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Joerg Roedel <Joerg.Roedel@amd.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 01/95] ARM: OMAP: make iommu subsys_initcall to fix builtin omap3isp
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ohad Ben-Cohen <ohad@wizery.com>

commit 435792d93410f008120c4dbab148019a3cc31dbc upstream.

omap3isp depends on omap's iommu and will fail to probe if
initialized before it (which always happen if they are builtin).

Make omap's iommu subsys_initcall as an interim solution until
the probe deferral mechanism is merged.

Reported-by: James <angweiyang@gmail.com>
Debugged-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/mailbox.c |    3 ++-
 drivers/iommu/omap-iommu.c    |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -412,7 +412,8 @@ static void __exit omap2_mbox_exit(void)
 	platform_driver_unregister(&omap2_mbox_driver);
 }
 
-module_init(omap2_mbox_init);
+/* must be ready before omap3isp is probed */
+subsys_initcall(omap2_mbox_init);
 module_exit(omap2_mbox_exit);
 
 MODULE_LICENSE("GPL v2");
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1229,7 +1229,8 @@ static int __init omap_iommu_init(void)
 
 	return platform_driver_register(&omap_iommu_driver);
 }
-module_init(omap_iommu_init);
+/* must be ready before omap3isp is probed */
+subsys_initcall(omap_iommu_init);
 
 static void __exit omap_iommu_exit(void)
 {


