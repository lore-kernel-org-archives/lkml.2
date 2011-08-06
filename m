Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab1HFJbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 05:31:24 -0400
Received: from www17.your-server.de ([213.133.104.17]:40408 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab1HFJbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 05:31:22 -0400
Subject: [PATCH] i2o: use kstrdup()
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 06 Aug 2011 11:30:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312623053.5589.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kstrdup rather than duplicating its implementation

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/kstrdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/message/i2o/memory.c b/drivers/message/i2o/memory.c
--- a/drivers/message/i2o/memory.c 2010-03-27 23:39:49.118521162 +0100
+++ b/drivers/message/i2o/memory.c 2011-08-01 21:02:30.929472234 +0200
@@ -270,10 +270,9 @@ EXPORT_SYMBOL_GPL(i2o_dma_realloc);
 int i2o_pool_alloc(struct i2o_pool *pool, const char *name,
 				 size_t size, int min_nr)
 {
-	pool->name = kmalloc(strlen(name) + 1, GFP_KERNEL);
+	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
 		goto exit;
-	strcpy(pool->name, name);
 
 	pool->slab =
 	    kmem_cache_create(pool->name, size, 0, SLAB_HWCACHE_ALIGN, NULL);


