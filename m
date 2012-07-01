Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2GAJoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:44:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49544 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2GAJoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:44:20 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] remoteproc/omap: fix randconfig unmet direct dependencies
Date: Sun,  1 Jul 2012 12:44:02 +0300
Message-Id: <1341135842-22006-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP_REMOTEPROC selects REMOTEPROC, which depends on EXPERIMENTAL,
so let's have OMAP_REMOTEPROC depend on EXPERIMENTAL too, in order
to avoid the below randconfig warnings.

This will also (indirectly) take care of the RPMSG unmet dependencies
warnings.

warning: (OMAP_REMOTEPROC) selects REMOTEPROC which has unmet direct dependencies (EXPERIMENTAL)
warning: (OMAP_REMOTEPROC) selects RPMSG which has unmet direct dependencies (EXPERIMENTAL)
warning: (OMAP_REMOTEPROC) selects REMOTEPROC which has unmet direct dependencies (EXPERIMENTAL)
warning: (OMAP_REMOTEPROC) selects RPMSG which has unmet direct dependencies (EXPERIMENTAL)

Reported-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index ff6f55c..726804e 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -8,6 +8,7 @@ config REMOTEPROC
 
 config OMAP_REMOTEPROC
 	tristate "OMAP remoteproc support"
+	depends on EXPERIMENTAL
 	depends on ARCH_OMAP4
 	depends on OMAP_IOMMU
 	select REMOTEPROC
-- 
1.7.10.rc3.743.gaa3bb87

