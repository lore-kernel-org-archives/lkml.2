Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2JJXJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:09:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55513 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601Ab2JJXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:00 -0400
X-Sasl-enc: 8cOJjwicWBlKxXKN1RXbrxfb5TAso0QCdtOxSuFd1BjF 1349910179
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 053/122] ext4: always set i_op in ext4_mknod()
Date: Thu, 11 Oct 2012 07:53:39 +0900
Message-Id: <20121010225347.635901264@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

commit 6a08f447facb4f9e29fcc30fb68060bb5a0d21c2 upstream.

ext4_special_inode_operations have their own ifdef CONFIG_EXT4_FS_XATTR
to mask those methods. And ext4_iget also always sets it, so there is
an inconsistency.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2149,9 +2149,7 @@ retry:
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
-#ifdef CONFIG_EXT4_FS_XATTR
 		inode->i_op = &ext4_special_inode_operations;
-#endif
 		err = ext4_add_nondir(handle, dentry, inode);
 	}
 	ext4_journal_stop(handle);


