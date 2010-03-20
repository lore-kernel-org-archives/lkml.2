Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0CTLWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:22:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61111 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab0CTLWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=w34IBrJq1MzKsGg0xScQhCd9tqEmwcJhbacnf5fZQKS4RvGewi1LXPYosKVA2joIQs
         5pDVNYRafGUlpgmGlLNIeHUTS5S3p6iY2yYNHVQmQcKM26vc+cTSPy9tLRKsWDeZGL6q
         2ezEeIvYShoErryEUQA2ECnKvbisnAzfamCOE=
Date: Sat, 20 Mar 2010 14:22:10 +0300
From: Dan Carpenter <error27@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
       Sage Weil <sage@newdream.net>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch 1/3] btrfs: checking for NULL instead of IS_ERR()
Message-ID: <20100320112210.GV5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>, Josef Bacik <josef@redhat.com>,
	Sage Weil <sage@newdream.net>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btrfs_get_extent() never returns NULL, only a valid pointer or ERR_PTR()

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2845c6c..15f661d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -511,7 +511,7 @@ static int should_defrag_range(struct inode *inode, u64 start, u64 len,
 		em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
 		unlock_extent(io_tree, start, start + len - 1, GFP_NOFS);
 
-		if (!em)
+		if (IS_ERR(em))
 			return 0;
 	}
 
