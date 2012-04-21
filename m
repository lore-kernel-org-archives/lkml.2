Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2DUFuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 01:50:39 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57493 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab2DUFty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 01:49:54 -0400
Subject: [PATCH] fs: fix integer overflow in MS_NOUSER definition
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Date: Sat, 21 Apr 2012 09:49:49 +0400
Message-ID: <20120421054949.32549.2823.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MS_NOUSER defined as signed int (1<<31), sb->s_flags declared as unsigned long.
So (sb->s_flags & MS_NOUSER) works as (sb->s_flags & 0xffffffff80000000).

Other potential bugs: git grep -w -e '1\s*<<\s*31'

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6b71bd6..903bf00 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -217,7 +217,7 @@ struct inodes_stat_t {
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
-#define MS_NOUSER	(1<<31)
+#define MS_NOUSER	(1u<<31)
 
 /*
  * Superblock flags that can be altered by MS_REMOUNT

