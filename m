Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0IUXWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 19:22:51 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43569 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab0IUXWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 19:22:49 -0400
Date: Tue, 21 Sep 2010 16:24:37 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        linux-fsdevel@vger.kernel.org, gregf@hq.newdream.net
Subject: [PATCH] fs: {lock,unlock}_flocks() stubs to prepare for BKL removal
Message-ID: <Pine.LNX.4.64.1009211438010.18094@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The locking for fs/locks.c will be switching to a new interface in 
preparation for BKL removal.  Getting these stubs upstream prior to the 
merge window will make it a bit easier for subsystems to make the 
necessary changes (non-trivial, in Ceph's case), test in linux-next 
without conflicts, and avoid worrying about the order in which things are 
pulled for 2.6.37.

Would you mind taking the patch below now?

Thanks!
sage

---

From: Sage Weil <sage@newdream.net>
Date: Tue, 21 Sep 2010 14:35:37 -0700
Subject: [PATCH] fs: {lock,unlock}_flocks() stubs to prepare for BKL removal

The lock structs are currently protected by the BKL, but are accessed by
code in fs/locks.c and misc file system and DLM code.  These stubs will
allow all users to switch to the new interface before the implementation
is changed to a spinlock.

Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 include/linux/fs.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 76041b6..63d069b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1093,6 +1093,10 @@ struct file_lock {
 
 #include <linux/fcntl.h>
 
+/* temporary stubs for BKL removal */
+#define lock_flocks() lock_kernel()
+#define unlock_flocks() unlock_kernel()
+
 extern void send_sigio(struct fown_struct *fown, int fd, int band);
 
 #ifdef CONFIG_FILE_LOCKING
-- 
1.7.0

