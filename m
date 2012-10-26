Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab2JZPvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:51:07 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23820 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933818Ab2JZPvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:51:04 -0400
Subject: [PATCH 09/12] mm: minor cleanup of iov_iter_single_seg_count()
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 26 Oct 2012 19:50:04 +0400
Message-ID: <20121026154938.18931.46351.stgit@maximpc.sw.ru>
In-Reply-To: <20121026152957.18931.46330.stgit@maximpc.sw.ru>
References: <20121026152957.18931.46330.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function does not modify iov_iter which 'i' points to.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 include/linux/fs.h |    2 +-
 mm/filemap.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..8967baa 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -300,7 +300,7 @@ size_t iov_iter_copy_from_user(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
-size_t iov_iter_single_seg_count(struct iov_iter *i);
+size_t iov_iter_single_seg_count(const struct iov_iter *i);
 
 static inline void iov_iter_init(struct iov_iter *i,
 			const struct iovec *iov, unsigned long nr_segs,
diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..24a7ea5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2056,7 +2056,7 @@ EXPORT_SYMBOL(iov_iter_fault_in_readable);
 /*
  * Return the count of just the current iov_iter segment.
  */
-size_t iov_iter_single_seg_count(struct iov_iter *i)
+size_t iov_iter_single_seg_count(const struct iov_iter *i)
 {
 	const struct iovec *iov = i->iov;
 	if (i->nr_segs == 1)

