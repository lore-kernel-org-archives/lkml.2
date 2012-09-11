Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab2IKTtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:49:41 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:57401 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab2IKTtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:49:40 -0400
Date: Tue, 11 Sep 2012 19:49:38 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (slab
 tree related)
In-Reply-To: <20120911161923.10299045655dd4c84f96f4b3@canb.auug.org.au>
Message-ID: <00000139b6e13c92-97adf129-be2c-4b74-9559-0a92c10b9eda-000000@email.amazonses.com>
References: <20120911161923.10299045655dd4c84f96f4b3@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, Stephen Rothwell wrote:

> After merging the final tree, today's linux-next build (sparc64 defconfig)
> produced this warning:
>
> mm/slab.c:808:13: warning: '__slab_error' defined but not used [-Wunused-function]
>
> Introduced by commit 945cf2b6199b ("mm/sl[aou]b: Extract a common function for kmem_cache_destroy").  All uses of slab_error() are now guarded by DEBUG.


Subject: Slab: Only define slab_error for DEBUG

There is no use case left for slab builds without DEBUG.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slab.c
===================================================================
--- linux.orig/mm/slab.c	2012-09-11 14:44:56.304015235 -0500
+++ linux/mm/slab.c	2012-09-11 14:48:46.988948440 -0500
@@ -803,6 +803,7 @@ static void cache_estimate(unsigned long
 	*left_over = slab_size - nr_objs*buffer_size - mgmt_size;
 }

+#if DEBUG
 #define slab_error(cachep, msg) __slab_error(__func__, cachep, msg)

 static void __slab_error(const char *function, struct kmem_cache *cachep,
@@ -812,6 +813,7 @@ static void __slab_error(const char *fun
 	       function, cachep->name, msg);
 	dump_stack();
 }
+#endif

 /*
  * By default on NUMA we use alien caches to stage the freeing of
