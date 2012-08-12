Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab2HLJyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 05:54:25 -0400
Received: from local.xorcom.com ([81.218.177.19]:36582 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab2HLJyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 05:54:24 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Aug 2012 05:54:23 EDT
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: Linux Kbuild <linux-kbuild@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Subject: [PATCH] Add mach-specific includes
Date: Sun, 12 Aug 2012 12:47:23 +0300
Message-Id: <1344764843-2179-1-git-send-email-tzafrir.cohen@xorcom.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a deb package, the linux-headers package should also
add arch/$ARCH/mach-*/include Required for arm and probably some
other architectures: avr32 and blackfin.

This is needed to allow building modules using the headers package.

Signed-off-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
---
 scripts/package/builddeb |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index acb8650..16f8c1a 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -245,6 +245,9 @@ fi
 # Build header package
 (cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
 (cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
+if echo arch/$SRCARCH/mach-*/include | grep q -v '*'; then
+	(cd $srctree; find arch/$SRCARCH/mach-*/include -type f >> "$objtree/debian/hdrsrcfiles")
+fi
 (cd $objtree; find arch/$SRCARCH/include .config Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
 destdir=$kernel_headers_dir/usr/src/linux-headers-$version
 mkdir -p "$destdir"
-- 
1.7.10.4

