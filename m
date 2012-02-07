Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2BGAWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:22:19 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2BGAWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:22:17 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, viro@zeniv.linux.org.uk,
        Artem.Bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/5] Introduce CONFIG_GENERIC_IO
Date: Tue,  7 Feb 2012 01:22:46 +0100
Message-Id: <1328574170-2286-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are situations where CONFIG_HAS_IOMEM is too restrictive.
For example CONFIG_MTD_NAND_NANDSIM depends on CONFIG_HAS_IOMEM
but it works perfectly fine if an architecture without io memory
just includes asm-generic/io.h or implements everything defined in it.
UML is such a corner case.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 lib/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index d69d321..c3c4c1c 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -26,6 +26,10 @@ config GENERIC_IOMAP
 	bool
 	select GENERIC_PCI_IOMAP
 
+config GENERIC_IO
+	boolean
+	default n
+
 config CRC_CCITT
 	tristate "CRC-CCITT functions"
 	help
@@ -221,6 +225,7 @@ config BTREE
 config HAS_IOMEM
 	boolean
 	depends on !NO_IOMEM
+	select GENERIC_IO
 	default y
 
 config HAS_IOPORT
-- 
1.7.6

