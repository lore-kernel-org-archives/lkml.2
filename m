Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab0JVSYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43781 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab0JVSYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=tU7PxCko+BYH/Kxjz+yj4qCpvCGor7sCQGfTmksZTsFSeSkqT4Ja+iNv9NfcZ6L+Vg
         3w51mqXXnONim9hamvzwFapNx+fhSH2Wea82MG+fiWf0N4T06Eu+t2Wa92ygo00qEoUR
         D1voREnTBzJdZ6xhEVRk74nkz0LP6vuXtJ83o=
Message-ID: <4CC1D6DC.1020101@gmail.com>
Date: Fri, 22 Oct 2010 20:24:28 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 5/8] Removal of dead code from arch/m68knommu/platform/68VZ328/config.c
References: <4CC1D2D5.9050009@gmail.com>
In-Reply-To: <4CC1D2D5.9050009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5fef858951eaa6d10a219e7a8abad01810694af4
Author: N.P.S <napohybelskurwysynom2010@gmail.com>
Date:   Thu Oct 21 23:41:16 2010 +0200

    Removal of dead code from
    arch/m68knommu/platform/68VZ328/config.c
    drivers/serial/68328serial.h
    
    Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    CC: <linux-kernel@vger.kernel.org>

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
index 58aa215..c6d5382 100644
--- a/drivers/serial/68328serial.h
+++ b/drivers/serial/68328serial.h
@@ -181,13 +181,8 @@ struct m68k_serial {
 /* 
  * Define the number of ports supported and their irqs.
  */
-#ifndef CONFIG_68328_SERIAL_UART2
-#define NR_PORTS 1
-#define UART_IRQ_DEFNS {UART_IRQ_NUM}
-#else
 #define NR_PORTS 2
 #define UART_IRQ_DEFNS {UART1_IRQ_NUM, UART2_IRQ_NUM}
-#endif
 
 #endif /* __KERNEL__ */
 #endif /* !(_MC683XX_SERIAL_H) */
