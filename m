Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1DTLgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:36:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:45178 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1DTLgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:36:07 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/3] uml: fix hppfs build
Date: Wed, 20 Apr 2011 13:34:26 +0200
Message-Id: <1303299266-10219-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303299266-10219-1-git-send-email-richard@nod.at>
References: <1303299266-10219-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make HoneyPot ProcFS depend on CONFIG_PROC_FS so that it will build.
Recommended by Christoph Hellwig.

Fixes kernel bugzilla #33692:
  https://bugzilla.kernel.org/show_bug.cgi?id=33692

Reported-by: Simon Danner <danner.simon@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Jeff Dike <jdike@addtoit.com>
Cc:	user-mode-linux-devel@lists.sourceforge.net
Cc:	Christoph Hellwig <hch@infradead.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Kconfig.um |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/Kconfig.um b/arch/um/Kconfig.um
index 90a438a..b5e675e 100644
--- a/arch/um/Kconfig.um
+++ b/arch/um/Kconfig.um
@@ -47,7 +47,7 @@ config HOSTFS
 
 config HPPFS
 	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && PROC_FS
 	help
 	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
 	  entries to be overridden, removed, or fabricated from the host.
-- 
1.7.4.2

