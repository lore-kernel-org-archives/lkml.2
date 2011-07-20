Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab1GTDch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 23:32:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63131 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1GTDcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 23:32:36 -0400
Subject: [PATCH] dmaengine: use DEFINE_IDR for static initialization
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 11:32:28 +0800
Message-ID: <1311132748.27093.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could use DEFINE_IDR for statically allocated idr
that allow us to save a few lines of code.

And also remove unneeded mutex_init() for dma_list_mutex, as
dma_list_mutex is initialized automatically by DEFINE_MUTEX().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/dma/dmaengine.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 26374b2..b48967b 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -62,9 +62,9 @@
 #include <linux/slab.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
+static DEFINE_IDR(dma_idr);
 static LIST_HEAD(dma_device_list);
 static long dmaengine_ref_count;
-static struct idr dma_idr;
 
 /* --- sysfs implementation --- */
 
@@ -1050,8 +1050,6 @@ EXPORT_SYMBOL_GPL(dma_run_dependencies);
 
 static int __init dma_bus_init(void)
 {
-	idr_init(&dma_idr);
-	mutex_init(&dma_list_mutex);
 	return class_register(&dma_devclass);
 }
 arch_initcall(dma_bus_init);
-- 
1.7.4.1



