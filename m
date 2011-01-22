Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1AVBSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:18:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:45820 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab1AVBRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:17:44 -0500
From: Jens Axboe <jaxboe@fusionio.com>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org
Cc: hch@infradead.org
Subject: [PATCH 08/10] read-ahead: use plugging
Date: Sat, 22 Jan 2011 01:17:27 +0000
Message-Id: <1295659049-2688-9-git-send-email-jaxboe@fusionio.com>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 01:17:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 mm/readahead.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index cbddc3e..2c0cc48 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -109,9 +109,12 @@ EXPORT_SYMBOL(read_cache_pages);
 static int read_pages(struct address_space *mapping, struct file *filp,
 		struct list_head *pages, unsigned nr_pages)
 {
+	struct blk_plug plug;
 	unsigned page_idx;
 	int ret;
 
+	blk_start_plug(&plug);
+
 	if (mapping->a_ops->readpages) {
 		ret = mapping->a_ops->readpages(filp, mapping, pages, nr_pages);
 		/* Clean up the remaining pages */
@@ -129,7 +132,10 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 		page_cache_release(page);
 	}
 	ret = 0;
+
 out:
+	blk_finish_plug(&plug);
+
 	return ret;
 }
 
-- 
1.7.3.2.146.gca209

