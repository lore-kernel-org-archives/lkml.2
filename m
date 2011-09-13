Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab1IMU3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:29:13 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:44408
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932470Ab1IMU3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:29:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 04/20] Staging: hv: vmbus: Introduce functions for setting and getting driver data
Date: Tue, 13 Sep 2011 10:59:40 -0700
Message-Id: <1315936796-20662-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936796-20662-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce vmbus specific wrapper functions to set/get driver specific data.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hyperv.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index caa3a7b..91e557b 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -843,6 +843,15 @@ static inline struct hv_driver *drv_to_hv_drv(struct device_driver *d)
 	return container_of(d, struct hv_driver, driver);
 }
 
+static inline void hv_set_drvdata(struct hv_device *dev, void *data)
+{
+	dev_set_drvdata(&dev->device, data);
+}
+
+static inline void *hv_get_drvdata(struct hv_device *dev)
+{
+	return dev_get_drvdata(&dev->device);
+}
 
 /* Vmbus interface */
 #define vmbus_driver_register(driver)	\
-- 
1.7.4.1

