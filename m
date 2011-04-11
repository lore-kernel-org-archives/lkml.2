Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1DKVtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:49:15 -0400
Received: from relay2.sgi.com ([192.48.179.30]:53860 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756111Ab1DKVtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:49:14 -0400
Subject: [PATCH] xfs_destroy_workqueues() should not be tagged with __exit
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: torvalds <torvalds@linux-foundation.org>
Cc: akpm <akpm@linux-foundation.org>, xfs@oss.sgi.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 16:48:19 -0500
Message-ID: <1302558499.2580.96.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Apr 2011 21:48:20.0276 (UTC) FILETIME=[2C534740:01CBF892]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please apply the following patch, which fixes
a problem with ia64 builds that is present in the XFS
pull request I sent you this morning.  Thank you.

					-Alex

-------- Forwarded Message --------
From: Luck, Tony <tony.luck@intel.com>
To: xfs-masters@oss.sgi.com
Cc: hch@lst.de, dchinner@redhat.com, aelder@sgi.com
Subject: [PATCH] xfs_destroy_workqueues() should not be tagged with
__exit
Date: Mon, 11 Apr 2011 12:06:12 -0700

ia64 throws away .exit sections for the built-in CONFIG case, so routines
that are used in other circumstances should not be tagged as __exit.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>

---

Should be applied after (or merged into) Dave Chinner's patch
	xfs: convert the xfsaild threads to a workqueue
which appeared as commit 0bf6a5bd4b55b466964ead6fa566d8f346a828ee in
next-20110411

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 67d5b2c..b38e58d 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1741,7 +1741,7 @@ out:
 	return -ENOMEM;
 }
 
-STATIC void __exit
+STATIC void
 xfs_destroy_workqueues(void)
 {
 	destroy_workqueue(xfs_ail_wq);


