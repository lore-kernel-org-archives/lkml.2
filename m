Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2BJFqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 00:46:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577Ab2BJFqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 00:46:51 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Cong Wang <amwang@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 46/60] udf: remove the second argument of k[un]map_atomic()
Date: Fri, 10 Feb 2012 13:40:07 +0800
Message-Id: <1328852421-19678-47-git-send-email-amwang@redhat.com>
In-Reply-To: <1328852421-19678-1-git-send-email-amwang@redhat.com>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/udf/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index dca0c38..c088507 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -87,10 +87,10 @@ static int udf_adinicb_write_end(struct file *file,
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + offset,
 		kaddr + offset, copied);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
 }
-- 
1.7.7.6

