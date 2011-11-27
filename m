Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab1K0Flk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:41:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab1K0FfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:35:18 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org
Subject: [PATCH 33/62] exofs: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:13 +0800
Message-Id: <1322371662-26166-34-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/exofs/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
index d0941c6..b757a6e 100644
--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -597,7 +597,7 @@ int exofs_make_empty(struct inode *inode, struct inode *parent)
 		goto fail;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	de = (struct exofs_dir_entry *)kaddr;
 	de->name_len = 1;
 	de->rec_len = cpu_to_le16(EXOFS_DIR_REC_LEN(1));
@@ -611,7 +611,7 @@ int exofs_make_empty(struct inode *inode, struct inode *parent)
 	de->inode_no = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, PARENT_DIR, sizeof(PARENT_DIR));
 	exofs_set_de_type(de, inode);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	err = exofs_commit_chunk(page, 0, chunk_size);
 fail:
 	page_cache_release(page);
-- 
1.7.4.4

