Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2LLSWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:22:43 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55775 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:22:41 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 20/26] sysfs: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:09 -0800
Message-Id: <0f1ebce9c3792f2d0e8ce794db19f663e41c6475.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/sysfs/file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 602f56d..bd7e59b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -91,8 +91,8 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	 * indicate truncated result or overflow in normal use cases.
 	 */
 	if (count >= (ssize_t)PAGE_SIZE) {
-		print_symbol("fill_read_buffer: %s returned bad count\n",
-			(unsigned long)ops->show);
+		printk("fill_read_buffer: %pSR returned bad count\n",
+		       ops->show);
 		/* Try to struggle along */
 		count = PAGE_SIZE - 1;
 	}
-- 
1.7.8.112.g3fd21

