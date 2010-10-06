Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0JFBpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:45:06 -0400
Received: from ns2.cypress.com ([157.95.67.5]:52862 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab0JFBpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:45:05 -0400
Subject: [PATCH] west bridge cyasgadget, removal of " " before ";"
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1285287885.17888.7.camel@odc-laptop>
References: <1285287600.17888.2.camel@odc-laptop>
	 <1285287885.17888.7.camel@odc-laptop>
Content-Type: text/plain
Organization: Cypress
Date: Tue, 05 Oct 2010 18:44:50 -0700
Message-Id: <1286329490.9470.8.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes removes all of the the " ;"'s in the west bridge
cyasgadget driver and instead replaces them with ";" only.

Signed-off-by: David Cross <david.cross@cypress.com>
---

diff -uprN -X linux-next-vanilla/Documentation/dontdiff linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-next-incremen/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
--- linux-next-vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-10-04 21:56:31.000000000 -0700
+++ linux-next-incremen/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2010-10-05 18:41:16.000000000 -0700
@@ -66,11 +66,11 @@ static const char *cy_as_ep_names[] = {
 /* forward declarations */
 static void
 cyas_ep_reset(
-	struct cyasgadget_ep *an_ep) ;
+	struct cyasgadget_ep *an_ep);
 
 static int
 cyasgadget_fifo_status(
-	struct usb_ep *_ep) ;
+	struct usb_ep *_ep);
 
 static void
 cyasgadget_stallcallback(
@@ -105,48 +105,48 @@ static void cy_as_gadget_usb_event_callb
 					void *evdata
 					)
 {
-	cyasgadget  *cy_as_dev ;
+	cyasgadget  *cy_as_dev;
 	#ifndef WESTBRIDGE_NDEBUG
 	struct usb_ctrlrequest *ctrlreq;
 	#endif
 
 	/* cy_as_dev = container_of(h, cyasgadget, dev_handle); */
-	cy_as_dev = cy_as_gadget_controller ;
+	cy_as_dev = cy_as_gadget_controller;
 	switch (ev) {
 	case cy_as_event_usb_suspend:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_suspend received\n") ;
+			"<1>_cy_as_event_usb_suspend received\n");
 		#endif
-		cy_as_dev->driver->suspend(&cy_as_dev->gadget) ;
+		cy_as_dev->driver->suspend(&cy_as_dev->gadget);
 		break;
 
 	case cy_as_event_usb_resume:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_resume received\n") ;
+			"<1>_cy_as_event_usb_resume received\n");
 		#endif
-		cy_as_dev->driver->resume(&cy_as_dev->gadget) ;
+		cy_as_dev->driver->resume(&cy_as_dev->gadget);
 		break;
 
 	case cy_as_event_usb_reset:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_reset received\n") ;
+			"<1>_cy_as_event_usb_reset received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_speed_change:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_speed_change received\n") ;
+			"<1>_cy_as_event_usb_speed_change received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_set_config:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_set_config received\n") ;
+			"<1>_cy_as_event_usb_set_config received\n");
 		#endif
 		break;
 
@@ -166,40 +166,40 @@ static void cy_as_gadget_usb_event_callb
 							ctrlreq->wValue,
 							ctrlreq->wIndex,
 							ctrlreq->wLength
-							) ;
+							);
 		#endif
 		cy_as_dev->outsetupreq = 0;
 		if ((((uint8_t *)evdata)[0] & USB_DIR_IN) == USB_DIR_OUT)
 			cy_as_dev->outsetupreq = 1;
 		cy_as_dev->driver->setup(&cy_as_dev->gadget,
-			(struct usb_ctrlrequest *)evdata) ;
+			(struct usb_ctrlrequest *)evdata);
 		break;
 
 	case cy_as_event_usb_status_packet:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_status_packet received\n") ;
+			"<1>_cy_as_event_usb_status_packet received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_inquiry_before:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_inquiry_before received\n") ;
+			"<1>_cy_as_event_usb_inquiry_before received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_inquiry_after:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_inquiry_after received\n") ;
+			"<1>_cy_as_event_usb_inquiry_after received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_start_stop:
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message(
-			"<1>_cy_as_event_usb_start_stop received\n") ;
+			"<1>_cy_as_event_usb_start_stop received\n");
 		#endif
 		break;
 
@@ -215,14 +215,14 @@ static void cy_as_gadget_mtp_event_callb
 					)
 {
 
-	cyasgadget *dev = cy_as_gadget_controller ;
+	cyasgadget *dev = cy_as_gadget_controller;
 	(void) handle;
 
 	switch (evtype) {
 	case cy_as_mtp_send_object_complete:
 		{
 			cy_as_mtp_send_object_complete_data *send_obj_data =
-				(cy_as_mtp_send_object_complete_data *) evdata ;
+				(cy_as_mtp_send_object_complete_data *) evdata;
 
 			#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message(
@@ -238,14 +238,14 @@ static void cy_as_gadget_mtp_event_callb
 			dev->tmtp_send_complete_data.status =
 				send_obj_data->status;
 			dev->tmtp_send_complete_data.transaction_id =
-				send_obj_data->transaction_id ;
-			dev->tmtp_send_complete = cy_true ;
+				send_obj_data->transaction_id;
+			dev->tmtp_send_complete = cy_true;
 			break;
 		}
 	case cy_as_mtp_get_object_complete:
 		{
 			cy_as_mtp_get_object_complete_data *get_obj_data =
-				(cy_as_mtp_get_object_complete_data *) evdata ;
+				(cy_as_mtp_get_object_complete_data *) evdata;
 
 			#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message(
@@ -258,13 +258,13 @@ static void cy_as_gadget_mtp_event_callb
 			dev->tmtp_get_complete_data.byte_count =
 				get_obj_data->byte_count;
 			dev->tmtp_get_complete_data.status =
-				get_obj_data->status ;
-			dev->tmtp_get_complete = cy_true ;
+				get_obj_data->status;
+			dev->tmtp_get_complete = cy_true;
 			break;
 		}
 	case cy_as_mtp_block_table_needed:
 		{
-			dev->tmtp_need_new_blk_tbl = cy_true ;
+			dev->tmtp_need_new_blk_tbl = cy_true;
 			#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message(
 				"<6>MTP EVENT: cy_as_mtp_block_table_needed\n");
@@ -284,43 +284,43 @@ cyasgadget_setupreadcallback(
 		void *buf,
 		cy_as_return_status_t status)
 {
-    cyasgadget_ep  *an_ep;
-    cyasgadget_req *an_req;
-    cyasgadget     *cy_as_dev ;
-    unsigned	   stopped ;
-    unsigned long	flags;
-    (void)buf ;
+	cyasgadget_ep  *an_ep;
+	cyasgadget_req *an_req;
+	cyasgadget	 *cy_as_dev;
+	unsigned	   stopped;
+	unsigned long	flags;
+	(void)buf;
 
-    cy_as_dev = cy_as_gadget_controller ;
-    if (cy_as_dev->driver == NULL)
+	cy_as_dev = cy_as_gadget_controller;
+	if (cy_as_dev->driver == NULL)
 		return;
 
-    an_ep =  &cy_as_dev->an_gadget_ep[ep] ;
-    spin_lock_irqsave(&cy_as_dev->lock, flags);
-	stopped = an_ep->stopped ;
+	an_ep =  &cy_as_dev->an_gadget_ep[ep];
+	spin_lock_irqsave(&cy_as_dev->lock, flags);
+	stopped = an_ep->stopped;
 
 #ifndef WESTBRIDGE_NDEBUG
-    cy_as_hal_print_message(
+	cy_as_hal_print_message(
 		"%s: ep=%d, count=%d, "
-		"status=%d\n", __func__,  ep, count, status) ;
+		"status=%d\n", __func__,  ep, count, status);
 #endif
 
-    an_req = list_entry(an_ep->queue.next,
-		cyasgadget_req, queue) ;
-    list_del_init(&an_req->queue) ;
+	an_req = list_entry(an_ep->queue.next,
+		cyasgadget_req, queue);
+	list_del_init(&an_req->queue);
 
-    if (status == CY_AS_ERROR_SUCCESS)
+	if (status == CY_AS_ERROR_SUCCESS)
 		an_req->req.status = 0;
-    else
+	else
 		an_req->req.status = -status;
-    an_req->req.actual = count ;
-    an_ep->stopped = 1;
+	an_req->req.actual = count;
+	an_ep->stopped = 1;
 
 	spin_unlock_irqrestore(&cy_as_dev->lock, flags);
 
-    an_req->req.complete(&an_ep->usb_ep_inst, &an_req->req);
+	an_req->req.complete(&an_ep->usb_ep_inst, &an_req->req);
 
-    an_ep->stopped = stopped;
+	an_ep->stopped = stopped;
 
 }
 /*called when the write of a setup packet has been completed*/
@@ -334,38 +334,38 @@ static void cyasgadget_setupwritecallbac
 {
 	cyasgadget_ep  *an_ep;
 	cyasgadget_req *an_req;
-	cyasgadget	 *cy_as_dev ;
-	unsigned	   stopped ;
+	cyasgadget	 *cy_as_dev;
+	unsigned	   stopped;
 	unsigned long	flags;
 
-	(void)buf ;
+	(void)buf;
 
 	#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("<1>%s called status=0x%x\n",
 			__func__, status);
 	#endif
 
-	cy_as_dev = cy_as_gadget_controller ;
+	cy_as_dev = cy_as_gadget_controller;
 
 	if (cy_as_dev->driver == NULL)
 		return;
 
-	an_ep =  &cy_as_dev->an_gadget_ep[ep] ;
+	an_ep =  &cy_as_dev->an_gadget_ep[ep];
 
 	spin_lock_irqsave(&cy_as_dev->lock, flags);
 
-	stopped = an_ep->stopped ;
+	stopped = an_ep->stopped;
 
 #ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("setup_write_callback: ep=%d, "
-		"count=%d, status=%d\n", ep, count, status) ;
+		"count=%d, status=%d\n", ep, count, status);
 #endif
 
-	an_req = list_entry(an_ep->queue.next, cyasgadget_req, queue) ;
-	list_del_init(&an_req->queue) ;
+	an_req = list_entry(an_ep->queue.next, cyasgadget_req, queue);
+	list_del_init(&an_req->queue);
 
-	an_req->req.actual = count ;
-	an_req->req.status = 0 ;
+	an_req->req.actual = count;
+	an_req->req.status = 0;
 	an_ep->stopped = 1;
 
 	spin_unlock_irqrestore(&cy_as_dev->lock, flags);
@@ -387,42 +387,42 @@ static void cyasgadget_readcallback(
 {
 	cyasgadget_ep  *an_ep;
 	cyasgadget_req *an_req;
-	cyasgadget	 *cy_as_dev ;
-	unsigned	   stopped ;
-	cy_as_return_status_t  ret ;
+	cyasgadget	 *cy_as_dev;
+	unsigned	   stopped;
+	cy_as_return_status_t  ret;
 	unsigned long	flags;
 
-	(void)h ;
-	(void)buf ;
+	(void)h;
+	(void)buf;
 
-	cy_as_dev = cy_as_gadget_controller ;
+	cy_as_dev = cy_as_gadget_controller;
 
 	if (cy_as_dev->driver == NULL)
 		return;
 
-	an_ep =  &cy_as_dev->an_gadget_ep[ep] ;
-	stopped = an_ep->stopped ;
+	an_ep =  &cy_as_dev->an_gadget_ep[ep];
+	stopped = an_ep->stopped;
 
 	#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s: ep=%d, count=%d, status=%d\n",
-			__func__, ep, count, status) ;
+			__func__, ep, count, status);
 	#endif
 
 	if (status == CY_AS_ERROR_CANCELED)
-		return ;
+		return;
 
 	spin_lock_irqsave(&cy_as_dev->lock, flags);
 
-	an_req = list_entry(an_ep->queue.next, cyasgadget_req, queue) ;
-	list_del_init(&an_req->queue) ;
+	an_req = list_entry(an_ep->queue.next, cyasgadget_req, queue);
+	list_del_init(&an_req->queue);
 
 	if (status == CY_AS_ERROR_SUCCESS)
-		an_req->req.status = 0 ;
+		an_req->req.status = 0;
 	else
-		an_req->req.status = -status ;
+		an_req->req.status = -status;
 
 	an_req->complete = 1;
-	an_req->req.actual = count ;
+	an_req->req.actual = count;
 	an_ep->stopped = 1;
 
 	spin_unlock_irqrestore(&cy_as_dev->lock, flags);
@@ -434,10 +434,10 @@ static void cyasgadget_readcallback(
 	 * again, so as to not miss any data packets. */
 	if (!an_ep->stopped) {
 		spin_lock_irqsave(&cy_as_dev->lock, flags);
-		an_req = 0 ;
+		an_req = 0;
 		if (!list_empty(&an_ep->queue))
 			an_req = list_entry(an_ep->queue.next,
-				cyasgadget_req, queue) ;
+				cyasgadget_req, queue);
 
 		spin_unlock_irqrestore(&cy_as_dev->lock, flags);
 
@@ -449,9 +449,9 @@ static void cyasgadget_readcallback(
 			if (ret != CY_AS_ERROR_SUCCESS)
 				cy_as_hal_print_message("<1>_cy_as_gadget: "
 					"cy_as_usb_read_data_async failed "
-					"with error code %d\n", ret) ;
+					"with error code %d\n", ret);
 			else
-				an_req->req.status = -EALREADY ;
+				an_req->req.status = -EALREADY;
 		}
 	}
 }
@@ -467,39 +467,39 @@ static void cyasgadget_writecallback(
 {
 	cyasgadget_ep  *an_ep;
 	cyasgadget_req *an_req;
-	cyasgadget	 *cy_as_dev ;
+	cyasgadget	 *cy_as_dev;
 	unsigned	   stopped = 0;
-	cy_as_return_status_t  ret ;
+	cy_as_return_status_t  ret;
 	unsigned long	flags;
 
-	(void)h ;
-	(void)buf ;
+	(void)h;
+	(void)buf;
 
-	cy_as_dev = cy_as_gadget_controller ;
+	cy_as_dev = cy_as_gadget_controller;
 	if (cy_as_dev->driver == NULL)
 		return;
 
-	an_ep =  &cy_as_dev->an_gadget_ep[ep] ;
+	an_ep =  &cy_as_dev->an_gadget_ep[ep];
 
 	if (status == CY_AS_ERROR_CANCELED)
-		return ;
+		return;
 
 	#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s: ep=%d, count=%d, status=%d\n",
-			__func__, ep, count, status) ;
+			__func__, ep, count, status);
 	#endif
 
 	spin_lock_irqsave(&cy_as_dev->lock, flags);
 
-	an_req = list_entry(an_ep->queue.next, cyasgadget_req, queue) ;
-	list_del_init(&an_req->queue) ;
-	an_req->req.actual = count ;
+	an_req = list_entry(an_ep->queue.next, cyasgadget_req, queue);
+	list_del_init(&an_req->queue);
+	an_req->req.actual = count;
 
 	/* Verify the status value before setting req.status to zero */
 	if (status == CY_AS_ERROR_SUCCESS)
-		an_req->req.status = 0 ;
+		an_req->req.status = 0;
 	else
-		an_req->req.status = -status ;
+		an_req->req.status = -status;
 
 	an_ep->stopped = 1;
 
@@ -512,10 +512,10 @@ static void cyasgadget_writecallback(
 	   miss any data packets. */
 	if (!an_ep->stopped) {
 		spin_lock_irqsave(&cy_as_dev->lock, flags);
-		an_req = 0 ;
+		an_req = 0;
 		if (!list_empty(&an_ep->queue))
 			an_req = list_entry(an_ep->queue.next,
-				cyasgadget_req, queue) ;
+				cyasgadget_req, queue);
 		spin_unlock_irqrestore(&cy_as_dev->lock, flags);
 
 		if ((an_req) && (an_req->req.status == -EINPROGRESS)) {
@@ -526,9 +526,9 @@ static void cyasgadget_writecallback(
 			if (ret != CY_AS_ERROR_SUCCESS)
 				cy_as_hal_print_message("<1>_cy_as_gadget: "
 					"cy_as_usb_write_data_async "
-					"failed with error code %d\n", ret) ;
+					"failed with error code %d\n", ret);
 			else
-				an_req->req.status = -EALREADY ;
+				an_req->req.status = -EALREADY;
 		}
 	}
 }
@@ -544,7 +544,7 @@ static void cyasgadget_stallcallback(
 	#ifndef WESTBRIDGE_NDEBUG
 	if (status != CY_AS_ERROR_SUCCESS)
 		cy_as_hal_print_message("<1>_set/_clear stall "
-			"failed with status %d\n", status) ;
+			"failed with status %d\n", status);
 	#endif
 }
 
@@ -585,7 +585,7 @@ static int cyasgadget_enable(
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
-			"on enabled\n", an_ep->usb_ep_inst.name) ;
+			"on enabled\n", an_ep->usb_ep_inst.name);
 		#endif
 		return -EINVAL;
 	}
@@ -602,7 +602,7 @@ static int cyasgadget_enable(
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
-				an_ep->cyepconfig.type, cy_as_usb_iso) ;
+				an_ep->cyepconfig.type, cy_as_usb_iso);
 			#endif
 			return -EINVAL;
 		}
@@ -613,7 +613,7 @@ static int cyasgadget_enable(
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
-				an_ep->cyepconfig.type, cy_as_usb_int) ;
+				an_ep->cyepconfig.type, cy_as_usb_int);
 			#endif
 			return -EINVAL;
 		}
@@ -624,7 +624,7 @@ static int cyasgadget_enable(
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
-				an_ep->cyepconfig.type, cy_as_usb_bulk) ;
+				an_ep->cyepconfig.type, cy_as_usb_bulk);
 			#endif
 			return -EINVAL;
 		}
@@ -640,7 +640,7 @@ static int cyasgadget_enable(
 		cy_as_hal_print_message("<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
 			"on dir %d %d\n", an_ep->usb_ep_inst.name,
-			an_ep->cyepconfig.dir, cy_as_usb_in) ;
+			an_ep->cyepconfig.dir, cy_as_usb_in);
 		#endif
 		return -EINVAL;
 	} else if ((an_ep->cyepconfig.dir == cy_as_usb_out) &&
@@ -649,7 +649,7 @@ static int cyasgadget_enable(
 		cy_as_hal_print_message("<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
 			"on dir %d %d\n", an_ep->usb_ep_inst.name,
-			an_ep->cyepconfig.dir, cy_as_usb_out) ;
+			an_ep->cyepconfig.dir, cy_as_usb_out);
 		#endif
 		return -EINVAL;
 	}
@@ -708,12 +708,12 @@ static void cyasgadget_free_request(
 					struct usb_request *_req
 					)
 {
-	cyasgadget_req *an_req ;
+	cyasgadget_req *an_req;
 
 	if (!_ep || !_req)
-		return ;
+		return;
 
-	an_req = container_of(_req, cyasgadget_req, req) ;
+	an_req = container_of(_req, cyasgadget_req, req);
 
 	kfree(an_req);
 }
@@ -759,35 +759,35 @@ static int cyasgadget_queue(
 		#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async being called "
-				"on ep %d\n", as_ep->num) ;
+				"on ep %d\n", as_ep->num);
 		#endif
 
 		ret = cy_as_usb_write_data_async(cy_as_dev->dev_handle,
 			as_ep->num, _req->length, _req->buf,
-			cy_false, cyasgadget_writecallback) ;
+			cy_false, cyasgadget_writecallback);
 		if (ret != CY_AS_ERROR_SUCCESS)
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async failed with "
-				"error code %d\n", ret) ;
+				"error code %d\n", ret);
 		else
-			_req->status = -EALREADY ;
+			_req->status = -EALREADY;
 	} else if (as_ep->num == 0) {
 		/*
 		ret = cy_as_usb_write_data_async(cy_as_dev->dev_handle,
 			as_ep->num, _req->length, _req->buf, cy_false,
-			cyasgadget_setupwritecallback) ;
+			cyasgadget_setupwritecallback);
 
 		if (ret != CY_AS_ERROR_SUCCESS)
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async failed with error "
-				"code %d\n", ret) ;
+				"code %d\n", ret);
 		*/
 		if ((cy_as_dev->outsetupreq) && (_req->length)) {
 			#ifndef WESTBRIDGE_NDEBUG
 				cy_as_hal_print_message("<1>_cy_as_gadget: "
 					"cy_as_usb_read_data_async "
 					"being called on ep %d\n",
-					as_ep->num) ;
+					as_ep->num);
 			#endif
 
 			ret = cy_as_usb_read_data_async (
@@ -798,42 +798,42 @@ static int cyasgadget_queue(
 			if (ret != CY_AS_ERROR_SUCCESS)
 				cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async failed with "
-				"error code %d\n", ret) ;
+				"error code %d\n", ret);
 
 		} else {
 			#ifndef WESTBRIDGE_NDEBUG
 				cy_as_hal_print_message("<1>_cy_as_gadget: "
 					"cy_as_usb_write_data_async "
 					"being called on ep %d\n",
-					as_ep->num) ;
+					as_ep->num);
 			#endif
 
 			ret = cy_as_usb_write_data_async(cy_as_dev->dev_handle,
 			as_ep->num, _req->length, _req->buf, cy_false,
-			cyasgadget_setupwritecallback) ;
+			cyasgadget_setupwritecallback);
 
 			if (ret != CY_AS_ERROR_SUCCESS)
 				cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async failed with "
-				"error code %d\n", ret) ;
+				"error code %d\n", ret);
 		}
 
 	} else if (list_empty(&as_ep->queue)) {
 		#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async being called since "
-				"ep queue empty%d\n", ret) ;
+				"ep queue empty%d\n", ret);
 		#endif
 
 		ret = cy_as_usb_read_data_async(cy_as_dev->dev_handle,
 			as_ep->num, cy_false, _req->length, _req->buf,
-			cyasgadget_readcallback) ;
+			cyasgadget_readcallback);
 		if (ret != CY_AS_ERROR_SUCCESS)
 			cy_as_hal_print_message("<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async failed with error "
-				"code %d\n", ret) ;
+				"code %d\n", ret);
 		else
-			_req->status = -EALREADY ;
+			_req->status = -EALREADY;
 	}
 
 	spin_lock_irqsave(&cy_as_dev->lock, flags);
@@ -855,7 +855,7 @@ static int cyasgadget_dequeue(
 	cyasgadget_ep	*an_ep;
 	cyasgadget		*dev;
 	an_ep = container_of(_ep, cyasgadget_ep, usb_ep_inst);
-	dev = an_ep->dev ;
+	dev = an_ep->dev;
 
 	#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("<1>%s called\n", __func__);
@@ -898,10 +898,10 @@ static int cyasgadget_set_halt(
 	else {
 		if (value) {
 			cy_as_usb_set_stall(an_ep->dev->dev_handle,
-				an_ep->num, cyasgadget_stallcallback, 0) ;
+				an_ep->num, cyasgadget_stallcallback, 0);
 		} else {
 			cy_as_usb_clear_stall(an_ep->dev->dev_handle,
-				an_ep->num, cyasgadget_stallcallback, 0) ;
+				an_ep->num, cyasgadget_stallcallback, 0);
 		}
 	}
 
@@ -916,7 +916,7 @@ static int cyasgadget_fifo_status(
 	cy_as_hal_print_message("<1>%s called\n", __func__);
 	#endif
 
-	return 0 ;
+	return 0;
 }
 
 static void cyasgadget_fifo_flush(
@@ -950,7 +950,7 @@ static int cyasgadget_get_frame(
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("<1>%s called\n", __func__);
 	#endif
-	return 0 ;
+	return 0;
 }
 
 static int cyasgadget_wakeup(
@@ -979,7 +979,7 @@ static int cyasgadget_pullup(
 					int is_on
 					)
 {
-	struct cyasgadget  *cy_as_dev ;
+	struct cyasgadget  *cy_as_dev;
 	unsigned long   flags;
 
 	#ifndef WESTBRIDGE_NDEBUG
@@ -994,9 +994,9 @@ static int cyasgadget_pullup(
 	spin_lock_irqsave(&cy_as_dev->lock, flags);
 	cy_as_dev->softconnect = (is_on != 0);
 	if (is_on)
-		cy_as_usb_connect(cy_as_dev->dev_handle, 0, 0) ;
+		cy_as_usb_connect(cy_as_dev->dev_handle, 0, 0);
 	else
-		cy_as_usb_disconnect(cy_as_dev->dev_handle, 0, 0) ;
+		cy_as_usb_disconnect(cy_as_dev->dev_handle, 0, 0);
 
 	spin_unlock_irqrestore(&cy_as_dev->lock, flags);
 
@@ -1012,7 +1012,7 @@ static int cyasgadget_ioctl(
 	int err = 0;
 	int retval = 0;
 	int ret_stat = 0;
-	cyasgadget *dev = cy_as_gadget_controller ;
+	cyasgadget *dev = cy_as_gadget_controller;
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("<1>%s called, code=%d, param=%ld\n",
@@ -1061,7 +1061,7 @@ static int cyasgadget_ioctl(
 	case CYASGADGET_GETMTPSTATUS:
 		{
 		cy_as_gadget_ioctl_tmtp_status *usr_d =
-			(cy_as_gadget_ioctl_tmtp_status *)param ;
+			(cy_as_gadget_ioctl_tmtp_status *)param;
 
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s: got CYASGADGET_GETMTPSTATUS\n",
@@ -1093,19 +1093,19 @@ static int cyasgadget_ioctl(
 			__func__);
 		#endif
 
-		dev->tmtp_send_complete = 0 ;
-		dev->tmtp_get_complete = 0 ;
-		dev->tmtp_need_new_blk_tbl = 0 ;
+		dev->tmtp_send_complete = 0;
+		dev->tmtp_get_complete = 0;
+		dev->tmtp_need_new_blk_tbl = 0;
 
 		break;
 		}
 	case CYASGADGET_INITSOJ:
 		{
-		cy_as_gadget_ioctl_i_s_o_j_d k_d ;
+		cy_as_gadget_ioctl_i_s_o_j_d k_d;
 		cy_as_gadget_ioctl_i_s_o_j_d *usr_d =
-			(cy_as_gadget_ioctl_i_s_o_j_d *)param ;
-		cy_as_mtp_block_table blk_table ;
-		struct scatterlist sg ;
+			(cy_as_gadget_ioctl_i_s_o_j_d *)param;
+		cy_as_mtp_block_table blk_table;
+		struct scatterlist sg;
 		char *alloc_filename;
 		struct file *file_to_allocate;
 
@@ -1184,7 +1184,7 @@ static int cyasgadget_ioctl(
 			bh.b_state = 0;
 			bh.b_blocknr = 0;
 			/* block size is arbitrary , we'll use sector size*/
-			bh.b_size = SECTOR_SIZE ;
+			bh.b_size = SECTOR_SIZE;
 
 
 
@@ -1315,8 +1315,8 @@ static int cyasgadget_ioctl(
 
 			filp_close(file_to_allocate, NULL);
 
-			dev->tmtp_send_complete = 0 ;
-			dev->tmtp_need_new_blk_tbl = 0 ;
+			dev->tmtp_send_complete = 0;
+			dev->tmtp_need_new_blk_tbl = 0;
 
 			#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message(
@@ -1350,11 +1350,11 @@ initsoj_safe_exit:
 		}
 	case CYASGADGET_INITGOJ:
 		{
-		cy_as_gadget_ioctl_i_g_o_j_d k_d ;
+		cy_as_gadget_ioctl_i_g_o_j_d k_d;
 		cy_as_gadget_ioctl_i_g_o_j_d *usr_d =
-			(cy_as_gadget_ioctl_i_g_o_j_d *)param ;
-		cy_as_mtp_block_table blk_table ;
-		struct scatterlist sg ;
+			(cy_as_gadget_ioctl_i_g_o_j_d *)param;
+		cy_as_mtp_block_table blk_table;
+		struct scatterlist sg;
 		char *map_filename;
 		struct file *file_to_map;
 
@@ -1461,7 +1461,7 @@ initsoj_safe_exit:
 				{
 					int i = 0;
 
-					for (i = 0 ; i <= blk_table_idx; i++) {
+					for (i = 0; i <= blk_table_idx; i++) {
 						cy_as_hal_print_message(
 						"%s %d 0x%x 0x%x\n",
 						__func__, i,
@@ -1481,8 +1481,8 @@ initsoj_safe_exit:
 
 			filp_close(file_to_map, NULL);
 
-			dev->tmtp_get_complete = 0 ;
-			dev->tmtp_need_new_blk_tbl = 0 ;
+			dev->tmtp_get_complete = 0;
+			dev->tmtp_need_new_blk_tbl = 0;
 
 			ret_stat = __put_user(
 				blk_table.start_blocks[blk_table_idx],
@@ -1536,7 +1536,7 @@ initsoj_safe_exit:
 	case CYASGADGET_CANCELSOJ:
 		{
 		cy_as_gadget_ioctl_cancel *usr_d =
-			(cy_as_gadget_ioctl_cancel *)param ;
+			(cy_as_gadget_ioctl_cancel *)param;
 
 		#ifndef WESTBRIDGE_NDEBUG
 			cy_as_hal_print_message(
@@ -1553,7 +1553,7 @@ initsoj_safe_exit:
 	case CYASGADGET_CANCELGOJ:
 		{
 		cy_as_gadget_ioctl_cancel *usr_d =
-			(cy_as_gadget_ioctl_cancel *)param ;
+			(cy_as_gadget_ioctl_cancel *)param;
 
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s: got CYASGADGET_CANCELGOJ\n",
@@ -1623,9 +1623,9 @@ static void cyas_ep_reset(
 	an_ep->desc = NULL;
 	INIT_LIST_HEAD(&an_ep->queue);
 
-	an_ep->stopped = 0 ;
-	an_ep->is_in   = 0 ;
-	an_ep->is_iso  = 0 ;
+	an_ep->stopped = 0;
+	an_ep->is_in   = 0;
+	an_ep->is_iso  = 0;
 	an_ep->usb_ep_inst.maxpacket = ~0;
 	an_ep->usb_ep_inst.ops = &cyasgadget_ep_ops;
 }
@@ -1635,40 +1635,40 @@ static void cyas_usb_reset(
 				)
 {
 	cy_as_return_status_t ret;
-	cy_as_usb_enum_control config ;
+	cy_as_usb_enum_control config;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_device *dev_p = (cy_as_device *)cy_as_dev->dev_handle ;
+	cy_as_device *dev_p = (cy_as_device *)cy_as_dev->dev_handle;
 
 	cy_as_hal_print_message("<1>%s called mtp_firmware=0x%x\n",
 		__func__, dev_p->is_mtp_firmware);
 	#endif
 
 	ret = cy_as_misc_release_resource(cy_as_dev->dev_handle,
-		cy_as_bus_u_s_b) ;
+		cy_as_bus_u_s_b);
 	if (ret != CY_AS_ERROR_SUCCESS && ret !=
 		CY_AS_ERROR_RESOURCE_NOT_OWNED) {
 		cy_as_hal_print_message("<1>_cy_as_gadget: cannot "
 			"release usb resource: failed with error code %d\n",
-			ret) ;
-		return ;
+			ret);
+		return;
 	}
 
-	cy_as_dev->gadget.speed = USB_SPEED_HIGH ;
+	cy_as_dev->gadget.speed = USB_SPEED_HIGH;
 
-	ret = cy_as_usb_start(cy_as_dev->dev_handle, 0, 0) ;
+	ret = cy_as_usb_start(cy_as_dev->dev_handle, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		cy_as_hal_print_message("<1>_cy_as_gadget: "
 			"cy_as_usb_start failed with error code %d\n",
-			ret) ;
-		return ;
+			ret);
+		return;
 	}
 	/* P port will do enumeration, not West Bridge */
-	config.antioch_enumeration = cy_false ;
+	config.antioch_enumeration = cy_false;
 	/*  1  2  : 1-BUS_NUM , 2:Storage_device number, SD - is bus 1*/
 
 	/* TODO: add module param to enumerate mass storage */
-	config.mass_storage_interface = 0 ;
+	config.mass_storage_interface = 0;
 
 	if (append_mtp) {
 		ret = cy_as_mtp_start(cy_as_dev->dev_handle,
@@ -1676,7 +1676,7 @@ static void cyas_usb_reset(
 		if (ret == CY_AS_ERROR_SUCCESS)  {
 			cy_as_hal_print_message("MTP start passed, enumerating "
 				"MTP interface\n");
-			config.mtp_interface = append_mtp ;
+			config.mtp_interface = append_mtp;
 			/*Do not enumerate NAND storage*/
 			config.devices_to_enumerate[0][0] = cy_false;
 
@@ -1686,19 +1686,19 @@ static void cyas_usb_reset(
 	} else {
 		cy_as_hal_print_message("MTP start not attempted, not "
 			"enumerating MTP interface\n");
-		config.mtp_interface = 0 ;
+		config.mtp_interface = 0;
 		/* enumerate mass storage based on module parameters */
 		config.devices_to_enumerate[0][0] = msc_enum_bus_0;
 		config.devices_to_enumerate[1][0] = msc_enum_bus_1;
 	}
 
 	ret = cy_as_usb_set_enum_config(cy_as_dev->dev_handle,
-		&config, 0, 0) ;
+		&config, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		cy_as_hal_print_message("<1>_cy_as_gadget: "
 			"cy_as_usb_set_enum_config failed with error "
-			"code %d\n", ret) ;
-		return ;
+			"code %d\n", ret);
+		return;
 	}
 
 	cy_as_usb_set_physical_configuration(cy_as_dev->dev_handle, 1);
@@ -1712,7 +1712,7 @@ static void cyas_usb_reinit(
 	int index = 0;
 	cyasgadget_ep *an_ep_p;
 	cy_as_return_status_t ret;
-	cy_as_device *dev_p = (cy_as_device *)cy_as_dev->dev_handle ;
+	cy_as_device *dev_p = (cy_as_device *)cy_as_dev->dev_handle;
 
 	INIT_LIST_HEAD(&cy_as_dev->gadget.ep_list);
 
@@ -1723,23 +1723,23 @@ static void cyas_usb_reinit(
 
 	/* Init the end points */
 	for (index = 1; index <= 15; index++) {
-		an_ep_p = &cy_as_dev->an_gadget_ep[index] ;
-		cyas_ep_reset(an_ep_p) ;
-		an_ep_p->usb_ep_inst.name = cy_as_ep_names[index] ;
-		an_ep_p->dev = cy_as_dev ;
-		an_ep_p->num = index ;
+		an_ep_p = &cy_as_dev->an_gadget_ep[index];
+		cyas_ep_reset(an_ep_p);
+		an_ep_p->usb_ep_inst.name = cy_as_ep_names[index];
+		an_ep_p->dev = cy_as_dev;
+		an_ep_p->num = index;
 		memset(&an_ep_p->cyepconfig, 0, sizeof(an_ep_p->cyepconfig));
 
 		/* EP0, EPs 2,4,6,8 need not be added */
 		if ((index <= 8) && (index % 2 == 0) &&
 			(!dev_p->is_mtp_firmware)) {
 			/* EP0 is 64 and EPs 2,4,6,8 not allowed */
-			cy_as_dev->an_gadget_ep[index].fifo_size = 0 ;
+			cy_as_dev->an_gadget_ep[index].fifo_size = 0;
 		} else {
 			if (index == 1)
 				an_ep_p->fifo_size = 64;
 			else
-				an_ep_p->fifo_size = 512 ;
+				an_ep_p->fifo_size = 512;
 			list_add_tail(&an_ep_p->usb_ep_inst.ep_list,
 				&cy_as_dev->gadget.ep_list);
 		}
@@ -1749,47 +1749,47 @@ static void cyas_usb_reinit(
 	 * by gadget after connect), therefore need to set config in
 	 * initialization and verify compatibility in ep_enable,
 	 * kick up error otherwise*/
-	an_ep_p = &cy_as_dev->an_gadget_ep[3] ;
-	an_ep_p->cyepconfig.enabled = cy_true ;
-	an_ep_p->cyepconfig.dir = cy_as_usb_out ;
-	an_ep_p->cyepconfig.type = cy_as_usb_bulk ;
-	an_ep_p->cyepconfig.size = 0 ;
-	an_ep_p->cyepconfig.physical = 1 ;
+	an_ep_p = &cy_as_dev->an_gadget_ep[3];
+	an_ep_p->cyepconfig.enabled = cy_true;
+	an_ep_p->cyepconfig.dir = cy_as_usb_out;
+	an_ep_p->cyepconfig.type = cy_as_usb_bulk;
+	an_ep_p->cyepconfig.size = 0;
+	an_ep_p->cyepconfig.physical = 1;
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
-		3, &an_ep_p->cyepconfig) ;
+		3, &an_ep_p->cyepconfig);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
-			"failed with error code %d\n", ret) ;
+			"failed with error code %d\n", ret);
 	}
 
 	cy_as_usb_set_stall(an_ep_p->dev->dev_handle, 3, 0, 0);
 
-	an_ep_p = &cy_as_dev->an_gadget_ep[5] ;
-	an_ep_p->cyepconfig.enabled = cy_true ;
-	an_ep_p->cyepconfig.dir = cy_as_usb_in ;
-	an_ep_p->cyepconfig.type = cy_as_usb_bulk ;
-	an_ep_p->cyepconfig.size = 0 ;
-	an_ep_p->cyepconfig.physical = 2 ;
+	an_ep_p = &cy_as_dev->an_gadget_ep[5];
+	an_ep_p->cyepconfig.enabled = cy_true;
+	an_ep_p->cyepconfig.dir = cy_as_usb_in;
+	an_ep_p->cyepconfig.type = cy_as_usb_bulk;
+	an_ep_p->cyepconfig.size = 0;
+	an_ep_p->cyepconfig.physical = 2;
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
-		5, &an_ep_p->cyepconfig) ;
+		5, &an_ep_p->cyepconfig);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
-			"failed with error code %d\n", ret) ;
+			"failed with error code %d\n", ret);
 	}
 
 	cy_as_usb_set_stall(an_ep_p->dev->dev_handle, 5, 0, 0);
 
-	an_ep_p = &cy_as_dev->an_gadget_ep[9] ;
-	an_ep_p->cyepconfig.enabled = cy_true ;
-	an_ep_p->cyepconfig.dir = cy_as_usb_in ;
-	an_ep_p->cyepconfig.type = cy_as_usb_bulk ;
-	an_ep_p->cyepconfig.size = 0 ;
-	an_ep_p->cyepconfig.physical = 4 ;
+	an_ep_p = &cy_as_dev->an_gadget_ep[9];
+	an_ep_p->cyepconfig.enabled = cy_true;
+	an_ep_p->cyepconfig.dir = cy_as_usb_in;
+	an_ep_p->cyepconfig.type = cy_as_usb_bulk;
+	an_ep_p->cyepconfig.size = 0;
+	an_ep_p->cyepconfig.physical = 4;
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
-		9, &an_ep_p->cyepconfig) ;
+		9, &an_ep_p->cyepconfig);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
-			"failed with error code %d\n", ret) ;
+			"failed with error code %d\n", ret);
 	}
 
 	cy_as_usb_set_stall(an_ep_p->dev->dev_handle, 9, 0, 0);
@@ -1797,28 +1797,28 @@ static void cyas_usb_reinit(
 	if (dev_p->mtp_count != 0) {
 		/* these need to be set for compatibility with
 		 * the gadget_enable logic */
-		an_ep_p = &cy_as_dev->an_gadget_ep[2] ;
-		an_ep_p->cyepconfig.enabled = cy_true ;
-		an_ep_p->cyepconfig.dir = cy_as_usb_out ;
-		an_ep_p->cyepconfig.type = cy_as_usb_bulk ;
-		an_ep_p->cyepconfig.size = 0 ;
-		an_ep_p->cyepconfig.physical = 0 ;
+		an_ep_p = &cy_as_dev->an_gadget_ep[2];
+		an_ep_p->cyepconfig.enabled = cy_true;
+		an_ep_p->cyepconfig.dir = cy_as_usb_out;
+		an_ep_p->cyepconfig.type = cy_as_usb_bulk;
+		an_ep_p->cyepconfig.size = 0;
+		an_ep_p->cyepconfig.physical = 0;
 		cy_as_usb_set_stall(an_ep_p->dev->dev_handle, 2, 0, 0);
 
-		an_ep_p = &cy_as_dev->an_gadget_ep[6] ;
-		an_ep_p->cyepconfig.enabled = cy_true ;
-		an_ep_p->cyepconfig.dir = cy_as_usb_in ;
-		an_ep_p->cyepconfig.type = cy_as_usb_bulk ;
-		an_ep_p->cyepconfig.size = 0 ;
-		an_ep_p->cyepconfig.physical = 0 ;
+		an_ep_p = &cy_as_dev->an_gadget_ep[6];
+		an_ep_p->cyepconfig.enabled = cy_true;
+		an_ep_p->cyepconfig.dir = cy_as_usb_in;
+		an_ep_p->cyepconfig.type = cy_as_usb_bulk;
+		an_ep_p->cyepconfig.size = 0;
+		an_ep_p->cyepconfig.physical = 0;
 		cy_as_usb_set_stall(an_ep_p->dev->dev_handle, 6, 0, 0);
 	}
 
-	cyas_ep_reset(&cy_as_dev->an_gadget_ep[0]) ;
-	cy_as_dev->an_gadget_ep[0].usb_ep_inst.name = cy_as_ep_names[0] ;
-	cy_as_dev->an_gadget_ep[0].dev = cy_as_dev ;
-	cy_as_dev->an_gadget_ep[0].num = 0 ;
-	cy_as_dev->an_gadget_ep[0].fifo_size = 64 ;
+	cyas_ep_reset(&cy_as_dev->an_gadget_ep[0]);
+	cy_as_dev->an_gadget_ep[0].usb_ep_inst.name = cy_as_ep_names[0];
+	cy_as_dev->an_gadget_ep[0].dev = cy_as_dev;
+	cy_as_dev->an_gadget_ep[0].num = 0;
+	cy_as_dev->an_gadget_ep[0].fifo_size = 64;
 
 	cy_as_dev->an_gadget_ep[0].usb_ep_inst.maxpacket = 64;
 	cy_as_dev->gadget.ep0 = &cy_as_dev->an_gadget_ep[0].usb_ep_inst;
@@ -1830,48 +1830,48 @@ static void cyas_ep0_start(
 				cyasgadget *dev
 				)
 {
-	cy_as_return_status_t ret ;
+	cy_as_return_status_t ret;
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("<1>%s called\n", __func__);
 	#endif
 
 	ret = cy_as_usb_register_callback(dev->dev_handle,
-		cy_as_gadget_usb_event_callback) ;
+		cy_as_gadget_usb_event_callback);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s: cy_as_usb_register_callback "
-			"failed with error code %d\n", __func__, ret) ;
+			"failed with error code %d\n", __func__, ret);
 		#endif
-		return ;
+		return;
 	}
 
-	ret = cy_as_usb_commit_config(dev->dev_handle, 0, 0) ;
+	ret = cy_as_usb_commit_config(dev->dev_handle, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s: cy_as_usb_commit_config "
-			"failed with error code %d\n", __func__, ret) ;
+			"failed with error code %d\n", __func__, ret);
 		#endif
-		return ;
+		return;
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("%s: cy_as_usb_commit_config "
-		"message sent\n", __func__) ;
+		"message sent\n", __func__);
 	#endif
 
-	ret = cy_as_usb_connect(dev->dev_handle, 0, 0) ;
+	ret = cy_as_usb_connect(dev->dev_handle, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("%s: cy_as_usb_connect failed "
-			"with error code %d\n", __func__, ret) ;
+			"with error code %d\n", __func__, ret);
 		#endif
-		return ;
+		return;
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("%s: cy_as_usb_connect message "
-		"sent\n", __func__) ;
+		"sent\n", __func__);
 	#endif
 }
 
@@ -1885,7 +1885,7 @@ static void cyas_ep0_start(
 int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
 		int (*bind)(struct usb_gadget *))
 {
-	cyasgadget *dev = cy_as_gadget_controller ;
+	cyasgadget *dev = cy_as_gadget_controller;
 	int		retval;
 
 	#ifndef WESTBRIDGE_NDEBUG
@@ -1915,8 +1915,8 @@ int usb_gadget_probe_driver(struct usb_g
 	dev->gadget.dev.driver = &driver->driver;
 
 	/* Do the needful */
-	cyas_usb_reset(dev) ; /* External usb */
-	cyas_usb_reinit(dev) ; /* Internal */
+	cyas_usb_reset(dev); /* External usb */
+	cyas_usb_reinit(dev); /* Internal */
 
 	retval = bind(&dev->gadget);
 	if (retval) {
@@ -1943,21 +1943,21 @@ static void cyasgadget_nuke(
 							cyasgadget_ep *an_ep
 							)
 {
-	cyasgadget	*dev = cy_as_gadget_controller ;
+	cyasgadget	*dev = cy_as_gadget_controller;
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("<1>%s called\n", __func__);
 	#endif
 
 	cy_as_usb_cancel_async(dev->dev_handle, an_ep->num);
-	an_ep->stopped = 1 ;
+	an_ep->stopped = 1;
 
 	while (!list_empty(&an_ep->queue)) {
 		cyasgadget_req *an_req = list_entry
-			(an_ep->queue.next, cyasgadget_req, queue) ;
-		list_del_init(&an_req->queue) ;
-		an_req->req.status = -ESHUTDOWN ;
-		an_req->req.complete(&an_ep->usb_ep_inst, &an_req->req) ;
+			(an_ep->queue.next, cyasgadget_req, queue);
+		list_del_init(&an_req->queue);
+		an_req->req.status = -ESHUTDOWN;
+		an_req->req.complete(&an_ep->usb_ep_inst, &an_req->req);
 	}
 }
 
@@ -1966,7 +1966,7 @@ static void cyasgadget_stop_activity(
 				struct usb_gadget_driver *driver
 				)
 {
-	int index ;
+	int index;
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("<1>%s called\n", __func__);
@@ -1982,16 +1982,16 @@ static void cyasgadget_stop_activity(
 	/* Stop hardware; prevent new request submissions;
 	 * and kill any outstanding requests.
 	 */
-	cy_as_usb_disconnect(dev->dev_handle, 0, 0) ;
+	cy_as_usb_disconnect(dev->dev_handle, 0, 0);
 
 	for (index = 3; index <= 7; index += 2) {
-		cyasgadget_ep *an_ep_p = &dev->an_gadget_ep[index] ;
-		cyasgadget_nuke(an_ep_p) ;
+		cyasgadget_ep *an_ep_p = &dev->an_gadget_ep[index];
+		cyasgadget_nuke(an_ep_p);
 	}
 
 	for (index = 9; index <= 15; index++) {
-		cyasgadget_ep *an_ep_p = &dev->an_gadget_ep[index] ;
-		cyasgadget_nuke(an_ep_p) ;
+		cyasgadget_ep *an_ep_p = &dev->an_gadget_ep[index];
+		cyasgadget_nuke(an_ep_p);
 	}
 
 	/* report disconnect; the driver is already quiesced */
@@ -2003,7 +2003,7 @@ static void cyasgadget_stop_activity(
 	#endif
 
 	/* Stop Usb */
-	cy_as_usb_stop(dev->dev_handle, 0, 0) ;
+	cy_as_usb_stop(dev->dev_handle, 0, 0);
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("cy_as_usb_stop returned success");
@@ -2014,7 +2014,7 @@ int usb_gadget_unregister_driver(
 				struct usb_gadget_driver *driver
 				)
 {
-	cyasgadget	*dev = cy_as_gadget_controller ;
+	cyasgadget	*dev = cy_as_gadget_controller;
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("<1>%s called\n", __func__);
@@ -2034,7 +2034,7 @@ int usb_gadget_unregister_driver(
 
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_hal_print_message("unregistered driver '%s'\n",
-		driver->driver.name) ;
+		driver->driver.name);
 	#endif
 
 	return 0;
@@ -2060,15 +2060,15 @@ static void cyasgadget_deinit(
 			)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>_cy_as_gadget deinitialize called\n") ;
+	cy_as_hal_print_message("<1>_cy_as_gadget deinitialize called\n");
 	#endif
 
 	if (!cy_as_dev) {
 		#ifndef WESTBRIDGE_NDEBUG
 		cy_as_hal_print_message("<1>_cy_as_gadget_deinit: "
-			"invalid cyasgadget device\n") ;
+			"invalid cyasgadget device\n");
 		#endif
-		return ;
+		return;
 	}
 
 	if (cy_as_dev->driver) {
@@ -2081,30 +2081,30 @@ static void cyasgadget_deinit(
 		usb_gadget_unregister_driver(cy_as_dev->driver);
 	}
 
-	kfree(cy_as_dev) ;
-	cy_as_gadget_controller = NULL ;
+	kfree(cy_as_dev);
+	cy_as_gadget_controller = NULL;
 }
 
 /* Initialize gadget driver  */
 static int cyasgadget_initialize(void)
 {
-	cyasgadget *cy_as_dev = 0 ;
-	int		 retval = 0 ;
+	cyasgadget *cy_as_dev = 0;
+	int		 retval = 0;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>_cy_as_gadget [V1.1] initialize called\n") ;
+	cy_as_hal_print_message("<1>_cy_as_gadget [V1.1] initialize called\n");
 	#endif
 
 	if (cy_as_gadget_controller != 0) {
 		cy_as_hal_print_message("<1> cy_as_gadget: the device has "
-			"already been initilaized. ignoring\n") ;
-		return -EBUSY ;
+			"already been initilaized. ignoring\n");
+		return -EBUSY;
 	}
 
 	cy_as_dev = kzalloc(sizeof(cyasgadget), GFP_ATOMIC);
 	if (cy_as_dev == NULL) {
 		cy_as_hal_print_message("<1> cy_as_gadget: memory "
-			"allocation failed\n") ;
+			"allocation failed\n");
 		return -ENOMEM;
 	}
 
@@ -2118,28 +2118,28 @@ static int cyasgadget_initialize(void)
 	cy_as_dev->gadget.name = cy_as_driver_name;
 
 	/* Get the device handle */
-	cy_as_dev->dev_handle = cyasdevice_getdevhandle() ;
+	cy_as_dev->dev_handle = cyasdevice_getdevhandle();
 	if (0 == cy_as_dev->dev_handle) {
 		#ifndef NDEBUG
 		cy_as_hal_print_message("<1> cy_as_gadget: "
-			"no west bridge device\n") ;
+			"no west bridge device\n");
 		#endif
-		retval = -EFAULT ;
-		goto done ;
+		retval = -EFAULT;
+		goto done;
 	}
 
 	/* We are done now */
-	cy_as_gadget_controller = cy_as_dev ;
-	return 0 ;
+	cy_as_gadget_controller = cy_as_dev;
+	return 0;
 
 /*
  * in case of an error
  */
 done:
 	if (cy_as_dev)
-		cyasgadget_deinit(cy_as_dev) ;
+		cyasgadget_deinit(cy_as_dev);
 
-	return retval ;
+	return retval;
 }
 
 static int __init cyas_init(void)


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

