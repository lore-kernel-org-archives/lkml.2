Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030Ab0LNUfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:35:10 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42747 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758586Ab0LNUez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:34:55 -0500
From: Rene Sapiens <rene.sapiens@ti.com>
To: omar.ramirez@ti.com
Cc: felipe.contreras@gmail.com, x0095840@ti.com, ernesto@ti.com, nm@ti.com,
        ohad@wizery.com, ameya.palande@nokia.com, x0095078@ti.com,
        ionut.nicu@mindbit.ro, ivan.gomez@ti.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Rene Sapiens <rene.sapiens@ti.com>
Subject: [PATCH 05/12] staging:tidspbridge - set5 remove hungarian from structs
Date: Tue, 14 Dec 2010 14:33:11 -0600
Message-Id: <1292358798-25875-6-git-send-email-rene.sapiens@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1292358798-25875-5-git-send-email-rene.sapiens@ti.com>
References: <1292358798-25875-1-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-2-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-3-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-4-git-send-email-rene.sapiens@ti.com>
 <1292358798-25875-5-git-send-email-rene.sapiens@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hungarian notation will be removed from the elements inside
structures, the next variables will be renamed:

Original:                Replacement:
pfn_dev_create           by dev_create
pfn_dev_destroy          dev_destroy
pfn_exit                 exit
pfn_get_fxn_addr         get_fxn_addr
pfn_init                 init
pfn_io_create            io_create
pfn_io_destroy           io_destroy
pfn_io_get_proc_load     io_get_proc_load
pfn_io_on_loaded         io_on_loaded
pfn_load                 load
pfn_msg_create           msg_create
pfn_msg_create_queue     msg_create_queue
pfn_msg_delete           msg_delete
pfn_msg_delete_queue     msg_delete_queue
pfn_msg_get              msg_get
pfn_msg_put              msg_put
pfn_msg_register_notify  msg_register_notify
pfn_msg_set_queue_id     msg_set_queue_id
pfn_ovly                 ovly
pfn_unload               unload

Signed-off-by: Rene Sapiens <rene.sapiens@ti.com>
---
 .../tidspbridge/include/dspbridge/dspdefs.h        |   28 ++++++------
 .../tidspbridge/include/dspbridge/nldrdefs.h       |   12 +++---
 drivers/staging/tidspbridge/pmgr/dev.c             |   46 ++++++++++----------
 drivers/staging/tidspbridge/pmgr/io.c              |    4 +-
 drivers/staging/tidspbridge/pmgr/msg.c             |    4 +-
 drivers/staging/tidspbridge/rmgr/nldr.c            |    4 +-
 drivers/staging/tidspbridge/rmgr/node.c            |   46 ++++++++++----------
 drivers/staging/tidspbridge/rmgr/proc.c            |    4 +-
 8 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index bed46ca..fc0c008 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -981,8 +981,8 @@ typedef void (*fxn_msg_setqueueid) (struct msg_queue *msg_queue_obj,
 struct bridge_drv_interface {
 	u32 brd_api_major_version;	/* Set to BRD_API_MAJOR_VERSION. */
 	u32 brd_api_minor_version;	/* Set to BRD_API_MINOR_VERSION. */
-	fxn_dev_create pfn_dev_create;	/* Create device context */
-	fxn_dev_destroy pfn_dev_destroy;	/* Destroy device context */
+	fxn_dev_create dev_create;	/* Create device context */
+	fxn_dev_destroy dev_destroy;	/* Destroy device context */
 	fxn_dev_ctrl dev_cntrl;	/* Optional vendor interface */
 	fxn_brd_monitor brd_monitor;	/* Load and/or start monitor */
 	fxn_brd_start brd_start;	/* Start DSP program. */
@@ -1009,23 +1009,23 @@ struct bridge_drv_interface {
 	fxn_chnl_idle chnl_idle;	/* Idle the channel */
 	/* Register for notif. */
 	fxn_chnl_registernotify chnl_register_notify;
-	fxn_io_create pfn_io_create;	/* Create IO manager */
-	fxn_io_destroy pfn_io_destroy;	/* Destroy IO manager */
-	fxn_io_onloaded pfn_io_on_loaded;	/* Notify of program loaded */
+	fxn_io_create io_create;	/* Create IO manager */
+	fxn_io_destroy io_destroy;	/* Destroy IO manager */
+	fxn_io_onloaded io_on_loaded;	/* Notify of program loaded */
 	/* Get Processor's current and predicted load */
-	fxn_io_getprocload pfn_io_get_proc_load;
-	fxn_msg_create pfn_msg_create;	/* Create message manager */
+	fxn_io_getprocload io_get_proc_load;
+	fxn_msg_create msg_create;	/* Create message manager */
 	/* Create message queue */
-	fxn_msg_createqueue pfn_msg_create_queue;
-	fxn_msg_delete pfn_msg_delete;	/* Delete message manager */
+	fxn_msg_createqueue msg_create_queue;
+	fxn_msg_delete msg_delete;	/* Delete message manager */
 	/* Delete message queue */
-	fxn_msg_deletequeue pfn_msg_delete_queue;
-	fxn_msg_get pfn_msg_get;	/* Get a message */
-	fxn_msg_put pfn_msg_put;	/* Send a message */
+	fxn_msg_deletequeue msg_delete_queue;
+	fxn_msg_get msg_get;	/* Get a message */
+	fxn_msg_put msg_put;	/* Send a message */
 	/* Register for notif. */
-	fxn_msg_registernotify pfn_msg_register_notify;
+	fxn_msg_registernotify msg_register_notify;
 	/* Set message queue id */
-	fxn_msg_setqueueid pfn_msg_set_queue_id;
+	fxn_msg_setqueueid msg_set_queue_id;
 };
 
 /*
diff --git a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
index b4610af..b1cd1a4 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/nldrdefs.h
@@ -82,7 +82,7 @@ typedef u32(*nldr_writefxn) (void *priv_ref,
  *  Attributes passed to nldr_create function.
  */
 struct nldr_attrs {
-	nldr_ovlyfxn pfn_ovly;
+	nldr_ovlyfxn ovly;
 	nldr_writefxn pfn_write;
 	u16 us_dsp_word_size;
 	u16 us_dsp_mau_size;
@@ -283,11 +283,11 @@ struct node_ldr_fxns {
 	nldr_allocatefxn allocate;
 	nldr_createfxn create;
 	nldr_deletefxn delete;
-	nldr_exitfxn pfn_exit;
-	nldr_getfxnaddrfxn pfn_get_fxn_addr;
-	nldr_initfxn pfn_init;
-	nldr_loadfxn pfn_load;
-	nldr_unloadfxn pfn_unload;
+	nldr_exitfxn exit;
+	nldr_getfxnaddrfxn get_fxn_addr;
+	nldr_initfxn init;
+	nldr_loadfxn load;
+	nldr_unloadfxn unload;
 };
 
 #endif /* NLDRDEFS_ */
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index db48cda..04673b1 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -194,7 +194,7 @@ int dev_create_device(struct dev_object **device_obj,
 
 			/* Call fxn_dev_create() to get the Bridge's device
 			 * context handle. */
-			status = (dev_obj->bridge_interface.pfn_dev_create)
+			status = (dev_obj->bridge_interface.dev_create)
 			    (&dev_obj->hbridge_context, dev_obj,
 			     host_res);
 			/* Assert bridge_dev_create()'s ensure clause: */
@@ -388,7 +388,7 @@ int dev_destroy_device(struct dev_object *hdev_obj)
 		/* Call the driver's bridge_dev_destroy() function: */
 		/* Require of DevDestroy */
 		if (dev_obj->hbridge_context) {
-			status = (*dev_obj->bridge_interface.pfn_dev_destroy)
+			status = (*dev_obj->bridge_interface.dev_destroy)
 			    (dev_obj->hbridge_context);
 			dev_obj->hbridge_context = NULL;
 		} else
@@ -1085,8 +1085,8 @@ static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
 	intf_fxns->brd_api_minor_version = drv_fxns->brd_api_minor_version;
 	/* Install functions up to DSP API version .80 (first alpha): */
 	if (bridge_version > 0) {
-		STORE_FXN(fxn_dev_create, pfn_dev_create);
-		STORE_FXN(fxn_dev_destroy, pfn_dev_destroy);
+		STORE_FXN(fxn_dev_create, dev_create);
+		STORE_FXN(fxn_dev_destroy, dev_destroy);
 		STORE_FXN(fxn_dev_ctrl, dev_cntrl);
 		STORE_FXN(fxn_brd_monitor, brd_monitor);
 		STORE_FXN(fxn_brd_start, brd_start);
@@ -1111,23 +1111,23 @@ static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
 		STORE_FXN(fxn_chnl_getmgrinfo, chnl_get_mgr_info);
 		STORE_FXN(fxn_chnl_idle, chnl_idle);
 		STORE_FXN(fxn_chnl_registernotify, chnl_register_notify);
-		STORE_FXN(fxn_io_create, pfn_io_create);
-		STORE_FXN(fxn_io_destroy, pfn_io_destroy);
-		STORE_FXN(fxn_io_onloaded, pfn_io_on_loaded);
-		STORE_FXN(fxn_io_getprocload, pfn_io_get_proc_load);
-		STORE_FXN(fxn_msg_create, pfn_msg_create);
-		STORE_FXN(fxn_msg_createqueue, pfn_msg_create_queue);
-		STORE_FXN(fxn_msg_delete, pfn_msg_delete);
-		STORE_FXN(fxn_msg_deletequeue, pfn_msg_delete_queue);
-		STORE_FXN(fxn_msg_get, pfn_msg_get);
-		STORE_FXN(fxn_msg_put, pfn_msg_put);
-		STORE_FXN(fxn_msg_registernotify, pfn_msg_register_notify);
-		STORE_FXN(fxn_msg_setqueueid, pfn_msg_set_queue_id);
+		STORE_FXN(fxn_io_create, io_create);
+		STORE_FXN(fxn_io_destroy, io_destroy);
+		STORE_FXN(fxn_io_onloaded, io_on_loaded);
+		STORE_FXN(fxn_io_getprocload, io_get_proc_load);
+		STORE_FXN(fxn_msg_create, msg_create);
+		STORE_FXN(fxn_msg_createqueue, msg_create_queue);
+		STORE_FXN(fxn_msg_delete, msg_delete);
+		STORE_FXN(fxn_msg_deletequeue, msg_delete_queue);
+		STORE_FXN(fxn_msg_get, msg_get);
+		STORE_FXN(fxn_msg_put, msg_put);
+		STORE_FXN(fxn_msg_registernotify, msg_register_notify);
+		STORE_FXN(fxn_msg_setqueueid, msg_set_queue_id);
 	}
 	/* Add code for any additional functions in newerBridge versions here */
 	/* Ensure postcondition: */
-	DBC_ENSURE(intf_fxns->pfn_dev_create != NULL);
-	DBC_ENSURE(intf_fxns->pfn_dev_destroy != NULL);
+	DBC_ENSURE(intf_fxns->dev_create != NULL);
+	DBC_ENSURE(intf_fxns->dev_destroy != NULL);
 	DBC_ENSURE(intf_fxns->dev_cntrl != NULL);
 	DBC_ENSURE(intf_fxns->brd_monitor != NULL);
 	DBC_ENSURE(intf_fxns->brd_start != NULL);
@@ -1147,11 +1147,11 @@ static void store_interface_fxns(struct bridge_drv_interface *drv_fxns,
 	DBC_ENSURE(intf_fxns->chnl_get_mgr_info != NULL);
 	DBC_ENSURE(intf_fxns->chnl_idle != NULL);
 	DBC_ENSURE(intf_fxns->chnl_register_notify != NULL);
-	DBC_ENSURE(intf_fxns->pfn_io_create != NULL);
-	DBC_ENSURE(intf_fxns->pfn_io_destroy != NULL);
-	DBC_ENSURE(intf_fxns->pfn_io_on_loaded != NULL);
-	DBC_ENSURE(intf_fxns->pfn_io_get_proc_load != NULL);
-	DBC_ENSURE(intf_fxns->pfn_msg_set_queue_id != NULL);
+	DBC_ENSURE(intf_fxns->io_create != NULL);
+	DBC_ENSURE(intf_fxns->io_destroy != NULL);
+	DBC_ENSURE(intf_fxns->io_on_loaded != NULL);
+	DBC_ENSURE(intf_fxns->io_get_proc_load != NULL);
+	DBC_ENSURE(intf_fxns->msg_set_queue_id != NULL);
 
 #undef  STORE_FXN
 }
diff --git a/drivers/staging/tidspbridge/pmgr/io.c b/drivers/staging/tidspbridge/pmgr/io.c
index 20cbb9f..181f4dd 100644
--- a/drivers/staging/tidspbridge/pmgr/io.c
+++ b/drivers/staging/tidspbridge/pmgr/io.c
@@ -68,7 +68,7 @@ int io_create(struct io_mgr **io_man, struct dev_object *hdev_obj,
 		dev_get_intf_fxns(hdev_obj, &intf_fxns);
 
 		/* Let Bridge channel module finish the create: */
-		status = (*intf_fxns->pfn_io_create) (&hio_mgr, hdev_obj,
+		status = (*intf_fxns->io_create) (&hio_mgr, hdev_obj,
 						      mgr_attrts);
 
 		if (!status) {
@@ -100,7 +100,7 @@ int io_destroy(struct io_mgr *hio_mgr)
 	intf_fxns = pio_mgr->intf_fxns;
 
 	/* Let Bridge channel module destroy the io_mgr: */
-	status = (*intf_fxns->pfn_io_destroy) (hio_mgr);
+	status = (*intf_fxns->io_destroy) (hio_mgr);
 
 	return status;
 }
diff --git a/drivers/staging/tidspbridge/pmgr/msg.c b/drivers/staging/tidspbridge/pmgr/msg.c
index abd4365..a691603 100644
--- a/drivers/staging/tidspbridge/pmgr/msg.c
+++ b/drivers/staging/tidspbridge/pmgr/msg.c
@@ -64,7 +64,7 @@ int msg_create(struct msg_mgr **msg_man,
 
 	/* Let Bridge message module finish the create: */
 	status =
-	    (*intf_fxns->pfn_msg_create) (&hmsg_mgr, hdev_obj, msg_callback);
+	    (*intf_fxns->msg_create) (&hmsg_mgr, hdev_obj, msg_callback);
 
 	if (!status) {
 		/* Fill in DSP API message module's fields of the msg_mgr
@@ -96,7 +96,7 @@ void msg_delete(struct msg_mgr *hmsg_mgr)
 		intf_fxns = msg_mgr_obj->intf_fxns;
 
 		/* Let Bridge message module destroy the msg_mgr: */
-		(*intf_fxns->pfn_msg_delete) (hmsg_mgr);
+		(*intf_fxns->msg_delete) (hmsg_mgr);
 	} else {
 		dev_dbg(bridge, "%s: Error hmsg_mgr handle: %p\n",
 			__func__, hmsg_mgr);
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index a6ae007..20630b1 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -432,7 +432,7 @@ int nldr_create(struct nldr_object **nldr,
 	DBC_REQUIRE(nldr != NULL);
 	DBC_REQUIRE(hdev_obj != NULL);
 	DBC_REQUIRE(pattrs != NULL);
-	DBC_REQUIRE(pattrs->pfn_ovly != NULL);
+	DBC_REQUIRE(pattrs->ovly != NULL);
 	DBC_REQUIRE(pattrs->pfn_write != NULL);
 
 	/* Allocate dynamic loader object */
@@ -537,7 +537,7 @@ int nldr_create(struct nldr_object **nldr,
 		new_attrs.sym_lookup = (dbll_sym_lookup) get_symbol_value;
 		new_attrs.sym_handle = nldr_obj;
 		new_attrs.write = (dbll_write_fxn) pattrs->pfn_write;
-		nldr_obj->ovly_fxn = pattrs->pfn_ovly;
+		nldr_obj->ovly_fxn = pattrs->ovly;
 		nldr_obj->write_fxn = pattrs->pfn_write;
 		nldr_obj->ldr_attrs = new_attrs;
 	}
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 042e73e..c198765 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -566,7 +566,7 @@ func_cont:
 		/* Create a message queue for this node */
 		intf_fxns = hnode_mgr->intf_fxns;
 		status =
-		    (*intf_fxns->pfn_msg_create_queue) (hnode_mgr->msg_mgr_obj,
+		    (*intf_fxns->msg_create_queue) (hnode_mgr->msg_mgr_obj,
 							&pnode->msg_queue_obj,
 							0,
 							pnode->create_args.asa.
@@ -598,7 +598,7 @@ func_cont:
 			   stack_seg_name, STACKSEGLABEL) == 0) {
 			status =
 			    hnode_mgr->nldr_fxns.
-			    pfn_get_fxn_addr(pnode->nldr_node_obj, "DYNEXT_BEG",
+			    get_fxn_addr(pnode->nldr_node_obj, "DYNEXT_BEG",
 					     &dynext_base);
 			if (status)
 				pr_err("%s: Failed to get addr for DYNEXT_BEG"
@@ -606,7 +606,7 @@ func_cont:
 
 			status =
 			    hnode_mgr->nldr_fxns.
-			    pfn_get_fxn_addr(pnode->nldr_node_obj,
+			    get_fxn_addr(pnode->nldr_node_obj,
 					     "L1DSRAM_HEAP", &pul_value);
 
 			if (status)
@@ -1229,7 +1229,7 @@ int node_create(struct node_object *hnode)
 		if (pdata->cpu_set_freq)
 			(*pdata->cpu_set_freq) (pdata->mpu_speed[VDD1_OPP3]);
 #endif
-		status = hnode_mgr->nldr_fxns.pfn_load(hnode->nldr_node_obj,
+		status = hnode_mgr->nldr_fxns.load(hnode->nldr_node_obj,
 						       NLDR_CREATE);
 		/* Get address of node's create function */
 		if (!status) {
@@ -1250,7 +1250,7 @@ int node_create(struct node_object *hnode)
 		/* Get address of iAlg functions, if socket node */
 		if (!status) {
 			if (node_type == NODE_DAISSOCKET) {
-				status = hnode_mgr->nldr_fxns.pfn_get_fxn_addr
+				status = hnode_mgr->nldr_fxns.get_fxn_addr
 				    (hnode->nldr_node_obj,
 				     hnode->dcd_props.obj_data.node_obj.
 				     pstr_i_alg_name,
@@ -1271,7 +1271,7 @@ int node_create(struct node_object *hnode)
 				/* Set the message queue id to the node env
 				 * pointer */
 				intf_fxns = hnode_mgr->intf_fxns;
-				(*intf_fxns->pfn_msg_set_queue_id) (hnode->
+				(*intf_fxns->msg_set_queue_id) (hnode->
 							msg_queue_obj,
 							hnode->node_env);
 			}
@@ -1282,7 +1282,7 @@ int node_create(struct node_object *hnode)
 	if (hnode->loaded && hnode->phase_split) {
 		/* If create code was dynamically loaded, we can now unload
 		 * it. */
-		status1 = hnode_mgr->nldr_fxns.pfn_unload(hnode->nldr_node_obj,
+		status1 = hnode_mgr->nldr_fxns.unload(hnode->nldr_node_obj,
 							  NLDR_CREATE);
 		hnode->loaded = false;
 	}
@@ -1402,11 +1402,11 @@ int node_create_mgr(struct node_mgr **node_man,
 		node_mgr_obj->nldr_fxns = nldr_fxns;	/* Dyn loader funcs */
 
 	if (!status) {
-		nldr_attrs_obj.pfn_ovly = ovly;
+		nldr_attrs_obj.ovly = ovly;
 		nldr_attrs_obj.pfn_write = mem_write;
 		nldr_attrs_obj.us_dsp_word_size = node_mgr_obj->udsp_word_size;
 		nldr_attrs_obj.us_dsp_mau_size = node_mgr_obj->udsp_mau_size;
-		node_mgr_obj->loader_init = node_mgr_obj->nldr_fxns.pfn_init();
+		node_mgr_obj->loader_init = node_mgr_obj->nldr_fxns.init();
 		status =
 		    node_mgr_obj->nldr_fxns.create(&node_mgr_obj->nldr_obj,
 						       hdev_obj,
@@ -1489,7 +1489,7 @@ int node_delete(struct node_res_object *noderes,
 				 * is not * running */
 				status1 =
 				    hnode_mgr->nldr_fxns.
-				    pfn_unload(pnode->nldr_node_obj,
+				    load(pnode->nldr_node_obj,
 					       NLDR_EXECUTE);
 				pnode->loaded = false;
 				NODE_SET_STATE(pnode, NODE_DONE);
@@ -1500,7 +1500,7 @@ int node_delete(struct node_res_object *noderes,
 			    pnode->phase_split) {
 				status =
 				    hnode_mgr->nldr_fxns.
-				    pfn_load(pnode->nldr_node_obj, NLDR_DELETE);
+				    load(pnode->nldr_node_obj, NLDR_DELETE);
 				if (!status)
 					pnode->loaded = true;
 				else
@@ -1541,7 +1541,7 @@ func_cont1:
 				    pnode->phase_split) {
 					status1 =
 					    hnode_mgr->nldr_fxns.
-					    pfn_unload(pnode->nldr_node_obj,
+					    unload(pnode->nldr_node_obj,
 						       NLDR_EXECUTE);
 				}
 				if (status1)
@@ -1549,7 +1549,7 @@ func_cont1:
 					       " 0x%x\n", __func__, status1);
 
 				status1 =
-				    hnode_mgr->nldr_fxns.pfn_unload(pnode->
+				    hnode_mgr->nldr_fxns.unload(pnode->
 							    nldr_node_obj,
 							    NLDR_DELETE);
 				pnode->loaded = false;
@@ -1835,7 +1835,7 @@ int node_get_message(struct node_object *hnode,
 	 *  available. */
 	intf_fxns = hnode_mgr->intf_fxns;
 	status =
-	    (*intf_fxns->pfn_msg_get) (hnode->msg_queue_obj, message, utimeout);
+	    (*intf_fxns->msg_get) (hnode->msg_queue_obj, message, utimeout);
 	/* Check if message contains SM descriptor */
 	if (status || !(message->cmd & DSP_RMSBUFDESC))
 		goto func_end;
@@ -1984,7 +1984,7 @@ void node_on_exit(struct node_object *hnode, s32 node_status)
 	NODE_SET_STATE(hnode, NODE_DONE);
 	hnode->exit_status = node_status;
 	if (hnode->loaded && hnode->phase_split) {
-		(void)hnode->hnode_mgr->nldr_fxns.pfn_unload(hnode->
+		(void)hnode->hnode_mgr->nldr_fxns.unload(hnode->
 							     nldr_node_obj,
 							     NLDR_EXECUTE);
 		hnode->loaded = false;
@@ -2167,7 +2167,7 @@ int node_put_message(struct node_object *hnode,
 	}
 	if (!status) {
 		intf_fxns = hnode_mgr->intf_fxns;
-		status = (*intf_fxns->pfn_msg_put) (hnode->msg_queue_obj,
+		status = (*intf_fxns->msg_put) (hnode->msg_queue_obj,
 						    &new_msg, utimeout);
 	}
 func_end:
@@ -2215,7 +2215,7 @@ int node_register_notify(struct node_object *hnode, u32 event_mask,
 		} else {
 			/* Send Message part of event mask to msg_ctrl */
 			intf_fxns = hnode->hnode_mgr->intf_fxns;
-			status = (*intf_fxns->pfn_msg_register_notify)
+			status = (*intf_fxns->msg_register_notify)
 			    (hnode->msg_queue_obj,
 			     event_mask & DSP_NODEMESSAGEREADY, notify_type,
 			     hnotification);
@@ -2297,7 +2297,7 @@ int node_run(struct node_object *hnode)
 		/* If node's execute function is not loaded, load it */
 		if (!(hnode->loaded) && hnode->phase_split) {
 			status =
-			    hnode_mgr->nldr_fxns.pfn_load(hnode->nldr_node_obj,
+			    hnode_mgr->nldr_fxns.load(hnode->nldr_node_obj,
 							  NLDR_EXECUTE);
 			if (!status) {
 				hnode->loaded = true;
@@ -2431,7 +2431,7 @@ int node_terminate(struct node_object *hnode, int *pstatus)
 		else
 			kill_time_out = (hnode->utimeout) * 2;
 
-		status = (*intf_fxns->pfn_msg_put) (hnode->msg_queue_obj, &msg,
+		status = (*intf_fxns->msg_put) (hnode->msg_queue_obj, &msg,
 						    hnode->utimeout);
 		if (status)
 			goto func_cont;
@@ -2447,7 +2447,7 @@ int node_terminate(struct node_object *hnode, int *pstatus)
 		if (status != ETIME)
 			goto func_cont;
 
-		status = (*intf_fxns->pfn_msg_put)(hnode->msg_queue_obj,
+		status = (*intf_fxns->msg_put)(hnode->msg_queue_obj,
 						&killmsg, hnode->utimeout);
 		if (status)
 			goto func_cont;
@@ -2519,7 +2519,7 @@ static void delete_node(struct node_object *hnode,
 		/* Free msg_ctrl queue */
 		if (hnode->msg_queue_obj) {
 			intf_fxns = hnode_mgr->intf_fxns;
-			(*intf_fxns->pfn_msg_delete_queue) (hnode->
+			(*intf_fxns->msg_delete_queue) (hnode->
 							    msg_queue_obj);
 			hnode->msg_queue_obj = NULL;
 		}
@@ -2653,7 +2653,7 @@ static void delete_node_mgr(struct node_mgr *hnode_mgr)
 			hnode_mgr->nldr_fxns.delete(hnode_mgr->nldr_obj);
 
 		if (hnode_mgr->loader_init)
-			hnode_mgr->nldr_fxns.pfn_exit();
+			hnode_mgr->nldr_fxns.exit();
 
 		kfree(hnode_mgr);
 	}
@@ -2814,7 +2814,7 @@ static int get_fxn_address(struct node_object *hnode, u32 * fxn_addr,
 	}
 
 	status =
-	    hnode_mgr->nldr_fxns.pfn_get_fxn_addr(hnode->nldr_node_obj,
+	    hnode_mgr->nldr_fxns.get_fxn_addr(hnode->nldr_node_obj,
 						  pstr_fxn_name, fxn_addr);
 
 	return status;
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index 8bc6924..6840d29 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -917,7 +917,7 @@ int proc_get_resource_info(void *hprocessor, u32 resource_type,
 		if (hio_mgr)
 			status =
 			    p_proc_object->intf_fxns->
-			    pfn_io_get_proc_load(hio_mgr,
+			    io_get_proc_load(hio_mgr,
 						 (struct dsp_procloadstat *)
 						 &(resource_info->result.
 						   proc_load_stat));
@@ -1227,7 +1227,7 @@ int proc_load(void *hprocessor, const s32 argc_index,
 		/* Set the Device object's message manager */
 		status = dev_get_io_mgr(p_proc_object->hdev_obj, &hio_mgr);
 		if (hio_mgr)
-			status = (*p_proc_object->intf_fxns->pfn_io_on_loaded)
+			status = (*p_proc_object->intf_fxns->io_on_loaded)
 								(hio_mgr);
 		else
 			status = -EFAULT;
-- 
1.6.3.3

