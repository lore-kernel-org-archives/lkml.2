Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2AKMTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:19:20 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:39748 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756830Ab2AKMTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:19:16 -0500
Date: Wed, 11 Jan 2012 17:49:01 +0530
From: Rajanikanth H V <rajanikanth.hv@stericsson.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@sude.de,
        linux-arm-kernel@lists.infradead.org
Subject: tty/serial: Need clarification on Support for 4+M Baudrate
Message-ID: <20120111121901.GA4034@bnru05>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ref:
	kernel version 3.0.8

Platform: ARM Based SOC, UART:amba pl011

I have a requirement to interface UART with an external microcontroller 
using baud rate above 4Mbps, hence following is my approach to apply
the changes. Can any one review/provide me appropriate approach.



diff --git a/arch/arm/include/asm/termbits.h b/arch/arm/include/asm/termbits.h
index 704135d..556f5fb 100644
--- a/arch/arm/include/asm/termbits.h
+++ b/arch/arm/include/asm/termbits.h
@@ -155,6 +155,8 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define  B4050000 0010020
+#define  B4800000 0010021
 #define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR    010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 53f2442..59c0682 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -203,7 +203,7 @@ static const speed_t baud_table[] = {
 	76800, 153600, 307200, 614400, 921600
 #else
 	500000, 576000, 921600, 1000000, 1152000, 1500000, 2000000,
-	2500000, 3000000, 3500000, 4000000
+	2500000, 3000000, 3500000, 4000000, 4050000, 4800000
 #endif
 };
 
@@ -213,7 +213,7 @@ static const tcflag_t baud_bits[] = {
 	B1200, B1800, B2400, B4800, B9600, B19200, B38400,
 	B57600, B115200, B230400, B460800, B500000, B576000,
 	B921600, B1000000, B1152000, B1500000, B2000000, B2500000,
-	B3000000, B3500000, B4000000
+	B3000000, B3500000, B4000000, B4050000, B4800000
 };
 #else
 static const tcflag_t baud_bits[] = {
diff --git a/include/asm-generic/termbits.h b/include/asm-generic/termbits.h
index 232b478..f71e72f 100644
--- a/include/asm-generic/termbits.h
+++ b/include/asm-generic/termbits.h
@@ -156,6 +156,8 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
+#define  B4050000 0010020
+#define  B4800000 0010021
 #define CIBAUD	  002003600000	/* input baud rate */
 #define CMSPAR	  010000000000	/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000	/* flow control */
