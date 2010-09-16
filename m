Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0IPWO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983Ab0IPWOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:23 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 11/34] union-mount: Add union_find_dir()
Date: Thu, 16 Sep 2010 15:12:02 -0700
Message-Id: <1284675145-4391-12-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

union_find_dir() returns the path of the directory at the specified
layer in a unioned directory.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/union.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/union.h b/fs/union.h
index 38b26fd..e242451 100644
--- a/fs/union.h
+++ b/fs/union.h
@@ -49,6 +49,16 @@ struct union_stack {
 	struct path u_dirs[0];
 };
 
+static inline struct path *union_find_dir(struct dentry *dentry,
+					  unsigned int layer) {
+	BUG_ON(layer >= dentry->d_sb->s_union_count);
+	return &(dentry->d_union_stack->u_dirs[layer]);
+}
+
+#else /* CONFIG_UNION_MOUNT */
+
+#define union_find_dir(x, y)		({ BUG(); (NULL); })
+
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
 #endif	/* __LINUX_UNION_H */
-- 
1.6.3.3

