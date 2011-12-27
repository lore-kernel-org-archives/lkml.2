Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab1L0Vrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:47:55 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:52740
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751419Ab1L0Vrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:47:53 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Fuzhou Chen <fuzhouch@microsoft.com>,
        Sasha Levin <levinsasha928@gmail.com>, stable <stable@vger.kernel.org>
Subject: [PATCH 1/1] Drivers:hv: Fix a bug in vmbus_driver_unregister()
Date: Tue, 27 Dec 2011 13:49:37 -0800
Message-Id: <1325022577-23081-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function vmbus_exists() was introduced recently to deal with cases where
the vmbus driver failed to initialize and yet other Hyper-V drivers attempted
to register with the vmbus bus driver. This patch introduced a bug where
vmbus_driver_unregister() would fail to unregister the driver. This patch 
fixes the problem.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Fuzhou Chen <fuzhouch@microsoft.com>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: stable <stable@vger.kernel.org>
---
 drivers/hv/vmbus_drv.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index c3875f7..a220e57 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -627,10 +627,7 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver)
 	pr_info("unregistering driver %s\n", hv_driver->name);
 
 	if (!vmbus_exists())
-		return;
-
-	driver_unregister(&hv_driver->driver);
-
+		driver_unregister(&hv_driver->driver);
 }
 EXPORT_SYMBOL_GPL(vmbus_driver_unregister);
 
-- 
1.7.4.1

