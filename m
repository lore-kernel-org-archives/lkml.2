Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1C1Ukd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 16:40:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48622 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1C1Ukb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 16:40:31 -0400
Date: Mon, 28 Mar 2011 13:40:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH] ubifs: fix kconfig dependency warning
Message-Id: <20110328134016.deb5d0c8.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D90F233.0058,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix another kconfig dependency warning, this time in ubifs.

warning: (UBIFS_FS_DEBUG && LOCKDEP && LATENCYTOP) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)

Without this patch, we can have:
# CONFIG_KALLSYMS is not set
CONFIG_KALLSYMS_ALL=y
which is useless (does nothing unless KALLSYMS is enabled).

However, ubifs builds successfully with or without this patch,
and it builds with this line completely deleted,
so what was this 'select' for?  Just developer convenience?

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:      Artem Bityutskiy <dedekind1@gmail.com>
Cc:      Adrian Hunter <adrian.hunter@nokia.com>
Cc:      linux-mtd@lists.infradead.org
---
 fs/ubifs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.38-git18.orig/fs/ubifs/Kconfig
+++ linux-2.6.38-git18/fs/ubifs/Kconfig
@@ -47,7 +47,7 @@ config UBIFS_FS_DEBUG
 	bool "Enable debugging support"
 	depends on UBIFS_FS
 	select DEBUG_FS
-	select KALLSYMS_ALL
+	select KALLSYMS_ALL if DEBUG_KERNEL && KALLSYMS
 	help
 	  This option enables UBIFS debugging support. It makes sure various
 	  assertions, self-checks, debugging messages and test modes are compiled
