Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2AZRNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:13:09 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:29706 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2AZRNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:13:06 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/6] ARM: at91/at91sam9x5: PMC header file
Date: Thu, 26 Jan 2012 18:12:33 +0100
Message-Id: <9cd1962fd21bcde4dc14ebc7114702015861eaa6.1327596859.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
References: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
References: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add at91sam9x5 chips family support in PMC header file:
Alternate prescaler location and CSS lenght for PCKR is added.
The new Peripheral Control Register management is added.
Protection mode register is modified to complete its management.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/include/mach/at91_pmc.h |   60 ++++++++++++++++++++++------
 1 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/at91_pmc.h b/arch/arm/mach-at91/include/mach/at91_pmc.h
index dbdd6ae..f9fdbbe 100644
--- a/arch/arm/mach-at91/include/mach/at91_pmc.h
+++ b/arch/arm/mach-at91/include/mach/at91_pmc.h
@@ -45,9 +45,13 @@
 #define		AT91_PMC_BIASCOUNT	(0xf << 28)		/* UTMI BIAS Start-up Time */
 
 #define	AT91_CKGR_MOR		(AT91_PMC + 0x20)	/* Main Oscillator Register [not on SAM9RL] */
-#define		AT91_PMC_MOSCEN		(1    << 0)		/* Main Oscillator Enable */
-#define		AT91_PMC_OSCBYPASS	(1    << 1)		/* Oscillator Bypass [SAM9x] */
-#define		AT91_PMC_OSCOUNT	(0xff << 8)		/* Main Oscillator Start-up Time */
+#define		AT91_PMC_MOSCEN		(1    <<  0)		/* Main Oscillator Enable */
+#define		AT91_PMC_OSCBYPASS	(1    <<  1)		/* Oscillator Bypass */
+#define		AT91_PMC_MOSCRCEN	(1    <<  3)		/* Main On-Chip RC Oscillator Enable [some SAM9] */
+#define		AT91_PMC_OSCOUNT	(0xff <<  8)		/* Main Oscillator Start-up Time */
+#define		AT91_PMC_KEY		(0x37 << 16)		/* MOR Writing Key */
+#define		AT91_PMC_MOSCSEL	(1    << 24)		/* Main Oscillator Selection [some SAM9] */
+#define		AT91_PMC_CFDEN		(1    << 25)		/* Clock Failure Detector Enable [some SAM9] */
 
 #define	AT91_CKGR_MCFR		(AT91_PMC + 0x24)	/* Main Clock Frequency Register */
 #define		AT91_PMC_MAINF		(0xffff <<  0)		/* Main Clock Frequency */
@@ -72,14 +76,24 @@
 #define			AT91_PMC_CSS_PLLA		(2 << 0)
 #define			AT91_PMC_CSS_PLLB		(3 << 0)
 #define			AT91_PMC_CSS_UPLL		(3 << 0)	/* [some SAM9 only] */
-#define		AT91_PMC_PRES		(7 <<  2)		/* Master Clock Prescaler */
-#define			AT91_PMC_PRES_1			(0 << 2)
-#define			AT91_PMC_PRES_2			(1 << 2)
-#define			AT91_PMC_PRES_4			(2 << 2)
-#define			AT91_PMC_PRES_8			(3 << 2)
-#define			AT91_PMC_PRES_16		(4 << 2)
-#define			AT91_PMC_PRES_32		(5 << 2)
-#define			AT91_PMC_PRES_64		(6 << 2)
+#define		PMC_PRES_OFFSET		2
+#define		AT91_PMC_PRES		(7 <<  PMC_PRES_OFFSET)		/* Master Clock Prescaler */
+#define			AT91_PMC_PRES_1			(0 << PMC_PRES_OFFSET)
+#define			AT91_PMC_PRES_2			(1 << PMC_PRES_OFFSET)
+#define			AT91_PMC_PRES_4			(2 << PMC_PRES_OFFSET)
+#define			AT91_PMC_PRES_8			(3 << PMC_PRES_OFFSET)
+#define			AT91_PMC_PRES_16		(4 << PMC_PRES_OFFSET)
+#define			AT91_PMC_PRES_32		(5 << PMC_PRES_OFFSET)
+#define			AT91_PMC_PRES_64		(6 << PMC_PRES_OFFSET)
+#define		PMC_ALT_PRES_OFFSET	4
+#define		AT91_PMC_ALT_PRES	(7 <<  PMC_ALT_PRES_OFFSET)		/* Master Clock Prescaler [alternate location] */
+#define			AT91_PMC_ALT_PRES_1		(0 << PMC_ALT_PRES_OFFSET)
+#define			AT91_PMC_ALT_PRES_2		(1 << PMC_ALT_PRES_OFFSET)
+#define			AT91_PMC_ALT_PRES_4		(2 << PMC_ALT_PRES_OFFSET)
+#define			AT91_PMC_ALT_PRES_8		(3 << PMC_ALT_PRES_OFFSET)
+#define			AT91_PMC_ALT_PRES_16		(4 << PMC_ALT_PRES_OFFSET)
+#define			AT91_PMC_ALT_PRES_32		(5 << PMC_ALT_PRES_OFFSET)
+#define			AT91_PMC_ALT_PRES_64		(6 << PMC_ALT_PRES_OFFSET)
 #define		AT91_PMC_MDIV		(3 <<  8)		/* Master Clock Division */
 #define			AT91RM9200_PMC_MDIV_1		(0 << 8)	/* [AT91RM9200 only] */
 #define			AT91RM9200_PMC_MDIV_2		(1 << 8)
@@ -103,7 +117,14 @@
 #define			AT91_PMC_USBS_UPLL		(1 << 0)
 #define		AT91_PMC_OHCIUSBDIV	(0xF <<  8)		/* Divider for USB OHCI Clock */
 
+#define	AT91_PMC_SMD		(AT91_PMC + 0x3c)	/* Soft Modem Clock Register [some SAM9 only] */
+#define		AT91_PMC_SMDS		(0x1  <<  0)		/* SMD input clock selection */
+#define		AT91_PMC_SMD_DIV	(0x1f <<  8)		/* SMD input clock divider */
+#define		AT91_PMC_SMDDIV(n)	(((n) <<  8) & AT91_PMC_SMD_DIV)
+
 #define	AT91_PMC_PCKR(n)	(AT91_PMC + 0x40 + ((n) * 4))	/* Programmable Clock 0-N Registers */
+#define		AT91_PMC_ALT_PCKR_CSS	(0x7 <<  0)		/* Programmable Clock Source Selection [alternate length] */
+#define			AT91_PMC_CSS_MASTER		(4 << 0)	/* [some SAM9 only] */
 #define		AT91_PMC_CSSMCK		(0x1 <<  8)		/* CSS or Master Clock Selection */
 #define			AT91_PMC_CSSMCK_CSS		(0 << 8)
 #define			AT91_PMC_CSSMCK_MCK		(1 << 8)
@@ -120,10 +141,25 @@
 #define		AT91_PMC_PCK1RDY	(1 <<  9)		/* Programmable Clock 1 */
 #define		AT91_PMC_PCK2RDY	(1 << 10)		/* Programmable Clock 2 */
 #define		AT91_PMC_PCK3RDY	(1 << 11)		/* Programmable Clock 3 */
+#define		AT91_PMC_MOSCSELS	(1 << 16)		/* Main Oscillator Selection [some SAM9] */
+#define		AT91_PMC_MOSCRCS	(1 << 17)		/* Main On-Chip RC [some SAM9] */
+#define		AT91_PMC_CFDEV		(1 << 18)		/* Clock Failure Detector Event [some SAM9] */
 #define	AT91_PMC_IMR		(AT91_PMC + 0x6c)	/* Interrupt Mask Register */
 
 #define AT91_PMC_PROT		(AT91_PMC + 0xe4)	/* Write Protect Mode Register [some SAM9] */
-#define		AT91_PMC_PROTKEY	0x504d4301	/* Activation Code */
+#define		AT91_PMC_WPEN		(0x1  <<  0)		/* Write Protect Enable */
+#define		AT91_PMC_WPKEY		(0xffffff << 8)		/* Write Protect Key */
+#define		AT91_PMC_PROTKEY	(0x504d43 << 8)		/* Activation Code */
+
+#define AT91_PMC_WPSR		(AT91_PMC + 0xe8)	/* Write Protect Status Register [some SAM9] */
+#define		AT91_PMC_WPVS		(0x1  <<  0)		/* Write Protect Violation Status */
+#define		AT91_PMC_WPVSRC		(0xffff  <<  8)		/* Write Protect Violation Source */
 
+#define AT91_PMC_PCR		(AT91_PMC + 0x10c)	/* Peripheral Control Register [some SAM9] */
+#define		AT91_PMC_PCR_PID	(0x3f  <<  0)		/* Peripheral ID */
+#define		AT91_PMC_PCR_CMD	(0x1  <<  12)		/* Command */
+#define		AT91_PMC_PCR_DIV	(0x3  <<  16)		/* Divisor Value */
+#define		AT91_PMC_PCRDIV(n)	(((n) <<  16) & AT91_PMC_PCR_DIV)
+#define		AT91_PMC_PCR_EN		(0x1  <<  28)		/* Enable */
 
 #endif
-- 
1.7.5.4

