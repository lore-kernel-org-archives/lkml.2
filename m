Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab2BJFqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:46:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932527Ab2BJFqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:46:02 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: [PATCH 35/60] jbd: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:39:56 +0800
Message-Id: <1328852421-19678-36-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/jbd/journal.c     |   12 ++++++------
 fs/jbd/transaction.c |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 59c09f9..e49e81b 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -328,7 +328,7 @@ repeat:
 		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
 	}
 
-	mapped_data = kmap_atomic(new_page, KM_USER0);
+	mapped_data = kmap_atomic(new_page);
 	/*
 	 * Check for escaping
 	 */
@@ -337,7 +337,7 @@ repeat:
 		need_copy_out = 1;
 		do_escape = 1;
 	}
-	kunmap_atomic(mapped_data, KM_USER0);
+	kunmap_atomic(mapped_data);
 
 	/*
 	 * Do we need to do a data copy?
@@ -354,9 +354,9 @@ repeat:
 		}
 
 		jh_in->b_frozen_data = tmp;
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic(new_page);
 		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);
-		kunmap_atomic(mapped_data, KM_USER0);
+		kunmap_atomic(mapped_data);
 
 		new_page = virt_to_page(tmp);
 		new_offset = offset_in_page(tmp);
@@ -368,9 +368,9 @@ repeat:
 	 * copying, we can finally do so.
 	 */
 	if (do_escape) {
-		mapped_data = kmap_atomic(new_page, KM_USER0);
+		mapped_data = kmap_atomic(new_page);
 		*((unsigned int *)(mapped_data + new_offset)) = 0;
-		kunmap_atomic(mapped_data, KM_USER0);
+		kunmap_atomic(mapped_data);
 	}
 
 	set_bh_page(new_bh, new_page, new_offset);
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 7fce94b..b2a7e52 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -718,9 +718,9 @@ done:
 			    "Possible IO failure.\n");
 		page = jh2bh(jh)->b_page;
 		offset = offset_in_page(jh2bh(jh)->b_data);
-		source = kmap_atomic(page, KM_USER0);
+		source = kmap_atomic(page);
 		memcpy(jh->b_frozen_data, source+offset, jh2bh(jh)->b_size);
-		kunmap_atomic(source, KM_USER0);
+		kunmap_atomic(source);
 	}
 	jbd_unlock_bh_state(bh);
 
-- 
1.7.7.6

