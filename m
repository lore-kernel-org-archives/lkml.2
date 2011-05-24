Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1EXNcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:32:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51602 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab1EXNcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WKp3yfO0pK5TiLjSS50sRhIYycATB+DJzsoejVy4KzOq6B3xDtJVzFE1uOdAsYf6hc
         od/Gwvpr0mciHAwbz68c0AvBzb6ZHy/vNTQ+x+SojiLtdTCRfOaHFDBHM3jCj87N5NLV
         HojjobWHsXD8SEJZ94pFMiLyXVUteUYPZKrM0=
Date: Tue, 24 May 2011 15:32:05 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] Delete unused variable no_wb.
Message-ID: <20110524133204.GA11529@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of writeback threads was removed from the output by c1955ce3.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
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
