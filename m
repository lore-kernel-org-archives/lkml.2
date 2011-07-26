Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1GZCk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 22:40:28 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:62391 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219Ab1GZCkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 22:40:21 -0400
Date: Tue, 26 Jul 2011 03:40:45 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: Exporting: update description of
 d_splice_alias
Message-ID: <4e2e292d.simGZB2oLp++vx9O%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following commits a904937 and 0c1aa9a update the d_splice_alias
desciption.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 Documentation/filesystems/nfs/Exporting |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/nfs/Exporting b/Documentation/filesystems/nfs/Exporting
index 87019d2..09994c2 100644
--- a/Documentation/filesystems/nfs/Exporting
+++ b/Documentation/filesystems/nfs/Exporting
@@ -92,7 +92,14 @@ For a filesystem to be exportable it must:
    1/ provide the filehandle fragment routines described below.
    2/ make sure that d_splice_alias is used rather than d_add
       when ->lookup finds an inode for a given parent and name.
-      Typically the ->lookup routine will end with a:
+
+      If inode is NULL, d_splice_alias(inode, dentry) is eqivalent to
+
+		d_add(dentry, inode), NULL
+
+      Similarly, d_splice_alias(ERR_PTR(err), dentry) = ERR_PTR(err)
+
+      Typically the ->lookup routine will simply end with a:
 
 		return d_splice_alias(inode, dentry);
 	}
-- 
1.7.1

