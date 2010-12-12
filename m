Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0LLXpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44566 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab0LLXpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:01 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jaxboe@fusionio.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [5/223] block: check for proper length of iov entries in blk_rq_map_user_iov()
Message-Id: <20101212234459.F3AFDB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:44:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jens Axboe <jaxboe@fusionio.com>

commit 9284bcf4e335e5f18a8bc7b26461c33ab60d0689 upstream.

Ensure that we pass down properly validated iov segments before
calling into the mapping or copy functions.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 block/blk-map.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/block/blk-map.c
===================================================================
--- linux.orig/block/blk-map.c
+++ linux/block/blk-map.c
@@ -205,6 +205,8 @@ int blk_rq_map_user_iov(struct request_q
 			unaligned = 1;
 			break;
 		}
+		if (!iov[i].iov_len)
+			return -EINVAL;
 	}
 
 	if (unaligned || (q->dma_pad_mask & len) || map_data)
