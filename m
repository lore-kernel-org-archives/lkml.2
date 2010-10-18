Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0JRDz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:55:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46225 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0JRDz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WYkVasn9n0Xw3Syjl1Rckz090JryM7emjRY9MTXpsS1wpfwxQvFDiyRUV3n6bwOhE3
         9aq0G+J6ZIHe/R/Q5jXWuak3Ti4AimUmo7cTty01MTRX+MAMoxJC5l0wt/ZhePYNMDAe
         fnU4VQQn8hdfXmpeekjHOb8qRjpfc52VH6OGU=
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Add ISA_DMA_API config item
Date: Mon, 18 Oct 2010 12:55:21 +0900
Message-Id: <1287374121-7289-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ISA_DMA_API config item and select it when GENERIC_ISA_DMA enabled.
This fixes build failure on allmodconfig like following:

  CC      sound/isa/es18xx.o
sound/isa/es18xx.c: In function 'snd_es18xx_playback1_prepare':
sound/isa/es18xx.c:501:9: error: implicit declaration of function 'snd_dma_program'
sound/isa/es18xx.c: In function 'snd_es18xx_playback_pointer':
sound/isa/es18xx.c:818:3: error: implicit declaration of function 'snd_dma_pointer'
make[3]: *** [sound/isa/es18xx.o] Error 1
make[2]: *** [sound/isa/es18xx.o] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/mips/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 5526faa..4c9f402 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -881,11 +881,15 @@ config NO_IOPORT
 config GENERIC_ISA_DMA
 	bool
 	select ZONE_DMA if GENERIC_ISA_DMA_SUPPORT_BROKEN=n
+	select ISA_DMA_API
 
 config GENERIC_ISA_DMA_SUPPORT_BROKEN
 	bool
 	select GENERIC_ISA_DMA
 
+config ISA_DMA_API
+	bool
+
 config GENERIC_GPIO
 	bool
 
-- 
1.7.0.4

