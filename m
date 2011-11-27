Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1K0Fhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:37:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528Ab1K0Fhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:37:35 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 48/62] udf: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:28 +0800
Message-Id: <1322371662-26166-49-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/udf/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index d8ffa7c..95b8d91 100644
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
1.7.4.4

