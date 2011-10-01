Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1JATY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:24:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab1JATXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:23:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 05/11] ARM: vfp: use -mfloat-abi=soft to build vfp
Date: Sat,  1 Oct 2011 21:21:54 +0200
Message-Id: <1317496920-7764-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:6CM3nQFKt4DRc2el4zwPHVMplojWJ/a5mdmGZVpI7Eh
 hO8h9a81UcVhXjaUm7byH4PHUHnRgM1B1Igl93mBsrEFem+mWF
 HVz5QVVwBHg9kWSI4FDp1n6F+CHG6kG7GU09vbPdZARjsHbOd7
 UYvsCFP7CyALEAT+TONpiGxwKJX/3ok371YPbKiOm7PWenRSdu
 NtrCOfldv6r1TRyCEDtITghMqwSlxwc4h1LTx3kHup6GEBwPhh
 0GIZASmkAPMv94pfBPjPXzUFuQvWw7glC7omNIQdEiAaxrU4/j
 Eun/cOXQ0LcQL5sTvoRGeNo3B7jA7kTx+UWhJ7ub293SC9HquU
 jKyXbi8w5cZEJZ8s65fEFvox8HKBbnDiTa0rkOMUy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distros are starting to ship with toolchains defaulting to
hardfloat. Using such a compiler to build the kernel fails
in the VFP directory with

arch/arm/vfp/entry.S:1:0: sorry, unimplemented: -mfloat-abi=hard and VFP

Adding -mfloat-abi=soft to the gcc command line fixes this.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/vfp/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/vfp/Makefile b/arch/arm/vfp/Makefile
index 6de73aa..a81404c 100644
--- a/arch/arm/vfp/Makefile
+++ b/arch/arm/vfp/Makefile
@@ -7,7 +7,7 @@
 # ccflags-y := -DDEBUG
 # asflags-y := -DDEBUG
 
-KBUILD_AFLAGS	:=$(KBUILD_AFLAGS:-msoft-float=-Wa,-mfpu=softvfp+vfp)
+KBUILD_AFLAGS	:=$(KBUILD_AFLAGS:-msoft-float=-Wa,-mfpu=softvfp+vfp -mfloat-abi=soft)
 LDFLAGS		+=--no-warn-mismatch
 
 obj-y			+= vfp.o
-- 
1.7.5.4

