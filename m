Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1EIWEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:04:50 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48633
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754362Ab1EIVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 038/206] Staging: hv: Get rid of some DPRINTS
Date: Mon,  9 May 2011 14:55:20 -0700
Message-Id: <1304978288-22999-38-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   65 +++----------------------------------
 1 files changed, 6 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 2f252ea..52d8974 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -79,13 +79,6 @@ static int stor_vsc_initialize(struct hv_driver *driver)
 
 	stor_driver = hvdr_to_stordr(driver);
 
-	DPRINT_DBG(STORVSC,
-		   "sizeof(struct hv_storvsc_request)=%zd "
-		   "sizeof(struct vstor_packet)=%zd, "
-		   "sizeof(struct vmscsi_request)=%zd",
-		   sizeof(struct hv_storvsc_request),
-		   sizeof(struct vstor_packet),
-		   sizeof(struct vmscsi_request));
 
 	/* Make sure we are at least 2 pages since 1 page is used for control */
 
@@ -199,14 +192,8 @@ static int storvsc_drv_init(void)
 		    storvsc_drv_obj->max_outstanding_req_per_channel);
 
 	if (storvsc_drv_obj->max_outstanding_req_per_channel <
-	    STORVSC_MAX_IO_REQUESTS) {
-		DPRINT_ERR(STORVSC_DRV,
-			   "The number of outstanding io requests (%d) "
-			   "is larger than that supported (%d) internally.",
-			   STORVSC_MAX_IO_REQUESTS,
-			   storvsc_drv_obj->max_outstanding_req_per_channel);
+	    STORVSC_MAX_IO_REQUESTS)
 		return -1;
-	}
 
 	drv->driver.name = storvsc_drv_obj->base.name;
 
@@ -230,11 +217,8 @@ static int stor_vsc_on_host_reset(struct hv_device *device)
 	DPRINT_INFO(STORVSC, "resetting host adapter...");
 
 	stor_device = get_stor_device(device);
-	if (!stor_device) {
-		DPRINT_ERR(STORVSC, "unable to get stor device..."
-			   "device being destroyed?");
+	if (!stor_device)
 		return -1;
-	}
 
 	request = &stor_device->reset_request;
 	vstor_packet = &request->vstor_packet;
@@ -250,11 +234,8 @@ static int stor_vsc_on_host_reset(struct hv_device *device)
 			       (unsigned long)&stor_device->reset_request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0) {
-		DPRINT_ERR(STORVSC, "Unable to send reset packet %p ret %d",
-			   vstor_packet, ret);
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	t = wait_for_completion_timeout(&request->wait_event, HZ);
 	if (t == 0) {
@@ -296,9 +277,6 @@ static void storvsc_drv_exit(void)
 					     (void *) &current_dev,
 					     storvsc_drv_exit_cb);
 
-		if (ret)
-			DPRINT_WARN(STORVSC_DRV,
-				    "driver_for_each_device returned %d", ret);
 
 		if (current_dev == NULL)
 			break;
@@ -331,10 +309,8 @@ static int storvsc_probe(struct hv_device *device)
 
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
-	if (!host) {
-		DPRINT_ERR(STORVSC_DRV, "unable to allocate scsi host object");
+	if (!host)
 		return -ENOMEM;
-	}
 
 	dev_set_drvdata(&device->device, host);
 
@@ -359,7 +335,6 @@ static int storvsc_probe(struct hv_device *device)
 	ret = storvsc_drv_obj->base.dev_add(device, (void *)&device_info);
 
 	if (ret != 0) {
-		DPRINT_ERR(STORVSC_DRV, "unable to add scsi vsc device");
 		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
 		return -1;
@@ -378,7 +353,6 @@ static int storvsc_probe(struct hv_device *device)
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);
 	if (ret != 0) {
-		DPRINT_ERR(STORVSC_DRV, "unable to add scsi host device");
 
 		storvsc_drv_obj->base.dev_rm(device);
 
@@ -692,11 +666,6 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
 
-	DPRINT_DBG(STORVSC_DRV, "scmnd %p dir %d, use_sg %d buf %p len %d "
-		   "queue depth %d tagged %d", scmnd, scmnd->sc_data_direction,
-		   scsi_sg_count(scmnd), scsi_sglist(scmnd),
-		   scsi_bufflen(scmnd), scmnd->device->queue_depth,
-		   scmnd->device->tagged_supported);
 
 	/* If retrying, no need to prep the cmd */
 	if (scmnd->host_scribble) {
@@ -720,8 +689,6 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	cmd_request = kmem_cache_zalloc(host_dev->request_pool,
 				       GFP_ATOMIC);
 	if (!cmd_request) {
-		DPRINT_ERR(STORVSC_DRV, "scmnd (%p) - unable to allocate "
-			   "storvsc_cmd_request...marking queue busy", scmnd);
 		scmnd->scsi_done = NULL;
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
@@ -736,7 +703,6 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	request = &cmd_request->request;
 	vm_srb = &request->vstor_packet.vm_srb;
 
-	DPRINT_DBG(STORVSC_DRV, "req %p size %d", request, request_size);
 
 	/* Build the SRB */
 	switch (scmnd->sc_data_direction) {
@@ -775,17 +741,10 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 		/* check if we need to bounce the sgl */
 		if (do_bounce_buffer(sgl, scsi_sg_count(scmnd)) != -1) {
-			DPRINT_INFO(STORVSC_DRV,
-				    "need to bounce buffer for this scmnd %p",
-				    scmnd);
 			cmd_request->bounce_sgl =
 				create_bounce_buffer(sgl, scsi_sg_count(scmnd),
 						     scsi_bufflen(scmnd));
 			if (!cmd_request->bounce_sgl) {
-				DPRINT_ERR(STORVSC_DRV,
-					   "unable to create bounce buffer for "
-					   "this scmnd %p", scmnd);
-
 				scmnd->scsi_done = NULL;
 				scmnd->host_scribble = NULL;
 				kmem_cache_free(host_dev->request_pool,
@@ -811,12 +770,10 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 		request->data_buffer.offset = sgl[0].offset;
 
-		for (i = 0; i < sg_count; i++) {
-			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
-				   i, sgl[i].length, sgl[i].offset);
+		for (i = 0; i < sg_count; i++)
 			request->data_buffer.pfn_array[i] =
 				page_to_pfn(sg_page((&sgl[i])));
-		}
+
 	} else if (scsi_sglist(scmnd)) {
 		/* ASSERT(scsi_bufflen(scmnd) <= PAGE_SIZE); */
 		request->data_buffer.offset =
@@ -831,9 +788,6 @@ retry_request:
 					   &cmd_request->request);
 	if (ret == -1) {
 		/* no more space */
-		DPRINT_ERR(STORVSC_DRV,
-			   "scmnd (%p) - queue FULL...marking queue busy",
-			   scmnd);
 
 		if (cmd_request->bounce_sgl_count) {
 			/*
@@ -872,8 +826,6 @@ static int storvsc_merge_bvec(struct request_queue *q,
  */
 static int storvsc_device_alloc(struct scsi_device *sdevice)
 {
-	DPRINT_DBG(STORVSC_DRV, "sdev (%p) - setting device flag to %d",
-		   sdevice, BLIST_SPARSELUN);
 	/*
 	 * This enables luns to be located sparsely. Otherwise, we may not
 	 * discovered them.
@@ -884,11 +836,6 @@ static int storvsc_device_alloc(struct scsi_device *sdevice)
 
 static int storvsc_device_configure(struct scsi_device *sdevice)
 {
-	DPRINT_INFO(STORVSC_DRV, "sdev (%p) - curr queue depth %d", sdevice,
-		    sdevice->queue_depth);
-
-	DPRINT_INFO(STORVSC_DRV, "sdev (%p) - setting queue depth to %d",
-		    sdevice, STORVSC_MAX_IO_REQUESTS);
 	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
 				STORVSC_MAX_IO_REQUESTS);
 
-- 
1.7.4.1

