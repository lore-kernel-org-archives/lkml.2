Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0H0RR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:17:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:41791 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0H0RRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:17:22 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com,
        j-nomura@ce.jp.nec.com, jamie@shareable.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, hch@lst.de
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] block: remove the WRITE_BARRIER flag
Date: Fri, 27 Aug 2010 19:11:00 +0200
Message-Id: <1282929060-23663-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282929060-23663-1-git-send-email-tj@kernel.org>
References: <1282929060-23663-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 27 Aug 2010 17:16:59 +0000 (UTC)
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
index 32703a9..6b0f6e9 100644
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

