Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab2HaOIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:08:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35361 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab2HaOIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:08:07 -0400
Message-ID: <5040C3B9.5050301@gmail.com>
Date: Fri, 31 Aug 2012 16:01:29 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Petr Vandrovec <petr@vandrovec.name>, Guenter Roeck <linux@roeck-us.net>,
        Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 17/21] ncpfs: drop vmtruncate
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
index 333df07..c1e73c3 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -971,9 +971,11 @@ int ncp_notify_change(struct dentry *dentry, struct iattr *attr)
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
