Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0H0W7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:59:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56157 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab0H0W7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:59:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] Blackfin: punt duplicate SPORT MMR defines
Date: Fri, 27 Aug 2010 19:08:37 -0400
Message-Id: <1282950518-7094-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282950518-7094-1-git-send-email-vapier@gentoo.org>
References: <1282950518-7094-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The common bfin_sport.h header now has unified definitions of these, so
stop polluting the global namespace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/bfin_sport.h             |    6 -
 .../mach-bf518/include/mach/defBF51x_base.h        |   82 ---------------
 .../mach-bf527/include/mach/defBF52x_base.h        |   82 ---------------
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |   92 -----------------
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |   80 ---------------
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |  107 --------------------
 .../mach-bf548/include/mach/defBF54x_base.h        |   67 ------------
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |   60 -----------
 8 files changed, 0 insertions(+), 576 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin_sport.h b/arch/blackfin/include/asm/bfin_sport.h
index 9626cf7..d27600c2 100644
--- a/arch/blackfin/include/asm/bfin_sport.h
+++ b/arch/blackfin/include/asm/bfin_sport.h
@@ -115,12 +115,6 @@ struct sport_register {
 
 #endif
 
-/* Workaround defBF*.h SPORT MMRs till they get cleansed */
-#undef DTYPE_NORM
-#undef SLEN
-#undef SP_WOFF
-#undef SP_WSIZE
-
 /* SPORT_TCR1 Masks */
 #define TSPEN		0x0001	/* TX enable */
 #define ITCLK		0x0002	/* Internal TX Clock Select */
diff --git a/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h b/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
index 2bc8f4f..037a51f 100644
--- a/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
+++ b/arch/blackfin/mach-bf518/include/mach/defBF51x_base.h
@@ -913,88 +913,6 @@
 #define PH6		0x0040
 #define PH7		0x0080
 
-
-/* *******************  SERIAL PORT MASKS  **************************************/
-/* SPORTx_TCR1 Masks															*/
-#define TSPEN		0x0001		/* Transmit Enable								*/
-#define ITCLK		0x0002		/* Internal Transmit Clock Select				*/
-#define DTYPE_NORM	0x0004		/* Data Format Normal							*/
-#define DTYPE_ULAW	0x0008		/* Compand Using u-Law							*/
-#define DTYPE_ALAW	0x000C		/* Compand Using A-Law							*/
-#define TLSBIT		0x0010		/* Transmit Bit Order							*/
-#define ITFS		0x0200		/* Internal Transmit Frame Sync Select			*/
-#define TFSR		0x0400		/* Transmit Frame Sync Required Select			*/
-#define DITFS		0x0800		/* Data-Independent Transmit Frame Sync Select	*/
-#define LTFS		0x1000		/* Low Transmit Frame Sync Select				*/
-#define LATFS		0x2000		/* Late Transmit Frame Sync Select				*/
-#define TCKFE		0x4000		/* Clock Falling Edge Select					*/
-
-/* SPORTx_TCR2 Masks and Macro													*/
-#define SLEN(x)		((x)&0x1F)	/* SPORT TX Word Length (2 - 31)				*/
-#define TXSE		0x0100		/* TX Secondary Enable							*/
-#define TSFSE		0x0200		/* Transmit Stereo Frame Sync Enable			*/
-#define TRFST		0x0400		/* Left/Right Order (1 = Right Channel 1st)		*/
-
-/* SPORTx_RCR1 Masks															*/
-#define RSPEN		0x0001		/* Receive Enable 								*/
-#define IRCLK		0x0002		/* Internal Receive Clock Select 				*/
-#define DTYPE_NORM	0x0004		/* Data Format Normal							*/
-#define DTYPE_ULAW	0x0008		/* Compand Using u-Law							*/
-#define DTYPE_ALAW	0x000C		/* Compand Using A-Law							*/
-#define RLSBIT		0x0010		/* Receive Bit Order							*/
-#define IRFS		0x0200		/* Internal Receive Frame Sync Select 			*/
-#define RFSR		0x0400		/* Receive Frame Sync Required Select 			*/
-#define LRFS		0x1000		/* Low Receive Frame Sync Select 				*/
-#define LARFS		0x2000		/* Late Receive Frame Sync Select 				*/
-#define RCKFE		0x4000		/* Clock Falling Edge Select 					*/
-
-/* SPORTx_RCR2 Masks															*/
-#define SLEN(x)		((x)&0x1F)	/* SPORT RX Word Length (2 - 31)				*/
-#define RXSE		0x0100		/* RX Secondary Enable							*/
-#define RSFSE		0x0200		/* RX Stereo Frame Sync Enable					*/
-#define RRFST		0x0400		/* Right-First Data Order 						*/
-
-/* SPORTx_STAT Masks															*/
-#define RXNE		0x0001		/* Receive FIFO Not Empty Status				*/
-#define RUVF		0x0002		/* Sticky Receive Underflow Status				*/
-#define ROVF		0x0004		/* Sticky Receive Overflow Status				*/
-#define TXF			0x0008		/* Transmit FIFO Full Status					*/
-#define TUVF		0x0010		/* Sticky Transmit Underflow Status				*/
-#define TOVF		0x0020		/* Sticky Transmit Overflow Status				*/
-#define TXHRE		0x0040		/* Transmit Hold Register Empty					*/
-
-/* SPORTx_MCMC1 Macros															*/
-#define SP_WOFF(x)	((x) & 0x3FF) 	/* Multichannel Window Offset Field			*/
-
-/* Only use WSIZE Macro With Logic OR While Setting Lower Order Bits						*/
-#define SP_WSIZE(x)	(((((x)>>0x3)-1)&0xF) << 0xC)	/* Multichannel Window Size = (x/8)-1	*/
-
-/* SPORTx_MCMC2 Masks															*/
-#define REC_BYPASS	0x0000		/* Bypass Mode (No Clock Recovery)				*/
-#define REC_2FROM4	0x0002		/* Recover 2 MHz Clock from 4 MHz Clock			*/
-#define REC_8FROM16	0x0003		/* Recover 8 MHz Clock from 16 MHz Clock		*/
-#define MCDTXPE		0x0004 		/* Multichannel DMA Transmit Packing			*/
-#define MCDRXPE		0x0008 		/* Multichannel DMA Receive Packing				*/
-#define MCMEN		0x0010 		/* Multichannel Frame Mode Enable				*/
-#define FSDR		0x0080 		/* Multichannel Frame Sync to Data Relationship	*/
-#define MFD_0		0x0000		/* Multichannel Frame Delay = 0					*/
-#define MFD_1		0x1000		/* Multichannel Frame Delay = 1					*/
-#define MFD_2		0x2000		/* Multichannel Frame Delay = 2					*/
-#define MFD_3		0x3000		/* Multichannel Frame Delay = 3					*/
-#define MFD_4		0x4000		/* Multichannel Frame Delay = 4					*/
-#define MFD_5		0x5000		/* Multichannel Frame Delay = 5					*/
-#define MFD_6		0x6000		/* Multichannel Frame Delay = 6					*/
-#define MFD_7		0x7000		/* Multichannel Frame Delay = 7					*/
-#define MFD_8		0x8000		/* Multichannel Frame Delay = 8					*/
-#define MFD_9		0x9000		/* Multichannel Frame Delay = 9					*/
-#define MFD_10		0xA000		/* Multichannel Frame Delay = 10				*/
-#define MFD_11		0xB000		/* Multichannel Frame Delay = 11				*/
-#define MFD_12		0xC000		/* Multichannel Frame Delay = 12				*/
-#define MFD_13		0xD000		/* Multichannel Frame Delay = 13				*/
-#define MFD_14		0xE000		/* Multichannel Frame Delay = 14				*/
-#define MFD_15		0xF000		/* Multichannel Frame Delay = 15				*/
-
-
 /* *********************  ASYNCHRONOUS MEMORY CONTROLLER MASKS  *************************/
 /* EBIU_AMGCTL Masks																	*/
 #define AMCKEN			0x0001		/* Enable CLKOUT									*/
diff --git a/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h b/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
index 5f97f01..3e00075 100644
--- a/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
+++ b/arch/blackfin/mach-bf527/include/mach/defBF52x_base.h
@@ -922,88 +922,6 @@
 #define PH14	0x4000
 #define PH15	0x8000
 
-
-/* *******************  SERIAL PORT MASKS  **************************************/
-/* SPORTx_TCR1 Masks															*/
-#define TSPEN		0x0001		/* Transmit Enable								*/
-#define ITCLK		0x0002		/* Internal Transmit Clock Select				*/
-#define DTYPE_NORM	0x0004		/* Data Format Normal							*/
-#define DTYPE_ULAW	0x0008		/* Compand Using u-Law							*/
-#define DTYPE_ALAW	0x000C		/* Compand Using A-Law							*/
-#define TLSBIT		0x0010		/* Transmit Bit Order							*/
-#define ITFS		0x0200		/* Internal Transmit Frame Sync Select			*/
-#define TFSR		0x0400		/* Transmit Frame Sync Required Select			*/
-#define DITFS		0x0800		/* Data-Independent Transmit Frame Sync Select	*/
-#define LTFS		0x1000		/* Low Transmit Frame Sync Select				*/
-#define LATFS		0x2000		/* Late Transmit Frame Sync Select				*/
-#define TCKFE		0x4000		/* Clock Falling Edge Select					*/
-
-/* SPORTx_TCR2 Masks and Macro													*/
-#define SLEN(x)		((x)&0x1F)	/* SPORT TX Word Length (2 - 31)				*/
-#define TXSE		0x0100		/* TX Secondary Enable							*/
-#define TSFSE		0x0200		/* Transmit Stereo Frame Sync Enable			*/
-#define TRFST		0x0400		/* Left/Right Order (1 = Right Channel 1st)		*/
-
-/* SPORTx_RCR1 Masks															*/
-#define RSPEN		0x0001		/* Receive Enable 								*/
-#define IRCLK		0x0002		/* Internal Receive Clock Select 				*/
-#define DTYPE_NORM	0x0004		/* Data Format Normal							*/
-#define DTYPE_ULAW	0x0008		/* Compand Using u-Law							*/
-#define DTYPE_ALAW	0x000C		/* Compand Using A-Law							*/
-#define RLSBIT		0x0010		/* Receive Bit Order							*/
-#define IRFS		0x0200		/* Internal Receive Frame Sync Select 			*/
-#define RFSR		0x0400		/* Receive Frame Sync Required Select 			*/
-#define LRFS		0x1000		/* Low Receive Frame Sync Select 				*/
-#define LARFS		0x2000		/* Late Receive Frame Sync Select 				*/
-#define RCKFE		0x4000		/* Clock Falling Edge Select 					*/
-
-/* SPORTx_RCR2 Masks															*/
-#define SLEN(x)		((x)&0x1F)	/* SPORT RX Word Length (2 - 31)				*/
-#define RXSE		0x0100		/* RX Secondary Enable							*/
-#define RSFSE		0x0200		/* RX Stereo Frame Sync Enable					*/
-#define RRFST		0x0400		/* Right-First Data Order 						*/
-
-/* SPORTx_STAT Masks															*/
-#define RXNE		0x0001		/* Receive FIFO Not Empty Status				*/
-#define RUVF		0x0002		/* Sticky Receive Underflow Status				*/
-#define ROVF		0x0004		/* Sticky Receive Overflow Status				*/
-#define TXF			0x0008		/* Transmit FIFO Full Status					*/
-#define TUVF		0x0010		/* Sticky Transmit Underflow Status				*/
-#define TOVF		0x0020		/* Sticky Transmit Overflow Status				*/
-#define TXHRE		0x0040		/* Transmit Hold Register Empty					*/
-
-/* SPORTx_MCMC1 Macros															*/
-#define SP_WOFF(x)	((x) & 0x3FF) 	/* Multichannel Window Offset Field			*/
-
-/* Only use WSIZE Macro With Logic OR While Setting Lower Order Bits						*/
-#define SP_WSIZE(x)	(((((x)>>0x3)-1)&0xF) << 0xC)	/* Multichannel Window Size = (x/8)-1	*/
-
-/* SPORTx_MCMC2 Masks															*/
-#define REC_BYPASS	0x0000		/* Bypass Mode (No Clock Recovery)				*/
-#define REC_2FROM4	0x0002		/* Recover 2 MHz Clock from 4 MHz Clock			*/
-#define REC_8FROM16	0x0003		/* Recover 8 MHz Clock from 16 MHz Clock		*/
-#define MCDTXPE		0x0004 		/* Multichannel DMA Transmit Packing			*/
-#define MCDRXPE		0x0008 		/* Multichannel DMA Receive Packing				*/
-#define MCMEN		0x0010 		/* Multichannel Frame Mode Enable				*/
-#define FSDR		0x0080 		/* Multichannel Frame Sync to Data Relationship	*/
-#define MFD_0		0x0000		/* Multichannel Frame Delay = 0					*/
-#define MFD_1		0x1000		/* Multichannel Frame Delay = 1					*/
-#define MFD_2		0x2000		/* Multichannel Frame Delay = 2					*/
-#define MFD_3		0x3000		/* Multichannel Frame Delay = 3					*/
-#define MFD_4		0x4000		/* Multichannel Frame Delay = 4					*/
-#define MFD_5		0x5000		/* Multichannel Frame Delay = 5					*/
-#define MFD_6		0x6000		/* Multichannel Frame Delay = 6					*/
-#define MFD_7		0x7000		/* Multichannel Frame Delay = 7					*/
-#define MFD_8		0x8000		/* Multichannel Frame Delay = 8					*/
-#define MFD_9		0x9000		/* Multichannel Frame Delay = 9					*/
-#define MFD_10		0xA000		/* Multichannel Frame Delay = 10				*/
-#define MFD_11		0xB000		/* Multichannel Frame Delay = 11				*/
-#define MFD_12		0xC000		/* Multichannel Frame Delay = 12				*/
-#define MFD_13		0xD000		/* Multichannel Frame Delay = 13				*/
-#define MFD_14		0xE000		/* Multichannel Frame Delay = 14				*/
-#define MFD_15		0xF000		/* Multichannel Frame Delay = 15				*/
-
-
 /* *********************  ASYNCHRONOUS MEMORY CONTROLLER MASKS  *************************/
 /* EBIU_AMGCTL Masks																	*/
 #define AMCKEN			0x0001		/* Enable CLKOUT									*/
diff --git a/arch/blackfin/mach-bf533/include/mach/defBF532.h b/arch/blackfin/mach-bf533/include/mach/defBF532.h
index e9ff491..04acf1e 100644
--- a/arch/blackfin/mach-bf533/include/mach/defBF532.h
+++ b/arch/blackfin/mach-bf533/include/mach/defBF532.h
@@ -509,98 +509,6 @@
 #define IREN_P	0x01
 #define UCEN_P	0x00
 
-/* **********  SERIAL PORT MASKS  ********************** */
-
-/* SPORTx_TCR1 Masks */
-#define TSPEN    0x0001		/* TX enable  */
-#define ITCLK    0x0002		/* Internal TX Clock Select  */
-#define TDTYPE   0x000C		/* TX Data Formatting Select */
-#define DTYPE_NORM	0x0000		/* Data Format Normal							*/
-#define DTYPE_ULAW	0x0008		/* Compand Using u-Law							*/
-#define DTYPE_ALAW	0x000C		/* Compand Using A-Law							*/
-#define TLSBIT   0x0010		/* TX Bit Order */
-#define ITFS     0x0200		/* Internal TX Frame Sync Select  */
-#define TFSR     0x0400		/* TX Frame Sync Required Select  */
-#define DITFS    0x0800		/* Data Independent TX Frame Sync Select  */
-#define LTFS     0x1000		/* Low TX Frame Sync Select  */
-#define LATFS    0x2000		/* Late TX Frame Sync Select  */
-#define TCKFE    0x4000		/* TX Clock Falling Edge Select  */
-
-/* SPORTx_TCR2 Masks */
-#if defined(__ADSPBF531__) || defined(__ADSPBF532__) || \
-    defined(__ADSPBF533__)
-# define SLEN	    0x001F	/*TX Word Length  */
-#else
-# define SLEN(x)		((x)&0x1F)	/* SPORT TX Word Length (2 - 31)				*/
-#endif
-#define TXSE        0x0100	/*TX Secondary Enable */
-#define TSFSE       0x0200	/*TX Stereo Frame Sync Enable */
-#define TRFST       0x0400	/*TX Right-First Data Order  */
-
-/* SPORTx_RCR1 Masks */
-#define RSPEN    0x0001		/* RX enable  */
-#define IRCLK    0x0002		/* Internal RX Clock Select  */
-#define RDTYPE   0x000C		/* RX Data Formatting Select */
-#define DTYPE_NORM	0x0000		/* no companding							*/
-#define DTYPE_ULAW	0x0008		/* Compand Using u-Law							*/
-#define DTYPE_ALAW	0x000C		/* Compand Using A-Law							*/
-#define RLSBIT   0x0010		/* RX Bit Order */
-#define IRFS     0x0200		/* Internal RX Frame Sync Select  */
-#define RFSR     0x0400		/* RX Frame Sync Required Select  */
-#define LRFS     0x1000		/* Low RX Frame Sync Select  */
-#define LARFS    0x2000		/* Late RX Frame Sync Select  */
-#define RCKFE    0x4000		/* RX Clock Falling Edge Select  */
-
-/* SPORTx_RCR2 Masks */
-/* SLEN defined above */
-#define RXSE        0x0100	/*RX Secondary Enable */
-#define RSFSE       0x0200	/*RX Stereo Frame Sync Enable */
-#define RRFST       0x0400	/*Right-First Data Order  */
-
-/*SPORTx_STAT Masks */
-#define RXNE		0x0001	/*RX FIFO Not Empty Status */
-#define RUVF	    	0x0002	/*RX Underflow Status */
-#define ROVF		0x0004	/*RX Overflow Status */
-#define TXF		0x0008	/*TX FIFO Full Status */
-#define TUVF         	0x0010	/*TX Underflow Status */
-#define TOVF         	0x0020	/*TX Overflow Status */
-#define TXHRE        	0x0040	/*TX Hold Register Empty */
-
-/*SPORTx_MCMC1 Masks */
-#define SP_WSIZE		0x0000F000	/*Multichannel Window Size Field */
-#define SP_WOFF		0x000003FF	/*Multichannel Window Offset Field */
-/* SPORTx_MCMC1 Macros															*/
-#define SET_SP_WOFF(x)	((x) & 0x3FF) 	/* Multichannel Window Offset Field			*/
-/* Only use SET_WSIZE Macro With Logic OR While Setting Lower Order Bits						*/
-#define SET_SP_WSIZE(x)	(((((x)>>0x3)-1)&0xF) << 0xC)	/* Multichannel Window Size = (x/8)-1	*/
-
-/*SPORTx_MCMC2 Masks */
-#define MCCRM		0x00000003 	/*Multichannel Clock Recovery Mode */
-#define REC_BYPASS	0x0000		/* Bypass Mode (No Clock Recovery)				*/
-#define REC_2FROM4	0x0002		/* Recover 2 MHz Clock from 4 MHz Clock			*/
-#define REC_8FROM16	0x0003		/* Recover 8 MHz Clock from 16 MHz Clock		*/
-#define MCDTXPE		0x00000004 	/*Multichannel DMA Transmit Packing */
-#define MCDRXPE		0x00000008 	/*Multichannel DMA Receive Packing */
-#define MCMEN		0x00000010 	/*Multichannel Frame Mode Enable */
-#define FSDR		0x00000080 	/*Multichannel Frame Sync to Data Relationship */
-#define MFD		0x0000F000 	/*Multichannel Frame Delay    */
-#define MFD_0		0x0000		/* Multichannel Frame Delay = 0					*/
-#define MFD_1		0x1000		/* Multichannel Frame Delay = 1					*/
-#define MFD_2		0x2000		/* Multichannel Frame Delay = 2					*/
-#define MFD_3		0x3000		/* Multichannel Frame Delay = 3					*/
-#define MFD_4		0x4000		/* Multichannel Frame Delay = 4					*/
-#define MFD_5		0x5000		/* Multichannel Frame Delay = 5					*/
-#define MFD_6		0x6000		/* Multichannel Frame Delay = 6					*/
-#define MFD_7		0x7000		/* Multichannel Frame Delay = 7					*/
-#define MFD_8		0x8000		/* Multichannel Frame Delay = 8					*/
-#define MFD_9		0x9000		/* Multichannel Frame Delay = 9					*/
-#define MFD_10		0xA000		/* Multichannel Frame Delay = 10				*/
-#define MFD_11		0xB000		/* Multichannel Frame Delay = 11				*/
-#define MFD_12		0xC000		/* Multichannel Frame Delay = 12				*/
-#define MFD_13		0xD000		/* Multichannel Frame Delay = 13				*/
-#define MFD_14		0xE000		/* Multichannel Frame Delay = 14				*/
-#define MFD_15		0xF000		/* Multichannel Frame Delay = 15				*/
-
 /*  *********  PARALLEL PERIPHERAL INTERFACE (PPI) MASKS ****************   */
 
 /*  PPI_CONTROL Masks         */
diff --git a/arch/blackfin/mach-bf537/include/mach/defBF534.h b/arch/blackfin/mach-bf537/include/mach/defBF534.h
index aad61b8..6f56907 100644
--- a/arch/blackfin/mach-bf537/include/mach/defBF534.h
+++ b/arch/blackfin/mach-bf537/include/mach/defBF534.h
@@ -1241,86 +1241,6 @@
 #define PH14	0x4000
 #define PH15	0x8000
 
-/* *******************  SERIAL PORT MASKS  **************************************/
-/* SPORTx_TCR1 Masks															*/
-#define TSPEN		0x0001	/* Transmit Enable                                                              */
-#define ITCLK		0x0002	/* Internal Transmit Clock Select                               */
-#define DTYPE_NORM	0x0004	/* Data Format Normal                                                   */
-#define DTYPE_ULAW	0x0008	/* Compand Using u-Law                                                  */
-#define DTYPE_ALAW	0x000C	/* Compand Using A-Law                                                  */
-#define TLSBIT		0x0010	/* Transmit Bit Order                                                   */
-#define ITFS		0x0200	/* Internal Transmit Frame Sync Select                  */
-#define TFSR		0x0400	/* Transmit Frame Sync Required Select                  */
-#define DITFS		0x0800	/* Data-Independent Transmit Frame Sync Select  */
-#define LTFS		0x1000	/* Low Transmit Frame Sync Select                               */
-#define LATFS		0x2000	/* Late Transmit Frame Sync Select                              */
-#define TCKFE		0x4000	/* Clock Falling Edge Select                                    */
-
-/* SPORTx_TCR2 Masks and Macro													*/
-#define SLEN(x)		((x)&0x1F)	/* SPORT TX Word Length (2 - 31)                                */
-#define TXSE		0x0100	/* TX Secondary Enable                                                  */
-#define TSFSE		0x0200	/* Transmit Stereo Frame Sync Enable                    */
-#define TRFST		0x0400	/* Left/Right Order (1 = Right Channel 1st)             */
-
-/* SPORTx_RCR1 Masks															*/
-#define RSPEN		0x0001	/* Receive Enable                                                               */
-#define IRCLK		0x0002	/* Internal Receive Clock Select                                */
-#define DTYPE_NORM	0x0004	/* Data Format Normal                                                   */
-#define DTYPE_ULAW	0x0008	/* Compand Using u-Law                                                  */
-#define DTYPE_ALAW	0x000C	/* Compand Using A-Law                                                  */
-#define RLSBIT		0x0010	/* Receive Bit Order                                                    */
-#define IRFS		0x0200	/* Internal Receive Frame Sync Select                   */
-#define RFSR		0x0400	/* Receive Frame Sync Required Select                   */
-#define LRFS		0x1000	/* Low Receive Frame Sync Select                                */
-#define LARFS		0x2000	/* Late Receive Frame Sync Select                               */
-#define RCKFE		0x4000	/* Clock Falling Edge Select                                    */
-
-/* SPORTx_RCR2 Masks															*/
-#define SLEN(x)		((x)&0x1F)	/* SPORT RX Word Length (2 - 31)                                */
-#define RXSE		0x0100	/* RX Secondary Enable                                                  */
-#define RSFSE		0x0200	/* RX Stereo Frame Sync Enable                                  */
-#define RRFST		0x0400	/* Right-First Data Order                                               */
-
-/* SPORTx_STAT Masks															*/
-#define RXNE		0x0001	/* Receive FIFO Not Empty Status                                */
-#define RUVF		0x0002	/* Sticky Receive Underflow Status                              */
-#define ROVF		0x0004	/* Sticky Receive Overflow Status                               */
-#define TXF			0x0008	/* Transmit FIFO Full Status                                    */
-#define TUVF		0x0010	/* Sticky Transmit Underflow Status                             */
-#define TOVF		0x0020	/* Sticky Transmit Overflow Status                              */
-#define TXHRE		0x0040	/* Transmit Hold Register Empty                                 */
-
-/* SPORTx_MCMC1 Macros															*/
-#define SP_WOFF(x)		((x) & 0x3FF)	/* Multichannel Window Offset Field                     */
-
-/* Only use WSIZE Macro With Logic OR While Setting Lower Order Bits						*/
-#define SP_WSIZE(x)	(((((x)>>0x3)-1)&0xF) << 0xC)	/* Multichannel Window Size = (x/8)-1   */
-
-/* SPORTx_MCMC2 Masks															*/
-#define REC_BYPASS	0x0000	/* Bypass Mode (No Clock Recovery)                              */
-#define REC_2FROM4	0x0002	/* Recover 2 MHz Clock from 4 MHz Clock                 */
-#define REC_8FROM16	0x0003	/* Recover 8 MHz Clock from 16 MHz Clock                */
-#define MCDTXPE		0x0004	/* Multichannel DMA Transmit Packing                    */
-#define MCDRXPE		0x0008	/* Multichannel DMA Receive Packing                             */
-#define MCMEN		0x0010	/* Multichannel Frame Mode Enable                               */
-#define FSDR		0x0080	/* Multichannel Frame Sync to Data Relationship */
-#define MFD_0		0x0000	/* Multichannel Frame Delay = 0                                 */
-#define MFD_1		0x1000	/* Multichannel Frame Delay = 1                                 */
-#define MFD_2		0x2000	/* Multichannel Frame Delay = 2                                 */
-#define MFD_3		0x3000	/* Multichannel Frame Delay = 3                                 */
-#define MFD_4		0x4000	/* Multichannel Frame Delay = 4                                 */
-#define MFD_5		0x5000	/* Multichannel Frame Delay = 5                                 */
-#define MFD_6		0x6000	/* Multichannel Frame Delay = 6                                 */
-#define MFD_7		0x7000	/* Multichannel Frame Delay = 7                                 */
-#define MFD_8		0x8000	/* Multichannel Frame Delay = 8                                 */
-#define MFD_9		0x9000	/* Multichannel Frame Delay = 9                                 */
-#define MFD_10		0xA000	/* Multichannel Frame Delay = 10                                */
-#define MFD_11		0xB000	/* Multichannel Frame Delay = 11                                */
-#define MFD_12		0xC000	/* Multichannel Frame Delay = 12                                */
-#define MFD_13		0xD000	/* Multichannel Frame Delay = 13                                */
-#define MFD_14		0xE000	/* Multichannel Frame Delay = 14                                */
-#define MFD_15		0xF000	/* Multichannel Frame Delay = 15                                */
-
 /* *********************  ASYNCHRONOUS MEMORY CONTROLLER MASKS  *************************/
 /* EBIU_AMGCTL Masks																	*/
 #define AMCKEN			0x0001	/* Enable CLKOUT                                                                        */
diff --git a/arch/blackfin/mach-bf538/include/mach/defBF539.h b/arch/blackfin/mach-bf538/include/mach/defBF539.h
index b674a1c..fe43062 100644
--- a/arch/blackfin/mach-bf538/include/mach/defBF539.h
+++ b/arch/blackfin/mach-bf538/include/mach/defBF539.h
@@ -1610,113 +1610,6 @@
 #define	UCEN_P		0x00
 
 
-/* **********  SERIAL PORT MASKS  ********************** */
-/* SPORTx_TCR1 Masks */
-#define	TSPEN		0x0001	/* TX enable  */
-#define	ITCLK		0x0002	/* Internal TX Clock Select  */
-#define	TDTYPE		0x000C	/* TX Data Formatting Select */
-#define	DTYPE_NORM	0x0000		/* Data	Format Normal */
-#define	DTYPE_ULAW	0x0008		/* Compand Using u-Law */
-#define	DTYPE_ALAW	0x000C		/* Compand Using A-Law */
-#define	TLSBIT		0x0010	/* TX Bit Order */
-#define	ITFS		0x0200	/* Internal TX Frame Sync Select  */
-#define	TFSR		0x0400	/* TX Frame Sync Required Select  */
-#define	DITFS		0x0800	/* Data	Independent TX Frame Sync Select  */
-#define	LTFS		0x1000	/* Low TX Frame	Sync Select  */
-#define	LATFS		0x2000	/* Late	TX Frame Sync Select  */
-#define	TCKFE		0x4000	/* TX Clock Falling Edge Select */
-/* SPORTx_RCR1 Deprecated Masks								 */
-#define	TULAW		DTYPE_ULAW		/* Compand Using u-Law */
-#define	TALAW		DTYPE_ALAW			/* Compand Using A-Law */
-
-/* SPORTx_TCR2 Masks */
-#ifdef _MISRA_RULES
-#define	SLEN(x)		((x)&0x1Fu)	/* SPORT TX Word Length	(2 - 31) */
-#else
-#define	SLEN(x)		((x)&0x1F)	/* SPORT TX Word Length	(2 - 31) */
-#endif /* _MISRA_RULES */
-#define	TXSE		0x0100	/*TX Secondary Enable */
-#define	TSFSE		0x0200	/*TX Stereo Frame Sync Enable */
-#define	TRFST		0x0400	/*TX Right-First Data Order  */
-
-/* SPORTx_RCR1 Masks */
-#define	RSPEN		0x0001	/* RX enable  */
-#define	IRCLK		0x0002	/* Internal RX Clock Select  */
-#define	RDTYPE		0x000C	/* RX Data Formatting Select */
-#define	DTYPE_NORM	0x0000		/* no companding */
-#define	DTYPE_ULAW	0x0008		/* Compand Using u-Law */
-#define	DTYPE_ALAW	0x000C		/* Compand Using A-Law */
-#define	RLSBIT		0x0010	/* RX Bit Order */
-#define	IRFS		0x0200	/* Internal RX Frame Sync Select  */
-#define	RFSR		0x0400	/* RX Frame Sync Required Select  */
-#define	LRFS		0x1000	/* Low RX Frame	Sync Select  */
-#define	LARFS		0x2000	/* Late	RX Frame Sync Select  */
-#define	RCKFE		0x4000	/* RX Clock Falling Edge Select */
-/* SPORTx_RCR1 Deprecated Masks								 */
-#define	RULAW		DTYPE_ULAW		/* Compand Using u-Law */
-#define	RALAW		DTYPE_ALAW			/* Compand Using A-Law */
-
-/* SPORTx_RCR2 Masks */
-#ifdef _MISRA_RULES
-#define	SLEN(x)		((x)&0x1Fu)	/* SPORT RX Word Length	(2 - 31) */
-#else
-#define	SLEN(x)		((x)&0x1F)	/* SPORT RX Word Length	(2 - 31) */
-#endif /* _MISRA_RULES */
-#define	RXSE		0x0100	/*RX Secondary Enable */
-#define	RSFSE		0x0200	/*RX Stereo Frame Sync Enable */
-#define	RRFST		0x0400	/*Right-First Data Order  */
-
-/*SPORTx_STAT Masks */
-#define	RXNE		0x0001		/*RX FIFO Not Empty Status */
-#define	RUVF		0x0002		/*RX Underflow Status */
-#define	ROVF		0x0004		/*RX Overflow Status */
-#define	TXF			0x0008		/*TX FIFO Full Status */
-#define	TUVF		0x0010		/*TX Underflow Status */
-#define	TOVF		0x0020		/*TX Overflow Status */
-#define	TXHRE		0x0040		/*TX Hold Register Empty */
-
-/*SPORTx_MCMC1 Masks */
-#define	WOFF			0x000003FF	/*Multichannel Window Offset Field */
-/* SPORTx_MCMC1	Macros								 */
-#ifdef _MISRA_RULES
-#define	SET_WOFF(x)		((x) & 0x3FFu)	/* Multichannel	Window Offset Field */
-/* Only	use SET_WSIZE Macro With Logic OR While	Setting	Lower Order Bits */
-#define	SET_WSIZE(x)	(((((x)>>0x3)-1u)&0xFu)	<< 0xC)	/* Multichannel	Window Size = (x/8)-1 */
-#else
-#define	SET_WOFF(x)		((x) & 0x3FF)	/* Multichannel	Window Offset Field */
-/* Only	use SET_WSIZE Macro With Logic OR While	Setting	Lower Order Bits */
-#define	SET_WSIZE(x)	(((((x)>>0x3)-1)&0xF) << 0xC)	/* Multichannel	Window Size = (x/8)-1 */
-#endif /* _MISRA_RULES */
-
-
-/*SPORTx_MCMC2 Masks */
-#define	MCCRM		0x0003	/*Multichannel Clock Recovery Mode */
-#define	REC_BYPASS	0x0000		/* Bypass Mode (No Clock Recovery) */
-#define	REC_2FROM4	0x0002		/* Recover 2 MHz Clock from 4 MHz Clock */
-#define	REC_8FROM16	0x0003		/* Recover 8 MHz Clock from 16 MHz Clock */
-#define	MCDTXPE		0x0004	/*Multichannel DMA Transmit Packing */
-#define	MCDRXPE		0x0008	/*Multichannel DMA Receive Packing */
-#define	MCMEN		0x0010	/*Multichannel Frame Mode Enable */
-#define	FSDR		0x0080	/*Multichannel Frame Sync to Data Relationship */
-#define	MFD			0xF000	/*Multichannel Frame Delay    */
-#define	MFD_0		0x0000		/* Multichannel	Frame Delay = 0 */
-#define	MFD_1		0x1000		/* Multichannel	Frame Delay = 1 */
-#define	MFD_2		0x2000		/* Multichannel	Frame Delay = 2 */
-#define	MFD_3		0x3000		/* Multichannel	Frame Delay = 3 */
-#define	MFD_4		0x4000		/* Multichannel	Frame Delay = 4 */
-#define	MFD_5		0x5000		/* Multichannel	Frame Delay = 5 */
-#define	MFD_6		0x6000		/* Multichannel	Frame Delay = 6 */
-#define	MFD_7		0x7000		/* Multichannel	Frame Delay = 7 */
-#define	MFD_8		0x8000		/* Multichannel	Frame Delay = 8 */
-#define	MFD_9		0x9000		/* Multichannel	Frame Delay = 9 */
-#define	MFD_10		0xA000		/* Multichannel	Frame Delay = 10 */
-#define	MFD_11		0xB000		/* Multichannel	Frame Delay = 11 */
-#define	MFD_12		0xC000		/* Multichannel	Frame Delay = 12 */
-#define	MFD_13		0xD000		/* Multichannel	Frame Delay = 13 */
-#define	MFD_14		0xE000		/* Multichannel	Frame Delay = 14 */
-#define	MFD_15		0xF000		/* Multichannel	Frame Delay = 15 */
-
-
 /*  *********  PARALLEL	PERIPHERAL INTERFACE (PPI) MASKS ****************   */
 /*  PPI_CONTROL	Masks	      */
 #define	PORT_EN		0x0001	/* PPI Port Enable  */
diff --git a/arch/blackfin/mach-bf548/include/mach/defBF54x_base.h b/arch/blackfin/mach-bf548/include/mach/defBF54x_base.h
index 95ff446..7866197 100644
--- a/arch/blackfin/mach-bf548/include/mach/defBF54x_base.h
+++ b/arch/blackfin/mach-bf548/include/mach/defBF54x_base.h
@@ -2221,73 +2221,6 @@
 
 #define                 RCVDATA16  0xffff     /* Receive FIFO 16-Bit Data */
 
-/* Bit masks for SPORTx_TCR1 */
-
-#define                     TCKFE  0x4000     /* Clock Falling Edge Select */
-#define                     LATFS  0x2000     /* Late Transmit Frame Sync */
-#define                      LTFS  0x1000     /* Low Transmit Frame Sync Select */
-#define                     DITFS  0x800      /* Data-Independent Transmit Frame Sync Select */
-#define                      TFSR  0x400      /* Transmit Frame Sync Required Select */
-#define                      ITFS  0x200      /* Internal Transmit Frame Sync Select */
-#define                    TLSBIT  0x10       /* Transmit Bit Order */
-#define                    TDTYPE  0xc        /* Data Formatting Type Select */
-#define                     ITCLK  0x2        /* Internal Transmit Clock Select */
-#define                     TSPEN  0x1        /* Transmit Enable */
-
-/* Bit masks for SPORTx_TCR2 */
-
-#define                     TRFST  0x400      /* Left/Right Order */
-#define                     TSFSE  0x200      /* Transmit Stereo Frame Sync Enable */
-#define                      TXSE  0x100      /* TxSEC Enable */
-#define                    SLEN_T  0x1f       /* SPORT Word Length */
-
-/* Bit masks for SPORTx_RCR1 */
-
-#define                     RCKFE  0x4000     /* Clock Falling Edge Select */
-#define                     LARFS  0x2000     /* Late Receive Frame Sync */
-#define                      LRFS  0x1000     /* Low Receive Frame Sync Select */
-#define                      RFSR  0x400      /* Receive Frame Sync Required Select */
-#define                      IRFS  0x200      /* Internal Receive Frame Sync Select */
-#define                    RLSBIT  0x10       /* Receive Bit Order */
-#define                    RDTYPE  0xc        /* Data Formatting Type Select */
-#define                     IRCLK  0x2        /* Internal Receive Clock Select */
-#define                     RSPEN  0x1        /* Receive Enable */
-
-/* Bit masks for SPORTx_RCR2 */
-
-#define                     RRFST  0x400      /* Left/Right Order */
-#define                     RSFSE  0x200      /* Receive Stereo Frame Sync Enable */
-#define                      RXSE  0x100      /* RxSEC Enable */
-#define                    SLEN_R  0x1f       /* SPORT Word Length */
-
-/* Bit masks for SPORTx_STAT */
-
-#define                     TXHRE  0x40       /* Transmit Hold Register Empty */
-#define                      TOVF  0x20       /* Sticky Transmit Overflow Status */
-#define                      TUVF  0x10       /* Sticky Transmit Underflow Status */
-#define                       TXF  0x8        /* Transmit FIFO Full Status */
-#define                      ROVF  0x4        /* Sticky Receive Overflow Status */
-#define                      RUVF  0x2        /* Sticky Receive Underflow Status */
-#define                      RXNE  0x1        /* Receive FIFO Not Empty Status */
-
-/* Bit masks for SPORTx_MCMC1 */
-
-#define                  SP_WSIZE  0xf000     /* Window Size */
-#define                   SP_WOFF  0x3ff      /* Windows Offset */
-
-/* Bit masks for SPORTx_MCMC2 */
-
-#define                       MFD  0xf000     /* Multi channel Frame Delay */
-#define                      FSDR  0x80       /* Frame Sync to Data Relationship */
-#define                  MCMEN  0x10       /* Multi channel Frame Mode Enable */
-#define                   MCDRXPE  0x8        /* Multi channel DMA Receive Packing */
-#define                   MCDTXPE  0x4        /* Multi channel DMA Transmit Packing */
-#define                     MCCRM  0x3        /* 2X Clock Recovery Mode */
-
-/* Bit masks for SPORTx_CHNL */
-
-#define                  CUR_CHNL  0x3ff      /* Current Channel Indicator */
-
 /* Bit masks for UARTx_LCR */
 
 #if 0
diff --git a/arch/blackfin/mach-bf561/include/mach/defBF561.h b/arch/blackfin/mach-bf561/include/mach/defBF561.h
index 4c8e36b..2674f00 100644
--- a/arch/blackfin/mach-bf561/include/mach/defBF561.h
+++ b/arch/blackfin/mach-bf561/include/mach/defBF561.h
@@ -1007,66 +1007,6 @@
 #define IREN_P	0x01
 #define UCEN_P	0x00
 
-/* **********  SERIAL PORT MASKS  ********************** */
-
-/* SPORTx_TCR1 Masks */
-#define TSPEN    0x0001		/* TX enable  */
-#define ITCLK    0x0002		/* Internal TX Clock Select  */
-#define TDTYPE   0x000C		/* TX Data Formatting Select */
-#define TLSBIT   0x0010		/* TX Bit Order */
-#define ITFS     0x0200		/* Internal TX Frame Sync Select  */
-#define TFSR     0x0400		/* TX Frame Sync Required Select  */
-#define DITFS    0x0800		/* Data Independent TX Frame Sync Select  */
-#define LTFS     0x1000		/* Low TX Frame Sync Select  */
-#define LATFS    0x2000		/* Late TX Frame Sync Select  */
-#define TCKFE    0x4000		/* TX Clock Falling Edge Select  */
-
-/* SPORTx_TCR2 Masks */
-#define SLEN	    0x001F	/*TX Word Length  */
-#define TXSE        0x0100	/*TX Secondary Enable */
-#define TSFSE       0x0200	/*TX Stereo Frame Sync Enable */
-#define TRFST       0x0400	/*TX Right-First Data Order  */
-
-/* SPORTx_RCR1 Masks */
-#define RSPEN    0x0001		/* RX enable  */
-#define IRCLK    0x0002		/* Internal RX Clock Select  */
-#define RDTYPE   0x000C		/* RX Data Formatting Select */
-#define RULAW    0x0008		/* u-Law enable  */
-#define RALAW    0x000C		/* A-Law enable  */
-#define RLSBIT   0x0010		/* RX Bit Order */
-#define IRFS     0x0200		/* Internal RX Frame Sync Select  */
-#define RFSR     0x0400		/* RX Frame Sync Required Select  */
-#define LRFS     0x1000		/* Low RX Frame Sync Select  */
-#define LARFS    0x2000		/* Late RX Frame Sync Select  */
-#define RCKFE    0x4000		/* RX Clock Falling Edge Select  */
-
-/* SPORTx_RCR2 Masks */
-#define SLEN	    0x001F	/*RX Word Length  */
-#define RXSE        0x0100	/*RX Secondary Enable */
-#define RSFSE       0x0200	/*RX Stereo Frame Sync Enable */
-#define RRFST       0x0400	/*Right-First Data Order  */
-
-/*SPORTx_STAT Masks */
-#define RXNE		0x0001	/*RX FIFO Not Empty Status */
-#define RUVF	    	0x0002	/*RX Underflow Status */
-#define ROVF		0x0004	/*RX Overflow Status */
-#define TXF		0x0008	/*TX FIFO Full Status */
-#define TUVF         	0x0010	/*TX Underflow Status */
-#define TOVF         	0x0020	/*TX Overflow Status */
-#define TXHRE        	0x0040	/*TX Hold Register Empty */
-
-/*SPORTx_MCMC1 Masks */
-#define SP_WSIZE		0x0000F000	/*Multichannel Window Size Field */
-#define SP_WOFF		0x000003FF	/*Multichannel Window Offset Field */
-
-/*SPORTx_MCMC2 Masks */
-#define MCCRM		0x00000003	/*Multichannel Clock Recovery Mode */
-#define MCDTXPE		0x00000004	/*Multichannel DMA Transmit Packing */
-#define MCDRXPE		0x00000008	/*Multichannel DMA Receive Packing */
-#define MCMEN		0x00000010	/*Multichannel Frame Mode Enable */
-#define FSDR		0x00000080	/*Multichannel Frame Sync to Data Relationship */
-#define MFD		0x0000F000	/*Multichannel Frame Delay    */
-
 /*  *********  PARALLEL PERIPHERAL INTERFACE (PPI) MASKS ****************   */
 
 /*  PPI_CONTROL Masks         */
-- 
1.7.2.2

