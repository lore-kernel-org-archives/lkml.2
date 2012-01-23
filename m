Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2AWUUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:20:08 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:45245 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab2AWUUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:20:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAGO9HU9bdWOb/2dsb2JhbABChQmqJoFzAQUjDwEjIxAlAhgOAgI5AxsGARKHfqcNkTGBL4lhgRYElRmFVox6
X-IronPort-AV: E=Sophos;i="4.71,557,1320620400"; 
   d="scan'208";a="865381557"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 1/5] staging: tidspbridge: more readable code
Date: Mon, 23 Jan 2012 22:09:44 +0200
Message-Id: <42f005f230f96409857bd96f38b234a4da01f421.1327348286.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1327348286.git.vjaquez@igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
In-Reply-To: <cover.1327348286.git.vjaquez@igalia.com>
References: <cover.1327348286.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uppercase function names are not pretty. Also the code flow readability is
enhanced.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 76cfc6e..85f6e8e 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -428,7 +428,7 @@ func_cont:
 }
 
 #ifdef CONFIG_PM
-static int BRIDGE_SUSPEND(struct platform_device *pdev, pm_message_t state)
+static int bridge_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	u32 status;
 	u32 command = PWR_EMERGENCYDEEPSLEEP;
@@ -441,7 +441,7 @@ static int BRIDGE_SUSPEND(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int BRIDGE_RESUME(struct platform_device *pdev)
+static int bridge_resume(struct platform_device *pdev)
 {
 	u32 status;
 
@@ -453,9 +453,6 @@ static int BRIDGE_RESUME(struct platform_device *pdev)
 	wake_up(&bridge_suspend_data.suspend_wq);
 	return 0;
 }
-#else
-#define BRIDGE_SUSPEND NULL
-#define BRIDGE_RESUME NULL
 #endif
 
 static struct platform_driver bridge_driver = {
@@ -464,8 +461,10 @@ static struct platform_driver bridge_driver = {
 		   },
 	.probe = omap34_xx_bridge_probe,
 	.remove = __devexit_p(omap34_xx_bridge_remove),
-	.suspend = BRIDGE_SUSPEND,
-	.resume = BRIDGE_RESUME,
+#ifdef CONFIG_PM
+	.suspend = bridge_suspend,
+	.resume = bridge_resume,
+#endif
 };
 
 static int __init bridge_init(void)
-- 
1.7.8.3

