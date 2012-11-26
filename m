Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2KZRrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:47:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318Ab2KZRJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Zafman <david.zafman@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 148/270] ceph: fix dentry reference leak in encode_fh()
Date: Mon, 26 Nov 2012 14:57:18 -0200
Message-Id: <1353949160-26803-149-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Zafman <david.zafman@inktank.com>

commit 52eb5a900a9863a8b77a895f770e5d825c8e02c6 upstream.

Call to d_find_alias() needs a corresponding dput()

This fixes http://tracker.newdream.net/issues/3271

Signed-off-by: David Zafman <david.zafman@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ceph/export.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 02ce909..9349bb3 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -90,6 +90,8 @@ static int ceph_encode_fh(struct inode *inode, u32 *rawfh, int *max_len,
 		*max_len = handle_length;
 		type = 255;
 	}
+	if (dentry)
+		dput(dentry);
 	return type;
 }
 
-- 
1.7.9.5

