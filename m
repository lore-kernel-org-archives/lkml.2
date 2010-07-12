Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab0GLW4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39462 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab0GLW4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:23 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 09/11] staging: tidspbridge: remove OPTIONAL
Date: Mon, 12 Jul 2010 17:56:07 -0500
Message-Id: <1278975369-7687-10-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPTIONAL modifier makes no sense in linux kernel

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/staging/tidspbridge/core/chnl_sm.c         |    2 +-
 .../staging/tidspbridge/include/dspbridge/cod.h    |    2 +-
 .../tidspbridge/include/dspbridge/dspchnl.h        |    4 ++--
 .../tidspbridge/include/dspbridge/dspdefs.h        |    4 ++--
 .../staging/tidspbridge/include/dspbridge/node.h   |   12 ++++++------
 .../staging/tidspbridge/include/dspbridge/proc.h   |    2 +-
 drivers/staging/tidspbridge/pmgr/cod.c             |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |   12 ++++++------
 drivers/staging/tidspbridge/rmgr/nldr.c            |    6 +++---
 drivers/staging/tidspbridge/rmgr/node.c            |   12 ++++++------
 drivers/staging/tidspbridge/rmgr/proc.c            |    2 +-
 11 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/chnl_sm.c b/drivers/staging/tidspbridge/core/chnl_sm.c
index 25d2450..2189796 100644
--- a/drivers/staging/tidspbridge/core/chnl_sm.c
+++ b/drivers/staging/tidspbridge/core/chnl_sm.c
@@ -91,7 +91,7 @@ static int search_free_channel(struct chnl_mgr *chnl_mgr_obj,
  */
 int bridge_chnl_add_io_req(struct chnl_object *chnl_obj, void *pHostBuf,
 			       u32 byte_size, u32 buf_size,
-			       OPTIONAL u32 dw_dsp_addr, u32 dw_arg)
+			       u32 dw_dsp_addr, u32 dw_arg)
 {
 	int status = 0;
 	struct chnl_object *pchnl = (struct chnl_object *)chnl_obj;
diff --git a/drivers/staging/tidspbridge/include/dspbridge/cod.h b/drivers/staging/tidspbridge/include/dspbridge/cod.h
index cb9b2c3..25817fc 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/cod.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/cod.h
@@ -93,7 +93,7 @@ extern void cod_close(struct cod_libraryobj *lib);
  */
 extern int cod_create(OUT struct cod_manager **phManager,
 			     char *pstrZLFile,
-			     OPTIONAL const struct cod_attrs *attrs);
+			     const struct cod_attrs *attrs);
 
 /*
  *  ======== cod_delete ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h b/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
index ee71e9b..8b943cc 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspchnl.h
@@ -35,7 +35,7 @@ extern int bridge_chnl_open(OUT struct chnl_object **phChnl,
 				   struct chnl_mgr *hchnl_mgr,
 				   s8 chnl_mode,
 				   u32 uChnlId,
-				   const OPTIONAL struct chnl_attr
+				   const struct chnl_attr
 				   *pattrs);
 
 extern int bridge_chnl_close(struct chnl_object *chnl_obj);
@@ -43,7 +43,7 @@ extern int bridge_chnl_close(struct chnl_object *chnl_obj);
 extern int bridge_chnl_add_io_req(struct chnl_object *chnl_obj,
 				      void *pHostBuf,
 				      u32 byte_size, u32 buf_size,
-				      OPTIONAL u32 dw_dsp_addr, u32 dw_arg);
+				      u32 dw_dsp_addr, u32 dw_arg);
 
 extern int bridge_chnl_get_ioc(struct chnl_object *chnl_obj,
 				   u32 dwTimeOut, OUT struct chnl_ioc *pIOC);
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
index 7c86e7b..467ec8b 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dspdefs.h
@@ -411,7 +411,7 @@ typedef int(*fxn_chnl_open) (OUT struct chnl_object
 				    struct chnl_mgr *hchnl_mgr,
 				    s8 chnl_mode,
 				    u32 uChnlId,
-				    const OPTIONAL struct
+				    const struct
 				    chnl_attr * pattrs);
 
 /*
@@ -474,7 +474,7 @@ typedef int(*fxn_chnl_addioreq) (struct chnl_object
 					void *pHostBuf,
 					u32 byte_size,
 					u32 buf_size,
-					OPTIONAL u32 dw_dsp_addr, u32 dw_arg);
+					u32 dw_dsp_addr, u32 dw_arg);
 
 /*
  *  ======== bridge_chnl_get_ioc ========
diff --git a/drivers/staging/tidspbridge/include/dspbridge/node.h b/drivers/staging/tidspbridge/include/dspbridge/node.h
index 7f16f6f..7be6dda 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/node.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/node.h
@@ -57,8 +57,8 @@
  */
 extern int node_allocate(struct proc_object *hprocessor,
 				const struct dsp_uuid *pNodeId,
-				OPTIONAL const struct dsp_cbdata
-				*pargs, OPTIONAL const struct dsp_nodeattrin
+				const struct dsp_cbdata
+				*pargs, const struct dsp_nodeattrin
 				*attr_in,
 				OUT struct node_object **ph_node,
 				struct process_context *pr_ctxt);
@@ -86,7 +86,7 @@ extern int node_allocate(struct proc_object *hprocessor,
  *  Ensures:
  */
 extern int node_alloc_msg_buf(struct node_object *hnode,
-				     u32 usize, OPTIONAL struct dsp_bufferattr
+				     u32 usize, struct dsp_bufferattr
 				     *pattr, OUT u8 **pbuffer);
 
 /*
@@ -182,8 +182,8 @@ extern int node_connect(struct node_object *hNode1,
 			       u32 uStream1,
 			       struct node_object *hNode2,
 			       u32 uStream2,
-			       OPTIONAL struct dsp_strmattr *pattrs,
-			       OPTIONAL struct dsp_cbdata
+			       struct dsp_strmattr *pattrs,
+			       struct dsp_cbdata
 			       *conn_param);
 
 /*
@@ -335,7 +335,7 @@ extern void node_exit(void);
  */
 extern int node_free_msg_buf(struct node_object *hnode,
 				    u8 *pbuffer,
-				    OPTIONAL struct dsp_bufferattr
+				    struct dsp_bufferattr
 				    *pattr);
 
 /*
diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
index a06ddc4..12f2f2a 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
@@ -52,7 +52,7 @@ extern char *iva_img;
  *      When attr_in is NULL, the default timeout value is 10 seconds.
  */
 extern int proc_attach(u32 processor_id,
-			      OPTIONAL const struct dsp_processorattrin
+			      const struct dsp_processorattrin
 			      *attr_in, void **ph_processor,
 			      struct process_context *pr_ctxt);
 
diff --git a/drivers/staging/tidspbridge/pmgr/cod.c b/drivers/staging/tidspbridge/pmgr/cod.c
index 859c2ff..2aed7a4 100644
--- a/drivers/staging/tidspbridge/pmgr/cod.c
+++ b/drivers/staging/tidspbridge/pmgr/cod.c
@@ -217,7 +217,7 @@ void cod_close(struct cod_libraryobj *lib)
  *
  */
 int cod_create(OUT struct cod_manager **phMgr, char *pstrDummyFile,
-		      OPTIONAL const struct cod_attrs *attrs)
+		      const struct cod_attrs *attrs)
 {
 	struct cod_manager *mgr_new;
 	struct dbll_attrs zl_attrs;
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 61c47b0..81b91b8 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -70,9 +70,9 @@ static char dsp_char2_gpp_char(char *pWord, s32 dsp_char_size);
 static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
 				   struct dsp_uuid *uuid_obj,
 				   OUT u16 *pNumLibs,
-				   OPTIONAL OUT u16 *pNumPersLibs,
-				   OPTIONAL OUT struct dsp_uuid *pDepLibUuids,
-				   OPTIONAL OUT bool *pPersistentDepLibs,
+				   OUT u16 *pNumPersLibs,
+				   OUT struct dsp_uuid *pDepLibUuids,
+				   OUT bool *pPersistentDepLibs,
 				   enum nldr_phase phase);
 
 /*
@@ -1392,9 +1392,9 @@ static char dsp_char2_gpp_char(char *pWord, s32 dsp_char_size)
 static int get_dep_lib_info(struct dcd_manager *hdcd_mgr,
 				   struct dsp_uuid *uuid_obj,
 				   OUT u16 *pNumLibs,
-				   OPTIONAL OUT u16 *pNumPersLibs,
-				   OPTIONAL OUT struct dsp_uuid *pDepLibUuids,
-				   OPTIONAL OUT bool *pPersistentDepLibs,
+				   OUT u16 *pNumPersLibs,
+				   OUT struct dsp_uuid *pDepLibUuids,
+				   OUT bool *pPersistentDepLibs,
 				   enum nldr_phase phase)
 {
 	struct dcd_manager *dcd_mgr_obj = hdcd_mgr;
diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index bad1b8f..aaaab67 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -306,8 +306,8 @@ static int load_lib(struct nldr_nodeobject *nldr_node_obj,
 static int load_ovly(struct nldr_nodeobject *nldr_node_obj,
 			    enum nldr_phase phase);
 static int remote_alloc(void **pRef, u16 mem_sect_type, u32 size,
-			       u32 align, u32 *dspAddr, OPTIONAL s32 segmentId,
-			       OPTIONAL s32 req, bool reserve);
+			       u32 align, u32 *dspAddr, s32 segmentId,
+			       s32 req, bool reserve);
 static int remote_free(void **pRef, u16 space, u32 dspAddr, u32 size,
 			      bool reserve);
 
@@ -1625,7 +1625,7 @@ func_end:
  */
 static int remote_alloc(void **pRef, u16 space, u32 size,
 			       u32 align, u32 *dspAddr,
-			       OPTIONAL s32 segmentId, OPTIONAL s32 req,
+			       s32 segmentId, s32 req,
 			       bool reserve)
 {
 	struct nldr_nodeobject *hnode = (struct nldr_nodeobject *)pRef;
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index c19e1bf..1f975c6 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -292,8 +292,8 @@ enum node_state node_get_state(void *hnode)
  */
 int node_allocate(struct proc_object *hprocessor,
 			 const struct dsp_uuid *pNodeId,
-			 OPTIONAL const struct dsp_cbdata *pargs,
-			 OPTIONAL const struct dsp_nodeattrin *attr_in,
+			 const struct dsp_cbdata *pargs,
+			 const struct dsp_nodeattrin *attr_in,
 			 OUT struct node_object **ph_node,
 			 struct process_context *pr_ctxt)
 {
@@ -685,7 +685,7 @@ func_end:
  *      Allocates buffer for zero copy messaging.
  */
 DBAPI node_alloc_msg_buf(struct node_object *hnode, u32 usize,
-			 OPTIONAL OUT struct dsp_bufferattr *pattr,
+			 OUT struct dsp_bufferattr *pattr,
 			 OUT u8 **pbuffer)
 {
 	struct node_object *pnode = (struct node_object *)hnode;
@@ -833,8 +833,8 @@ func_end:
  */
 int node_connect(struct node_object *hNode1, u32 uStream1,
 			struct node_object *hNode2,
-			u32 uStream2, OPTIONAL struct dsp_strmattr *pattrs,
-			OPTIONAL struct dsp_cbdata *conn_param)
+			u32 uStream2, struct dsp_strmattr *pattrs,
+			struct dsp_cbdata *conn_param)
 {
 	struct node_mgr *hnode_mgr;
 	char *pstr_dev_name = NULL;
@@ -1674,7 +1674,7 @@ void node_exit(void)
  *      Frees the message buffer.
  */
 int node_free_msg_buf(struct node_object *hnode, u8 * pbuffer,
-			     OPTIONAL struct dsp_bufferattr *pattr)
+			     struct dsp_bufferattr *pattr)
 {
 	struct node_object *pnode = (struct node_object *)hnode;
 	int status = 0;
diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
index e95d44c..1f450fe 100644
--- a/drivers/staging/tidspbridge/rmgr/proc.c
+++ b/drivers/staging/tidspbridge/rmgr/proc.c
@@ -272,7 +272,7 @@ static inline struct page *get_mapping_page(struct dmm_map_object *map_obj,
  */
 int
 proc_attach(u32 processor_id,
-	    OPTIONAL const struct dsp_processorattrin *attr_in,
+	    const struct dsp_processorattrin *attr_in,
 	    void **ph_processor, struct process_context *pr_ctxt)
 {
 	int status = 0;
-- 
1.6.3.3

