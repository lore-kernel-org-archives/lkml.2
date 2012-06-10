Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab2FJOkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:40:09 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:57765 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab2FJOkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:40:06 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Zankel <chris@zankel.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 2/3] xtensa: Use "test -e" instead of bashism "test -a"
Date: Sun, 10 Jun 2012 16:39:57 +0200
Message-Id: <1339339198-24789-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339339198-24789-1-git-send-email-geert@linux-m68k.org>
References: <1339339198-24789-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Ubuntu, /bin/sh is a symlink to dash, which does not support "test -a".
This causes messages like

    test: 1: -a: unexpected operator
    test: 1: -a: unexpected operator

and link failures like

    (.init.text+0x132): undefined reference to `platform_init'

due to the appropriate platform code not being compiled.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org
---
 arch/xtensa/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/Makefile b/arch/xtensa/Makefile
index d41f9ed..1537a0a 100644
--- a/arch/xtensa/Makefile
+++ b/arch/xtensa/Makefile
@@ -68,8 +68,8 @@ core-$(CONFIG_EMBEDDED_RAMDISK)	+= arch/xtensa/boot/ramdisk/
 
 # Only build variant and/or platform if it includes a Makefile
 
-buildvar := $(shell test -a $(srctree)/arch/xtensa/variants/$(VARIANT)/Makefile && echo arch/xtensa/variants/$(VARIANT)/)
-buildplf := $(shell test -a $(srctree)/arch/xtensa/platforms/$(PLATFORM)/Makefile && echo arch/xtensa/platforms/$(PLATFORM)/)
+buildvar := $(shell test -e $(srctree)/arch/xtensa/variants/$(VARIANT)/Makefile && echo arch/xtensa/variants/$(VARIANT)/)
+buildplf := $(shell test -e $(srctree)/arch/xtensa/platforms/$(PLATFORM)/Makefile && echo arch/xtensa/platforms/$(PLATFORM)/)
 
 # Find libgcc.a
 
-- 
1.7.0.4

