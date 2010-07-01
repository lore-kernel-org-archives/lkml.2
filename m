Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0GANkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:40:53 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41466 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab0GANkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GKhpE9Xi13rk7yqAGHtrNwOEIv/Q0iihRYmSfKM4Iq+K4Ykfa7GMDA4tjbETpWKVFT
         29W2iPAWz5pNrZPGoD5WkWyIgiMEmRppDwB24DfNpYrQp+YbkQg2rFIIzyBAntM6dvwI
         Slqf/2XQ3hZ4qmFiqv6SzsM9sxBgxB+Ifcxb4=
From: Afzal Mohammed <lazfamam@gmail.com>
To: tomi.valkeinen@nokia.com
Cc: ville.syrjala@nokia.com, tj@kernel.org, lazfamam@gmail.com,
       linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP:DSS2:OMAPFB: Fix probe error path
Date: Thu,  1 Jul 2010 19:10:01 +0530
Message-Id: <1277991601-16528-2-git-send-email-lazfamam@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277991601-16528-1-git-send-email-lazfamam@gmail.com>
References: <1277991601-16528-1-git-send-email-lazfamam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move sysfs entry creation to omapfb_probe() from omapfb_create_framebuffers().
This will make sure that sysfs entry is not left behind in case of unsuccessful
probe due to failure in enabling fb0 of omapfb_create_framebuffers().

Signed-off-by: Afzal Mohammed <lazfamam@gmail.com>
---
 drivers/video/omap2/omapfb/omapfb-main.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/omap2/omapfb/omapfb-main.c b/drivers/video/omap2/omapfb/omapfb-main.c
index 4b4506d..710e117 100644
--- a/drivers/video/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/omap2/omapfb/omapfb-main.c
@@ -1928,13 +1928,6 @@ static int omapfb_create_framebuffers(struct omapfb2_device *fbdev)
 		}
 	}
 
-	DBG("create sysfs for fbs\n");
-	r = omapfb_create_sysfs(fbdev);
-	if (r) {
-		dev_err(fbdev->dev, "failed to create sysfs entries\n");
-		return r;
-	}
-
 	/* Enable fb0 */
 	if (fbdev->num_fbs > 0) {
 		struct omapfb_info *ofbi = FB2OFB(fbdev->fbs[0]);
@@ -2220,6 +2213,13 @@ static int omapfb_probe(struct platform_device *pdev)
 		}
 	}
 
+	DBG("create sysfs for fbs\n");
+	r = omapfb_create_sysfs(fbdev);
+	if (r) {
+		dev_err(fbdev->dev, "failed to create sysfs entries\n");
+		goto cleanup;
+	}
+
 	return 0;
 
 cleanup:
-- 
1.7.0.4

