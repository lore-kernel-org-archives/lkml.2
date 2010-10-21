Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0JUO6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:58:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44355 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0JUO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LMMcBW31ccYlgPxQKXQkCS44Dt4uR9DYNrW/nKHP5UyUe36yNiQHNsicQufbQXjw7A
         FuHRozE5W1X+YdHWoPN5jHDjd/riGLgG7HRM4ulI3BqV6Oech3uT+u7gFu2k2e4VXogT
         V6ZDBLNDbLWJQyQMe0r/VRGXm6YNPv2vLoaro=
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Define dummy MAX_DMA_CHANNELS to fix build failure
Date: Thu, 21 Oct 2010 23:57:59 +0900
Message-Id: <1287673079-15065-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allmodconfig build failes like following:

  CC [M]  sound/oss/soundcard.o
sound/oss/soundcard.c:68: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function)
make[3]: *** [sound/oss/soundcard.o] Error 1
make[2]: *** [sound/oss] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/mips/include/asm/dma.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/dma.h b/arch/mips/include/asm/dma.h
index 1353c81..e0d498c 100644
--- a/arch/mips/include/asm/dma.h
+++ b/arch/mips/include/asm/dma.h
@@ -74,7 +74,9 @@
  *
  */
 
-#ifndef CONFIG_GENERIC_ISA_DMA_SUPPORT_BROKEN
+#ifdef CONFIG_GENERIC_ISA_DMA_SUPPORT_BROKEN
+#define MAX_DMA_CHANNELS	0
+#else
 #define MAX_DMA_CHANNELS	8
 #endif
 
-- 
1.7.0.4

