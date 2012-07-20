Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2GTCVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:21:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:8248 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab2GTCVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:21:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="180982205"
Date: Fri, 20 Jul 2012 10:21:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] vfs: Make sys_sync writeout also block device inodes
Message-ID: <20120720022129.GA7205@localhost>
References: <1341326734-29881-1-git-send-email-jack@suse.cz>
 <1341326734-29881-7-git-send-email-jack@suse.cz>
 <20120717062734.GA6698@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120717062734.GA6698@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Would you please fold the below fix to commit 5c781a65fff ("vfs:
Create function for iterating over block devices")?

Thanks,
Fengguang
---
Subject: [PATCH] sync: fix build error on iterate_bdevs()

fs/sync.c:110:2: error: implicit declaration of function 'iterate_bdevs'

---
 include/linux/fs.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ef839a7..b62af06 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2124,6 +2124,10 @@ static inline int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
 	return 0;
 }
+
+static inline void iterate_bdevs(void (*func)(struct block_device *, void *), void *arg)
+{
+}
 #endif
 extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
-- 
1.7.10

