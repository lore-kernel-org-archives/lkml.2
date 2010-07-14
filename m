Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab0GNNVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:21:35 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:45207 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756968Ab0GNNVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:21:32 -0400
Date: Wed, 14 Jul 2010 15:21:30 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Muralidharan Karicheri <mkaricheri@gmail.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Julia Lawall <julia@diku.dk>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 3/4] drivers/media/video: Remove dead
 CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE
Message-ID: <debd91a5c9725b43210a0c479f3f2e4134cb3592.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1279111369.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE doesn't exist in Kconfig and is never defined anywhere
else, therefore removing all references for it from the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/media/video/omap/omap_vout.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 929073e..4ed51b1 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2545,19 +2545,11 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 			/* set the update mode */
 			if (def_display->caps &
 					OMAP_DSS_DISPLAY_CAP_MANUAL_UPDATE) {
-#ifdef CONFIG_FB_OMAP2_FORCE_AUTO_UPDATE
-				if (dssdrv->enable_te)
-					dssdrv->enable_te(def_display, 1);
-				if (dssdrv->set_update_mode)
-					dssdrv->set_update_mode(def_display,
-							OMAP_DSS_UPDATE_AUTO);
-#else	/* MANUAL_UPDATE */
 				if (dssdrv->enable_te)
 					dssdrv->enable_te(def_display, 0);
 				if (dssdrv->set_update_mode)
 					dssdrv->set_update_mode(def_display,
 							OMAP_DSS_UPDATE_MANUAL);
-#endif
 			} else {
 				if (dssdrv->set_update_mode)
 					dssdrv->set_update_mode(def_display,
-- 
1.7.0.4

