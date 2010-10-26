Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955Ab0JZPvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:51:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54997 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab0JZPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QfrAWmwGaGrWEK1Dp7mxrNUg49J6JDCFeRZMaKZIxBdQQz2snUn6r5hPVKnjl2PFBt
         ElkzRr4LldEfJRl2D1wc4fdpe29yOqmSxu/QeJjBtTSVXYckddyn2NopQKDuhpVsY798
         ZHMr/Wm3E3AT1zEYqn7yxBXi+KNDNcaDcnTTQ=
From: Namhyung Kim <namhyung@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sparc32: make CONFIG_SPARC_LEON depends on !SMP to fix build failure
Date: Wed, 27 Oct 2010 00:51:43 +0900
Message-Id: <1288108303-2712-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      arch/sparc/kernel/irq_32.o
arch/sparc/kernel/irq_32.c: In function 'request_fast_irq':
arch/sparc/kernel/irq_32.c:370:25: error: conflicting types for 'trapbase_cpu1'
arch/sparc/include/asm/leon.h:366:22: note: previous declaration of 'trapbase_cpu1' was here
arch/sparc/kernel/irq_32.c:370:40: error: conflicting types for 'trapbase_cpu2'
arch/sparc/include/asm/leon.h:367:22: note: previous declaration of 'trapbase_cpu2' was here
arch/sparc/kernel/irq_32.c:370:55: error: conflicting types for 'trapbase_cpu3'
arch/sparc/include/asm/leon.h:368:22: note: previous declaration of 'trapbase_cpu3' was here
make[3]: *** [arch/sparc/kernel/irq_32.o] Error 1
make[2]: *** [arch/sparc/kernel] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/sparc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 4db8bc0..a6685ba 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -463,7 +463,7 @@ config SERIAL_CONSOLE
 
 config SPARC_LEON
 	bool "Sparc Leon processor family"
-	depends on SPARC32
+	depends on SPARC32 && !SMP
 	---help---
 	  If you say Y here if you are running on a SPARC-LEON processor.
 	  The LEON processor is a synthesizable VHDL model of the
-- 
1.7.0.4

