Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0CTLiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:38:08 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46328 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0CTLiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=SNxY7eltHmnS4Qt9KmqpSj1ulaaoj+IgQVAIRYt9jTFhYBIaYI3/4jbpKyCVsJjjif
         D0a7rOJWRXt7soE4AxzHxHNDmmHSBJ1BJDpYXSjdgtpDtqlcGXbBqBgD+umXxCPOTyri
         JGxvKX0xkiNaT0/qTHsTrj3JgS7Lt122XWpwc=
Date: Sat, 20 Mar 2010 14:37:52 +0300
From: Dan Carpenter <error27@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Josef Bacik <josef@redhat.com>, Yan Zheng <zheng.yan@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 3/3] btrfs cleanup: unneeded null check
Message-ID: <20100320113752.GA5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Yan Zheng <zheng.yan@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

old_inode cannot be null here so I removed the check.
This fixes a smatch warning:
fs/btrfs/inode.c +5545 btrfs_rename(88) warn: variable dereferenced 
	before check 'old_inode'

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
linux-next material

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 02bb099..647ce41 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5541,10 +5541,8 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * make sure the inode gets flushed if it is replacing
 	 * something.
 	 */
-	if (new_inode && new_inode->i_size &&
-	    old_inode && S_ISREG(old_inode->i_mode)) {
+	if (new_inode && new_inode->i_size && S_ISREG(old_inode->i_mode))
 		btrfs_add_ordered_operation(trans, root, old_inode);
-	}
 
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
