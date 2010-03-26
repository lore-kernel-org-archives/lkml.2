Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab0CZHYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 03:24:06 -0400
Received: from av9-2-sn2.hy.skanova.net ([81.228.8.180]:52917 "EHLO
	av9-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0CZHYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 03:24:03 -0400
Subject: [PATCH] dma: timb-dma: Update comment and fix compiler warning
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "Dan J <dan.j.williams"@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 08:23:58 +0100
Message-ID: <1269588238.26867.8.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An incremental patch which clarifies what the spinlock is used for
and fixes a compiler warning.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 4dd7102..145f1c2 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -79,7 +79,10 @@ struct timb_dma_desc {
 struct timb_dma_chan {
 	struct dma_chan		chan;
 	void __iomem		*membase;
-	spinlock_t		lock; /* Used for mutual exclusion */
+	spinlock_t		lock; /* Used to protect data structures,
+					especially the lists and descriptors,
+					from races between the tasklet and calls
+					from above */
 	dma_cookie_t		last_completed_cookie;
 	bool			ongoing;
 	struct list_head	active_list;
@@ -197,7 +200,7 @@ static int td_fill_desc(struct timb_dma_chan *td_chan, u8 *dma_desc,
 	}
 
 	dev_dbg(chan2dev(&td_chan->chan), "desc: %p, addr: %p\n",
-		dma_desc, (void *)(int)sg_dma_address(sg));
+		dma_desc, (void *)sg_dma_address(sg));
 
 	dma_desc[7] = (sg_dma_address(sg) >> 24) & 0xff;
 	dma_desc[6] = (sg_dma_address(sg) >> 16) & 0xff;



