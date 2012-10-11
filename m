Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196Ab2JKBYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:24:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48714 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934183Ab2JKBYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:24:46 -0400
X-Sasl-enc: lIGL2fGZYARwTYIxc7OCnPNTxaAheoFIYafx/VfOUmIH 1349918685
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 070/120] ext4: online defrag is not supported for journaled files
Date: Thu, 11 Oct 2012 10:00:22 +0900
Message-Id: <20121011005838.985815617@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit f066055a3449f0e5b0ae4f3ceab4445bead47638 upstream.

Proper block swap for inodes with full journaling enabled is
truly non obvious task. In order to be on a safe side let's
explicitly disable it for now.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/move_extent.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -1142,7 +1142,12 @@ ext4_move_extents(struct file *o_filp, s
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
-
+	/* TODO: This is non obvious task to swap blocks for inodes with full
+	   jornaling enabled */
+	if (ext4_should_journal_data(orig_inode) ||
+	    ext4_should_journal_data(donor_inode)) {
+		return -EINVAL;
+	}
 	/* Protect orig and donor inodes against a truncate */
 	mext_inode_double_lock(orig_inode, donor_inode);
 


