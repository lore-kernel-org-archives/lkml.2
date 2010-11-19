Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab0KSWWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:22:12 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39246 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab0KSV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:54 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, aaro.koskinen@iki.fi
Subject: [PATCH 8/9] sisfb: move the CONFIG warning to sis_main.c
Date: Fri, 19 Nov 2010 23:58:50 +0200
Message-Id: <1290203931-25188-9-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
References: <1290203931-25188-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sis_main.c is always compiled, so we can check Kconfig options there.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
---
 drivers/video/sis/osdef.h    |    5 -----
 drivers/video/sis/sis_main.c |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/sis/osdef.h b/drivers/video/sis/osdef.h
index af5e9a2..5baaa79 100644
--- a/drivers/video/sis/osdef.h
+++ b/drivers/video/sis/osdef.h
@@ -58,9 +58,4 @@
 /*  LINUX KERNEL                                                      */
 /**********************************************************************/
 
-#if !defined(CONFIG_FB_SIS_300) && !defined(CONFIG_FB_SIS_315)
-#warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set
-#warning sisfb will not work!
-#endif
-
 #endif  /* _OSDEF_H_ */
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 7feb699..7e3370f 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -60,6 +60,11 @@
 #include "sis.h"
 #include "sis_main.h"
 
+#if !defined(CONFIG_FB_SIS_300) && !defined(CONFIG_FB_SIS_315)
+#warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set
+#warning sisfb will not work!
+#endif
+
 static void sisfb_handle_command(struct sis_video_info *ivideo,
 				 struct sisfb_cmd *sisfb_command);
 
-- 
1.5.6.5

