Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab1BZB5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 20:57:46 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53991
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750945Ab1BZB5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 20:57:44 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 3/6] Staging: hv: Cleanup hyperv_device variable names
Date: Fri, 25 Feb 2011 18:06:32 -0800
Message-Id: <1298685992-30864-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the names of variables that refer to the
hyperv_device abstraction.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc_drv.c  |   12 ++--
 drivers/staging/hv/netvsc.c      |    4 +-
 drivers/staging/hv/netvsc_drv.c  |   36 ++++----
 drivers/staging/hv/storvsc_drv.c |   44 +++++-----
 drivers/staging/hv/vmbus_drv.c   |  164 +++++++++++++++++++-------------------
 5 files changed, 130 insertions(+), 130 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 58ab0e8..305a665 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -95,7 +95,7 @@ struct blkvsc_request {
 /* Per device structure */
 struct block_device_context {
 	/* point back to our device context */
-	struct hyperv_device *device_ctx;
+	struct hyperv_device *device_obj;
 	struct kmem_cache *request_pool;
 	spinlock_t lock;
 	struct gendisk *gd;
@@ -298,7 +298,7 @@ static int blkvsc_probe(struct device *device)
 		goto Cleanup;
 	}
 
-	blkdev->device_ctx = device_obj;
+	blkdev->device_obj = device_obj;
 	/* this identified the device 0 or 1 */
 	blkdev->target = device_info.target_id;
 	/* this identified the ide ctrl 0 or 1 */
@@ -367,7 +367,7 @@ static int blkvsc_probe(struct device *device)
 		blkdev->gd->first_minor = 0;
 	blkdev->gd->fops = &block_ops;
 	blkdev->gd->private_data = blkdev;
-	blkdev->gd->driverfs_dev = &(blkdev->device_ctx->device);
+	blkdev->gd->driverfs_dev = &(blkdev->device_obj->device);
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
 
 	blkvsc_do_inquiry(blkdev);
@@ -848,9 +848,9 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 			void (*request_completion)(struct hv_storvsc_request *))
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
-	struct hyperv_device *device_ctx = blkdev->device_ctx;
+	struct hyperv_device *device_obj = blkdev->device_obj;
 	struct driver_context *driver_ctx =
-			driver_to_driver_context(device_ctx->device.driver);
+			driver_to_driver_context(device_obj->device.driver);
 	struct blkvsc_driver_context *blkvsc_drv_ctx =
 			(struct blkvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
@@ -895,7 +895,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
 	storvsc_req->sense_buffer_size = SCSI_SENSE_BUFFERSIZE;
 
-	ret = storvsc_drv_obj->on_io_request(blkdev->device_ctx,
+	ret = storvsc_drv_obj->on_io_request(blkdev->device_obj,
 					   &blkvsc_req->request);
 	if (ret == 0)
 		blkdev->num_outstanding_reqs++;
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 7841cae..7cf6999 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -44,8 +44,8 @@ static const struct hv_guid netvsc_device_type = {
 	}
 };
 
-static int netvsc_device_add(struct hyperv_device *device,
-			void *additional_info);
+static int
+netvsc_device_add(struct hyperv_device *device, void *additional_info);
 
 static int netvsc_device_remove(struct hyperv_device *device);
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 31cbbab..fc4eb9b 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -44,7 +44,7 @@
 
 struct net_device_context {
 	/* point back to our device context */
-	struct hyperv_device *device_ctx;
+	struct hyperv_device *device_obj;
 	unsigned long avail;
 };
 
@@ -75,8 +75,8 @@ static void netvsc_set_multicast_list(struct net_device *net)
 
 static int netvsc_open(struct net_device *net)
 {
-	struct net_device_context *net_device_ctx = netdev_priv(net);
-	struct hyperv_device *device_obj = net_device_ctx->device_ctx;
+	struct net_device_context *net_device_obj = netdev_priv(net);
+	struct hyperv_device *device_obj = net_device_obj->device_obj;
 	int ret = 0;
 
 	if (netif_carrier_ok(net)) {
@@ -98,8 +98,8 @@ static int netvsc_open(struct net_device *net)
 
 static int netvsc_close(struct net_device *net)
 {
-	struct net_device_context *net_device_ctx = netdev_priv(net);
-	struct hyperv_device *device_obj = net_device_ctx->device_ctx;
+	struct net_device_context *net_device_obj = netdev_priv(net);
+	struct hyperv_device *device_obj = net_device_obj->device_obj;
 	int ret;
 
 	netif_stop_queue(net);
@@ -121,22 +121,22 @@ static void netvsc_xmit_completion(void *context)
 
 	if (skb) {
 		struct net_device *net = skb->dev;
-		struct net_device_context *net_device_ctx = netdev_priv(net);
+		struct net_device_context *net_device_obj = netdev_priv(net);
 		unsigned int num_pages = skb_shinfo(skb)->nr_frags + 2;
 
 		dev_kfree_skb_any(skb);
 
-		net_device_ctx->avail += num_pages;
-		if (net_device_ctx->avail >= PACKET_PAGES_HIWATER)
+		net_device_obj->avail += num_pages;
+		if (net_device_obj->avail >= PACKET_PAGES_HIWATER)
  			netif_wake_queue(net);
 	}
 }
 
 static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 {
-	struct net_device_context *net_device_ctx = netdev_priv(net);
+	struct net_device_context *net_device_obj = netdev_priv(net);
 	struct driver_context *driver_ctx =
-	    driver_to_driver_context(net_device_ctx->device_ctx->device.driver);
+	    driver_to_driver_context(net_device_obj->device_obj->device.driver);
 	struct netvsc_driver_context *net_drv_ctx =
 		(struct netvsc_driver_context *)driver_ctx;
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
@@ -149,7 +149,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 
 	/* Add 1 for skb->data and additional one for RNDIS */
 	num_pages = skb_shinfo(skb)->nr_frags + 1 + 1;
-	if (num_pages > net_device_ctx->avail)
+	if (num_pages > net_device_obj->avail)
 		return NETDEV_TX_BUSY;
 
 	/* Allocate a netvsc packet based on # of frags. */
@@ -198,7 +198,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	packet->completion.send.send_completion_ctx = packet;
 	packet->completion.send.send_completion_tid = (unsigned long)skb;
 
-	ret = net_drv_obj->send(net_device_ctx->device_ctx,
+	ret = net_drv_obj->send(net_device_obj->device_obj,
 				  packet);
 	if (ret == 0) {
 		net->stats.tx_bytes += skb->len;
@@ -208,8 +208,8 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 			   net->stats.tx_packets,
 			   net->stats.tx_bytes);
 
-		net_device_ctx->avail -= num_pages;
-		if (net_device_ctx->avail < PACKET_PAGES_LOWATER)
+		net_device_obj->avail -= num_pages;
+		if (net_device_obj->avail < PACKET_PAGES_LOWATER)
 			netif_stop_queue(net);
 	} else {
 		/* we are shutting down or bus overloaded, just drop packet */
@@ -345,7 +345,7 @@ static int netvsc_probe(struct device *device)
 	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct net_device *net = NULL;
-	struct net_device_context *net_device_ctx;
+	struct net_device_context *net_device_obj;
 	struct netvsc_device_info device_info;
 	int ret;
 
@@ -359,9 +359,9 @@ static int netvsc_probe(struct device *device)
 	/* Set initial state */
 	netif_carrier_off(net);
 
-	net_device_ctx = netdev_priv(net);
-	net_device_ctx->device_ctx = device_obj;
-	net_device_ctx->avail = ring_size;
+	net_device_obj = netdev_priv(net);
+	net_device_obj->device_obj = device_obj;
+	net_device_obj->avail = ring_size;
 	dev_set_drvdata(device, net);
 
 	/* Notify the netvsc driver of the new device */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 2b9a097..c094578 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -43,7 +43,7 @@ struct host_device_context {
 	/* must be 1st field
 	 * FIXME this is a bug */
 	/* point back to our device context */
-	struct hyperv_device *device_ctx;
+	struct hyperv_device *device_obj;
 	struct kmem_cache *request_pool;
 	unsigned int port;
 	unsigned char path;
@@ -247,7 +247,7 @@ static int storvsc_probe(struct device *device)
 	memset(host_device_ctx, 0, sizeof(struct host_device_context));
 
 	host_device_ctx->port = host->host_no;
-	host_device_ctx->device_ctx = device_obj;
+	host_device_ctx->device_obj = device_obj;
 
 	host_device_ctx->request_pool =
 				kmem_cache_create(dev_name(&device_obj->device),
@@ -271,7 +271,7 @@ static int storvsc_probe(struct device *device)
 		return -1;
 	}
 
-	/* host_device_ctx->port = device_info.PortNumber; */
+	/* host_hyperv_dev->port = device_info.PortNumber; */
 	host_device_ctx->path = device_info.path_id;
 	host_device_ctx->target = device_info.target_id;
 
@@ -312,7 +312,7 @@ static int storvsc_remove(struct device *device)
 			&storvsc_drv_ctx->drv_obj;
 	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	struct Scsi_Host *host = dev_get_drvdata(device);
-	struct host_device_context *host_device_ctx =
+	struct host_device_context *host_device_obj =
 			(struct host_device_context *)host->hostdata;
 
 
@@ -330,9 +330,9 @@ static int storvsc_remove(struct device *device)
 			   ret);
 	}
 
-	if (host_device_ctx->request_pool) {
-		kmem_cache_destroy(host_device_ctx->request_pool);
-		host_device_ctx->request_pool = NULL;
+	if (host_device_obj->request_pool) {
+		kmem_cache_destroy(host_device_obj->request_pool);
+		host_device_obj->request_pool = NULL;
 	}
 
 	DPRINT_INFO(STORVSC, "removing host adapter (%p)...", host);
@@ -351,7 +351,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	struct storvsc_cmd_request *cmd_request =
 		(struct storvsc_cmd_request *)request->context;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
-	struct host_device_context *host_device_ctx =
+	struct host_device_context *host_device_obj =
 		(struct host_device_context *)scmnd->device->host->hostdata;
 	void (*scsi_done_fn)(struct scsi_cmnd *);
 	struct scsi_sense_hdr sense_hdr;
@@ -394,7 +394,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	/* !!DO NOT MODIFY the scmnd after this call */
 	scsi_done_fn(scmnd);
 
-	kmem_cache_free(host_device_ctx->request_pool, cmd_request);
+	kmem_cache_free(host_device_obj->request_pool, cmd_request);
 }
 
 static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count)
@@ -598,11 +598,11 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 				void (*done)(struct scsi_cmnd *))
 {
 	int ret;
-	struct host_device_context *host_device_ctx =
+	struct host_device_context *host_device_obj =
 		(struct host_device_context *)scmnd->device->host->hostdata;
-	struct hyperv_device *device_ctx = host_device_ctx->device_ctx;
+	struct hyperv_device *device_obj = host_device_obj->device_obj;
 	struct driver_context *driver_ctx =
-		driver_to_driver_context(device_ctx->device.driver);
+		driver_to_driver_context(device_obj->device.driver);
 	struct storvsc_driver_context *storvsc_drv_ctx =
 		(struct storvsc_driver_context *)driver_ctx;
 	struct storvsc_driver_object *storvsc_drv_obj =
@@ -639,7 +639,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	request_size = sizeof(struct storvsc_cmd_request);
 
-	cmd_request = kmem_cache_alloc(host_device_ctx->request_pool,
+	cmd_request = kmem_cache_alloc(host_device_obj->request_pool,
 				       GFP_ATOMIC);
 	if (!cmd_request) {
 		DPRINT_ERR(STORVSC_DRV, "scmnd (%p) - unable to allocate "
@@ -679,7 +679,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	request->context = cmd_request;/* scmnd; */
 
 	/* request->PortId = scmnd->device->channel; */
-	request->host = host_device_ctx->port;
+	request->host = host_device_obj->port;
 	request->bus = scmnd->device->channel;
 	request->target_id = scmnd->device->id;
 	request->lun_id = scmnd->device->lun;
@@ -712,7 +712,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 				scmnd->scsi_done = NULL;
 				scmnd->host_scribble = NULL;
-				kmem_cache_free(host_device_ctx->request_pool,
+				kmem_cache_free(host_device_obj->request_pool,
 						cmd_request);
 
 				return SCSI_MLQUEUE_HOST_BUSY;
@@ -751,7 +751,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 retry_request:
 	/* Invokes the vsc to start an IO */
-	ret = storvsc_drv_obj->on_io_request(device_ctx,
+	ret = storvsc_drv_obj->on_io_request(device_obj,
 					   &cmd_request->request);
 	if (ret == -1) {
 		/* no more space */
@@ -771,7 +771,7 @@ retry_request:
 					      cmd_request->bounce_sgl_count);
 		}
 
-		kmem_cache_free(host_device_ctx->request_pool, cmd_request);
+		kmem_cache_free(host_device_obj->request_pool, cmd_request);
 
 		scmnd->scsi_done = NULL;
 		scmnd->host_scribble = NULL;
@@ -836,20 +836,20 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 {
 	int ret;
-	struct host_device_context *host_device_ctx =
+	struct host_device_context *host_device_obj =
 		(struct host_device_context *)scmnd->device->host->hostdata;
-	struct hyperv_device *device_ctx = host_device_ctx->device_ctx;
+	struct hyperv_device *device_obj = host_device_obj->device_obj;
 
 	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
-		    scmnd->device, device_ctx);
+		    scmnd->device, device_obj);
 
 	/* Invokes the vsc to reset the host/bus */
-	ret = stor_vsc_on_host_reset(device_ctx);
+	ret = stor_vsc_on_host_reset(device_obj);
 	if (ret != 0)
 		return ret;
 
 	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host reseted",
-		    scmnd->device, device_ctx);
+		    scmnd->device, device_obj);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 38152df..a385bd2 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -54,7 +54,7 @@ struct vmbus_driver_context {
 	struct tasklet_struct event_dpc;
 
 	/* The bus root device */
-	struct hyperv_device device_ctx;
+	struct hyperv_device device_obj;
 };
 
 static int vmbus_match(struct device *device, struct device_driver *driver);
@@ -354,12 +354,12 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
 				      char *buf)
 {
-	struct hyperv_device *device_ctx = device_to_hyperv_device(dev);
+	struct hyperv_device *device_obj = device_to_hyperv_device(dev);
 	struct hyperv_device_info device_info;
 
 	memset(&device_info, 0, sizeof(struct hyperv_device_info));
 
-	get_channel_info(device_ctx, &device_info);
+	get_channel_info(device_obj, &device_info);
 
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
 		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
@@ -464,7 +464,7 @@ static int vmbus_bus_init(void)
 {
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 	struct hv_driver *driver = &vmbus_drv.drv_obj;
-	struct hyperv_device *dev_ctx = &vmbus_drv.device_ctx;
+	struct hyperv_device *dev = &vmbus_drv.device_obj;
 	int ret;
 	unsigned int vector;
 
@@ -535,9 +535,9 @@ static int vmbus_bus_init(void)
 	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
 
 	/* Call to bus driver to add the root device */
-	memset(dev_ctx, 0, sizeof(struct hyperv_device));
+	memset(dev, 0, sizeof(struct hyperv_device));
 
-	ret = driver->dev_add(dev_ctx, &vector);
+	ret = driver->dev_add(dev, &vector);
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS_DRV,
 			   "ERROR - Unable to add vmbus root device");
@@ -549,19 +549,19 @@ static int vmbus_bus_init(void)
 		ret = -1;
 		goto cleanup;
 	}
-	/* strcpy(dev_ctx->device.bus_id, dev_ctx->device_obj.name); */
-	dev_set_name(&dev_ctx->device, "vmbus_0_0");
+	/* strcpy(dev->device.bus_id, dev->device_obj.name); */
+	dev_set_name(&dev->device, "vmbus_0_0");
 
 	/* No need to bind a driver to the root device. */
-	dev_ctx->device.parent = NULL;
+	dev->device.parent = NULL;
 	/* NULL; vmbus_remove() does not get invoked */
-	dev_ctx->device.bus = &vmbus_drv_ctx->bus;
+	dev->device.bus = &vmbus_drv_ctx->bus;
 
 	/* Setup the device dispatch table */
-	dev_ctx->device.release = vmbus_bus_release;
+	dev->device.release = vmbus_bus_release;
 
 	/* Setup the bus as root device */
-	ret = device_register(&dev_ctx->device);
+	ret = device_register(&dev->device);
 	if (ret) {
 		DPRINT_ERR(VMBUS_DRV,
 			   "ERROR - Unable to register vmbus root device");
@@ -590,17 +590,17 @@ static void vmbus_bus_exit(void)
 	struct hv_driver *driver = &vmbus_drv.drv_obj;
 	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 
-	struct hyperv_device *dev_ctx = &vmbus_drv.device_ctx;
+	struct hyperv_device *dev = &vmbus_drv.device_obj;
 
 	/* Remove the root device */
 	if (driver->dev_rm)
-		driver->dev_rm(dev_ctx);
+		driver->dev_rm(dev);
 
 	if (driver->cleanup)
 		driver->cleanup(driver);
 
 	/* Unregister the root bus device */
-	device_unregister(&dev_ctx->device);
+	device_unregister(&dev->device);
 
 	bus_unregister(&vmbus_drv_ctx->bus);
 
@@ -671,11 +671,11 @@ struct hyperv_device *vmbus_child_device_create(struct hv_guid *type,
 					    struct hv_guid *instance,
 					    struct vmbus_channel *channel)
 {
-	struct hyperv_device *child_device_ctx;
+	struct hyperv_device *child_device_obj;
 
 	/* Allocate the new child device */
-	child_device_ctx = kzalloc(sizeof(struct hyperv_device), GFP_KERNEL);
-	if (!child_device_ctx) {
+	child_device_obj = kzalloc(sizeof(struct hyperv_device), GFP_KERNEL);
+	if (!child_device_obj) {
 		DPRINT_ERR(VMBUS_DRV,
 			"unable to allocate device_context for child device");
 		return NULL;
@@ -686,7 +686,7 @@ struct hyperv_device *vmbus_child_device_create(struct hv_guid *type,
 		"%02x%02x%02x%02x%02x%02x%02x%02x},"
 		"id {%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 		"%02x%02x%02x%02x%02x%02x%02x%02x}",
-		&child_device_ctx->device,
+		&child_device_obj->device,
 		type->data[3], type->data[2], type->data[1], type->data[0],
 		type->data[5], type->data[4], type->data[7], type->data[6],
 		type->data[8], type->data[9], type->data[10], type->data[11],
@@ -700,12 +700,12 @@ struct hyperv_device *vmbus_child_device_create(struct hv_guid *type,
 		instance->data[12], instance->data[13],
 		instance->data[14], instance->data[15]);
 
-	child_device_ctx->channel = channel;
+	child_device_obj->channel = channel;
 
-	memcpy(&child_device_ctx->class_id, type, sizeof(struct hv_guid));
-	memcpy(&child_device_ctx->device_id, instance, sizeof(struct hv_guid));
+	memcpy(&child_device_obj->class_id, type, sizeof(struct hv_guid));
+	memcpy(&child_device_obj->device_id, instance, sizeof(struct hv_guid));
 
-	return child_device_ctx;
+	return child_device_obj;
 }
 
 /*
@@ -777,43 +777,43 @@ void vmbus_child_device_unregister(struct hyperv_device *device_obj)
  */
 static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 {
-	struct hyperv_device *device_ctx = device_to_hyperv_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 	int ret;
 
 	DPRINT_INFO(VMBUS_DRV, "generating uevent - VMBUS_DEVICE_CLASS_GUID={"
 		    "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
-		    device_ctx->class_id.data[3], device_ctx->class_id.data[2],
-		    device_ctx->class_id.data[1], device_ctx->class_id.data[0],
-		    device_ctx->class_id.data[5], device_ctx->class_id.data[4],
-		    device_ctx->class_id.data[7], device_ctx->class_id.data[6],
-		    device_ctx->class_id.data[8], device_ctx->class_id.data[9],
-		    device_ctx->class_id.data[10],
-		    device_ctx->class_id.data[11],
-		    device_ctx->class_id.data[12],
-		    device_ctx->class_id.data[13],
-		    device_ctx->class_id.data[14],
-		    device_ctx->class_id.data[15]);
+		    device_obj->class_id.data[3], device_obj->class_id.data[2],
+		    device_obj->class_id.data[1], device_obj->class_id.data[0],
+		    device_obj->class_id.data[5], device_obj->class_id.data[4],
+		    device_obj->class_id.data[7], device_obj->class_id.data[6],
+		    device_obj->class_id.data[8], device_obj->class_id.data[9],
+		    device_obj->class_id.data[10],
+		    device_obj->class_id.data[11],
+		    device_obj->class_id.data[12],
+		    device_obj->class_id.data[13],
+		    device_obj->class_id.data[14],
+		    device_obj->class_id.data[15]);
 
 	ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
 			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     device_ctx->class_id.data[3],
-			     device_ctx->class_id.data[2],
-			     device_ctx->class_id.data[1],
-			     device_ctx->class_id.data[0],
-			     device_ctx->class_id.data[5],
-			     device_ctx->class_id.data[4],
-			     device_ctx->class_id.data[7],
-			     device_ctx->class_id.data[6],
-			     device_ctx->class_id.data[8],
-			     device_ctx->class_id.data[9],
-			     device_ctx->class_id.data[10],
-			     device_ctx->class_id.data[11],
-			     device_ctx->class_id.data[12],
-			     device_ctx->class_id.data[13],
-			     device_ctx->class_id.data[14],
-			     device_ctx->class_id.data[15]);
+			     device_obj->class_id.data[3],
+			     device_obj->class_id.data[2],
+			     device_obj->class_id.data[1],
+			     device_obj->class_id.data[0],
+			     device_obj->class_id.data[5],
+			     device_obj->class_id.data[4],
+			     device_obj->class_id.data[7],
+			     device_obj->class_id.data[6],
+			     device_obj->class_id.data[8],
+			     device_obj->class_id.data[9],
+			     device_obj->class_id.data[10],
+			     device_obj->class_id.data[11],
+			     device_obj->class_id.data[12],
+			     device_obj->class_id.data[13],
+			     device_obj->class_id.data[14],
+			     device_obj->class_id.data[15]);
 
 	if (ret)
 		return ret;
@@ -821,22 +821,22 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 	ret = add_uevent_var(env, "VMBUS_DEVICE_DEVICE_GUID={"
 			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
 			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     device_ctx->device_id.data[3],
-			     device_ctx->device_id.data[2],
-			     device_ctx->device_id.data[1],
-			     device_ctx->device_id.data[0],
-			     device_ctx->device_id.data[5],
-			     device_ctx->device_id.data[4],
-			     device_ctx->device_id.data[7],
-			     device_ctx->device_id.data[6],
-			     device_ctx->device_id.data[8],
-			     device_ctx->device_id.data[9],
-			     device_ctx->device_id.data[10],
-			     device_ctx->device_id.data[11],
-			     device_ctx->device_id.data[12],
-			     device_ctx->device_id.data[13],
-			     device_ctx->device_id.data[14],
-			     device_ctx->device_id.data[15]);
+			     device_obj->device_id.data[3],
+			     device_obj->device_id.data[2],
+			     device_obj->device_id.data[1],
+			     device_obj->device_id.data[0],
+			     device_obj->device_id.data[5],
+			     device_obj->device_id.data[4],
+			     device_obj->device_id.data[7],
+			     device_obj->device_id.data[6],
+			     device_obj->device_id.data[8],
+			     device_obj->device_id.data[9],
+			     device_obj->device_id.data[10],
+			     device_obj->device_id.data[11],
+			     device_obj->device_id.data[12],
+			     device_obj->device_id.data[13],
+			     device_obj->device_id.data[14],
+			     device_obj->device_id.data[15]);
 	if (ret)
 		return ret;
 
@@ -850,10 +850,10 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 {
 	int match = 0;
 	struct driver_context *driver_ctx = driver_to_driver_context(driver);
-	struct hyperv_device *device_ctx = device_to_hyperv_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 
 	/* We found our driver ? */
-	if (memcmp(&device_ctx->class_id, &driver_ctx->class_id,
+	if (memcmp(&device_obj->class_id, &driver_ctx->class_id,
 		   sizeof(struct hv_guid)) == 0) {
 		/*
 		 * !! NOTE: The driver_ctx is not a vmbus_drv_ctx. We typecast
@@ -862,11 +862,11 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 		struct vmbus_driver_context *vmbus_drv_ctx =
 			(struct vmbus_driver_context *)driver_ctx;
 
-		device_ctx->drv = &vmbus_drv_ctx->drv_obj;
+		device_obj->drv = &vmbus_drv_ctx->drv_obj;
 		DPRINT_INFO(VMBUS_DRV,
 			    "device object (%p) set to driver object (%p)",
-			    &device_ctx,
-			    device_ctx->drv);
+			    &device_obj,
+			    device_obj->drv);
 
 		match = 1;
 	}
@@ -882,15 +882,15 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
  */
 static void vmbus_probe_failed_cb(struct work_struct *context)
 {
-	struct hyperv_device *device_ctx = (struct hyperv_device *)context;
+	struct hyperv_device *device_obj = (struct hyperv_device *)context;
 
 	/*
 	 * Kick off the process of unregistering the device.
 	 * This will call vmbus_remove() and eventually vmbus_device_release()
 	 */
-	device_unregister(&device_ctx->device);
+	device_unregister(&device_obj->device);
 
-	/* put_device(&device_ctx->device); */
+	/* put_device(&device_obj->device); */
 }
 
 /*
@@ -901,21 +901,21 @@ static int vmbus_probe(struct device *child_device)
 	int ret = 0;
 	struct driver_context *driver_ctx =
 			driver_to_driver_context(child_device->driver);
-	struct hyperv_device *device_ctx =
+	struct hyperv_device *device_obj =
 			device_to_hyperv_device(child_device);
 
 	/* Let the specific open-source driver handles the probe if it can */
 	if (driver_ctx->probe) {
-		ret = device_ctx->probe_error = driver_ctx->probe(child_device);
+		ret = device_obj->probe_error = driver_ctx->probe(child_device);
 		if (ret != 0) {
 			DPRINT_ERR(VMBUS_DRV, "probe() failed for device %s "
 				   "(%p) on driver %s (%d)...",
 				   dev_name(child_device), child_device,
 				   child_device->driver->name, ret);
 
-			INIT_WORK(&device_ctx->probe_failed_work_item,
+			INIT_WORK(&device_obj->probe_failed_work_item,
 				  vmbus_probe_failed_cb);
-			schedule_work(&device_ctx->probe_failed_work_item);
+			schedule_work(&device_obj->probe_failed_work_item);
 		}
 	} else {
 		DPRINT_ERR(VMBUS_DRV, "probe() method not set for driver - %s",
@@ -1008,11 +1008,11 @@ static void vmbus_bus_release(struct device *device)
  */
 static void vmbus_device_release(struct device *device)
 {
-	struct hyperv_device *device_ctx = device_to_hyperv_device(device);
+	struct hyperv_device *device_obj = device_to_hyperv_device(device);
 
-	kfree(device_ctx);
+	kfree(device_obj);
 
-	/* !!DO NOT REFERENCE device_ctx anymore at this point!! */
+	/* !!DO NOT REFERENCE device_obj anymore at this point!! */
 }
 
 /*
-- 
1.5.5.6

