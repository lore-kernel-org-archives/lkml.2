Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0LTV0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:26:50 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41589 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab0LTV0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:26:49 -0500
From: Ernesto Ramos <ernesto@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: omar.ramirez@ti.com, ohad@wizery.com, felipe.contreras@gmail.com,
        Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH] staging: tidspbridge: remove code referred by OPT_ZERO_COPY_LOADER
Date: Mon, 20 Dec 2010 15:23:08 -0600
Message-Id: <1292880188-5860-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code referred by OPT_ZERO_COPY_LOADER since it is
not used.

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/dynload/cload.c |   60 +++++++++------------------
 1 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/tidspbridge/dynload/cload.c b/drivers/staging/tidspbridge/dynload/cload.c
index a5cdfa1..7713e76 100644
--- a/drivers/staging/tidspbridge/dynload/cload.c
+++ b/drivers/staging/tidspbridge/dynload/cload.c
@@ -1133,9 +1133,6 @@ static void dload_data(struct dload_state *dlthis)
 	u16 curr_sect;
 	struct doff_scnhdr_t *sptr = dlthis->sect_hdrs;
 	struct ldr_section_info *lptr = dlthis->ldr_sections;
-#ifdef OPT_ZERO_COPY_LOADER
-	bool zero_copy = false;
-#endif
 	u8 *dest;
 
 	struct {
@@ -1194,17 +1191,6 @@ static void dload_data(struct dload_state *dlthis)
 					return;
 				}
 				dest = ibuf.bufr;
-#ifdef OPT_ZERO_COPY_LOADER
-				zero_copy = false;
-				if (!dload_check_type(sptr, DLOAD_CINIT) {
-					dlthis->myio->writemem(dlthis->myio,
-							       &dest,
-							       lptr->load_addr +
-							       image_offset,
-							       lptr, 0);
-					zero_copy = (dest != ibuf.bufr);
-				}
-#endif
 				/* End of determination */
 
 				if (dlthis->strm->read_buffer(dlthis->strm,
@@ -1268,33 +1254,27 @@ static void dload_data(struct dload_state *dlthis)
 							    &ibuf.ipacket);
 						cinit_processed = true;
 					} else {
-#ifdef OPT_ZERO_COPY_LOADER
-						if (!zero_copy) {
-#endif
-							/* FIXME */
-							if (!dlthis->myio->
-							    writemem(dlthis->
-								myio,
-								ibuf.bufr,
-								lptr->
-								load_addr +
-								image_offset,
-								lptr,
-								BYTE_TO_HOST
-								(ibuf.
-								ipacket.
-								packet_size))) {
-								DL_ERROR
-								  ("Write to "
-								  FMT_UI32
-								  " failed",
-								  lptr->
-								  load_addr +
-								  image_offset);
-							}
-#ifdef OPT_ZERO_COPY_LOADER
+						/* FIXME */
+						if (!dlthis->myio->
+						    writemem(dlthis->
+							myio,
+							ibuf.bufr,
+							lptr->
+							load_addr +
+							image_offset,
+							lptr,
+							BYTE_TO_HOST
+							(ibuf.
+							ipacket.
+							packet_size))) {
+							DL_ERROR
+							  ("Write to "
+							  FMT_UI32
+							  " failed",
+							  lptr->
+							  load_addr +
+							  image_offset);
 						}
-#endif
 					}
 				}
 				image_offset +=
-- 
1.7.0.4

