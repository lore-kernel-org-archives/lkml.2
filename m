Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968189Ab2ERWqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:46:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:38460 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967348Ab2ERWqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:46:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [PATCH] tile: set KBUILD_DEFCONFIG to point at a real config file
Date: Fri, 18 May 2012 18:46:05 -0400
Message-Id: <1337381165-7376-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix this:

~/git/linux-head$ make defconfig
*** Default configuration is based on 'tile_defconfig'
***
*** Can't find default configuration "arch/tile/configs/tile_defconfig"!
***
make[1]: *** [defconfig] Error 1
make: *** [defconfig] Error 2

There is no need to use $ARCH in the tile/Makefile, since if we are
in there, we know ARCH must be tile.  Use the GX as the defconfig,
as that is what is used in linux-next.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 5015144..89f2310 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -34,7 +34,7 @@ LIBGCC_PATH     := \
   $(shell $(CC) $(KBUILD_CFLAGS) $(KCFLAGS) -print-libgcc-file-name)
 
 # Provide the path to use for "make defconfig".
-KBUILD_DEFCONFIG := $(ARCH)_defconfig
+KBUILD_DEFCONFIG := tilegx_defconfig
 
 # Used as a file extension when useful, e.g. head_$(BITS).o
 # Not needed for (e.g.) "$(CC) -m32" since the compiler automatically
-- 
1.7.9.1

