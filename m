Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab2LOLDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 06:03:55 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57238 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab2LOLDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 06:03:53 -0500
Message-ID: <50CC577F.90900@gmail.com>
Date: Sat, 15 Dec 2012 11:57:03 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Petr Vandrovec <petr@vandrovec.name>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 16/21] ncpfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/ncpfs/inode.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index d7e9fe7..1acdad7 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -976,9 +976,7 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
 			goto out;
 
 		if (attr->ia_size != i_size_read(inode)) {
-			result = vmtruncate(inode, attr->ia_size);
-			if (result)
-				goto out;
+			truncate_setsize(inode, attr->ia_size);
 			mark_inode_dirty(inode);
 		}
 	}
-- 
1.7.3.4
