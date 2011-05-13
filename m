Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705Ab1EMX0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:26:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:59038 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358Ab1EMXYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:24:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,366,1301900400"; 
   d="scan'208";a="2026751"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/5] EXEC: Use define for stack to argument size limit
Date: Fri, 13 May 2011 16:24:17 -0700
Message-Id: <1305329059-2017-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Change the hardcoded 4 constant for the argument size limit in exec
to a exported constant.

Needed for followon patch.

Open: better place for the constant?

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/exec.c          |    2 +-
 include/linux/fs.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5e62d26..1707832 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -225,7 +225,7 @@ struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 		 *    to work from.
 		 */
 		rlim = current->signal->rlim;
-		if (size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur) / 4) {
+		if (size > ACCESS_ONCE(rlim[RLIMIT_STACK].rlim_cur) / ARG_MAX_FACTOR) {
 			put_page(page);
 			return NULL;
 		}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dbd860a..fcd84a6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -33,6 +33,8 @@
 #define SEEK_END	2	/* seek relative to end of file */
 #define SEEK_MAX	SEEK_END
 
+#define ARG_MAX_FACTOR	4
+
 struct fstrim_range {
 	__u64 start;
 	__u64 len;
-- 
1.7.4.4

