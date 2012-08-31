Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2HaOGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:06:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44892 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2HaOGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:06:30 -0400
Message-ID: <5040C359.1030303@gmail.com>
Date: Fri, 31 Aug 2012 15:59:53 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/21] hostfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/hostfs/hostfs_kern.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 1241465..36f5a62 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -848,9 +848,11 @@ int hostfs_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_size != i_size_read(inode)) {
 		int error;
 
-		error = vmtruncate(inode, attr->ia_size);
-		if (err)
-			return err;
+		error = inode_newsize_ok(inode, attr->ia_size);
+		if (error)
+			return error;
+
+		truncate_setsize(inode, attr->ia_size);
 	}
 
 	setattr_copy(inode, attr);
-- 
1.7.3.4
