Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2CLUGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:06:40 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.42]:44677 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2CLUGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:06:39 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] init/do_mounts.c: Print error code on mount failure
Date: Mon, 12 Mar 2012 21:06:30 +0100
Message-Id: <1331582790-35901-1-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.7.9.2
X-Df-Sender: YmVybmhhcmRAYndhbGxlLmRl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing the error code makes it easier to debug the cause of a mount
failure. For example I had the problem that the root file system could
not be mounted read-writeable because my SD card was write-protected.
Without an error code it looks like the SD card was not detected at all.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 init/do_mounts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 2974c8b..0e93f92 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -373,8 +373,8 @@ retry:
 #ifdef CONFIG_BLOCK
 		__bdevname(ROOT_DEV, b);
 #endif
-		printk("VFS: Cannot open root device \"%s\" or %s\n",
-				root_device_name, b);
+		printk("VFS: Cannot open root device \"%s\" or %s: error %d\n",
+				root_device_name, b, err);
 		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
 		printk_all_partitions();
-- 
1.7.9.2

