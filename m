Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0GLW4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:56:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47423 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab0GLW4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:56:20 -0400
From: Nishanth Menon <nm@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Ameya Palande <ameya.palande@nokia.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 01/11] staging: tidspbridge: remove custom TRUE FALSE
Date: Mon, 12 Jul 2010 17:55:59 -0500
Message-Id: <1278975369-7687-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278975369-7687-1-git-send-email-nm@ti.com>
References: <1278975369-7687-1-git-send-email-nm@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bool has standard true and false, we dont need to introduce
our own TRUE and FALSE macros.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/staging/tidspbridge/core/tiomap3430.c      |    6 +++---
 .../staging/tidspbridge/dynload/dload_internal.h   |    3 ---
 drivers/staging/tidspbridge/dynload/header.h       |    2 --
 drivers/staging/tidspbridge/gen/gb.c               |    2 +-
 drivers/staging/tidspbridge/hw/GlobalTypes.h       |   10 ----------
 .../staging/tidspbridge/include/dspbridge/dbtype.h |   11 -----------
 drivers/staging/tidspbridge/pmgr/dbll.c            |    4 ++--
 drivers/staging/tidspbridge/pmgr/dmm.c             |    2 +-
 drivers/staging/tidspbridge/rmgr/node.c            |    2 +-
 9 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index 60fca91..25c1271 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -1863,10 +1863,10 @@ bool wait_for_start(struct bridge_dev_context *dev_context, u32 dw_sync_addr)
 	while (*((volatile u16 *)dw_sync_addr) && --timeout)
 		udelay(10);
 
-	/*  If timed out: return FALSE */
+	/*  If timed out: return false */
 	if (!timeout) {
 		pr_err("%s: Timed out waiting DSP to Start\n", __func__);
-		return FALSE;
+		return false;
 	}
-	return TRUE;
+	return true;
 }
diff --git a/drivers/staging/tidspbridge/dynload/dload_internal.h b/drivers/staging/tidspbridge/dynload/dload_internal.h
index 8037561..5a17e6c 100644
--- a/drivers/staging/tidspbridge/dynload/dload_internal.h
+++ b/drivers/staging/tidspbridge/dynload/dload_internal.h
@@ -23,9 +23,6 @@
  * Internal state definitions for the dynamic loader
  */
 
-#define TRUE 1
-#define FALSE 0
-
 /* type used for relocation intermediate results */
 typedef s32 rvalue;
 
diff --git a/drivers/staging/tidspbridge/dynload/header.h b/drivers/staging/tidspbridge/dynload/header.h
index 5cef360..04623f1 100644
--- a/drivers/staging/tidspbridge/dynload/header.h
+++ b/drivers/staging/tidspbridge/dynload/header.h
@@ -14,8 +14,6 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
-#define TRUE 1
-#define FALSE 0
 #ifndef NULL
 #define NULL 0
 #endif
diff --git a/drivers/staging/tidspbridge/gen/gb.c b/drivers/staging/tidspbridge/gen/gb.c
index f1a9dd3..d007233 100644
--- a/drivers/staging/tidspbridge/gen/gb.c
+++ b/drivers/staging/tidspbridge/gen/gb.c
@@ -161,7 +161,7 @@ bool gb_test(struct gb_t_map *map, u32 bitn)
 
 	mask = 1L << (bitn % BITS_PER_LONG);
 	word = map->words[bitn / BITS_PER_LONG];
-	state = word & mask ? TRUE : FALSE;
+	state = word & mask ? true : false;
 
 	return state;
 }
diff --git a/drivers/staging/tidspbridge/hw/GlobalTypes.h b/drivers/staging/tidspbridge/hw/GlobalTypes.h
index 9b55150..ba045eb 100644
--- a/drivers/staging/tidspbridge/hw/GlobalTypes.h
+++ b/drivers/staging/tidspbridge/hw/GlobalTypes.h
@@ -20,16 +20,6 @@
 #define _GLOBALTYPES_H
 
 /*
- * Definition: TRUE, FALSE
- *
- * DESCRIPTION:  Boolean Definitions
- */
-#ifndef TRUE
-#define FALSE	0
-#define TRUE	(!(FALSE))
-#endif
-
-/*
  * Definition: NULL
  *
  * DESCRIPTION:  Invalid pointer
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dbtype.h b/drivers/staging/tidspbridge/include/dspbridge/dbtype.h
index de65a82..0b2cb93 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dbtype.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dbtype.h
@@ -42,17 +42,6 @@
 #endif
 
 /*===========================================================================*/
-/*  Boolean constants */
-/*===========================================================================*/
-
-#ifndef FALSE
-#define FALSE   0
-#endif
-#ifndef TRUE
-#define TRUE    1
-#endif
-
-/*===========================================================================*/
 /*  NULL    (Definition is language specific) */
 /*===========================================================================*/
 
diff --git a/drivers/staging/tidspbridge/pmgr/dbll.c b/drivers/staging/tidspbridge/pmgr/dbll.c
index 3636aa3..3a50071 100644
--- a/drivers/staging/tidspbridge/pmgr/dbll.c
+++ b/drivers/staging/tidspbridge/pmgr/dbll.c
@@ -1225,7 +1225,7 @@ static int dbll_rmm_alloc(struct dynamic_loader_allocate *this,
 	int status = 0;
 	u32 mem_sect_type;
 	struct rmm_addr rmm_addr_obj;
-	s32 ret = TRUE;
+	s32 ret = true;
 	unsigned stype = DLOAD_SECTION_TYPE(info->type);
 	char *token = NULL;
 	char *sz_sec_last_token = NULL;
@@ -1314,7 +1314,7 @@ func_cont:
 						    rmm_handle, mem_sect_type,
 						    alloc_size, align,
 						    (u32 *) &rmm_addr_obj,
-						    seg_id, req, FALSE);
+						    seg_id, req, false);
 	}
 	if (DSP_FAILED(status)) {
 		ret = false;
diff --git a/drivers/staging/tidspbridge/pmgr/dmm.c b/drivers/staging/tidspbridge/pmgr/dmm.c
index e0be8e0..e211ec5 100644
--- a/drivers/staging/tidspbridge/pmgr/dmm.c
+++ b/drivers/staging/tidspbridge/pmgr/dmm.c
@@ -503,7 +503,7 @@ u32 dmm_mem_map_dump(struct dmm_object *dmm_mgr)
 		for (i = 0; i < table_size; i +=
 		     virtual_mapping_table[i].region_size) {
 			curr_node = virtual_mapping_table + i;
-			if (curr_node->reserved == TRUE) {
+			if (curr_node->reserved) {
 				/*printk("RESERVED size = 0x%x, "
 				   "Map size = 0x%x\n",
 				   (curr_node->region_size * PG_SIZE4K),
diff --git a/drivers/staging/tidspbridge/rmgr/node.c b/drivers/staging/tidspbridge/rmgr/node.c
index 1870b80..9a46edc 100644
--- a/drivers/staging/tidspbridge/rmgr/node.c
+++ b/drivers/staging/tidspbridge/rmgr/node.c
@@ -2620,7 +2620,7 @@ static void delete_node(struct node_object *hnode,
 
 	/* Free all SM address translator resources */
 	if (xlator) {
-		(void)cmm_xlator_delete(xlator, TRUE);	/* force free */
+		(void)cmm_xlator_delete(xlator, true);	/* force free */
 		xlator = NULL;
 	}
 
-- 
1.6.3.3

