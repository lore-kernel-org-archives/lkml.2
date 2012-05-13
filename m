Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab2EMQIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:08:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47592 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab2EMQHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:07:47 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH 4/7] Kconfig: Do not switch default values in EXPERT mode
Date: Sun, 13 May 2012 18:07:07 +0200
Message-Id: <1336925230-2853-5-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
References: <1336925230-2853-1-git-send-email-dh.herrmann@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should avoid changing default values when EXPERT mode is enabled. Often
users enable EXPERT mode to change a single value. If other subsystems
change their defaults in EXPERT mode, the user might get a totally
different result as expected.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
---
 init/Kconfig |    2 +-
 usr/Kconfig  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..f16400d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -801,7 +801,7 @@ config CHECKPOINT_RESTORE
 
 menuconfig NAMESPACES
 	bool "Namespaces support" if EXPERT
-	default !EXPERT
+	default y
 	help
 	  Provides the way to make tasks work with different objects using
 	  the same id. For example same IPC id may refer to different objects
diff --git a/usr/Kconfig b/usr/Kconfig
index 65b845b..065a0e3 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -56,7 +56,7 @@ config RD_GZIP
 
 config RD_BZIP2
 	bool "Support initial ramdisks compressed using bzip2" if EXPERT
-	default !EXPERT
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_BZIP2
 	help
@@ -65,7 +65,7 @@ config RD_BZIP2
 
 config RD_LZMA
 	bool "Support initial ramdisks compressed using LZMA" if EXPERT
-	default !EXPERT
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZMA
 	help
@@ -74,7 +74,7 @@ config RD_LZMA
 
 config RD_XZ
 	bool "Support initial ramdisks compressed using XZ" if EXPERT
-	default !EXPERT
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_XZ
 	help
@@ -83,7 +83,7 @@ config RD_XZ
 
 config RD_LZO
 	bool "Support initial ramdisks compressed using LZO" if EXPERT
-	default !EXPERT
+	default y
 	depends on BLK_DEV_INITRD
 	select DECOMPRESS_LZO
 	help
-- 
1.7.10.2

