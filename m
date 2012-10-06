Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2JFIjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:39:53 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56366 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2JFIjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:39:49 -0400
Message-ID: <506FECC4.1080907@gmail.com>
Date: Sat, 06 Oct 2012 10:33:08 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Petr Vandrovec <petr@vandrovec.name>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 17/22] ncpfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ncpfs/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index d7e9fe7..b6881aa 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -976,9 +976,11 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
 			goto out;
 
 		if (attr->ia_size != i_size_read(inode)) {
-			result = vmtruncate(inode, attr->ia_size);
+			result = inode_newsize_ok(inode, attr->ia_size);
 			if (result)
 				goto out;
+
+			truncate_setsize(inode, attr->ia_size);
 			mark_inode_dirty(inode);
 		}
 	}
-- 
1.7.3.4
