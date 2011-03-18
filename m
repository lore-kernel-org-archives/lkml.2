Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1CRAdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 20:33:16 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56475 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1CRAcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 20:32:46 -0400
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] of/flattree: minor cleanups
Date: Thu, 17 Mar 2011 17:32:35 -0700
Message-Id: <1300408356-15253-4-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300408356-15253-1-git-send-email-dilinger@queued.net>
References: <1300408356-15253-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - static-ize some functions
 - add some additional comments

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/fdt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index af824e7..c9db49c 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -139,12 +139,13 @@ static void *unflatten_dt_alloc(unsigned long *mem, unsigned long size,
 /**
  * unflatten_dt_node - Alloc and populate a device_node from the flat tree
  * @blob: The parent device tree blob
+ * @mem: Memory chunk to use for allocating device nodes and properties
  * @p: pointer to node in flat tree
  * @dad: Parent struct device_node
  * @allnextpp: pointer to ->allnext from last allocated device_node
  * @fpsize: Size of the node path up at the current depth.
  */
-unsigned long unflatten_dt_node(struct boot_param_header *blob,
+static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 				unsigned long mem,
 				unsigned long *p,
 				struct device_node *dad,
@@ -230,6 +231,7 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
 		}
 		kref_init(&np->kref);
 	}
+	/* process properties */
 	while (1) {
 		u32 sz, noff;
 		char *pname;
@@ -351,7 +353,7 @@ unsigned long unflatten_dt_node(struct boot_param_header *blob,
  * @dt_alloc: An allocator that provides a virtual address to memory
  * for the resulting tree
  */
-void __unflatten_device_tree(struct boot_param_header *blob,
+static void __unflatten_device_tree(struct boot_param_header *blob,
 			     struct device_node **mynodes,
 			     void * (*dt_alloc)(u64 size, u64 align))
 {
-- 
1.7.2.3

