Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0ICKiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:38:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:35754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab0ICKbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:22 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 37/41] fat: do not send discards as barriers
Date: Fri,  3 Sep 2010 12:29:52 +0200
Message-Id: <1283509796-1510-38-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

fat already uses synchronous discards, no need to add I/O barriers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fat/fatent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 3a56a82..f9a0b7a 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -579,7 +579,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 					fat_clus_to_blknr(sbi, first_cl),
 					nr_clus * sbi->sec_per_clus,
 					GFP_NOFS,
-					BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+					BLKDEV_IFL_WAIT);
 
 				first_cl = cluster;
 			}
-- 
1.7.1

