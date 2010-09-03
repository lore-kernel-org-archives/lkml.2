Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab0ICKoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:44:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:35580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756763Ab0ICKbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:02 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/41] block: initialize flush request with WRITE_FLUSH instead of REQ_FLUSH
Date: Fri,  3 Sep 2010 12:29:28 +0200
Message-Id: <1283509796-1510-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_flush_request() only set REQ_FLUSH when initializing flush
requests making them READ requests.  Use WRITE_FLUSH instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-flush.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 72905f8..f357f1f 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -77,7 +77,7 @@ static void post_flush_end_io(struct request *rq, int error)
 static void init_flush_request(struct request *rq, struct gendisk *disk)
 {
 	rq->cmd_type = REQ_TYPE_FS;
-	rq->cmd_flags = REQ_FLUSH;
+	rq->cmd_flags = WRITE_FLUSH;
 	rq->rq_disk = disk;
 }
 
-- 
1.7.1

