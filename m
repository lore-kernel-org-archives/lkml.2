Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935711Ab1ETTN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:13:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37031 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935691Ab1ETTN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:13:26 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com> (commit_signer:24/34=71%),
        Christoph Hellwig <hch@lst.de> (commit_signer:15/34=44%),
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com> (commit_signer:14/34=41%),
        Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/34=12%),
        Dave Chinner <dchinner@redhat.com> (commit_signer:3/34=9%),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Subject: [PATCH 1/8] mm: Kill set but not used var in  bdi_debug_stats_show()
Date: Fri, 20 May 2011 16:12:58 -0300
Message-Id: <1305918786-7239-1-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 mm/backing-dev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index befc875..f032e6e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -63,10 +63,10 @@ static int bdi_debug_stats_show(struct seq_file *m, void *v)
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
-	unsigned long nr_dirty, nr_io, nr_more_io, nr_wb;
+	unsigned long nr_dirty, nr_io, nr_more_io;
 	struct inode *inode;
 
-	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
+	nr_dirty = nr_io = nr_more_io = 0;
 	spin_lock(&inode_wb_list_lock);
 	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
 		nr_dirty++;
-- 
1.7.5.1

