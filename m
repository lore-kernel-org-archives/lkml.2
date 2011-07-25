Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1GYMhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:37:47 -0400
Received: from ozlabs.org ([203.10.76.45]:46738 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1GYMhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:37:25 -0400
X-Mailbox-Line: From anton@samba.org Mon Jul 25 12:34:26 2011
Message-Id: <20110725023426.218116288@samba.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 12:33:14 +1000
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, peterz@infradead.org, benh@kernel.crashing.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] powerpc/numa: Increase SD_NODES_PER_DOMAIN to 32.
References: <20110725023311.175792493@samba.org>
Content-Disposition: inline; filename=override_SD_NODES_PER_DOMAIN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The largest POWER7 boxes have 32 nodes. SD_NODES_PER_DOMAIN groups
nodes into chunks of 16 and adds a global balancing domain
(SD_ALLNODES) above it.

If we bump SD_NODES_PER_DOMAIN to 32, then we avoid this extra
level of balancing on our largest boxes.

Signed-off-by: Anton Blanchard <anton@samba.org> 
---

Index: linux-2.6-work/arch/powerpc/include/asm/topology.h
===================================================================
--- linux-2.6-work.orig/arch/powerpc/include/asm/topology.h	2011-07-25 11:43:24.954093179 +1000
+++ linux-2.6-work/arch/powerpc/include/asm/topology.h	2011-07-25 11:43:31.274205122 +1000
@@ -28,6 +28,12 @@ struct device_node;
  */
 #define RECLAIM_DISTANCE 10
 
+/*
+ * Avoid creating an extra level of balancing (SD_ALLNODES) on the largest
+ * POWER7 boxes which have a maximum of 32 nodes.
+ */
+#define SD_NODES_PER_DOMAIN 32
+
 #include <asm/mmzone.h>
 
 static inline int cpu_to_node(int cpu)


