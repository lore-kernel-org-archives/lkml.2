Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0HZNWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:22:38 -0400
Received: from relay2.sgi.com ([192.48.179.30]:38424 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752069Ab0HZNV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:27 -0400
Message-Id: <20100826132125.022534356@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:19:50 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 13/25] GRU - delete obsolete debug code
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_delete_debug_config_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

SGI UV driver. Delete some debug code that has outlived it's usefullness.
The code is not part of a supported API

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grufile.c |   25 -------------------------
 drivers/misc/sgi-gru/grulib.h  |    3 ---
 2 files changed, 28 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c	2010-06-09 08:11:43.712036004 -0500
+++ linux/drivers/misc/sgi-gru/grufile.c	2010-06-09 08:11:44.973081222 -0500
@@ -166,28 +166,6 @@ static int gru_create_new_context(unsign
 	return ret;
 }
 
-/*
- * Get GRU configuration info (temp - for emulator testing)
- */
-static long gru_get_config_info(unsigned long arg)
-{
-	struct gru_config_info info;
-	int nodesperblade;
-
-	if (num_online_nodes() > 1 &&
-			(uv_node_to_blade_id(1) == uv_node_to_blade_id(0)))
-		nodesperblade = 2;
-	else
-		nodesperblade = 1;
-	info.cpus = num_online_cpus();
-	info.nodes = num_online_nodes();
-	info.blades = info.nodes / nodesperblade;
-	info.chiplets = GRU_CHIPLETS_PER_BLADE * info.blades;
-
-	if (copy_to_user((void __user *)arg, &info, sizeof(info)))
-		return -EFAULT;
-	return 0;
-}
 
 /*
  * gru_file_unlocked_ioctl
@@ -226,9 +204,6 @@ static long gru_file_unlocked_ioctl(stru
 	case GRU_KTEST:
 		err = gru_ktest(arg);
 		break;
-	case GRU_GET_CONFIG_INFO:
-		err = gru_get_config_info(arg);
-		break;
 	case GRU_DUMP_CHIPLET_STATE:
 		err = gru_dump_chiplet_request(arg);
 		break;
Index: linux/drivers/misc/sgi-gru/grulib.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grulib.h	2010-06-09 08:11:41.655538228 -0500
+++ linux/drivers/misc/sgi-gru/grulib.h	2010-06-09 08:11:44.973081222 -0500
@@ -53,9 +53,6 @@
 /* For user TLB flushing (primarily for tests) */
 #define GRU_USER_FLUSH_TLB		_IOWR(GRU_IOCTL_NUM, 50, void *)
 
-/* Get some config options (primarily for tests & emulator) */
-#define GRU_GET_CONFIG_INFO		_IOWR(GRU_IOCTL_NUM, 51, void *)
-
 /* Various kernel self-tests */
 #define GRU_KTEST			_IOWR(GRU_IOCTL_NUM, 52, void *)
 

