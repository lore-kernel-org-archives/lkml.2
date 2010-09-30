Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0I3S2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:28:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52181 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab0I3S17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:27:59 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ameya.palande@nokia.com, felipe.contreras@gmail.com,
        andy.shevchenko@gmail.com, Ernesto Ramos <ernesto@ti.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH] staging:ti dspbridge: Replace find_lcm with lcm kernel func
Date: Thu, 30 Sep 2010 13:34:13 -0500
Message-Id: <1285871653-26944-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resendig this patch since it was missed in the last merge...

Remove find_lcm within nldr.c and use standard
kernel function lcm().

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/rmgr/nldr.c |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index d8f4eeb..a6ae007 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -35,7 +35,7 @@
 #include <dspbridge/uuidutil.h>
 
 #include <dspbridge/nldr.h>
-#include <linux/gcd.h>
+#include <linux/lcm.h>
 
 /* Name of section containing dynamic load mem */
 #define DYNMEMSECT  ".dspbridge_mem"
@@ -304,7 +304,6 @@ static void unload_ovly(struct nldr_nodeobject *nldr_node_obj,
 			enum nldr_phase phase);
 static bool find_in_persistent_lib_array(struct nldr_nodeobject *nldr_node_obj,
 					 struct dbll_library_obj *lib);
-static u32 find_lcm(u32 a, u32 b);
 
 /*
  *  ======== nldr_allocate ========
@@ -1637,7 +1636,7 @@ static int remote_alloc(void **ref, u16 mem_sect, u32 size,
 	    (size + nldr_obj->us_dsp_word_size -
 	     1) / nldr_obj->us_dsp_word_size;
 	/* Modify memory 'align' to account for DSP cache line size */
-	align = find_lcm(GEM_CACHE_LINE_SIZE, align);
+	align = lcm(GEM_CACHE_LINE_SIZE, align);
 	dev_dbg(bridge, "%s: memory align to 0x%x\n", __func__, align);
 	if (segmnt_id != -1) {
 		rmm_addr_obj->segid = segmnt_id;
@@ -1880,18 +1879,6 @@ static bool find_in_persistent_lib_array(struct nldr_nodeobject *nldr_node_obj,
 	return false;
 }
 
-/*
- * ================ Find LCM (Least Common Multiplier ===
- */
-static u32 find_lcm(u32 a, u32 b)
-{
-	u32 ret;
-
-	ret = a * b / gcd(a, b);
-
-	return ret;
-}
-
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 /**
  * nldr_find_addr() - Find the closest symbol to the given address based on
-- 
1.5.4.5

