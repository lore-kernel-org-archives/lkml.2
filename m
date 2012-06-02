Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966606Ab2FBNmR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 09:42:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61911 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965393Ab2FBNlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 09:41:11 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com
Subject: [PATCH v2 07/10] ocfs2: use memweight()
Date: Sat,  2 Jun 2012 22:40:13 +0900
Message-Id: <1338644416-11417-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memweight to count the total number of bits set in memory area.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@oss.oracle.com
---

No changes from v1

 fs/ocfs2/localalloc.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 210c352..a9f78c7 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -784,14 +784,10 @@ bail:
 
 static u32 ocfs2_local_alloc_count_bits(struct ocfs2_dinode *alloc)
 {
-	int i;
-	u8 *buffer;
-	u32 count = 0;
+	u32 count;
 	struct ocfs2_local_alloc *la = OCFS2_LOCAL_ALLOC(alloc);
 
-	buffer = la->la_bitmap;
-	for (i = 0; i < le16_to_cpu(la->la_size); i++)
-		count += hweight8(buffer[i]);
+	count = memweight(la->la_bitmap, le16_to_cpu(la->la_size));
 
 	trace_ocfs2_local_alloc_count_bits(count);
 	return count;
-- 
1.7.7.6

