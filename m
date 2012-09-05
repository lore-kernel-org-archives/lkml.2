Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2IENeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:34:13 -0400
Received: from local.xorcom.com ([81.218.177.19]:61145 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab2IENeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:34:10 -0400
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Maximilian Attems <max@stro.at>,
        Linux Kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Subject: [PATCH] Add mach-specific includes
Date: Wed,  5 Sep 2012 16:30:36 +0300
Message-Id: <1346851836-18284-1-git-send-email-tzafrir.cohen@xorcom.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <5040BFF3.6050705@suse.cz>
References: <5040BFF3.6050705@suse.cz>
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
index acb8650..811a53a 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -245,6 +245,9 @@ fi
 # Build header package
 (cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name \*.pl > "$objtree/debian/hdrsrcfiles")
 (cd $srctree; find arch/$SRCARCH/include include scripts -type f >> "$objtree/debian/hdrsrcfiles")
+if echo arch/$SRCARCH/mach-*/include | grep -v '*' >/dev/null; then
+	(cd $srctree; find arch/$SRCARCH/mach-*/include -type f >> "$objtree/debian/hdrsrcfiles")
+fi
 (cd $objtree; find arch/$SRCARCH/include .config Module.symvers include scripts -type f >> "$objtree/debian/hdrobjfiles")
 destdir=$kernel_headers_dir/usr/src/linux-headers-$version
 mkdir -p "$destdir"
-- 
1.7.10.4

