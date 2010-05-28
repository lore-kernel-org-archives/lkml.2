Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0E1Bb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 21:31:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42798 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505Ab0E1BbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 21:31:17 -0400
Date: Fri, 28 May 2010 11:31:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>,
       =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>,
       Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the vfs tree with the logfs tree
Message-Id: <20100528113114.55b0fdf5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/logfs/logfs.h between commit ddbb5dd99c40a695d5d75645b5a18bef394acb16
("logfs: kill BKL") from the logfs tree and commit
05b2fc7d1f1046fef1199e1a4d2f63df998ef3aa ("drop unused dentry argument to
->fsync") from the vfs tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/logfs/logfs.h
index 6365509,c838c4d..0000000
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@@ -504,9 -504,9 +504,9 @@@ extern const struct inode_operations lo
  extern const struct file_operations logfs_reg_fops;
  extern const struct address_space_operations logfs_reg_aops;
  int logfs_readpage(struct file *file, struct page *page);
 -int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 -		unsigned long arg);
 +long logfs_ioctl(struct file *file, unsigned int cmd,
 +		 unsigned long arg);
- int logfs_fsync(struct file *file, struct dentry *dentry, int datasync);
+ int logfs_fsync(struct file *file, int datasync);
  
  /* gc.c */
  u32 get_best_cand(struct super_block *sb, struct candidate_list *list, u32 *ec);
