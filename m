Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0IRTx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:53:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61408 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab0IRTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:53:56 -0400
Date: Sat, 18 Sep 2010 12:53:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org
Subject: [PATCH] usibfs: fix kconfig dependency warning
Message-Id: <20100918125340.7a2cbb8b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix another kconfig dependency warning, this time in ubifs.

warning: (MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI && KALLSYMS && DEBUG_KERNEL || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT && DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:      Artem Bityutskiy <dedekind1@gmail.com>
Cc:      Adrian Hunter <adrian.hunter@nokia.com>
Cc:      linux-mtd@lists.infradead.org
---
 fs/ubifs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100917.orig/fs/ubifs/Kconfig
+++ linux-next-20100917/fs/ubifs/Kconfig
@@ -47,7 +47,7 @@ config UBIFS_FS_DEBUG
 	bool "Enable debugging"
 	depends on UBIFS_FS
 	select DEBUG_FS
-	select KALLSYMS_ALL
+	select KALLSYMS_ALL if DEBUG_KERNEL && KALLSYMS
 	help
 	  This option enables UBIFS debugging.
 
