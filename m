Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab0D1QRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:17:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40632 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab0D1QRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:17:15 -0400
Message-Id: <20100428161708.365052108@szeredi.hu>
References: <20100428161636.272097923@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 28 Apr 2010 18:16:38 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [RFC PATCH 2/6] mm: export remove_from_page_cache() to modules
Content-Disposition: inline; filename=export-remove_from_page_cache.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to enable moving pages into the page cache in fuse with
splice(..., SPLICE_F_MOVE).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 mm/filemap.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2010-04-26 11:33:57.000000000 +0200
+++ linux-2.6/mm/filemap.c	2010-04-28 15:50:30.000000000 +0200
@@ -151,6 +151,7 @@ void remove_from_page_cache(struct page
 	spin_unlock_irq(&mapping->tree_lock);
 	mem_cgroup_uncharge_cache_page(page);
 }
+EXPORT_SYMBOL(remove_from_page_cache);
 
 static int sync_page(void *word)
 {

-- 
