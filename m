Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab2HHV3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:29:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61971 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab2HHV2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:28:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 04/10] ARM: pass -marm to gcc by default
Date: Wed,  8 Aug 2012 23:27:52 +0200
Message-Id: <1344461278-28245-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344461278-28245-1-git-send-email-arnd@arndb.de>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:nd8XuSNg3c4SZ09Jhb7+/zeFJBVPUv9+oP3u/DhLaAF
 u3bRnZAri28uO5kLBSI3z37nC81oIiGUaedz1bpZjJdEHF2Y8A
 l3yljfBSO31hI2xPRN/QjsDOE9UiJM2xwiFcYqUAwnL9qQY/XY
 CWAhrv81bM7+xm854i2gHSI+kZOfKpheDaY14OrBDTYDRMJ6MV
 7GKIB/9ZS/KP0wh92SHE0sfsQlI/TKNYmUP92WwG/yjyI5VDKA
 Vltji8f/AB/lO39ZFzv5xNc07EjmfdBLtrDW4QDA9X7DUCbYk0
 ezsuVRK2qyxvBah1TVYXLx20l5PFfXrhsJuLo2ohXDmTfduYlH
 vC+9Sb1Q/CvHhj68I0VhbJNua9B3CahDFugDOrQL6MdLGRH0em
 59wqKKGItwWLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linaro cross toolchain and probably others nowadays default to
building in THUMB2 mode. When building a kernel for a CPU that does
not support THUMB2, the compiler complains about incorrect flags.
We can work around this by setting -marm for all non-T2 builds.

Without this patch, building assabet_defconfig results in:

usr/initramfs_data.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
arch/arm/nwfpe/entry.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
firmware/cis/PCMLM28.cis.gen.S:1:0: warning: target CPU does not support THUMB instructions [enabled by default]
(and many more)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Dave Martin <dave.martin@linaro.org>
---
 arch/arm/Makefile |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 30eae87..b4c2296 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -111,6 +111,9 @@ AFLAGS_THUMB2	:=$(CFLAGS_THUMB2) -Wa$(comma)-mthumb
 ifeq ($(CONFIG_THUMB2_AVOID_R_ARM_THM_JUMP11),y)
 CFLAGS_MODULE	+=-fno-optimize-sibling-calls
 endif
+else
+CFLAGS_THUMB2  :=-marm
+AFLAGS_THUMB2	:=-marm
 endif
 
 # Need -Uarm for gcc < 3.x
-- 
1.7.10

