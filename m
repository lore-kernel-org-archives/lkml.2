Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0EQM6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab0EQM6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:12 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/11] GFS2: Eliminate useless err variable
Date: Mon, 17 May 2010 13:40:23 +0100
Message-Id: <1274100025-26629-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-9-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-5-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-6-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-7-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-8-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-9-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch removes an unneeded "err" variable that is always
returned as zero.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/meta_io.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index abafda1..18176d0 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -34,7 +34,6 @@
 
 static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wbc)
 {
-	int err;
 	struct buffer_head *bh, *head;
 	int nr_underway = 0;
 	int write_op = (1 << BIO_RW_META) | ((wbc->sync_mode == WB_SYNC_ALL ?
@@ -86,11 +85,10 @@ static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wb
 	} while (bh != head);
 	unlock_page(page);
 
-	err = 0;
 	if (nr_underway == 0)
 		end_page_writeback(page);
 
-	return err;
+	return 0;
 }
 
 const struct address_space_operations gfs2_meta_aops = {
-- 
1.6.2.5

