Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2KEXV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:21:59 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42908 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab2KEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:26 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Neil Brown <neilb@suse.de>
Subject: [PATCH 058/104] drivers/md: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:15 -0800
Message-Id: <1352156701-4038-59-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

CC: Neil Brown <neilb@suse.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/Kconfig |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 91a02ee..3631846 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -158,7 +158,6 @@ config MULTICORE_RAID456
 	bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
 	depends on MD_RAID456
 	depends on SMP
-	depends on EXPERIMENTAL
 	---help---
 	  Enable the raid456 module to dispatch per-stripe raid operations to a
 	  thread pool.
@@ -210,7 +209,7 @@ config DM_DEBUG
 
 config DM_BUFIO
        tristate
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       depends on BLK_DEV_DM
        ---help---
 	 This interface allows you to do buffered I/O on a device and acts
 	 as a cache, holding recently-read blocks in memory and performing
@@ -251,8 +250,8 @@ config DM_SNAPSHOT
          Allow volume managers to take writable snapshots of a device.
 
 config DM_THIN_PROVISIONING
-       tristate "Thin provisioning target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       tristate "Thin provisioning target"
+       depends on BLK_DEV_DM
        select DM_PERSISTENT_DATA
        select DM_BIO_PRISON
        ---help---
@@ -302,8 +301,8 @@ config DM_RAID
 	 in one of the available parity distribution methods.
 
 config DM_LOG_USERSPACE
-	tristate "Mirror userspace logging (EXPERIMENTAL)"
-	depends on DM_MIRROR && EXPERIMENTAL && NET
+	tristate "Mirror userspace logging"
+	depends on DM_MIRROR && NET
 	select CONNECTOR
 	---help---
 	  The userspace logging module provides a mechanism for
@@ -350,8 +349,8 @@ config DM_MULTIPATH_ST
 	  If unsure, say N.
 
 config DM_DELAY
-	tristate "I/O delaying target (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	tristate "I/O delaying target"
+	depends on BLK_DEV_DM
 	---help---
 	A target that delays reads and/or writes and can send
 	them to different devices.  Useful for testing.
@@ -365,14 +364,14 @@ config DM_UEVENT
 	Generate udev events for DM events.
 
 config DM_FLAKEY
-       tristate "Flakey target (EXPERIMENTAL)"
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       tristate "Flakey target"
+       depends on BLK_DEV_DM
        ---help---
          A target that intermittently fails I/O for debugging purposes.
 
 config DM_VERITY
-	tristate "Verity target support (EXPERIMENTAL)"
-	depends on BLK_DEV_DM && EXPERIMENTAL
+	tristate "Verity target support"
+	depends on BLK_DEV_DM
 	select CRYPTO
 	select CRYPTO_HASH
 	select DM_BUFIO
-- 
1.7.9.5

