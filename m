Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0D1QRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:17:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40652 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0D1QR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:17:28 -0400
Message-Id: <20100428161705.995898265@szeredi.hu>
References: <20100428161636.272097923@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 28 Apr 2010 18:16:37 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [RFC PATCH 1/6] mm: export lru_cache_add_*() to modules
Content-Disposition: inline; filename=export-lru_cache_add.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to enable moving pages into the page cache in fuse with
splice(..., SPLICE_F_MOVE).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 mm/swap.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c	2010-04-26 11:33:57.000000000 +0200
+++ linux-2.6/mm/swap.c	2010-04-28 15:50:28.000000000 +0200
@@ -224,6 +224,7 @@ void __lru_cache_add(struct page *page,
 		____pagevec_lru_add(pvec, lru);
 	put_cpu_var(lru_add_pvecs);
 }
+EXPORT_SYMBOL(__lru_cache_add);
 
 /**
  * lru_cache_add_lru - add a page to a page list

-- 
