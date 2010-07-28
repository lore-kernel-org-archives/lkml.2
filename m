Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0G1OvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:51:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42973 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab0G1OvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:51:23 -0400
From: Ernesto Ramos <ernesto@ti.com>
To: gregkh@suse.de
Cc: omar.ramirez@ti.com, ohad@wizery.com, ameya.palande@nokia.com,
        felipe.contreras@nokia.com, fernando.lugo@ti.com,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, nm@ti.com,
        linux-omap@vger.kernel.org, Ernesto Ramos <ernesto@ti.com>
Subject: [PATCH] staging:ti dspbridge: remove find_gcf from nldr.c
Date: Wed, 28 Jul 2010 09:56:01 -0500
Message-Id: <1280328961-31409-1-git-send-email-ernesto@ti.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove find_gcf from nldr.c and use kernel function
gcd().

Signed-off-by: Ernesto Ramos <ernesto@ti.com>
---
 drivers/staging/tidspbridge/rmgr/nldr.c |   20 ++------------------
 1 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/tidspbridge/rmgr/nldr.c b/drivers/staging/tidspbridge/rmgr/nldr.c
index 23b44cf..f01bddd 100644
--- a/drivers/staging/tidspbridge/rmgr/nldr.c
+++ b/drivers/staging/tidspbridge/rmgr/nldr.c
@@ -35,6 +35,7 @@
 #include <dspbridge/uuidutil.h>
 
 #include <dspbridge/nldr.h>
+#include <linux/gcd.h>
 
 /* Name of section containing dynamic load mem */
 #define DYNMEMSECT  ".dspbridge_mem"
@@ -304,7 +305,6 @@ static void unload_ovly(struct nldr_nodeobject *nldr_node_obj,
 static bool find_in_persistent_lib_array(struct nldr_nodeobject *nldr_node_obj,
 					 struct dbll_library_obj *lib);
 static u32 find_lcm(u32 a, u32 b);
-static u32 find_gcf(u32 a, u32 b);
 
 /*
  *  ======== nldr_allocate ========
@@ -1889,27 +1889,11 @@ static u32 find_lcm(u32 a, u32 b)
 {
 	u32 ret;
 
-	ret = a * b / find_gcf(a, b);
+	ret = a * b / gcd(a, b);
 
 	return ret;
 }
 
-/*
- * ================ Find GCF (Greatest Common Factor ) ===
- */
-static u32 find_gcf(u32 a, u32 b)
-{
-	u32 c;
-
-	/* Get the GCF (Greatest common factor between the numbers,
-	 * using Euclidian Algo */
-	while ((c = (a % b))) {
-		a = b;
-		b = c;
-	}
-	return b;
-}
-
 #ifdef CONFIG_TIDSPBRIDGE_BACKTRACE
 /**
  * nldr_find_addr() - Find the closest symbol to the given address based on
-- 
1.5.4.5

