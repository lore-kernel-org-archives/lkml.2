Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938Ab2C3VFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:05:54 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab2C3VFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:44 -0400
Message-Id: <201203302105.q2UL54PJ006287@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:29:28 -0400
Subject: [PATCH] arch/tile: fix a couple of comments that needed updating
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:04.0725 (UTC) FILETIME=[C77D2050:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not associated with any code changes, so I'm just lumping these
comment changes into a commit by themselves.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c |   11 +++++++++--
 arch/tile/mm/fault.c     |    2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 1a7276a..62b1903 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -913,6 +913,13 @@ void __cpuinit setup_cpu(int boot)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
+/*
+ * Note that the kernel can potentially support other compression
+ * techniques than gz, though we don't do so by default.  If we ever
+ * decide to do so we can either look for other filename extensions,
+ * or just allow a file with this name to be compressed with an
+ * arbitrary compressor (somewhat counterintuitively).
+ */
 static int __initdata set_initramfs_file;
 static char __initdata initramfs_file[128] = "initramfs.cpio.gz";
 
@@ -928,9 +935,9 @@ static int __init setup_initramfs_file(char *str)
 early_param("initramfs_file", setup_initramfs_file);
 
 /*
- * We look for an additional "initramfs.cpio.gz" file in the hvfs.
+ * We look for an "initramfs.cpio.gz" file in the hvfs.
  * If there is one, we allocate some memory for it and it will be
- * unpacked to the initramfs after any built-in initramfs_data.
+ * unpacked to the initramfs.
  */
 static void __init load_hv_initrd(void)
 {
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index c1eaaa1..5f1fdeb 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -131,7 +131,7 @@ static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 }
 
 /*
- * Handle a fault on the vmalloc or module mapping area
+ * Handle a fault on the vmalloc area.
  */
 static inline int vmalloc_fault(pgd_t *pgd, unsigned long address)
 {
-- 
1.6.5.2

