Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab0HDMms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:42:48 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:57240 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476Ab0HDMmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:42:46 -0400
Date: Wed, 4 Aug 2010 14:42:43 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 9/9] arch/m68knommu: Removing dead 68328_SERIAL_UART2
 config option
Message-ID: <27f32e81b41a8ef690253ea7a2d3aec4e46d09c3.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280924671.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_68328_SERIAL_UART2 doesn't exist in Kconfig, therefore removing
all references to it from the source.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/m68knommu/platform/68VZ328/config.c |    5 -----
 drivers/serial/68328serial.h             |    5 -----
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/m68knommu/platform/68VZ328/config.c b/arch/m68knommu/platform/68VZ328/config.c
index fc5c630..eabaabe 100644
--- a/arch/m68knommu/platform/68VZ328/config.c
+++ b/arch/m68knommu/platform/68VZ328/config.c
@@ -90,11 +90,6 @@ static void init_hardware(char *command, int size)
 	PDIQEG &= ~PD(1);
 	PDIRQEN |= PD(1);			/* IRQ enabled */
 
-#ifdef CONFIG_68328_SERIAL_UART2
-	/* Enable RXD TXD port bits to enable UART2 */
-	PJSEL &= ~(PJ(5) | PJ(4));
-#endif
-
 #ifdef CONFIG_INIT_LCD
 	/* initialize LCD controller */
 	LSSA = (long) screen_bits;
diff --git a/drivers/serial/68328serial.h b/drivers/serial/68328serial.h
index 58aa215..664ceb0 100644
--- a/drivers/serial/68328serial.h
+++ b/drivers/serial/68328serial.h
@@ -181,13 +181,8 @@ struct m68k_serial {
 /* 
  * Define the number of ports supported and their irqs.
  */
-#ifndef CONFIG_68328_SERIAL_UART2
 #define NR_PORTS 1
 #define UART_IRQ_DEFNS {UART_IRQ_NUM}
-#else
-#define NR_PORTS 2
-#define UART_IRQ_DEFNS {UART1_IRQ_NUM, UART2_IRQ_NUM}
-#endif
 
 #endif /* __KERNEL__ */
 #endif /* !(_MC683XX_SERIAL_H) */
-- 
1.7.0.4

