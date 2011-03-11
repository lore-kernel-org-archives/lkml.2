Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab1CKF2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 00:28:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50224 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab1CKF2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 00:28:12 -0500
Date: Fri, 11 Mar 2011 16:28:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: linux-next: manual merge of the workqueues tree with the block tree
Message-Id: <20110311162805.ca739319.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
fs/aio.c between commit cf15900e1209 ("aio: remove request submission
batching") from the block tree and commit d37adaa15962 ("fs/aio: aio_wq
isn't used in memory reclaim path") from the workqueues tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/aio.c
index a936b7f,8007bd6..0000000
--- a/fs/aio.c
+++ b/fs/aio.c
@@@ -75,8 -85,9 +75,8 @@@ static int __init aio_setup(void
  	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
  	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
  
- 	aio_wq = create_workqueue("aio");
+ 	aio_wq = alloc_workqueue("aio", 0, 1);	/* used to limit concurrency */
 -	abe_pool = mempool_create_kmalloc_pool(1, sizeof(struct aio_batch_entry));
 -	BUG_ON(!aio_wq || !abe_pool);
 +	BUG_ON(!aio_wq);
  
  	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
  
