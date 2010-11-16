Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab0KPOrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:47:25 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36044 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763Ab0KPOrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:47:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=baUIfW7nTFCCkgj2rh15Tjy3nuxeSFeBqs6WNBTsbbJMOjI5p1EHQLffX14u31Vdy6
         z1w7JduzU7QNlfilofXAuCwLZQcmPKxJRcFmhNuQFpXOZpTqZEioOGgqYafc+9aQqbKh
         z8Sb39P41D2Fb9BtCQUgbYdnRV+Z/4NyDggog=
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] MIPS: Define dummy MAX_DMA_CHANNELS to fix build failure
Date: Tue, 16 Nov 2010 23:47:20 +0900
Message-Id: <1289918840-13434-1-git-send-email-namhyung@gmail.com>
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
index 2d47da6..c601cff 100644
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

