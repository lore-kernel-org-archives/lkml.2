Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1DZQIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:08:18 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:32780
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753241Ab1DZQIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:08:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/25] Staging: hv: Introduce a function to map a generic driver pointer to a pointer to storvsc_driver_object
Date: Tue, 26 Apr 2011 09:20:18 -0700
Message-Id: <1303834842-5022-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303834785-4981-1-git-send-email-kys@microsoft.com>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for getting rid of the priv element from struct hv_driver,
introduce a function that maps a generic struct driver pointer to struct
storvsc_driver_object.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_api.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index c98139c..b60a058 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -28,6 +28,7 @@
 #include <linux/kernel.h>
 #include "vstorage.h"
 #include "vmbus_api.h"
+#include "vmbus.h"
 
 /* Defines */
 #define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
@@ -153,6 +154,13 @@ static inline struct storvsc_driver_object *hvdr_to_stordr(struct hv_driver *d)
 	return container_of(d, struct storvsc_driver_object, base);
 }
 
+static inline
+struct storvsc_driver_object *drv_to_stordrv(struct device_driver *d)
+{
+	struct hv_driver *hvdrv = drv_to_hv_drv(d);
+	return hvdr_to_stordr(hvdrv);
+}
+
 /* Interface */
 
 int stor_vsc_on_device_add(struct hv_device *device,
-- 
1.7.4.1

