Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab0HZOLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:11:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab0HZOL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:11:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/7] Blackfin: Don't redefine blackfin serial port symbols
To: linux-arch@vger.kernel.org, vapier@gentoo.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Date: Thu, 26 Aug 2010 15:11:15 +0100
Message-ID: <20100826141115.11132.52122.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk>
References: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various Blackfin machine-specific headers override Blackfin serial port
symbols from the <asm/bfin_sport.h> header file with exactly the same values.

Remove the duplicates in favour of the master header.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/blackfin/include/asm/bfin_sport.h             |   16 +++++
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |   27 ---------
 .../mach-bf548/include/mach/defBF54x_base.h        |   59 +-------------------
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |   58 --------------------
 4 files changed, 18 insertions(+), 142 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin_sport.h b/arch/blackfin/include/asm/bfin_sport.h
index 9626cf7..a98533e 100644
--- a/arch/blackfin/include/asm/bfin_sport.h
+++ b/arch/blackfin/include/asm/bfin_sport.h
@@ -189,6 +189,22 @@ struct sport_register {
 #define MCMEN		0x0010	/* Multichannel Frame Mode Enable */
 #define FSDR		0x0080	/* Multichannel Frame Sync to Data Relationship */
 #define MFD		0xF000	/* Multichannel Frame Delay */
+#define MFD_0		0x0000		/* Multichannel Frame Delay = 0	  */
+#define MFD_1		0x1000		/* Multichannel Frame Delay = 1	 */
+#define MFD_2		0x2000		/* Multichannel Frame Delay = 2	 */
+#define MFD_3		0x3000		/* Multichannel Frame Delay = 3	 */
+#define MFD_4		0x4000		/* Multichannel Frame Delay = 4	 */
+#define MFD_5		0x5000		/* Multichannel Frame Delay = 5	 */
+#define MFD_6		0x6000		/* Multichannel Frame Delay = 6	 */
+#define MFD_7		0x7000		/* Multichannel Frame Delay = 7	 */
+#define MFD_8		0x8000		/* Multichannel Frame Delay = 8	 */
+#define MFD_9		0x9000		/* Multichannel Frame Delay = 9	 */
+#define MFD_10		0xA000		/* Multichannel Frame Delay = 10 */
+#define MFD_11		0xB000		/* Multichannel Frame Delay = 11 */
+#define MFD_12		0xC000		/* Multichannel Frame Delay = 12 */
+#define MFD_13		0xD000		/* Multichannel Frame Delay = 13 */
+#define MFD_14		0xE000		/* Multichannel Frame Delay = 14 */
+#define MFD_15		0xF000		/* Multichannel Frame Delay = 15 */
 #define DP_MFD(x)	BFIN_DEPOSIT(MFD, x)
 #define EX_MFD(x)	BFIN_EXTRACT(MFD, x)
 
diff --git a/arch/blackfin/mach-bf533/include/mach/defBF532.h b/arch/blackfin/mach-bf533/include/mach/defBF532.h
index e9ff491..3ebb010 100644
--- a/arch/blackfin/mach-bf533/include/mach/defBF532.h
+++ b/arch/blackfin/mach-bf533/include/mach/defBF532.h
@@ -574,33 +574,6 @@
 /* Only use SET_WSIZE Macro With Logic OR While Setting Lower Order Bits						*/
 #define SET_SP_WSIZE(x)	(((((x)>>0x3)-1)&0xF) << 0xC)	/* Multichannel Window Size = (x/8)-1	*/
 
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
diff --git a/arch/blackfin/mach-bf548/include/mach/defBF54x_base.h b/arch/blackfin/mach-bf548/include/mach/defBF54x_base.h
index 95ff446..77054fd 100644
--- a/arch/blackfin/mach-bf548/include/mach/defBF54x_base.h
+++ b/arch/blackfin/mach-bf548/include/mach/defBF54x_base.h
@@ -2221,68 +2221,13 @@
 
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
 /* Bit masks for SPORTx_TCR2 */
 
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
+#define                    SLEN_T  SLEN       /* SPORT Word Length */
 
 /* Bit masks for SPORTx_RCR2 */
 
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
+#define                    SLEN_R  SLEN       /* SPORT Word Length */
 
 /* Bit masks for SPORTx_CHNL */
 
diff --git a/arch/blackfin/mach-bf561/include/mach/defBF561.h b/arch/blackfin/mach-bf561/include/mach/defBF561.h
index 4c8e36b..cc50b70 100644
--- a/arch/blackfin/mach-bf561/include/mach/defBF561.h
+++ b/arch/blackfin/mach-bf561/include/mach/defBF561.h
@@ -1009,64 +1009,6 @@
 
 /* **********  SERIAL PORT MASKS  ********************** */
 
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

