Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1GYMiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:38:14 -0400
Received: from ozlabs.org ([203.10.76.45]:49632 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1GYMha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:37:30 -0400
X-Mailbox-Line: From anton@samba.org Mon Jul 25 12:34:26 2011
Message-Id: <20110725023426.408998418@samba.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 12:33:16 +1000
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, peterz@infradead.org, benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] powerpc/numa: Remove duplicate RECLAIM_DISTANCE definition
References: <20110725023311.175792493@samba.org>
Content-Disposition: inline; filename=move_duplicate_distance
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have two identical definitions of RECLAIM_DISTANCE, looks like
the patch got applied twice. Remove one.

Signed-off-by: Anton Blanchard <anton@samba.org> 
---

Index: linux-2.6-work/arch/powerpc/include/asm/topology.h
===================================================================
--- linux-2.6-work.orig/arch/powerpc/include/asm/topology.h	2011-07-25 12:15:33.059921510 +1000
+++ linux-2.6-work/arch/powerpc/include/asm/topology.h	2011-07-25 12:15:46.750174446 +1000
@@ -19,16 +19,6 @@ struct device_node;
 #define RECLAIM_DISTANCE 10
 
 /*
- * Before going off node we want the VM to try and reclaim from the local
- * node. It does this if the remote distance is larger than RECLAIM_DISTANCE.
- * With the default REMOTE_DISTANCE of 20 and the default RECLAIM_DISTANCE of
- * 20, we never reclaim and go off node straight away.
- *
- * To fix this we choose a smaller value of RECLAIM_DISTANCE.
- */
-#define RECLAIM_DISTANCE 10
-
-/*
  * Avoid creating an extra level of balancing (SD_ALLNODES) on the largest
  * POWER7 boxes which have a maximum of 32 nodes.
  */


