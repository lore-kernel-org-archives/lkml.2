Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795Ab0HLTLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:11:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41265 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab0HLTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:11:21 -0400
Date: Thu, 12 Aug 2010 12:10:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH -next] ubi: fix kconfig unmet dependency
Message-Id: <20100812121059.e1d40380.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT && DEBUG_KERNEL || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Artem Bityutskiy <dedekind1@gmail.com>
Cc:	linux-mtd@lists.infradead.org
---
 drivers/mtd/ubi/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

This builds cleanly.  Will it execute OK?
or we can make MTD_UBI_DEBUG depend on KALLSYMS_ALL.

--- linux-next-20100810.orig/drivers/mtd/ubi/Kconfig.debug
+++ linux-next-20100810/drivers/mtd/ubi/Kconfig.debug
@@ -6,7 +6,7 @@ config MTD_UBI_DEBUG
 	depends on SYSFS
 	depends on MTD_UBI
 	select DEBUG_FS
-	select KALLSYMS_ALL
+	select KALLSYMS_ALL if KALLSYMS && DEBUG_KERNEL
 	help
 	  This option enables UBI debugging.
 
