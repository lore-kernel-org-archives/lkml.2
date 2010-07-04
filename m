Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab0GDCd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 22:33:57 -0400
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:59210 "EHLO
	homiemail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756588Ab0GDCd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 22:33:56 -0400
X-Greylist: delayed 58361 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jul 2010 22:33:55 EDT
Subject: [PATCH] omfs: fix memory leak
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: me@bobcopeland.com, linux-karma-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Jul 2010 22:33:48 -0400
Message-ID: <1278210828.27014.2.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In omfs_fill_super(), when returning on error, sbi is not being freed.

Thanks,
Davidlohr.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/omfs/inode.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 089839a..253846e 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -523,12 +523,14 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	printk(KERN_DEBUG "omfs: Mounted volume %s\n", omfs_rb->r_name);
 
-	ret = 0;
+	ret = 0; /* success */
 out_brelse_bh2:
 	brelse(bh2);
 out_brelse_bh:
 	brelse(bh);
 end:
+	if (ret != 0)
+		kfree(sbi);
 	return ret;
 }
 
-- 
1.7.0.4



