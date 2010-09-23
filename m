Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab0IWGvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:51:12 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:37555
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586Ab0IWGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:51:08 -0400
From: matt mooney <mfm@muteddisk.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 04/20] arm: change to new flag variables
Date: Wed, 22 Sep 2010 23:50:18 -0700
Message-Id: <1285224618-29564-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/arm/boot/compressed/Makefile |    4 ++--
 arch/arm/vfp/Makefile             |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index b23f6bc..9ba5726 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -76,8 +76,8 @@ ORIG_CFLAGS := $(KBUILD_CFLAGS)
 KBUILD_CFLAGS = $(subst -pg, , $(ORIG_CFLAGS))
 endif
 
-EXTRA_CFLAGS  := -fpic -fno-builtin
-EXTRA_AFLAGS  := -Wa,-march=all
+ccflags-y := -fpic -fno-builtin
+asflags-y := -Wa,-march=all
 
 # Supply ZRELADDR to the decompressor via a linker symbol.
 ifneq ($(CONFIG_AUTO_ZRELADDR),y)
diff --git a/arch/arm/vfp/Makefile b/arch/arm/vfp/Makefile
index 39f6d8e..6de73aa 100644
--- a/arch/arm/vfp/Makefile
+++ b/arch/arm/vfp/Makefile
@@ -4,8 +4,8 @@
 # Copyright (C) 2001 ARM Limited
 #
 
-# EXTRA_CFLAGS := -DDEBUG
-# EXTRA_AFLAGS := -DDEBUG
+# ccflags-y := -DDEBUG
+# asflags-y := -DDEBUG
 
 KBUILD_AFLAGS	:=$(KBUILD_AFLAGS:-msoft-float=-Wa,-mfpu=softvfp+vfp)
 LDFLAGS		+=--no-warn-mismatch
-- 
1.7.2.1

