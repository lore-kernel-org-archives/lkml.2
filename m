Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1HCX3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:29:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab1HCX2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:51 2011
Message-Id: <20110803221251.387258955@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thieu Le <thieule@chromium.org>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [073/102] ecryptfs: Make inode bdi consistent with superblock bdi
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thieu Le <thieule@chromium.org>

commit 985ca0e626e195ea08a1a82b8dbeb6719747429a upstream.

Make the inode mapping bdi consistent with the superblock bdi so that
dirty pages are flushed properly.

Signed-off-by: Thieu Le <thieule@chromium.org>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -69,6 +69,7 @@ static int ecryptfs_inode_set(struct ino
 	inode->i_ino = lower_inode->i_ino;
 	inode->i_version++;
 	inode->i_mapping->a_ops = &ecryptfs_aops;
+	inode->i_mapping->backing_dev_info = inode->i_sb->s_bdi;
 
 	if (S_ISLNK(inode->i_mode))
 		inode->i_op = &ecryptfs_symlink_iops;


