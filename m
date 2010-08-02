Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0HBJuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:50:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab0HBJtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:49:13 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] GFS2: Use nobh_writepage
Date: Mon,  2 Aug 2010 10:27:52 +0100
Message-Id: <1280741279-6782-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
References: <1280741279-6782-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use nobh_writepage rather than calling mpage_writepage directly.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 9f8b525..9485a88 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -136,10 +136,7 @@ static int gfs2_writeback_writepage(struct page *page,
 	if (ret <= 0)
 		return ret;
 
-	ret = mpage_writepage(page, gfs2_get_block_noalloc, wbc);
-	if (ret == -EAGAIN)
-		ret = block_write_full_page(page, gfs2_get_block_noalloc, wbc);
-	return ret;
+	return nobh_writepage(page, gfs2_get_block_noalloc, wbc);
 }
 
 /**
-- 
1.7.1.1

