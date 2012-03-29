Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934976Ab2C3VGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:06:06 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41906 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934875Ab2C3VFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:45 -0400
Message-Id: <201203302105.q2UL54Ed006288@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:30:19 -0400
Subject: [PATCH] arch/tile/Makefile: use KCFLAGS when figuring out the libgcc path.
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:04.0882 (UTC) FILETIME=[C7951520:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 17acce7..5e4d3b9 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -30,7 +30,8 @@ ifneq ($(CONFIG_DEBUG_EXTRA_FLAGS),"")
 KBUILD_CFLAGS   += $(CONFIG_DEBUG_EXTRA_FLAGS)
 endif
 
-LIBGCC_PATH     := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+LIBGCC_PATH     := \
+  $(shell $(CC) $(KBUILD_CFLAGS) $(KCFLAGS) -print-libgcc-file-name)
 
 # Provide the path to use for "make defconfig".
 KBUILD_DEFCONFIG := $(ARCH)_defconfig
-- 
1.6.5.2

