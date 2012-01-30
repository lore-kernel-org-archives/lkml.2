Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2A3XNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:13:23 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:37131 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2A3XMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:12:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAB4jJ09bdWOb/2dsb2JhbABDhQuqUYFzAQUjDwEjIxAlAhgOAgI5AxsGARKHf6cGkV2BL4lQAQUCAgIIAQEEDQQGAQsJCBQXgzNeFYJCgRYElRqFVox8
X-IronPort-AV: E=Sophos;i="4.71,592,1320620400"; 
   d="scan'208";a="945795219"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Armando Uribe <x0095078@ti.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v2 6/8] staging: tidspbridge: remove trivial assert
Date: Tue, 31 Jan 2012 00:12:22 +0100
Message-Id: <24823056ec30b5aa47ac56198b0b571fcf80ec73.1327964066.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
In-Reply-To: <cover.1327964066.git.vjaquez@igalia.com>
References: <cover.1327964066.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function dsp_deinit() always return true, so assert its output is
pointless. As consequence the variable were the returned value is stored, is
no longer needed.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 4531920..97c40ff 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -531,7 +531,6 @@ err1:
 static int __devexit omap34_xx_bridge_remove(struct platform_device *pdev)
 {
 	dev_t devno;
-	bool ret;
 	int status = 0;
 	struct drv_data *drv_datap = dev_get_drvdata(bridge);
 
@@ -551,9 +550,8 @@ static int __devexit omap34_xx_bridge_remove(struct platform_device *pdev)
 
 	if (driver_context) {
 		/* Put the DSP in reset state */
-		ret = dsp_deinit(driver_context);
+		dsp_deinit(driver_context);
 		driver_context = 0;
-		DBC_ASSERT(ret == true);
 	}
 
 func_cont:
-- 
1.7.8.3

