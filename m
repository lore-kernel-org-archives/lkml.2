Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab1GORaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:30:01 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37186
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754010Ab1GOR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:29:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 027/117] Staging: hv: blkvsc: Get rid of the dev_type guid from blkvsc_drv.c
Date: Fri, 15 Jul 2011 10:46:15 -0700
Message-Id: <1310752065-27895-27-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the dev_type guid from blkvsc_drv.c as it is no longer used.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 8e4c206..cb61598 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -111,14 +111,6 @@ struct block_device_context {
 
 static const char *drv_name = "blkvsc";
 
-/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
-static const uuid_le dev_type = {
-	.b = {
-		0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
-		0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
-	}
-};
-
 /*
  * There is a circular dependency involving blkvsc_request_completion()
  * and blkvsc_do_request().
@@ -846,7 +838,6 @@ static int blkvsc_drv_init(void)
 
 	BUILD_BUG_ON(sizeof(sector_t) != 8);
 
-	memcpy(&drv->dev_type, &dev_type, sizeof(uuid_le));
 	drv->driver.name = drv_name;
 
 	/* The driver belongs to vmbus */
-- 
1.7.4.1

