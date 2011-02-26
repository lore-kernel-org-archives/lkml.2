Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab1BZB6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 20:58:51 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:49856
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750887Ab1BZB6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 20:58:50 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 5/6] Staging: hv:  Rename driver_context to hyperv_driver
Date: Fri, 25 Feb 2011 18:07:38 -0800
Message-Id: <1298686058-30918-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The title says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c       |    2 +-
 drivers/staging/hv/blkvsc_drv.c   |   36 ++++++++++++------------
 drivers/staging/hv/netvsc.c       |    6 ++--
 drivers/staging/hv/netvsc_api.h   |    4 +-
 drivers/staging/hv/netvsc_drv.c   |   36 ++++++++++++------------
 drivers/staging/hv/rndis_filter.c |    4 +-
 drivers/staging/hv/storvsc.c      |    4 +-
 drivers/staging/hv/storvsc_api.h  |    6 ++--
 drivers/staging/hv/storvsc_drv.c  |   36 ++++++++++++------------
 drivers/staging/hv/vmbus.h        |   15 +++++-----
 drivers/staging/hv/vmbus_api.h    |    2 +-
 drivers/staging/hv/vmbus_drv.c    |   54 ++++++++++++++++++------------------
 12 files changed, 103 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index d29af4b..51d4dfa 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -63,7 +63,7 @@ blk_vsc_on_device_add(struct hyperv_device *device, void *additional_info)
 	return ret;
 }
 
-int blk_vsc_initialize(struct driver_context *driver)
+int blk_vsc_initialize(struct hyperv_driver *driver)
 {
 	struct storvsc_driver_object *stor_driver;
 	int ret = 0;
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index a280f83..ceba20c 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -116,10 +116,10 @@ struct block_device_context {
 };
 
 /* Per driver */
-struct blkvsc_driver_context {
+struct blkvsc_hyperv_driver {
 	/* !! These must be the first 2 fields !! */
 	/* FIXME this is a bug! */
-	struct driver_context drv_ctx;
+	struct hyperv_driver drv_ctx;
 	struct storvsc_driver_object drv_obj;
 };
 
@@ -156,7 +156,7 @@ module_param(blkvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (in bytes)");
 
 /* The one and only one */
-static struct blkvsc_driver_context g_blkvsc_drv;
+static struct blkvsc_hyperv_driver g_blkvsc_drv;
 
 static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
@@ -171,10 +171,10 @@ static const struct block_device_operations block_ops = {
 /*
  * blkvsc_drv_init -  BlkVsc driver initialization.
  */
-static int blkvsc_drv_init(int (*drv_init)(struct driver_context *drv))
+static int blkvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
+	struct hyperv_driver *drv_ctx = &g_blkvsc_drv.drv_ctx;
 	int ret;
 
 	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
@@ -206,7 +206,7 @@ static int blkvsc_drv_exit_cb(struct device *dev, void *data)
 static void blkvsc_drv_exit(void)
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
+	struct hyperv_driver *drv_ctx = &g_blkvsc_drv.drv_ctx;
 	struct device *current_dev;
 	int ret;
 
@@ -243,10 +243,10 @@ static void blkvsc_drv_exit(void)
  */
 static int blkvsc_probe(struct device *device)
 {
-	struct driver_context *driver_ctx =
-				driver_to_driver_context(device->driver);
-	struct blkvsc_driver_context *blkvsc_drv_ctx =
-				(struct blkvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+				driver_to_hyperv_driver(device->driver);
+	struct blkvsc_hyperv_driver *blkvsc_drv_ctx =
+				(struct blkvsc_hyperv_driver *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
@@ -727,10 +727,10 @@ static int blkvsc_do_read_capacity16(struct block_device_context *blkdev)
  */
 static int blkvsc_remove(struct device *device)
 {
-	struct driver_context *driver_ctx =
-				driver_to_driver_context(device->driver);
-	struct blkvsc_driver_context *blkvsc_drv_ctx =
-				(struct blkvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+				driver_to_hyperv_driver(device->driver);
+	struct blkvsc_hyperv_driver *blkvsc_drv_ctx =
+				(struct blkvsc_hyperv_driver *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
@@ -849,10 +849,10 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
 	struct hyperv_device *device_obj = blkdev->device_obj;
-	struct driver_context *driver_ctx =
-			driver_to_driver_context(device_obj->device.driver);
-	struct blkvsc_driver_context *blkvsc_drv_ctx =
-			(struct blkvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+			driver_to_hyperv_driver(device_obj->device.driver);
+	struct blkvsc_hyperv_driver *blkvsc_drv_ctx =
+			(struct blkvsc_hyperv_driver *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&blkvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *storvsc_req;
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 6d8d0a3..5d41bdf 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -49,7 +49,7 @@ netvsc_device_add(struct hyperv_device *device, void *additional_info);
 
 static int netvsc_device_remove(struct hyperv_device *device);
 
-static void netvsc_cleanup(struct driver_context *driver);
+static void netvsc_cleanup(struct hyperv_driver *driver);
 
 static void netvsc_channel_cb(void *context);
 
@@ -178,7 +178,7 @@ static struct netvsc_device *release_inbound_net_device(
 /*
  * netvsc_initialize - Main entry point
  */
-int netvsc_initialize(struct driver_context *drv)
+int netvsc_initialize(struct hyperv_driver *drv)
 {
 	struct netvsc_driver *driver = (struct netvsc_driver *)drv;
 
@@ -837,7 +837,7 @@ static int netvsc_device_remove(struct hyperv_device *device)
 /*
  * netvsc_cleanup - Perform any cleanup when the driver is removed
  */
-static void netvsc_cleanup(struct driver_context *drv)
+static void netvsc_cleanup(struct hyperv_driver *drv)
 {
 }
 
diff --git a/drivers/staging/hv/netvsc_api.h b/drivers/staging/hv/netvsc_api.h
index 842f542..a96cce4 100644
--- a/drivers/staging/hv/netvsc_api.h
+++ b/drivers/staging/hv/netvsc_api.h
@@ -84,7 +84,7 @@ struct hv_netvsc_packet {
 struct netvsc_driver {
 	/* Must be the first field */
 	/* Which is a bug FIXME! */
-	struct driver_context base;
+	struct hyperv_driver base;
 
 	u32 ring_buf_size;
 	u32 req_ext_size;
@@ -109,7 +109,7 @@ struct netvsc_device_info {
 };
 
 /* Interface */
-int netvsc_initialize(struct driver_context *drv);
+int netvsc_initialize(struct hyperv_driver *drv);
 int rndis_filter_open(struct hyperv_device *dev);
 int rndis_filter_close(struct hyperv_device *dev);
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index fbb32f7..359d596 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -48,10 +48,10 @@ struct net_device_context {
 	unsigned long avail;
 };
 
-struct netvsc_driver_context {
+struct netvsc_hyperv_driver {
 	/* !! These must be the first 2 fields !! */
 	/* Which is a bug FIXME! */
-	struct driver_context drv_ctx;
+	struct hyperv_driver drv_ctx;
 	struct netvsc_driver drv_obj;
 };
 
@@ -64,7 +64,7 @@ module_param(ring_size, int, S_IRUGO);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
 
 /* The one and only one */
-static struct netvsc_driver_context g_netvsc_drv;
+static struct netvsc_hyperv_driver g_netvsc_drv;
 
 /* no-op so the netdev core doesn't return -EINVAL when modifying the the
  * multicast address list in SIOCADDMULTI. hv is setup to get all multicast
@@ -135,10 +135,10 @@ static void netvsc_xmit_completion(void *context)
 static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
 	struct net_device_context *net_device_obj = netdev_priv(net);
-	struct driver_context *driver_ctx =
-	    driver_to_driver_context(net_device_obj->device_obj->device.driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+	    driver_to_hyperv_driver(net_device_obj->device_obj->device.driver);
+	struct netvsc_hyperv_driver *net_drv_ctx =
+		(struct netvsc_hyperv_driver *)driver_ctx;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct hv_netvsc_packet *packet;
 	int ret;
@@ -338,10 +338,10 @@ static const struct net_device_ops device_ops = {
 
 static int netvsc_probe(struct device *device)
 {
-	struct driver_context *driver_ctx =
-		driver_to_driver_context(device->driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+		driver_to_hyperv_driver(device->driver);
+	struct netvsc_hyperv_driver *net_drv_ctx =
+		(struct netvsc_hyperv_driver *)driver_ctx;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct net_device *net = NULL;
@@ -409,10 +409,10 @@ static int netvsc_probe(struct device *device)
 
 static int netvsc_remove(struct device *device)
 {
-	struct driver_context *driver_ctx =
-		driver_to_driver_context(device->driver);
-	struct netvsc_driver_context *net_drv_ctx =
-		(struct netvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+		driver_to_hyperv_driver(device->driver);
+	struct netvsc_hyperv_driver *net_drv_ctx =
+		(struct netvsc_hyperv_driver *)driver_ctx;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct net_device *net = dev_get_drvdata(&device_obj->device);
@@ -458,7 +458,7 @@ static int netvsc_drv_exit_cb(struct device *dev, void *data)
 static void netvsc_drv_exit(void)
 {
 	struct netvsc_driver *netvsc_drv_obj = &g_netvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
+	struct hyperv_driver *drv_ctx = &g_netvsc_drv.drv_ctx;
 	struct device *current_dev;
 	int ret;
 
@@ -490,10 +490,10 @@ static void netvsc_drv_exit(void)
 	return;
 }
 
-static int netvsc_drv_init(int (*drv_init)(struct driver_context *drv))
+static int netvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 {
 	struct netvsc_driver *net_drv_obj = &g_netvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
+	struct hyperv_driver *drv_ctx = &g_netvsc_drv.drv_ctx;
 	int ret;
 
 	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index a2b5f4d..a8f7927 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -90,7 +90,7 @@ static int rndis_filte_device_add(struct hyperv_device *dev,
 
 static int rndis_filter_device_remove(struct hyperv_device *dev);
 
-static void rndis_filter_cleanup(struct driver_context *drv);
+static void rndis_filter_cleanup(struct hyperv_driver *drv);
 
 static int rndis_filter_send(struct hyperv_device *dev,
 			     struct hv_netvsc_packet *pkt);
@@ -834,7 +834,7 @@ static int rndis_filter_device_remove(struct hyperv_device *dev)
 	return 0;
 }
 
-static void rndis_filter_cleanup(struct driver_context *drv)
+static void rndis_filter_cleanup(struct hyperv_driver *drv)
 {
 }
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index c86bc68..d17df6a 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -781,14 +781,14 @@ static int stor_vsc_on_io_request(struct hyperv_device *device,
 /*
  * stor_vsc_on_cleanup - Perform any cleanup when the driver is removed
  */
-static void stor_vsc_on_cleanup(struct driver_context *driver)
+static void stor_vsc_on_cleanup(struct hyperv_driver *driver)
 {
 }
 
 /*
  * stor_vsc_initialize - Main entry point
  */
-int stor_vsc_initialize(struct driver_context *driver)
+int stor_vsc_initialize(struct hyperv_driver *driver)
 {
 	struct storvsc_driver_object *stor_driver;
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index b488d75..e105929 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -80,7 +80,7 @@ struct hv_storvsc_request {
 struct storvsc_driver_object {
 	/* Must be the first field */
 	/* Which is a bug FIXME! */
-	struct driver_context base;
+	struct hyperv_driver base;
 
 	/* Set by caller (in bytes) */
 	u32 ring_buffer_size;
@@ -103,8 +103,8 @@ struct storvsc_device_info {
 };
 
 /* Interface */
-int stor_vsc_initialize(struct driver_context *driver);
+int stor_vsc_initialize(struct hyperv_driver *driver);
 int stor_vsc_on_host_reset(struct hyperv_device *device);
-int blk_vsc_initialize(struct driver_context *driver);
+int blk_vsc_initialize(struct hyperv_driver *driver);
 
 #endif /* _STORVSC_API_H_ */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 282bd66..659d385 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -64,10 +64,10 @@ struct storvsc_cmd_request {
 	 * Which sounds like a very bad design... */
 };
 
-struct storvsc_driver_context {
+struct storvsc_hyperv_driver {
 	/* !! These must be the first 2 fields !! */
 	/* FIXME this is a bug... */
-	struct driver_context drv_ctx;
+	struct hyperv_driver drv_ctx;
 	struct storvsc_driver_object drv_obj;
 };
 
@@ -101,7 +101,7 @@ module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 /* The one and only one */
-static struct storvsc_driver_context g_storvsc_drv;
+static struct storvsc_hyperv_driver g_storvsc_drv;
 
 /* Scsi driver */
 static struct scsi_host_template scsi_driver = {
@@ -135,11 +135,11 @@ static struct scsi_host_template scsi_driver = {
 /*
  * storvsc_drv_init - StorVsc driver initialization.
  */
-static int storvsc_drv_init(int (*drv_init)(struct driver_context *drv))
+static int storvsc_drv_init(int (*drv_init)(struct hyperv_driver *drv))
 {
 	int ret;
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_storvsc_drv.drv_ctx;
+	struct hyperv_driver *drv_ctx = &g_storvsc_drv.drv_ctx;
 
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
 
@@ -184,7 +184,7 @@ static int storvsc_drv_exit_cb(struct device *dev, void *data)
 static void storvsc_drv_exit(void)
 {
 	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
-	struct driver_context *drv_ctx = &g_storvsc_drv.drv_ctx;
+	struct hyperv_driver *drv_ctx = &g_storvsc_drv.drv_ctx;
 	struct device *current_dev = NULL;
 	int ret;
 
@@ -220,10 +220,10 @@ static void storvsc_drv_exit(void)
 static int storvsc_probe(struct device *device)
 {
 	int ret;
-	struct driver_context *driver_ctx =
-				driver_to_driver_context(device->driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-				(struct storvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+				driver_to_hyperv_driver(device->driver);
+	struct storvsc_hyperv_driver *storvsc_drv_ctx =
+				(struct storvsc_hyperv_driver *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&storvsc_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
@@ -304,10 +304,10 @@ static int storvsc_probe(struct device *device)
 static int storvsc_remove(struct device *device)
 {
 	int ret;
-	struct driver_context *driver_ctx =
-			driver_to_driver_context(device->driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-			(struct storvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+			driver_to_hyperv_driver(device->driver);
+	struct storvsc_hyperv_driver *storvsc_drv_ctx =
+			(struct storvsc_hyperv_driver *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&storvsc_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
@@ -601,10 +601,10 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	struct host_device_context *host_device_obj =
 		(struct host_device_context *)scmnd->device->host->hostdata;
 	struct hyperv_device *device_obj = host_device_obj->device_obj;
-	struct driver_context *driver_ctx =
-		driver_to_driver_context(device_obj->device.driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-		(struct storvsc_driver_context *)driver_ctx;
+	struct hyperv_driver *driver_ctx =
+		driver_to_hyperv_driver(device_obj->device.driver);
+	struct storvsc_hyperv_driver *storvsc_drv_ctx =
+		(struct storvsc_hyperv_driver *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
 		&storvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *request;
diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
index cad8b4c..617c3ed 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -28,7 +28,7 @@
 #include <linux/device.h>
 #include "vmbus_api.h"
 
-struct driver_context {
+struct hyperv_driver {
 	const char *name;
 
 	struct hv_guid class_id;
@@ -37,7 +37,7 @@ struct driver_context {
 
 	int (*dev_rm)(struct hyperv_device *device);
 
-	void (*cleanup)(struct driver_context *driver);
+	void (*cleanup)(struct hyperv_driver *driver);
 
 	struct device_driver driver;
 
@@ -56,7 +56,7 @@ struct hyperv_device {
 	struct work_struct probe_failed_work_item;
 	struct hv_guid class_id; /* device type id */
 	struct hv_guid device_id; /* device instance id */
-	struct driver_context *drv;
+	struct hyperv_driver *drv;
 	int probe_error;
 	struct vmbus_channel *channel; /* associated channel to host*/
 	void    *ext;
@@ -69,15 +69,16 @@ static inline struct hyperv_device *device_to_hyperv_device(struct device *d)
 	return container_of(d, struct hyperv_device, device);
 }
 
-static inline struct driver_context *driver_to_driver_context(struct device_driver *d)
+static inline struct hyperv_driver *
+driver_to_hyperv_driver(struct device_driver *d)
 {
-	return container_of(d, struct driver_context, driver);
+	return container_of(d, struct hyperv_driver, driver);
 }
 
 
 /* Vmbus interface */
-int vmbus_child_driver_register(struct driver_context *driver_ctx);
-void vmbus_child_driver_unregister(struct driver_context *driver_ctx);
+int vmbus_child_driver_register(struct hyperv_driver *driver_ctx);
+void vmbus_child_driver_unregister(struct hyperv_driver *driver_ctx);
 
 extern struct completion hv_channel_ready;
 
diff --git a/drivers/staging/hv/vmbus_api.h b/drivers/staging/hv/vmbus_api.h
index 0d8232e..6e3e1a8 100644
--- a/drivers/staging/hv/vmbus_api.h
+++ b/drivers/staging/hv/vmbus_api.h
@@ -55,7 +55,7 @@ struct hv_multipage_buffer {
 
 #pragma pack(pop)
 
-struct driver_context;
+struct hyperv_driver;
 struct hyperv_device;
 
 struct hv_dev_port_info {
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 3922a07..c7e8a36 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -41,13 +41,13 @@
 #define VMBUS_IRQ_VECTOR	IRQ5_VECTOR
 
 /* Main vmbus driver data structure */
-struct vmbus_driver_context {
+struct vmbus_hyperv_driver {
 	/* !! These must be the first 2 fields !! */
 	/* FIXME, this is a bug */
 	/* The driver field is not used in here. Instead, the bus field is */
 	/* used to represent the driver */
-	struct driver_context drv_ctx;
-	struct driver_context drv_obj;
+	struct hyperv_driver drv_ctx;
+	struct hyperv_driver drv_obj;
 
 	struct bus_type bus;
 	struct tasklet_struct msg_dpc;
@@ -113,7 +113,7 @@ static struct device_attribute vmbus_device_attrs[] = {
 };
 
 /* The one and only one */
-static struct vmbus_driver_context vmbus_drv = {
+static struct vmbus_hyperv_driver vmbus_drv = {
 	.bus.name =		"vmbus",
 	.bus.match =		vmbus_match,
 	.bus.shutdown =		vmbus_shutdown,
@@ -196,7 +196,7 @@ static int vmbus_dev_rm(struct hyperv_device *dev)
 /*
  * vmbus_cleanup - Perform any cleanup when the driver is removed
  */
-static void vmbus_cleanup(struct driver_context *drv)
+static void vmbus_cleanup(struct hyperv_driver *drv)
 {
 	/* struct vmbus_driver *driver = (struct vmbus_driver *)drv; */
 
@@ -221,7 +221,7 @@ static void vmbus_onmessage_work(struct work_struct *work)
 /*
  * vmbus_on_msg_dpc - DPC routine to handle messages from the hypervisior
  */
-static void vmbus_on_msg_dpc(struct driver_context *drv)
+static void vmbus_on_msg_dpc(struct hyperv_driver *drv)
 {
 	int cpu = smp_processor_id();
 	void *page_addr = hv_context.synic_message_page[cpu];
@@ -267,7 +267,7 @@ static void vmbus_on_msg_dpc(struct driver_context *drv)
 /*
  * vmbus_on_isr - ISR routine
  */
-static int vmbus_on_isr(struct driver_context *drv)
+static int vmbus_on_isr(struct hyperv_driver *drv)
 {
 	int ret = 0;
 	int cpu = smp_processor_id();
@@ -462,8 +462,8 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
  */
 static int vmbus_bus_init(void)
 {
-	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
-	struct driver_context *driver = &vmbus_drv.drv_obj;
+	struct vmbus_hyperv_driver *vmbus_drv_ctx = &vmbus_drv;
+	struct hyperv_driver *driver = &vmbus_drv.drv_obj;
 	struct hyperv_device *dev = &vmbus_drv.device_obj;
 	int ret;
 	unsigned int vector;
@@ -587,8 +587,8 @@ cleanup:
  */
 static void vmbus_bus_exit(void)
 {
-	struct driver_context *driver = &vmbus_drv.drv_obj;
-	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
+	struct hyperv_driver *driver = &vmbus_drv.drv_obj;
+	struct vmbus_hyperv_driver *vmbus_drv_ctx = &vmbus_drv;
 
 	struct hyperv_device *dev = &vmbus_drv.device_obj;
 
@@ -615,7 +615,7 @@ static void vmbus_bus_exit(void)
  * vmbus_child_driver_register() - Register a vmbus's child driver
  * @driver_ctx:        Pointer to driver structure you want to register
  *
- * @driver_ctx is of type &struct driver_context
+ * @driver_ctx is of type &struct hyperv_driver
  *
  * Registers the given driver with Linux through the 'driver_register()' call
  * And sets up the hyper-v vmbus handling for this driver.
@@ -623,7 +623,7 @@ static void vmbus_bus_exit(void)
  *
  * Mainly used by Hyper-V drivers.
  */
-int vmbus_child_driver_register(struct driver_context *driver_ctx)
+int vmbus_child_driver_register(struct hyperv_driver *driver_ctx)
 {
 	int ret;
 
@@ -645,14 +645,14 @@ EXPORT_SYMBOL(vmbus_child_driver_register);
  * vmbus_child_driver_unregister() - Unregister a vmbus's child driver
  * @driver_ctx:        Pointer to driver structure you want to un-register
  *
- * @driver_ctx is of type &struct driver_context
+ * @driver_ctx is of type &struct hyperv_driver
  *
  * Un-register the given driver with Linux through the 'driver_unregister()'
  * call. And ungegisters the driver from the Hyper-V vmbus handler.
  *
  * Mainly used by Hyper-V drivers.
  */
-void vmbus_child_driver_unregister(struct driver_context *driver_ctx)
+void vmbus_child_driver_unregister(struct hyperv_driver *driver_ctx)
 {
 	DPRINT_INFO(VMBUS_DRV, "child driver (%p) unregistering - name %s",
 		    driver_ctx, driver_ctx->driver.name);
@@ -849,7 +849,7 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 static int vmbus_match(struct device *device, struct device_driver *driver)
 {
 	int match = 0;
-	struct driver_context *driver_ctx = driver_to_driver_context(driver);
+	struct hyperv_driver *driver_ctx = driver_to_hyperv_driver(driver);
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 
 	/* We found our driver ? */
@@ -857,10 +857,10 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 		   sizeof(struct hv_guid)) == 0) {
 		/*
 		 * !! NOTE: The driver_ctx is not a vmbus_drv_ctx. We typecast
-		 * it here to access the struct driver_context field
+		 * it here to access the struct hyperv_driver field
 		 */
-		struct vmbus_driver_context *vmbus_drv_ctx =
-			(struct vmbus_driver_context *)driver_ctx;
+		struct vmbus_hyperv_driver *vmbus_drv_ctx =
+			(struct vmbus_hyperv_driver *)driver_ctx;
 
 		device_obj->drv = &vmbus_drv_ctx->drv_obj;
 		DPRINT_INFO(VMBUS_DRV,
@@ -899,8 +899,8 @@ static void vmbus_probe_failed_cb(struct work_struct *context)
 static int vmbus_probe(struct device *child_device)
 {
 	int ret = 0;
-	struct driver_context *driver_ctx =
-			driver_to_driver_context(child_device->driver);
+	struct hyperv_driver *driver_ctx =
+			driver_to_hyperv_driver(child_device->driver);
 	struct hyperv_device *device_obj =
 			device_to_hyperv_device(child_device);
 
@@ -931,7 +931,7 @@ static int vmbus_probe(struct device *child_device)
 static int vmbus_remove(struct device *child_device)
 {
 	int ret;
-	struct driver_context *driver_ctx;
+	struct hyperv_driver *driver_ctx;
 
 	/* Special case root bus device */
 	if (child_device->parent == NULL) {
@@ -943,7 +943,7 @@ static int vmbus_remove(struct device *child_device)
 	}
 
 	if (child_device->driver) {
-		driver_ctx = driver_to_driver_context(child_device->driver);
+		driver_ctx = driver_to_hyperv_driver(child_device->driver);
 
 		/*
 		 * Let the specific open-source driver handles the removal if
@@ -967,7 +967,7 @@ static int vmbus_remove(struct device *child_device)
  */
 static void vmbus_shutdown(struct device *child_device)
 {
-	struct driver_context *driver_ctx;
+	struct hyperv_driver *driver_ctx;
 
 	/* Special case root bus device */
 	if (child_device->parent == NULL) {
@@ -982,7 +982,7 @@ static void vmbus_shutdown(struct device *child_device)
 	if (!child_device->driver)
 		return;
 
-	driver_ctx = driver_to_driver_context(child_device->driver);
+	driver_ctx = driver_to_hyperv_driver(child_device->driver);
 
 	/* Let the specific open-source driver handles the removal if it can */
 	if (driver_ctx->shutdown)
@@ -1020,7 +1020,7 @@ static void vmbus_device_release(struct device *device)
  */
 static void vmbus_msg_dpc(unsigned long data)
 {
-	struct driver_context *driver = (struct driver_context *)data;
+	struct hyperv_driver *driver = (struct hyperv_driver *)data;
 
 	/* Call to bus driver to handle interrupt */
 	vmbus_on_msg_dpc(driver);
@@ -1037,7 +1037,7 @@ static void vmbus_event_dpc(unsigned long data)
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id)
 {
-	struct driver_context *driver = &vmbus_drv.drv_obj;
+	struct hyperv_driver *driver = &vmbus_drv.drv_obj;
 	int ret;
 
 	/* Call to bus driver to handle interrupt */
-- 
1.5.5.6

