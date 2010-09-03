Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab0ICKhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:37:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:35773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab0ICKbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:24 -0400
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
Subject: [PATCH 39/41] block: remove the WRITE_BARRIER flag
Date: Fri,  3 Sep 2010 12:29:54 +0200
Message-Id: <1283509796-1510-40-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

It's unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/fs.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 352c486..d6add69 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -135,7 +135,6 @@ struct inodes_stat_t {
  *			immediately after submission. The write equivalent
  *			of READ_SYNC.
  * WRITE_ODIRECT_PLUG	Special case write for O_DIRECT only.
- * WRITE_BARRIER	DEPRECATED. Always fails. Use FLUSH/FUA instead.
  * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
  * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
  *			non-volatile media on completion.
@@ -157,8 +156,6 @@ struct inodes_stat_t {
 #define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG)
 #define WRITE_ODIRECT_PLUG	(WRITE | REQ_SYNC)
 #define WRITE_META		(WRITE | REQ_META)
-#define WRITE_BARRIER		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-				 REQ_HARDBARRIER)
 #define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
 				 REQ_FLUSH)
 #define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-- 
1.7.1

