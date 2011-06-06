Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab1FFWfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:35:06 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37202
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753290Ab1FFWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 02/49] Staging: hv: storvsc: Cleanup the exit function in storvsc_drv.c
Date: Mon,  6 Jun 2011 15:49:26 -0700
Message-Id: <1307400613-13234-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of unnecessary layering in the module exit path.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 942cc5f..e21f7e6 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -792,7 +792,7 @@ static int storvsc_drv_init(void)
 	return ret;
 }
 
-static void storvsc_drv_exit(void)
+static void __exit storvsc_drv_exit(void)
 {
 	vmbus_child_driver_unregister(&storvsc_drv.driver);
 }
@@ -806,13 +806,8 @@ static int __init storvsc_init(void)
 	return ret;
 }
 
-static void __exit storvsc_exit(void)
-{
-	storvsc_drv_exit();
-}
-
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 MODULE_DESCRIPTION("Microsoft Hyper-V virtual storage driver");
 module_init(storvsc_init);
-module_exit(storvsc_exit);
+module_exit(storvsc_drv_exit);
-- 
1.7.4.1

