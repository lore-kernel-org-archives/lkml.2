Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762281Ab0HGMaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 08:30:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:32935 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0HGMaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 08:30:15 -0400
Message-ID: <4C5D51A2.8030306@kernel.org>
Date: Sat, 07 Aug 2010 14:29:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
CC: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] slub: add missing __percpu markup in mm/slub_def.h
References: <1281119187-12640-4-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281119187-12640-4-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 12:29:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

kmem_cache->cpu_slab is a percpu pointer but was missing __percpu
markup.  Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
Christoph, Pekka, can you please route this through slab tree?

Thanks.

 include/linux/slub_def.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: percpu/include/linux/slub_def.h
===================================================================
--- percpu.orig/include/linux/slub_def.h
+++ percpu/include/linux/slub_def.h
@@ -68,7 +68,7 @@ struct kmem_cache_order_objects {
  * Slab cache management.
  */
 struct kmem_cache {
-	struct kmem_cache_cpu *cpu_slab;
+	struct kmem_cache_cpu __percpu *cpu_slab;
 	/* Used for retriving partial slabs etc */
 	unsigned long flags;
 	int size;		/* The size of an object including meta data */
