Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2FGI5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:57:17 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4905 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883Ab2FGI5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:57:09 -0400
Message-ID: <1339059427.25798.3.camel@x61.thuisdomein>
Subject: [PATCH] m68k: remove six unused headers
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Jun 2012 10:57:07 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 07 Jun 2012 08:57:07.0257 (UTC) FILETIME=[84312A90:01CD448B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are six entirely unused headers in arch/m68k/include/asm. Nothing
includes these headers. And a few tests found no hits for the things
they provide (which makes sense).

MC68332.h, mac_mouse.h, mcfmbus.h, and mcfne.h are all unused since at
least v2.6.12-rc2 (I didn't bother looking further back than that).

apollodma.h is unused since v2.6.19: commit
2ed0ce5b57950a620155433c62a5a02a067f1376 ("m68k/Apollo: Remove obsolete
arch/m68k/apollo/dma.c") removed the last file interested in that
header.

And everything interested in <asm/sbus.h> was removed in the v2.6.28
release cycle. The last occurrence of "sbus.h" was deleted with commit
0c0db98b50ed1217c0dbf4051722034ba314d06e ("sparc: Remove
Documentation/sparc/sbus_drivers.txt"). I'm not sure whether anything
relevant for m68k was included in v2.6.27, but it doesn't really matter.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only. I haven't got the hardware nor the
toolchain needed to do anything more thorough.

 arch/m68k/include/asm/MC68332.h   |  152 -----------------------
 arch/m68k/include/asm/apollodma.h |  248 -------------------------------------
 arch/m68k/include/asm/mac_mouse.h |   23 ----
 arch/m68k/include/asm/mcfmbus.h   |   77 ------------
 arch/m68k/include/asm/mcfne.h     |  242 ------------------------------------
 arch/m68k/include/asm/sbus.h      |   45 -------
 6 files changed, 0 insertions(+), 787 deletions(-)
 delete mode 100644 arch/m68k/include/asm/MC68332.h
 delete mode 100644 arch/m68k/include/asm/apollodma.h
 delete mode 100644 arch/m68k/include/asm/mac_mouse.h
 delete mode 100644 arch/m68k/include/asm/mcfmbus.h
 delete mode 100644 arch/m68k/include/asm/mcfne.h
 delete mode 100644 arch/m68k/include/asm/sbus.h

diff --git a/arch/m68k/include/asm/MC68332.h b/arch/m68k/include/asm/MC68332.h
deleted file mode 100644
index 6bb8f02..0000000
--- a/arch/m68k/include/asm/MC68332.h
+++ /dev/null
@@ -1,152 +0,0 @@
-
-/* include/asm-m68knommu/MC68332.h: '332 control registers
- *
- * Copyright (C) 1998  Kenneth Albanowski <kjahds@kjahds.com>,
- *
- */
-
-#ifndef _MC68332_H_
-#define _MC68332_H_
-
-#define BYTE_REF(addr) (*((volatile unsigned char*)addr))
-#define WORD_REF(addr) (*((volatile unsigned short*)addr))
-
-#define PORTE_ADDR	0xfffa11
-#define PORTE	BYTE_REF(PORTE_ADDR)
-#define DDRE_ADDR	0xfffa15
-#define DDRE	BYTE_REF(DDRE_ADDR)
-#define PEPAR_ADDR	0xfffa17
-#define PEPAR	BYTE_REF(PEPAR_ADDR)
-
-#define PORTF_ADDR	0xfffa19
-#define PORTF	BYTE_REF(PORTF_ADDR)
-#define DDRF_ADDR	0xfffa1d
-#define DDRF	BYTE_REF(DDRF_ADDR)
-#define PFPAR_ADDR	0xfffa1f
-#define PFPAR	BYTE_REF(PFPAR_ADDR)
-
-#define PORTQS_ADDR	0xfffc15
-#define PORTQS	BYTE_REF(PORTQS_ADDR)
-#define DDRQS_ADDR	0xfffc17
-#define DDRQS	BYTE_REF(DDRQS_ADDR)
-#define PQSPAR_ADDR	0xfffc16
-#define PQSPAR	BYTE_REF(PQSPAR_ADDR)
-
-#define CSPAR0_ADDR 0xFFFA44
-#define CSPAR0 WORD_REF(CSPAR0_ADDR)
-#define CSPAR1_ADDR 0xFFFA46
-#define CSPAR1 WORD_REF(CSPAR1_ADDR)
-#define CSARBT_ADDR 0xFFFA48
-#define CSARBT WORD_REF(CSARBT_ADDR)
-#define CSOPBT_ADDR 0xFFFA4A
-#define CSOPBT WORD_REF(CSOPBT_ADDR)
-#define CSBAR0_ADDR 0xFFFA4C
-#define CSBAR0 WORD_REF(CSBAR0_ADDR)
-#define CSOR0_ADDR 0xFFFA4E
-#define CSOR0 WORD_REF(CSOR0_ADDR)
-#define CSBAR1_ADDR 0xFFFA50
-#define CSBAR1 WORD_REF(CSBAR1_ADDR)
-#define CSOR1_ADDR 0xFFFA52
-#define CSOR1 WORD_REF(CSOR1_ADDR)
-#define CSBAR2_ADDR 0xFFFA54
-#define CSBAR2 WORD_REF(CSBAR2_ADDR)
-#define CSOR2_ADDR 0xFFFA56
-#define CSOR2 WORD_REF(CSOR2_ADDR)
-#define CSBAR3_ADDR 0xFFFA58
-#define CSBAR3 WORD_REF(CSBAR3_ADDR)
-#define CSOR3_ADDR 0xFFFA5A
-#define CSOR3 WORD_REF(CSOR3_ADDR)
-#define CSBAR4_ADDR 0xFFFA5C
-#define CSBAR4 WORD_REF(CSBAR4_ADDR)
-#define CSOR4_ADDR 0xFFFA5E
-#define CSOR4 WORD_REF(CSOR4_ADDR)
-#define CSBAR5_ADDR 0xFFFA60
-#define CSBAR5 WORD_REF(CSBAR5_ADDR)
-#define CSOR5_ADDR 0xFFFA62
-#define CSOR5 WORD_REF(CSOR5_ADDR)
-#define CSBAR6_ADDR 0xFFFA64
-#define CSBAR6 WORD_REF(CSBAR6_ADDR)
-#define CSOR6_ADDR 0xFFFA66
-#define CSOR6 WORD_REF(CSOR6_ADDR)
-#define CSBAR7_ADDR 0xFFFA68
-#define CSBAR7 WORD_REF(CSBAR7_ADDR)
-#define CSOR7_ADDR 0xFFFA6A
-#define CSOR7 WORD_REF(CSOR7_ADDR)
-#define CSBAR8_ADDR 0xFFFA6C
-#define CSBAR8 WORD_REF(CSBAR8_ADDR)
-#define CSOR8_ADDR 0xFFFA6E
-#define CSOR8 WORD_REF(CSOR8_ADDR)
-#define CSBAR9_ADDR 0xFFFA70
-#define CSBAR9 WORD_REF(CSBAR9_ADDR)
-#define CSOR9_ADDR 0xFFFA72
-#define CSOR9 WORD_REF(CSOR9_ADDR)
-#define CSBAR10_ADDR 0xFFFA74
-#define CSBAR10 WORD_REF(CSBAR10_ADDR)
-#define CSOR10_ADDR 0xFFFA76
-#define CSOR10 WORD_REF(CSOR10_ADDR)
-
-#define CSOR_MODE_ASYNC	0x0000
-#define CSOR_MODE_SYNC	0x8000
-#define CSOR_MODE_MASK	0x8000
-#define CSOR_BYTE_DISABLE	0x0000
-#define CSOR_BYTE_UPPER		0x4000
-#define CSOR_BYTE_LOWER		0x2000
-#define CSOR_BYTE_BOTH		0x6000
-#define CSOR_BYTE_MASK		0x6000
-#define CSOR_RW_RSVD		0x0000
-#define CSOR_RW_READ		0x0800
-#define CSOR_RW_WRITE		0x1000
-#define CSOR_RW_BOTH		0x1800
-#define CSOR_RW_MASK		0x1800
-#define CSOR_STROBE_DS		0x0400
-#define CSOR_STROBE_AS		0x0000
-#define CSOR_STROBE_MASK	0x0400
-#define CSOR_DSACK_WAIT(x)	(wait << 6)
-#define CSOR_DSACK_FTERM	(14 << 6)
-#define CSOR_DSACK_EXTERNAL	(15 << 6)
-#define CSOR_DSACK_MASK		0x03c0
-#define CSOR_SPACE_CPU		0x0000
-#define CSOR_SPACE_USER		0x0010
-#define CSOR_SPACE_SU		0x0020
-#define CSOR_SPACE_BOTH		0x0030
-#define CSOR_SPACE_MASK		0x0030
-#define CSOR_IPL_ALL		0x0000
-#define CSOR_IPL_PRIORITY(x)	(x << 1)
-#define CSOR_IPL_MASK		0x000e
-#define CSOR_AVEC_ON		0x0001
-#define CSOR_AVEC_OFF		0x0000
-#define CSOR_AVEC_MASK		0x0001
-
-#define CSBAR_ADDR(x)		((addr >> 11) << 3) 
-#define CSBAR_ADDR_MASK		0xfff8
-#define CSBAR_BLKSIZE_2K	0x0000
-#define CSBAR_BLKSIZE_8K	0x0001
-#define CSBAR_BLKSIZE_16K	0x0002
-#define CSBAR_BLKSIZE_64K	0x0003
-#define CSBAR_BLKSIZE_128K	0x0004
-#define CSBAR_BLKSIZE_256K	0x0005
-#define CSBAR_BLKSIZE_512K	0x0006
-#define CSBAR_BLKSIZE_1M	0x0007
-#define CSBAR_BLKSIZE_MASK	0x0007
-
-#define CSPAR_DISC	0
-#define CSPAR_ALT	1
-#define CSPAR_CS8	2
-#define CSPAR_CS16	3
-#define CSPAR_MASK	3
-
-#define CSPAR0_CSBOOT(x) (x << 0)
-#define CSPAR0_CS0(x)	(x << 2)
-#define CSPAR0_CS1(x)	(x << 4)
-#define CSPAR0_CS2(x)	(x << 6)
-#define CSPAR0_CS3(x)	(x << 8)
-#define CSPAR0_CS4(x)	(x << 10)
-#define CSPAR0_CS5(x)	(x << 12)
-
-#define CSPAR1_CS6(x)	(x << 0)
-#define CSPAR1_CS7(x)	(x << 2)
-#define CSPAR1_CS8(x)	(x << 4)
-#define CSPAR1_CS9(x)	(x << 6)
-#define CSPAR1_CS10(x)	(x << 8)
-
-#endif
diff --git a/arch/m68k/include/asm/apollodma.h b/arch/m68k/include/asm/apollodma.h
deleted file mode 100644
index 954adc8..0000000
--- a/arch/m68k/include/asm/apollodma.h
+++ /dev/null
@@ -1,248 +0,0 @@
-/*
- * linux/include/asm/dma.h: Defines for using and allocating dma channels.
- * Written by Hennus Bergman, 1992.
- * High DMA channel support & info by Hannu Savolainen
- * and John Boyd, Nov. 1992.
- */
-
-#ifndef _ASM_APOLLO_DMA_H
-#define _ASM_APOLLO_DMA_H
-
-#include <asm/apollohw.h>		/* need byte IO */
-#include <linux/spinlock.h>		/* And spinlocks */
-#include <linux/delay.h>
-
-
-#define dma_outb(val,addr) (*((volatile unsigned char *)(addr+IO_BASE)) = (val))
-#define dma_inb(addr)	   (*((volatile unsigned char *)(addr+IO_BASE)))
-
-/*
- * NOTES about DMA transfers:
- *
- *  controller 1: channels 0-3, byte operations, ports 00-1F
- *  controller 2: channels 4-7, word operations, ports C0-DF
- *
- *  - ALL registers are 8 bits only, regardless of transfer size
- *  - channel 4 is not used - cascades 1 into 2.
- *  - channels 0-3 are byte - addresses/counts are for physical bytes
- *  - channels 5-7 are word - addresses/counts are for physical words
- *  - transfers must not cross physical 64K (0-3) or 128K (5-7) boundaries
- *  - transfer count loaded to registers is 1 less than actual count
- *  - controller 2 offsets are all even (2x offsets for controller 1)
- *  - page registers for 5-7 don't use data bit 0, represent 128K pages
- *  - page registers for 0-3 use bit 0, represent 64K pages
- *
- * DMA transfers are limited to the lower 16MB of _physical_ memory.
- * Note that addresses loaded into registers must be _physical_ addresses,
- * not logical addresses (which may differ if paging is active).
- *
- *  Address mapping for channels 0-3:
- *
- *   A23 ... A16 A15 ... A8  A7 ... A0    (Physical addresses)
- *    |  ...  |   |  ... |   |  ... |
- *    |  ...  |   |  ... |   |  ... |
- *    |  ...  |   |  ... |   |  ... |
- *   P7  ...  P0  A7 ... A0  A7 ... A0
- * |    Page    | Addr MSB | Addr LSB |   (DMA registers)
- *
- *  Address mapping for channels 5-7:
- *
- *   A23 ... A17 A16 A15 ... A9 A8 A7 ... A1 A0    (Physical addresses)
- *    |  ...  |   \   \   ... \  \  \  ... \  \
- *    |  ...  |    \   \   ... \  \  \  ... \  (not used)
- *    |  ...  |     \   \   ... \  \  \  ... \
- *   P7  ...  P1 (0) A7 A6  ... A0 A7 A6 ... A0
- * |      Page      |  Addr MSB   |  Addr LSB  |   (DMA registers)
- *
- * Again, channels 5-7 transfer _physical_ words (16 bits), so addresses
- * and counts _must_ be word-aligned (the lowest address bit is _ignored_ at
- * the hardware level, so odd-byte transfers aren't possible).
- *
- * Transfer count (_not # bytes_) is limited to 64K, represented as actual
- * count - 1 : 64K => 0xFFFF, 1 => 0x0000.  Thus, count is always 1 or more,
- * and up to 128K bytes may be transferred on channels 5-7 in one operation.
- *
- */
-
-#define MAX_DMA_CHANNELS	8
-
-/* The maximum address that we can perform a DMA transfer to on this platform */#define MAX_DMA_ADDRESS      (PAGE_OFFSET+0x1000000)
-
-/* 8237 DMA controllers */
-#define IO_DMA1_BASE	0x10C00	/* 8 bit slave DMA, channels 0..3 */
-#define IO_DMA2_BASE	0x10D00	/* 16 bit master DMA, ch 4(=slave input)..7 */
-
-/* DMA controller registers */
-#define DMA1_CMD_REG		(IO_DMA1_BASE+0x08) /* command register (w) */
-#define DMA1_STAT_REG		(IO_DMA1_BASE+0x08) /* status register (r) */
-#define DMA1_REQ_REG            (IO_DMA1_BASE+0x09) /* request register (w) */
-#define DMA1_MASK_REG		(IO_DMA1_BASE+0x0A) /* single-channel mask (w) */
-#define DMA1_MODE_REG		(IO_DMA1_BASE+0x0B) /* mode register (w) */
-#define DMA1_CLEAR_FF_REG	(IO_DMA1_BASE+0x0C) /* clear pointer flip-flop (w) */
-#define DMA1_TEMP_REG           (IO_DMA1_BASE+0x0D) /* Temporary Register (r) */
-#define DMA1_RESET_REG		(IO_DMA1_BASE+0x0D) /* Master Clear (w) */
-#define DMA1_CLR_MASK_REG       (IO_DMA1_BASE+0x0E) /* Clear Mask */
-#define DMA1_MASK_ALL_REG       (IO_DMA1_BASE+0x0F) /* all-channels mask (w) */
-
-#define DMA2_CMD_REG		(IO_DMA2_BASE+0x10) /* command register (w) */
-#define DMA2_STAT_REG		(IO_DMA2_BASE+0x10) /* status register (r) */
-#define DMA2_REQ_REG            (IO_DMA2_BASE+0x12) /* request register (w) */
-#define DMA2_MASK_REG		(IO_DMA2_BASE+0x14) /* single-channel mask (w) */
-#define DMA2_MODE_REG		(IO_DMA2_BASE+0x16) /* mode register (w) */
-#define DMA2_CLEAR_FF_REG	(IO_DMA2_BASE+0x18) /* clear pointer flip-flop (w) */
-#define DMA2_TEMP_REG           (IO_DMA2_BASE+0x1A) /* Temporary Register (r) */
-#define DMA2_RESET_REG		(IO_DMA2_BASE+0x1A) /* Master Clear (w) */
-#define DMA2_CLR_MASK_REG       (IO_DMA2_BASE+0x1C) /* Clear Mask */
-#define DMA2_MASK_ALL_REG       (IO_DMA2_BASE+0x1E) /* all-channels mask (w) */
-
-#define DMA_ADDR_0              (IO_DMA1_BASE+0x00) /* DMA address registers */
-#define DMA_ADDR_1              (IO_DMA1_BASE+0x02)
-#define DMA_ADDR_2              (IO_DMA1_BASE+0x04)
-#define DMA_ADDR_3              (IO_DMA1_BASE+0x06)
-#define DMA_ADDR_4              (IO_DMA2_BASE+0x00)
-#define DMA_ADDR_5              (IO_DMA2_BASE+0x04)
-#define DMA_ADDR_6              (IO_DMA2_BASE+0x08)
-#define DMA_ADDR_7              (IO_DMA2_BASE+0x0C)
-
-#define DMA_CNT_0               (IO_DMA1_BASE+0x01)   /* DMA count registers */
-#define DMA_CNT_1               (IO_DMA1_BASE+0x03)
-#define DMA_CNT_2               (IO_DMA1_BASE+0x05)
-#define DMA_CNT_3               (IO_DMA1_BASE+0x07)
-#define DMA_CNT_4               (IO_DMA2_BASE+0x02)
-#define DMA_CNT_5               (IO_DMA2_BASE+0x06)
-#define DMA_CNT_6               (IO_DMA2_BASE+0x0A)
-#define DMA_CNT_7               (IO_DMA2_BASE+0x0E)
-
-#define DMA_MODE_READ	0x44	/* I/O to memory, no autoinit, increment, single mode */
-#define DMA_MODE_WRITE	0x48	/* memory to I/O, no autoinit, increment, single mode */
-#define DMA_MODE_CASCADE 0xC0   /* pass thru DREQ->HRQ, DACK<-HLDA only */
-
-#define DMA_AUTOINIT	0x10
-
-#define DMA_8BIT 0
-#define DMA_16BIT 1
-#define DMA_BUSMASTER 2
-
-extern spinlock_t  dma_spin_lock;
-
-static __inline__ unsigned long claim_dma_lock(void)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&dma_spin_lock, flags);
-	return flags;
-}
-
-static __inline__ void release_dma_lock(unsigned long flags)
-{
-	spin_unlock_irqrestore(&dma_spin_lock, flags);
-}
-
-/* enable/disable a specific DMA channel */
-static __inline__ void enable_dma(unsigned int dmanr)
-{
-	if (dmanr<=3)
-		dma_outb(dmanr,  DMA1_MASK_REG);
-	else
-		dma_outb(dmanr & 3,  DMA2_MASK_REG);
-}
-
-static __inline__ void disable_dma(unsigned int dmanr)
-{
-	if (dmanr<=3)
-		dma_outb(dmanr | 4,  DMA1_MASK_REG);
-	else
-		dma_outb((dmanr & 3) | 4,  DMA2_MASK_REG);
-}
-
-/* Clear the 'DMA Pointer Flip Flop'.
- * Write 0 for LSB/MSB, 1 for MSB/LSB access.
- * Use this once to initialize the FF to a known state.
- * After that, keep track of it. :-)
- * --- In order to do that, the DMA routines below should ---
- * --- only be used while holding the DMA lock ! ---
- */
-static __inline__ void clear_dma_ff(unsigned int dmanr)
-{
-	if (dmanr<=3)
-		dma_outb(0,  DMA1_CLEAR_FF_REG);
-	else
-		dma_outb(0,  DMA2_CLEAR_FF_REG);
-}
-
-/* set mode (above) for a specific DMA channel */
-static __inline__ void set_dma_mode(unsigned int dmanr, char mode)
-{
-	if (dmanr<=3)
-		dma_outb(mode | dmanr,  DMA1_MODE_REG);
-	else
-		dma_outb(mode | (dmanr&3),  DMA2_MODE_REG);
-}
-
-/* Set transfer address & page bits for specific DMA channel.
- * Assumes dma flipflop is clear.
- */
-static __inline__ void set_dma_addr(unsigned int dmanr, unsigned int a)
-{
-	if (dmanr <= 3)  {
-	    dma_outb( a & 0xff, ((dmanr&3)<<1) + IO_DMA1_BASE );
-            dma_outb( (a>>8) & 0xff, ((dmanr&3)<<1) + IO_DMA1_BASE );
-	}  else  {
-	    dma_outb( (a>>1) & 0xff, ((dmanr&3)<<2) + IO_DMA2_BASE );
-	    dma_outb( (a>>9) & 0xff, ((dmanr&3)<<2) + IO_DMA2_BASE );
-	}
-}
-
-
-/* Set transfer size (max 64k for DMA1..3, 128k for DMA5..7) for
- * a specific DMA channel.
- * You must ensure the parameters are valid.
- * NOTE: from a manual: "the number of transfers is one more
- * than the initial word count"! This is taken into account.
- * Assumes dma flip-flop is clear.
- * NOTE 2: "count" represents _bytes_ and must be even for channels 5-7.
- */
-static __inline__ void set_dma_count(unsigned int dmanr, unsigned int count)
-{
-        count--;
-	if (dmanr <= 3)  {
-	    dma_outb( count & 0xff, ((dmanr&3)<<1) + 1 + IO_DMA1_BASE );
-	    dma_outb( (count>>8) & 0xff, ((dmanr&3)<<1) + 1 + IO_DMA1_BASE );
-        } else {
-	    dma_outb( (count>>1) & 0xff, ((dmanr&3)<<2) + 2 + IO_DMA2_BASE );
-	    dma_outb( (count>>9) & 0xff, ((dmanr&3)<<2) + 2 + IO_DMA2_BASE );
-        }
-}
-
-
-/* Get DMA residue count. After a DMA transfer, this
- * should return zero. Reading this while a DMA transfer is
- * still in progress will return unpredictable results.
- * If called before the channel has been used, it may return 1.
- * Otherwise, it returns the number of _bytes_ left to transfer.
- *
- * Assumes DMA flip-flop is clear.
- */
-static __inline__ int get_dma_residue(unsigned int dmanr)
-{
-	unsigned int io_port = (dmanr<=3)? ((dmanr&3)<<1) + 1 + IO_DMA1_BASE
-					 : ((dmanr&3)<<2) + 2 + IO_DMA2_BASE;
-
-	/* using short to get 16-bit wrap around */
-	unsigned short count;
-
-	count = 1 + dma_inb(io_port);
-	count += dma_inb(io_port) << 8;
-
-	return (dmanr<=3)? count : (count<<1);
-}
-
-
-/* These are in kernel/dma.c: */
-extern int request_dma(unsigned int dmanr, const char * device_id);	/* reserve a DMA channel */
-extern void free_dma(unsigned int dmanr);	/* release it again */
-
-/* These are in arch/m68k/apollo/dma.c: */
-extern unsigned short dma_map_page(unsigned long phys_addr,int count,int type);
-extern void dma_unmap_page(unsigned short dma_addr);
-
-#endif /* _ASM_APOLLO_DMA_H */
diff --git a/arch/m68k/include/asm/mac_mouse.h b/arch/m68k/include/asm/mac_mouse.h
deleted file mode 100644
index 39a5c29..0000000
--- a/arch/m68k/include/asm/mac_mouse.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef _ASM_MAC_MOUSE_H
-#define _ASM_MAC_MOUSE_H
-
-/*
- * linux/include/asm-m68k/mac_mouse.h
- * header file for Macintosh ADB mouse driver
- * 27-10-97 Michael Schmitz
- * copied from:
- * header file for Atari Mouse driver
- * by Robert de Vries (robert@and.nl) on 19Jul93
- */
-
-struct mouse_status {
-	char		buttons;
-	short		dx;
-	short		dy;
-	int		ready;
-	int		active;
-	wait_queue_head_t wait;
-	struct fasync_struct *fasyncptr;
-};
-
-#endif
diff --git a/arch/m68k/include/asm/mcfmbus.h b/arch/m68k/include/asm/mcfmbus.h
deleted file mode 100644
index 319899c..0000000
--- a/arch/m68k/include/asm/mcfmbus.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/****************************************************************************/
-
-/*
- *      mcfmbus.h -- Coldfire MBUS support defines.
- *
- *      (C) Copyright 1999, Martin Floeer (mfloeer@axcent.de) 
- */
-
-/****************************************************************************/
-
-
-#ifndef mcfmbus_h
-#define mcfmbus_h
-
-
-#define MCFMBUS_BASE		0x280
-#define MCFMBUS_IRQ_VECTOR	0x19
-#define MCFMBUS_IRQ		0x1
-#define MCFMBUS_CLK		0x3f
-#define MCFMBUS_IRQ_LEVEL	0x07	/*IRQ Level 1*/
-#define MCFMBUS_ADDRESS		0x01
-
-
-/*
-*	Define the 5307 MBUS register set addresses
-*/
-
-#define MCFMBUS_MADR	0x00
-#define MCFMBUS_MFDR	0x04
-#define MCFMBUS_MBCR	0x08
-#define MCFMBUS_MBSR	0x0C
-#define MCFMBUS_MBDR	0x10
-
-
-#define MCFMBUS_MADR_ADDR(a)	(((a)&0x7F)<<0x01) /*Slave Address*/
-
-#define MCFMBUS_MFDR_MBC(a)	((a)&0x3F)	   /*M-Bus Clock*/
-
-/*
-*	Define bit flags in Control Register
-*/
-
-#define MCFMBUS_MBCR_MEN           (0x80)  /* M-Bus Enable                 */
-#define MCFMBUS_MBCR_MIEN          (0x40)  /* M-Bus Interrupt Enable       */
-#define MCFMBUS_MBCR_MSTA          (0x20)  /* Master/Slave Mode Select Bit */
-#define MCFMBUS_MBCR_MTX           (0x10)  /* Transmit/Rcv Mode Select Bit */
-#define MCFMBUS_MBCR_TXAK          (0x08)  /* Transmit Acknowledge Enable  */
-#define MCFMBUS_MBCR_RSTA          (0x04)  /* Repeat Start                 */
-
-/*
-*	Define bit flags in Status Register
-*/
-
-#define MCFMBUS_MBSR_MCF           (0x80)  /* Data Transfer Complete       */
-#define MCFMBUS_MBSR_MAAS          (0x40)  /* Addressed as a Slave         */
-#define MCFMBUS_MBSR_MBB           (0x20)  /* Bus Busy                     */
-#define MCFMBUS_MBSR_MAL           (0x10)  /* Arbitration Lost             */
-#define MCFMBUS_MBSR_SRW           (0x04)  /* Slave Transmit               */
-#define MCFMBUS_MBSR_MIF           (0x02)  /* M-Bus Interrupt              */
-#define MCFMBUS_MBSR_RXAK          (0x01)  /* No Acknowledge Received      */
-
-/*
-*	Define bit flags in DATA I/O Register
-*/
-
-#define MCFMBUS_MBDR_READ          (0x01)  /* 1=read 0=write MBUS */
-
-#define MBUSIOCSCLOCK		1
-#define MBUSIOCGCLOCK		2
-#define MBUSIOCSADDR			3
-#define MBUSIOCGADDR			4
-#define MBUSIOCSSLADDR			5
-#define MBUSIOCGSLADDR			6
-#define MBUSIOCSSUBADDR			7
-#define MBUSIOCGSUBADDR			8
-
-#endif
diff --git a/arch/m68k/include/asm/mcfne.h b/arch/m68k/include/asm/mcfne.h
deleted file mode 100644
index bf638be..0000000
--- a/arch/m68k/include/asm/mcfne.h
+++ /dev/null
@@ -1,242 +0,0 @@
-/****************************************************************************/
-
-/*
- *	mcfne.h -- NE2000 in ColdFire eval boards.
- *
- *	(C) Copyright 1999-2000, Greg Ungerer (gerg@snapgear.com)
- *	(C) Copyright 2000,      Lineo (www.lineo.com)
- *	(C) Copyright 2001,      SnapGear (www.snapgear.com)
- *
- *      19990409 David W. Miller  Converted from m5206ne.h for 5307 eval board
- *
- *      Hacked support for m5206e Cadre III evaluation board
- *      Fred Stevens (fred.stevens@pemstar.com) 13 April 1999
- */
-
-/****************************************************************************/
-#ifndef	mcfne_h
-#define	mcfne_h
-/****************************************************************************/
-
-
-/*
- *	Support for NE2000 clones devices in ColdFire based boards.
- *	Not all boards address these parts the same way, some use a
- *	direct addressing method, others use a side-band address space
- *	to access odd address registers, some require byte swapping
- *	others do not.
- */
-#define	BSWAP(w)	(((w) << 8) | ((w) >> 8))
-#define	RSWAP(w)	(w)
-
-
-/*
- *	Define the basic hardware resources of NE2000 boards.
- */
-
-#if defined(CONFIG_ARN5206)
-#define NE2000_ADDR		0x40000300
-#define NE2000_ODDOFFSET	0x00010000
-#define	NE2000_IRQ_VECTOR	0xf0
-#define	NE2000_IRQ_PRIORITY	2
-#define	NE2000_IRQ_LEVEL	4
-#define	NE2000_BYTE		volatile unsigned short
-#endif
-
-#if defined(CONFIG_M5206eC3)
-#define	NE2000_ADDR		0x40000300
-#define	NE2000_ODDOFFSET	0x00010000
-#define	NE2000_IRQ_VECTOR	0x1c
-#define	NE2000_IRQ_PRIORITY	2
-#define	NE2000_IRQ_LEVEL	4
-#define	NE2000_BYTE		volatile unsigned short
-#endif
-
-#if defined(CONFIG_M5206e) && defined(CONFIG_NETtel)
-#define NE2000_ADDR		0x30000300
-#define NE2000_IRQ_VECTOR	25
-#define NE2000_IRQ_PRIORITY	1
-#define NE2000_IRQ_LEVEL	3
-#define	NE2000_BYTE		volatile unsigned char
-#endif
-
-#if defined(CONFIG_M5307C3)
-#define NE2000_ADDR		0x40000300
-#define NE2000_ODDOFFSET	0x00010000
-#define NE2000_IRQ_VECTOR	0x1b
-#define	NE2000_BYTE		volatile unsigned short
-#endif
-
-#if defined(CONFIG_M5272) && defined(CONFIG_NETtel)
-#define NE2000_ADDR		0x30600300
-#define NE2000_ODDOFFSET	0x00008000
-#define NE2000_IRQ_VECTOR	67
-#undef	BSWAP
-#define	BSWAP(w)		(w)
-#define	NE2000_BYTE		volatile unsigned short
-#undef	RSWAP
-#define	RSWAP(w)		(((w) << 8) | ((w) >> 8))
-#endif
-
-#if defined(CONFIG_M5307) && defined(CONFIG_NETtel)
-#define NE2000_ADDR0		0x30600300
-#define NE2000_ADDR1		0x30800300
-#define NE2000_ODDOFFSET	0x00008000
-#define NE2000_IRQ_VECTOR0	27
-#define NE2000_IRQ_VECTOR1	29
-#undef	BSWAP
-#define	BSWAP(w)		(w)
-#define	NE2000_BYTE		volatile unsigned short
-#undef	RSWAP
-#define	RSWAP(w)		(((w) << 8) | ((w) >> 8))
-#endif
-
-#if defined(CONFIG_M5307) && defined(CONFIG_SECUREEDGEMP3)
-#define NE2000_ADDR		0x30600300
-#define NE2000_ODDOFFSET	0x00008000
-#define NE2000_IRQ_VECTOR	27
-#undef	BSWAP
-#define	BSWAP(w)		(w)
-#define	NE2000_BYTE		volatile unsigned short
-#undef	RSWAP
-#define	RSWAP(w)		(((w) << 8) | ((w) >> 8))
-#endif
-
-#if defined(CONFIG_ARN5307)
-#define NE2000_ADDR		0xfe600300
-#define NE2000_ODDOFFSET	0x00010000
-#define NE2000_IRQ_VECTOR	0x1b
-#define NE2000_IRQ_PRIORITY	2
-#define NE2000_IRQ_LEVEL	3
-#define	NE2000_BYTE		volatile unsigned short
-#endif
-
-#if defined(CONFIG_M5407C3)
-#define NE2000_ADDR		0x40000300
-#define NE2000_ODDOFFSET	0x00010000
-#define NE2000_IRQ_VECTOR	0x1b
-#define	NE2000_BYTE		volatile unsigned short
-#endif
-
-/****************************************************************************/
-
-/*
- *	Side-band address space for odd address requires re-mapping
- *	many of the standard ISA access functions.
- */
-#ifdef NE2000_ODDOFFSET
-
-#undef outb
-#undef outb_p
-#undef inb
-#undef inb_p
-#undef outsb
-#undef outsw
-#undef insb
-#undef insw
-
-#define	outb	ne2000_outb
-#define	inb	ne2000_inb
-#define	outb_p	ne2000_outb
-#define	inb_p	ne2000_inb
-#define	outsb	ne2000_outsb
-#define	outsw	ne2000_outsw
-#define	insb	ne2000_insb
-#define	insw	ne2000_insw
-
-
-#ifndef COLDFIRE_NE2000_FUNCS
-
-void ne2000_outb(unsigned int val, unsigned int addr);
-int  ne2000_inb(unsigned int addr);
-void ne2000_insb(unsigned int addr, void *vbuf, int unsigned long len);
-void ne2000_insw(unsigned int addr, void *vbuf, unsigned long len);
-void ne2000_outsb(unsigned int addr, void *vbuf, unsigned long len);
-void ne2000_outsw(unsigned int addr, void *vbuf, unsigned long len);
-
-#else
-
-/*
- *	This macro converts a conventional register address into the
- *	real memory pointer of the mapped NE2000 device.
- *	On most NE2000 implementations on ColdFire boards the chip is
- *	mapped in kinda funny, due to its ISA heritage.
- */
-#define	NE2000_PTR(addr)	((addr&0x1)?(NE2000_ODDOFFSET+addr-1):(addr))
-#define	NE2000_DATA_PTR(addr)	(addr)
-
-
-void ne2000_outb(unsigned int val, unsigned int addr)
-{
-	NE2000_BYTE	*rp;
-
-	rp = (NE2000_BYTE *) NE2000_PTR(addr);
-	*rp = RSWAP(val);
-}
-
-int ne2000_inb(unsigned int addr)
-{
-	NE2000_BYTE	*rp, val;
-
-	rp = (NE2000_BYTE *) NE2000_PTR(addr);
-	val = *rp;
-	return((int) ((NE2000_BYTE) RSWAP(val)));
-}
-
-void ne2000_insb(unsigned int addr, void *vbuf, int unsigned long len)
-{
-	NE2000_BYTE	*rp, val;
-	unsigned char	*buf;
-
-	buf = (unsigned char *) vbuf;
-	rp = (NE2000_BYTE *) NE2000_DATA_PTR(addr);
-	for (; (len > 0); len--) {
-		val = *rp;
-		*buf++ = RSWAP(val);
-	}
-}
-
-void ne2000_insw(unsigned int addr, void *vbuf, unsigned long len)
-{
-	volatile unsigned short	*rp;
-	unsigned short		w, *buf;
-
-	buf = (unsigned short *) vbuf;
-	rp = (volatile unsigned short *) NE2000_DATA_PTR(addr);
-	for (; (len > 0); len--) {
-		w = *rp;
-		*buf++ = BSWAP(w);
-	}
-}
-
-void ne2000_outsb(unsigned int addr, const void *vbuf, unsigned long len)
-{
-	NE2000_BYTE	*rp, val;
-	unsigned char	*buf;
-
-	buf = (unsigned char *) vbuf;
-	rp = (NE2000_BYTE *) NE2000_DATA_PTR(addr);
-	for (; (len > 0); len--) {
-		val = *buf++;
-		*rp = RSWAP(val);
-	}
-}
-
-void ne2000_outsw(unsigned int addr, const void *vbuf, unsigned long len)
-{
-	volatile unsigned short	*rp;
-	unsigned short		w, *buf;
-
-	buf = (unsigned short *) vbuf;
-	rp = (volatile unsigned short *) NE2000_DATA_PTR(addr);
-	for (; (len > 0); len--) {
-		w = *buf++;
-		*rp = BSWAP(w);
-	}
-}
-
-#endif /* COLDFIRE_NE2000_FUNCS */
-#endif /* NE2000_OFFOFFSET */
-
-/****************************************************************************/
-#endif	/* mcfne_h */
diff --git a/arch/m68k/include/asm/sbus.h b/arch/m68k/include/asm/sbus.h
deleted file mode 100644
index bfe3ba1..0000000
--- a/arch/m68k/include/asm/sbus.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * some sbus structures and macros to make usage of sbus drivers possible
- */
-
-#ifndef __M68K_SBUS_H
-#define __M68K_SBUS_H
-
-struct sbus_dev {
-	struct {
-		unsigned int which_io;
-		unsigned int phys_addr;
-	} reg_addrs[1];
-};
-
-/* sbus IO functions stolen from include/asm-sparc/io.h for the serial driver */
-/* No SBUS on the Sun3, kludge -- sam */
-
-static inline void _sbus_writeb(unsigned char val, unsigned long addr)
-{
-	*(volatile unsigned char *)addr = val;
-}
-
-static inline unsigned char _sbus_readb(unsigned long addr)
-{
-	return *(volatile unsigned char *)addr;
-}
-
-static inline void _sbus_writel(unsigned long val, unsigned long addr)
-{
-	*(volatile unsigned long *)addr = val;
-
-}
-
-extern inline unsigned long _sbus_readl(unsigned long addr)
-{
-	return *(volatile unsigned long *)addr;
-}
-
-
-#define sbus_readb(a) _sbus_readb((unsigned long)a)
-#define sbus_writeb(v, a) _sbus_writeb(v, (unsigned long)a)
-#define sbus_readl(a) _sbus_readl((unsigned long)a)
-#define sbus_writel(v, a) _sbus_writel(v, (unsigned long)a)
-
-#endif
-- 
1.7.7.6

