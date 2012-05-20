Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2ETTSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 15:18:42 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:7753 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2ETTSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 15:18:41 -0400
Message-ID: <201205201918.q4KJIdXL012088@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sun, 20 May 2012 15:15:34 -0400
Subject: [PATCH] tile: default to tilegx_defconfig for ARCH=tile
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-kernel@vger.kernel.org>
References: <1337381165-7376-1-git-send-email-paul.gortmaker@windriver.com>
 <4FB6F28F.3090404@tilera.com>
 <20120519031806.GA24697@windriver.com>
In-Reply-To: <20120519031806.GA24697@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no "ARCH=tile" (just like there is no "ARCH=x86") so we need
to pick a default configuration, either tilepro or tilegx, when users
specify ARCH=tile.  We'll use tilegx, since that's our current chip.

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Makefile |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 5015144..55640cf 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -34,7 +34,12 @@ LIBGCC_PATH     := \
   $(shell $(CC) $(KBUILD_CFLAGS) $(KCFLAGS) -print-libgcc-file-name)
 
 # Provide the path to use for "make defconfig".
-KBUILD_DEFCONFIG := $(ARCH)_defconfig
+# We default to the newer TILE-Gx architecture if only "tile" is given.
+ifeq ($(ARCH),tile)
+        KBUILD_DEFCONFIG := tilegx_defconfig
+else
+        KBUILD_DEFCONFIG := $(ARCH)_defconfig
+endif
 
 # Used as a file extension when useful, e.g. head_$(BITS).o
 # Not needed for (e.g.) "$(CC) -m32" since the compiler automatically
-- 
1.6.5.2

