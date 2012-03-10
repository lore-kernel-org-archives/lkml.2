Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302Ab2CJDLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:11:39 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:60317 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab2CJDLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:11:37 -0500
Date: Sat, 10 Mar 2012 02:54:37 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/6] Squashfs: fix f_pos check in
 get_dir_index_using_offset
Message-ID: <4f5ac26d.cUNt6jDcU1/Q0PqV%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One off error in the f_pos check.  If f_pos is 3 or less don't
bother reading the index because we're at the start of the
directory, and we obviously already know where that is on disk.

This eliminates an unnecessary read.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/squashfs/dir.c b/fs/squashfs/dir.c
index bbd3864..100b01b 100644
--- a/fs/squashfs/dir.c
+++ b/fs/squashfs/dir.c
@@ -64,7 +64,7 @@ static int get_dir_index_using_offset(struct super_block *sb,
 	 * is offset by 3 because we invent "." and ".." entries which are
 	 * not actually stored in the directory.
 	 */
-	if (f_pos < 3)
+	if (f_pos <= 3)
 		return f_pos;
 	f_pos -= 3;
 
-- 
1.7.5.4

