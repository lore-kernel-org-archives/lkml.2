Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1DGRdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:33:00 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:55289 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab1DGRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:32:59 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Kumar Gala <galak@kernel.crashing.org>,
        bluesmoke-devel@lists.sourceforge.net
Subject: [PATCH] edac/mpc85xx: fix unused variable warning
Date: Thu,  7 Apr 2011 10:32:48 -0700
Message-Id: <1302197568-31725-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Thu, 07 Apr 2011 10:32:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a94d7b35067ab403485a1ea06b7a3d0172d1a1ba introduced an unused
variable warning when CONFIG_FSL_SOC_BOOKE is not defined. Fix it.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: bluesmoke-devel@lists.sourceforge.net
---
 drivers/edac/mpc85xx_edac.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 38ab8e2..6002657 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -1154,7 +1154,9 @@ static void __init mpc85xx_mc_clear_rfxe(void *data)
 static int __init mpc85xx_mc_init(void)
 {
 	int res = 0;
+#ifdef CONFIG_FSL_SOC_BOOKE
 	u32 pvr = 0;
+#endif
 
 	printk(KERN_INFO "Freescale(R) MPC85xx EDAC driver, "
 	       "(C) 2006 Montavista Software\n");
-- 
1.7.3.4

