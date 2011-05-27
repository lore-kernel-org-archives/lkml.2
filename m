Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1E0M76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:59:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56263 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab1E0M74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:59:56 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 08:59:56 EDT
From: Andreas Gruenbacher <agruen@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: Improve the bio_add_page() and bio_add_pc_page() descriptions
Date: Fri, 27 May 2011 14:52:09 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.36-rc7+; KDE/4.3.5; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271452.09505.agruen@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The descriptions of bio_add_page() and bio_add_pc_page() are slightly
inconsistent; improve them.

Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>
---
 fs/bio.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 840a0d7..9bfade8 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -638,10 +638,11 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
  *	@offset: vec entry offset
  *
  *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block
- *	device limitations. The target block device must allow bio's
- *      smaller than PAGE_SIZE, so it is always possible to add a single
- *      page to an empty bio. This should only be used by REQ_PC bios.
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
+ *
+ *	This should only be used by REQ_PC bios.
  */
 int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
 		    unsigned int len, unsigned int offset)
@@ -659,10 +660,9 @@ EXPORT_SYMBOL(bio_add_pc_page);
  *	@offset: vec entry offset
  *
  *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block
- *	device limitations. The target block device must allow bio's
- *      smaller than PAGE_SIZE, so it is always possible to add a single
- *      page to an empty bio.
+ *	number of reasons, such as the bio being full or target block device
+ *	limitations. The target block device must allow bio's up to PAGE_SIZE,
+ *	so it is always possible to add a single page to an empty bio.
  */
 int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 		 unsigned int offset)
-- 
1.7.1
