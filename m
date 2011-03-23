Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1CWRko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:40:44 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42539
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756062Ab1CWRkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:39 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 05/16] Staging: hv: Get rid of the include of  storvsc.c from blkvsc.c
Date: Wed, 23 Mar 2011 10:50:23 -0700
Message-Id: <1300902635-1347-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all the structure definitions have been moved to a header file,
get rid of the inclusion of storvsc.c from blkvsc.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/Makefile      |    2 +-
 drivers/staging/hv/blkvsc.c      |    2 +-
 drivers/staging/hv/storvsc.c     |    8 ++++----
 drivers/staging/hv/storvsc_api.h |    9 +++++++++
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/Makefile b/drivers/staging/hv/Makefile
index abeb2f7..a733154 100644
--- a/drivers/staging/hv/Makefile
+++ b/drivers/staging/hv/Makefile
@@ -9,6 +9,6 @@ hv_vmbus-y := vmbus_drv.o \
 		 hv.o connection.o channel.o \
 		 channel_mgmt.o ring_buffer.o
 hv_storvsc-y := storvsc_drv.o storvsc.o
-hv_blkvsc-y := blkvsc_drv.o blkvsc.o
+hv_blkvsc-y := blkvsc_drv.o blkvsc.o storvsc.o
 hv_netvsc-y := netvsc_drv.o netvsc.o rndis_filter.o
 hv_utils-y := hv_util.o hv_kvp.o
diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 88d6e3c..ebe511a 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -22,8 +22,8 @@
  */
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include "logging.h"
 #include "hv_api.h"
-#include "storvsc.c"
 #include "storvsc_api.h"
 
 static const char *g_blk_driver_name = "blkvsc";
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index be1c77a..c8d7ff7 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -504,7 +504,7 @@ static int stor_vsc_connect_to_vsp(struct hv_device *device)
  * stor_vsc_on_device_add - Callback when the device belonging to this driver
  * is added
  */
-static int stor_vsc_on_device_add(struct hv_device *device,
+int stor_vsc_on_device_add(struct hv_device *device,
 					void *additional_info)
 {
 	struct storvsc_device *stor_device;
@@ -553,7 +553,7 @@ cleanup:
 /*
  * stor_vsc_on_device_remove - Callback when the our device is being removed
  */
-static int stor_vsc_on_device_remove(struct hv_device *device)
+int stor_vsc_on_device_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 
@@ -646,7 +646,7 @@ cleanup:
 /*
  * stor_vsc_on_io_request - Callback to initiate an I/O request
  */
-static int stor_vsc_on_io_request(struct hv_device *device,
+int stor_vsc_on_io_request(struct hv_device *device,
 			      struct hv_storvsc_request *request)
 {
 	struct storvsc_device *stor_device;
@@ -739,7 +739,7 @@ static int stor_vsc_on_io_request(struct hv_device *device,
 /*
  * stor_vsc_on_cleanup - Perform any cleanup when the driver is removed
  */
-static void stor_vsc_on_cleanup(struct hv_driver *driver)
+void stor_vsc_on_cleanup(struct hv_driver *driver)
 {
 }
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 7f780c5..141b8fd 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -142,4 +142,13 @@ int stor_vsc_initialize(struct hv_driver *driver);
 int stor_vsc_on_host_reset(struct hv_device *device);
 int blk_vsc_initialize(struct hv_driver *driver);
 
+int stor_vsc_on_device_add(struct hv_device *device,
+				void *additional_info);
+int stor_vsc_on_device_remove(struct hv_device *device);
+
+int stor_vsc_on_io_request(struct hv_device *device,
+				struct hv_storvsc_request *request);
+void stor_vsc_on_cleanup(struct hv_driver *driver);
+
+
 #endif /* _STORVSC_API_H_ */
-- 
1.7.4.1

