Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002Ab0HEWcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:32:32 -0400
Received: from kroah.org ([198.145.64.141]:37805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934562Ab0HEWY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/28] debugfs: no longer needs to depend on SYSFS
Date: Thu,  5 Aug 2010 15:24:08 -0700
Message-Id: <1281047058-23716-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

debugfs no longer uses 'kernel_subsys' (which is gone), and other
kernel/ksysfs.c code is always built, so DEBUG_FS does not need
to depend on SYSFS.

Fixes this kconfig warning:

warning: (TREE_RCU_TRACE || AMD_IOMMU_STATS && AMD_IOMMU || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || DEBUG_KMEMLEAK && DEBUG_KERNEL && EXPERIMENTAL && !MEMORY_HOTPLUG && (X86 || ARM || PPC || S390 || SPARC64 || SUPERH || MICROBLAZE) && SYSFS || TRACING || X86_PTDUMP && DEBUG_KERNEL || BLK_DEV_IO_TRACE && TRACING_SUPPORT && FTRACE && SYSFS && BLOCK) selects DEBUG_FS which has unmet direct dependencies (SYSFS)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/Kconfig.debug |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 154ff43..4608952 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -76,7 +76,6 @@ config UNUSED_SYMBOLS
 
 config DEBUG_FS
 	bool "Debug Filesystem"
-	depends on SYSFS
 	help
 	  debugfs is a virtual file system that kernel developers use to put
 	  debugging files into.  Enable this option to be able to read and
-- 
1.7.2

