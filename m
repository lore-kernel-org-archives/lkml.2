Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab2ANX37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 18:29:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34346 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2ANX36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 18:29:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] ARM: Fix regression caused by ARCH_NR_GPIOS removal
Date: Sun, 15 Jan 2012 00:33:25 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Peter De Schrijver (NVIDIA) <pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201150033.25885.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 3dea19e826da3dd43b3dc308aca299c0b7263c6b (ARM: 7244/1:
mach-shmobile: Use CONFIG_ARCH_NR_GPIO) removed ARCH_NR_GPIOS
and introduced ARCH_NR_GPIO instead without changing the users
of that symbol.  As a result, the kernels including that commit
don't boot on my test-bed Mackerel board.

Fix the problem by defining ARCH_NR_GPIOS again.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/include/asm/gpio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/arm/include/asm/gpio.h
===================================================================
--- linux.orig/arch/arm/include/asm/gpio.h
+++ linux/arch/arm/include/asm/gpio.h
@@ -2,7 +2,7 @@
 #define _ARCH_ARM_GPIO_H
 
 #if CONFIG_ARCH_NR_GPIO > 0
-#define ARCH_NR_GPIO CONFIG_ARCH_NR_GPIO
+#define ARCH_NR_GPIOS CONFIG_ARCH_NR_GPIO
 #endif
 
 /* not all ARM platforms necessarily support this API ... */
