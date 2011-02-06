Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1BFPTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:19:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53236 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1BFPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:19:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=H7i97dp66r4btV4LFvYD7JNed7LlxuZTBFjY1e20T6pv+YDWRgvqG5DmoE1C8KRgQr
         SEqhPzIMWp0IaIVqLVkiX/k6TAYE7Jhk+jvPUv5nzY+Dz74NlFKQv05wJ4YOc6lNPwdd
         FK5gmv+a11GCb+VB/4ObgxDHq8jGj1RKQsPfI=
Message-ID: <4D4EBAF4.9070403@gmail.com>
Date: Sun, 06 Feb 2011 16:15:00 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, rdunlap@xenotime.net
Subject: [PATCH] Kconfig: XIP doesn't depend on block
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

XIP doesn't depend on block symbol, then we can reorder the Kconfig.
For ext2 doesn't change the Kconfig behavior but if other fs will use
FS_XIP it won't need to include block support if not needed.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

--- Kconfig.orig	2011-01-19 00:14:02.000000000 +0100
+++ Kconfig	2011-02-06 16:04:51.000000000 +0100
@@ -9,13 +9,6 @@ if BLOCK
 source "fs/ext2/Kconfig"
 source "fs/ext3/Kconfig"
 source "fs/ext4/Kconfig"
-
-config FS_XIP
-# execute in place
-	bool
-	depends on EXT2_FS_XIP
-	default y
-
 source "fs/jbd/Kconfig"
 source "fs/jbd2/Kconfig"
 
@@ -38,6 +31,12 @@ source "fs/nilfs2/Kconfig"
 
 endif # BLOCK
 
+config FS_XIP
+# execute in place
+	bool
+	depends on EXT2_FS_XIP
+	default y
+
 # Posix ACL utility routines
 #
 # Note: Posix ACLs can be implemented without these helpers.  Never use

