Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2HNKpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 06:45:14 -0400
Received: from local.xorcom.com ([81.218.177.19]:36969 "EHLO local.xorcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab2HNKpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 06:45:12 -0400
From: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
To: Linux Kbuild <linux-kbuild@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Subject: [PATCH] builddeb: remove unneeded explicit Architecture
Date: Tue, 14 Aug 2012 13:44:52 +0300
Message-Id: <1344941092-31312-1-git-send-email-tzafrir.cohen@xorcom.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architecture was set explicitly in debian/control for one of the three
packages (linux-libc-dev) but not for the other two. When cross-building
it gives me an error:

  dpkg-gencontrol: error: current host architecture 'armhf' does not
  appear in package's architecture list (amd64)

Also note that if used, dpkg --print-architecture should have been
replaced with dpkg-architecture.

Signed-off-by: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
---
 scripts/package/builddeb |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index acb8650..d9c71a6 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -252,13 +252,12 @@ mkdir -p "$destdir"
 (cd $objtree; tar -c -f - -T "$objtree/debian/hdrobjfiles") | (cd $destdir; tar -xf -)
 ln -sf "/usr/src/linux-headers-$version" "$kernel_headers_dir/lib/modules/$version/build"
 rm -f "$objtree/debian/hdrsrcfiles" "$objtree/debian/hdrobjfiles"
-arch=$(dpkg --print-architecture)
 
 cat <<EOF >> debian/control
 
 Package: $kernel_headers_packagename
 Provides: linux-headers, linux-headers-2.6
-Architecture: $arch
+Architecture: any
 Description: Linux kernel headers for $KERNELRELEASE on $arch
  This package provides kernel header files for $KERNELRELEASE on $arch
  .
-- 
1.7.10.4

