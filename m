Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab0ENUGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758476Ab0ENUGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:06:38 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] anon_inode: set S_IFREG on the anon_inode
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org, npiggin@suse.de
Date: Fri, 14 May 2010 16:05:59 -0400
Message-ID: <20100514200555.17387.92658.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anon_inode_mkinode() sets inode->i_mode = S_IRUSR | S_IWUSR;  This means
that (inode->i_mode & S_IFMT) == 0.  This trips up some SELinux code that
needs to determine if a given inode is a regular file, a directory, etc.
The easiest solution is to just make sure that the anon_inode also sets
S_IFREG.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/anon_inodes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index e4b75d6..9bd4b38 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -205,7 +205,7 @@ static struct inode *anon_inode_mkinode(void)
 	 * that it already _is_ on the dirty list.
 	 */
 	inode->i_state = I_DIRTY;
-	inode->i_mode = S_IRUSR | S_IWUSR;
+	inode->i_mode = S_IFREG | S_IRUSR | S_IWUSR;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 	inode->i_flags |= S_PRIVATE;

