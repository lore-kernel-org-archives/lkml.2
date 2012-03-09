Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab2CIAEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:04:47 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:31437 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab2CIAEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:04:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAN1HWU9bdWOb/2dsb2JhbABDhTWwe4ILAQUjDwEjIxAlAhgOAgI5AxsGARKIDqgakgWBL44RgRYElUWFZYNchleCZA
X-IronPort-AV: E=Sophos;i="4.73,554,1325458800"; 
   d="scan'208";a="886086921"
From: =?UTF-8?q?V=C3=ADctor=20Manuel=20J=C3=A1quez=20Leal?= 
	<vjaquez@igalia.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 05/17] staging: tidspbridge: remove disp_init() and disp_exit()
Date: Fri,  9 Mar 2012 01:03:40 +0100
Message-Id: <75764cca8222a575878215b05ff361a100b58d11.1331250369.git.vjaquez@igalia.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <cover.1331250368.git.vjaquez@igalia.com>
References: <cover.1331250368.git.vjaquez@igalia.com>
In-Reply-To: <cover.1331250368.git.vjaquez@igalia.com>
References: <cover.1331250368.git.vjaquez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The disp module has a disp_init() and a disp_exit() whose only purpose
is to keep a reference counting which is not used at all.

This patch removes these functions and the reference count variable.

There is no functional changes.

Signed-off-by: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
---
 .../staging/tidspbridge/include/dspbridge/disp.h   |   31 --------------------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |    7 +----
 drivers/staging/tidspbridge/rmgr/disp.c            |   25 ----------------
 3 files changed, 1 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/disp.h b/drivers/staging/tidspbridge/include/dspbridge/disp.h
index 5dfdc8c..39d3cea 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/disp.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/disp.h
@@ -53,7 +53,6 @@ struct disp_attr {
  *      -ENOMEM:            Insufficient memory for requested resources.
  *      -EPERM:              Unable to create dispatcher.
  *  Requires:
- *      disp_init(void) called.
  *      disp_attrs != NULL.
  *      hdev_obj != NULL.
  *      dispatch_obj != NULL.
@@ -73,7 +72,6 @@ extern int disp_create(struct disp_object **dispatch_obj,
  *      disp_obj:  Node Dispatcher object.
  *  Returns:
  *  Requires:
- *      disp_init(void) called.
  *      Valid disp_obj.
  *  Ensures:
  *      disp_obj is invalid.
@@ -81,31 +79,6 @@ extern int disp_create(struct disp_object **dispatch_obj,
 extern void disp_delete(struct disp_object *disp_obj);
 
 /*
- *  ======== disp_exit ========
- *  Discontinue usage of DISP module.
- *
- *  Parameters:
- *  Returns:
- *  Requires:
- *      disp_init(void) previously called.
- *  Ensures:
- *      Any resources acquired in disp_init(void) will be freed when last DISP
- *      client calls disp_exit(void).
- */
-extern void disp_exit(void);
-
-/*
- *  ======== disp_init ========
- *  Initialize the DISP module.
- *
- *  Parameters:
- *  Returns:
- *      TRUE if initialization succeeded, FALSE otherwise.
- *  Ensures:
- */
-extern bool disp_init(void);
-
-/*
  *  ======== disp_node_change_priority ========
  *  Change the priority of a node currently running on the target.
  *
@@ -120,7 +93,6 @@ extern bool disp_init(void);
  *      0:                Success.
  *      -ETIME:           A timeout occurred before the DSP responded.
  *  Requires:
- *      disp_init(void) called.
  *      Valid disp_obj.
  *      hnode != NULL.
  *  Ensures:
@@ -148,7 +120,6 @@ extern int disp_node_change_priority(struct disp_object
  *      -ETIME:   A timeout occurred before the DSP responded.
  *      -EPERM:      A failure occurred, unable to create node.
  *  Requires:
- *      disp_init(void) called.
  *      Valid disp_obj.
  *      pargs != NULL.
  *      hnode != NULL.
@@ -178,7 +149,6 @@ extern int disp_node_create(struct disp_object *disp_obj,
  *      0:        Success.
  *      -ETIME:   A timeout occurred before the DSP responded.
  *  Requires:
- *      disp_init(void) called.
  *      Valid disp_obj.
  *      hnode != NULL.
  *  Ensures:
@@ -204,7 +174,6 @@ extern int disp_node_delete(struct disp_object *disp_obj,
  *      0:        Success.
  *      -ETIME:   A timeout occurred before the DSP responded.
  *  Requires:
- *      disp_init(void) called.
  *      Valid disp_obj.
  *      hnode != NULL.
  *  Ensures:
diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index a5f1f65..b1a99f7 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -272,7 +272,6 @@ void api_exit(void)
 		msg_exit();
 		io_exit();
 		strm_exit();
-		disp_exit();
 		mgr_exit();
 		rmm_exit();
 	}
@@ -287,12 +286,11 @@ bool api_init(void)
 {
 	bool ret = true;
 	bool fdev, fchnl, fmsg, fio;
-	bool fmgr, fdisp, fstrm, frmm;
+	bool fmgr, fstrm, frmm;
 
 	if (api_c_refs == 0) {
 		/* initialize driver and other modules */
 		fmgr = mgr_init();
-		fdisp = disp_init();
 		fstrm = strm_init();
 		frmm = rmm_init();
 		fchnl = chnl_init();
@@ -309,9 +307,6 @@ bool api_init(void)
 			if (fstrm)
 				strm_exit();
 
-			if (fdisp)
-				disp_exit();
-
 			if (fchnl)
 				chnl_exit();
 
diff --git a/drivers/staging/tidspbridge/rmgr/disp.c b/drivers/staging/tidspbridge/rmgr/disp.c
index e510bb2..4af51b7 100644
--- a/drivers/staging/tidspbridge/rmgr/disp.c
+++ b/drivers/staging/tidspbridge/rmgr/disp.c
@@ -69,8 +69,6 @@ struct disp_object {
 	u32 data_mau_size;	/* Size of DSP Data MAU */
 };
 
-static u32 refs;
-
 static void delete_disp(struct disp_object *disp_obj);
 static int fill_stream_def(rms_word *pdw_buf, u32 *ptotal, u32 offset,
 				  struct node_strmdef strm_def, u32 max,
@@ -173,29 +171,6 @@ void disp_delete(struct disp_object *disp_obj)
 }
 
 /*
- *  ======== disp_exit ========
- *  Discontinue usage of DISP module.
- */
-void disp_exit(void)
-{
-	refs--;
-}
-
-/*
- *  ======== disp_init ========
- *  Initialize the DISP module.
- */
-bool disp_init(void)
-{
-	bool ret = true;
-
-	if (ret)
-		refs++;
-
-	return ret;
-}
-
-/*
  *  ======== disp_node_change_priority ========
  *  Change the priority of a node currently running on the target.
  */
-- 
1.7.9.1

