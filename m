Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1AVBR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:17:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:45823 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab1AVBRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:45 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH 10/10] fs: make aio plug
Date: Sat, 22 Jan 2011 01:17:29 +0000
Message-Id: <1295659049-2688-11-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 fs/aio.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index c5ea494..1476bed 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1660,6 +1660,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 	long ret = 0;
 	int i;
 	struct hlist_head batch_hash[AIO_BATCH_HASH_SIZE] = { { 0, }, };
+	struct blk_plug plug;
 
 	if (unlikely(nr < 0))
 		return -EINVAL;
@@ -1676,6 +1677,8 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 		return -EINVAL;
 	}
 
+	blk_start_plug(&plug);
+
 	/*
 	 * AKPM: should this return a partial result if some of the IOs were
 	 * successfully submitted?
@@ -1698,6 +1701,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 		if (ret)
 			break;
 	}
+	blk_finish_plug(&plug);
 	aio_batch_free(batch_hash);
 
 	put_ioctx(ctx);
-- 
1.7.3.2.146.gca209

