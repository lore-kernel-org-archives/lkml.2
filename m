Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1HKKaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:30:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab1HKKaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:30:03 -0400
From: Michal Marek <mmarek@suse.cz>
To: dedekind1@gmail.com, adrian.hunter@intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ubifs: Do not build debug messages with CONFIG_UBIFS_FS_DEBUG disabled
Date: Thu, 11 Aug 2011 12:29:46 +0200
Message-Id: <1313058586-24239-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With
  $ grep -e UBIFS_FS_DEBUG -e DYNAMIC_DEBUG .config
  # CONFIG_UBIFS_FS_DEBUG is not set
  CONFIG_DYNAMIC_DEBUG=y

Debug messages are kept in the object files due to the
dynamic_pr_debug() macro, even if they are never going to be printed:
  $ make fs/ubifs/super.o
  $ strings fs/ubifs/super.o | grep 'compiled on'
  compiled on:         Aug 11 2011 at 12:21:38

Use plain printk to fix this.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 fs/ubifs/debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/debug.h b/fs/ubifs/debug.h
index 45174b5..5163a01 100644
--- a/fs/ubifs/debug.h
+++ b/fs/ubifs/debug.h
@@ -337,7 +337,7 @@ void dbg_debugfs_exit_fs(struct ubifs_info *c);
 
 #define ubifs_dbg_msg(fmt, ...) do {               \
 	if (0)                                     \
-		pr_debug(fmt "\n", ##__VA_ARGS__); \
+		printk(KERN_DEBUG fmt "\n", ##__VA_ARGS__); \
 } while (0)
 
 #define dbg_dump_stack()
-- 
1.7.6

