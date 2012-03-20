Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab2CTKcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:32:10 -0400
Received: from msa105.auone-net.jp ([61.117.18.165]:57138 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab2CTKcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:32:08 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2012 06:32:08 EDT
Date: Tue, 20 Mar 2012 19:26:27 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] deb-pkg: Fix build error on read-only source
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20120320102628.02DC16FC039@msa105.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ make O=/tmp/a V=1 deb-pkg
...
make -C /usr/src/linux O=/tmp/a/. headers_check
set -e; : '  CHK     include/linux/version.h'; mkdir -p include/linux/;         (echo \#define LINUX_VERSION_CODE 197376; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < /usr/src/linux/Makefile > include/linux/version.h.tmp; if [ -r include/linux/version.h ] && cmp -s include/linux/version.h include/linux/version.h.tmp; then rm -f include/linux/version.h.tmp; else : '  UPD     include/linux/version.h'; mv -f include/linux/version.h.tmp include/linux/version.h; fi
/bin/sh: 1: cannot create include/linux/version.h.tmp: Read-only file system
make[4]: *** [include/linux/version.h] Error 2
make[3]: *** [all] Error 2
make[2]: *** [deb-pkg] Error 2
make[1]: *** [deb-pkg] Error 2
make: *** [sub-make] Error 2

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 scripts/package/builddeb |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 3c6c0b1..ceb1de2 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -127,8 +127,8 @@ if grep -q '^CONFIG_MODULES=y' .config ; then
 	fi
 fi
 
-make headers_check
-make headers_install INSTALL_HDR_PATH="$libc_headers_dir/usr"
+make KBUILD_SRC= headers_check
+make KBUILD_SRC= headers_install INSTALL_HDR_PATH="$libc_headers_dir/usr"
 
 # Install the maintainer scripts
 # Note: hook scripts under /etc/kernel are also executed by official Debian
-- 
1.7.9.1

