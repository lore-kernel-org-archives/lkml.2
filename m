Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab1C3IhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:37:14 -0400
Received: from smtp.nokia.com ([147.243.128.24]:58049 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab1C3IhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:37:13 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] UBIFS: do not select KALLSYMS_ALL
Date: Wed, 30 Mar 2011 11:40:15 +0300
Message-Id: <1301474416-8202-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

All UBIFS needs is to make sure we stacktraces when UBIFS debugging
is enabled. It is enough to select KALLSYMS for this, KALLSYMS_ALL
is not necessary. Moreover, Randy Dunlap reported that UBIFS causes
the following Kconfig dependency warning:

warning: (UBIFS_FS_DEBUG && LOCKDEP && LATENCYTOP) selects KALLSYMS_ALL
which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)

The reason is that KALLSYMS_ALL requires DEBUG_KERNEL and KALLSYMS, so
ideally, to select KALLSYMS_ALL we'd need to select DEBUG_KERNEL and
KALLSYMS first.

This seems to be too much to select. The easiest way to go is to forget
about KALLSYMS_ALL and just select KALLSYMS when UBIFS debugging is
enabled - that should be enough for stackdumps.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
index d744090..f8b0160 100644
--- a/fs/ubifs/Kconfig
+++ b/fs/ubifs/Kconfig
@@ -47,7 +47,7 @@ config UBIFS_FS_DEBUG
 	bool "Enable debugging support"
 	depends on UBIFS_FS
 	select DEBUG_FS
-	select KALLSYMS_ALL
+	select KALLSYMS
 	help
 	  This option enables UBIFS debugging support. It makes sure various
 	  assertions, self-checks, debugging messages and test modes are compiled
-- 
1.7.2.3

