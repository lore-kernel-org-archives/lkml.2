Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2FMIr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:47:27 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4263 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137Ab2FMIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:47:21 -0400
Message-ID: <1339577239.30984.145.camel@x61.thuisdomein>
Subject: [PATCH] [media] stradis: remove unused V4L1 headers
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 10:47:19 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jun 2012 08:47:19.0248 (UTC) FILETIME=[24309D00:01CD4941]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 39c3d488452ae206cfc8afda0db041ee55d01c3c ("[media] cpia, stradis:
remove deprecated V4L1 drivers") removed the last file including these
five headers. Apparently it was just an oversight to keep them in the
tree. They can safely be removed now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested only by using various git commands on the (history of the)
tree.

1) Note that I haven't checked whether the things these headers provide
might still be used in the tree. Since no file includes these files
anymore, that should have caused compilation errors by now, so checking
for that seems rather pointless.

2) Also note that there are two other headers called "saa7146.h":
 - include/media/saa7146.h; and
 - sound/pci/aw2/saa7146.h.
Those should be the headers that are included by:
 - drivers/media/common/saa7146_core.c,
   drivers/media/dvb/ttpci/budget.h,
   include/media/saa7146_vv.h; and
 - sound/pci/aw2/aw2-alsa.c,
   sound/pci/aw2/aw2-saa7146.c.

So the "saa7146.h" header that this patch removes shouldn't break
compilation of those files. Perhaps the maintains would like that to be
actually tested. Can the drivers that use those files be compiled for
x86?

 drivers/media/video/cs8420.h     |   50 -------
 drivers/media/video/ibmmpeg2.h   |   94 -------------
 drivers/media/video/saa7121.h    |  132 ------------------
 drivers/media/video/saa7146.h    |  112 ---------------
 drivers/media/video/saa7146reg.h |  283 --------------------------------------
 5 files changed, 0 insertions(+), 671 deletions(-)
 delete mode 100644 drivers/media/video/cs8420.h
 delete mode 100644 drivers/media/video/ibmmpeg2.h
 delete mode 100644 drivers/media/video/saa7121.h
 delete mode 100644 drivers/media/video/saa7146.h
 delete mode 100644 drivers/media/video/saa7146reg.h

diff --git a/drivers/media/video/cs8420.h b/drivers/media/video/cs8420.h
deleted file mode 100644
index 621c0c6..0000000
--- a/drivers/media/video/cs8420.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/* cs8420.h - cs8420 initializations
-   Copyright (C) 1999 Nathan Laredo (laredo@gnu.org)
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
- */
-#ifndef __CS8420_H__
-#define __CS8420_H__
-
-/* Initialization Sequence */
-
-static __u8 init8420[] = {
-	1, 0x01,	2, 0x02,	3, 0x00,	4, 0x46,
-	5, 0x24,	6, 0x84,	18, 0x18,	19, 0x13,
-};
-
-#define INIT8420LEN	(sizeof(init8420)/2)
-
-static __u8 mode8420pro[] = {	/* professional output mode */
-	32, 0xa1,	33, 0x00,	34, 0x00,	35, 0x00,
-	36, 0x00,	37, 0x00,	38, 0x00,	39, 0x00,
-	40, 0x00,	41, 0x00,	42, 0x00,	43, 0x00,
-	44, 0x00,	45, 0x00,	46, 0x00,	47, 0x00,
-	48, 0x00,	49, 0x00,	50, 0x00,	51, 0x00,
-	52, 0x00,	53, 0x00,	54, 0x00,	55, 0x00,
-};
-#define MODE8420LEN	(sizeof(mode8420pro)/2)
-
-static __u8 mode8420con[] = {	/* consumer output mode */
-	32, 0x20,	33, 0x00,	34, 0x00,	35, 0x48,
-	36, 0x00,	37, 0x00,	38, 0x00,	39, 0x00,
-	40, 0x00,	41, 0x00,	42, 0x00,	43, 0x00,
-	44, 0x00,	45, 0x00,	46, 0x00,	47, 0x00,
-	48, 0x00,	49, 0x00,	50, 0x00,	51, 0x00,
-	52, 0x00,	53, 0x00,	54, 0x00,	55, 0x00,
-};
-
-#endif
diff --git a/drivers/media/video/ibmmpeg2.h b/drivers/media/video/ibmmpeg2.h
deleted file mode 100644
index 68e1038..0000000
--- a/drivers/media/video/ibmmpeg2.h
+++ /dev/null
@@ -1,94 +0,0 @@
-/* ibmmpeg2.h - IBM MPEGCD21 definitions */
-
-#ifndef __IBM_MPEG2__
-#define __IBM_MPEG2__
-
-/* Define all MPEG Decoder registers */
-/* Chip Control and Status */
-#define IBM_MP2_CHIP_CONTROL	0x200*2
-#define IBM_MP2_CHIP_MODE	0x201*2
-/* Timer Control and Status */
-#define IBM_MP2_SYNC_STC2	0x202*2
-#define IBM_MP2_SYNC_STC1	0x203*2
-#define IBM_MP2_SYNC_STC0	0x204*2
-#define IBM_MP2_SYNC_PTS2	0x205*2
-#define IBM_MP2_SYNC_PTS1	0x206*2
-#define IBM_MP2_SYNC_PTS0	0x207*2
-/* Video FIFO Control */
-#define IBM_MP2_FIFO		0x208*2
-#define IBM_MP2_FIFOW		0x100*2
-#define IBM_MP2_FIFO_STAT	0x209*2
-#define IBM_MP2_RB_THRESHOLD	0x22b*2
-/* Command buffer */
-#define IBM_MP2_COMMAND		0x20a*2
-#define IBM_MP2_CMD_DATA	0x20b*2
-#define IBM_MP2_CMD_STAT	0x20c*2
-#define IBM_MP2_CMD_ADDR	0x20d*2
-/* Internal Processor Control and Status */
-#define IBM_MP2_PROC_IADDR	0x20e*2
-#define IBM_MP2_PROC_IDATA	0x20f*2
-#define IBM_MP2_WR_PROT		0x235*2
-/* DRAM Access */
-#define IBM_MP2_DRAM_ADDR	0x210*2
-#define IBM_MP2_DRAM_DATA	0x212*2
-#define IBM_MP2_DRAM_CMD_STAT	0x213*2
-#define IBM_MP2_BLOCK_SIZE	0x23b*2
-#define IBM_MP2_SRC_ADDR	0x23c*2
-/* Onscreen Display */
-#define IBM_MP2_OSD_ADDR	0x214*2
-#define IBM_MP2_OSD_DATA	0x215*2
-#define IBM_MP2_OSD_MODE	0x217*2
-#define IBM_MP2_OSD_LINK_ADDR	0x229*2
-#define IBM_MP2_OSD_SIZE	0x22a*2
-/* Interrupt Control */
-#define IBM_MP2_HOST_INT	0x218*2
-#define IBM_MP2_MASK0		0x219*2
-#define IBM_MP2_HOST_INT1	0x23e*2
-#define IBM_MP2_MASK1		0x23f*2
-/* Audio Control */
-#define IBM_MP2_AUD_IADDR	0x21a*2
-#define IBM_MP2_AUD_IDATA	0x21b*2
-#define IBM_MP2_AUD_FIFO	0x21c*2
-#define IBM_MP2_AUD_FIFOW	0x101*2
-#define IBM_MP2_AUD_CTL		0x21d*2
-#define IBM_MP2_BEEP_CTL	0x21e*2
-#define IBM_MP2_FRNT_ATTEN	0x22d*2
-/* Display Control */
-#define IBM_MP2_DISP_MODE	0x220*2
-#define IBM_MP2_DISP_DLY	0x221*2
-#define IBM_MP2_VBI_CTL		0x222*2
-#define IBM_MP2_DISP_LBOR	0x223*2
-#define IBM_MP2_DISP_TBOR	0x224*2
-/* Polarity Control */
-#define IBM_MP2_INFC_CTL	0x22c*2
-
-/* control commands */
-#define IBM_MP2_PLAY		0
-#define IBM_MP2_PAUSE		1
-#define IBM_MP2_SINGLE_FRAME	2
-#define IBM_MP2_FAST_FORWARD	3
-#define IBM_MP2_SLOW_MOTION	4
-#define IBM_MP2_IMED_NORM_PLAY	5
-#define IBM_MP2_RESET_WINDOW	6
-#define IBM_MP2_FREEZE_FRAME	7
-#define IBM_MP2_RESET_VID_RATE	8
-#define IBM_MP2_CONFIG_DECODER	9
-#define IBM_MP2_CHANNEL_SWITCH	10
-#define IBM_MP2_RESET_AUD_RATE	11
-#define IBM_MP2_PRE_OP_CHN_SW	12
-#define IBM_MP2_SET_STILL_MODE	14
-
-/* Define Xilinx FPGA Internal Registers */
-
-/* general control register 0 */
-#define XILINX_CTL0		0x600
-/* genlock delay resister 1 */
-#define XILINX_GLDELAY		0x602
-/* send 16 bits to CS3310 port */
-#define XILINX_CS3310		0x604
-/* send 16 bits to CS3310 and complete */
-#define XILINX_CS3310_CMPLT	0x60c
-/* pulse width modulator control */
-#define XILINX_PWM		0x606
-
-#endif
diff --git a/drivers/media/video/saa7121.h b/drivers/media/video/saa7121.h
deleted file mode 100644
index 66967ae..0000000
--- a/drivers/media/video/saa7121.h
+++ /dev/null
@@ -1,132 +0,0 @@
-/* saa7121.h - saa7121 initializations
-   Copyright (C) 1999 Nathan Laredo (laredo@gnu.org)
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
- */
-#ifndef __SAA7121_H__
-#define __SAA7121_H__
-
-#define NTSC_BURST_START	0x19	/* 28 */
-#define NTSC_BURST_END		0x1d	/* 29 */
-#define NTSC_CHROMA_PHASE	0x67	/* 5a */
-#define NTSC_GAINU		0x76	/* 5b */
-#define NTSC_GAINV		0xa5	/* 5c */
-#define NTSC_BLACK_LEVEL	0x2a	/* 5d */
-#define NTSC_BLANKING_LEVEL	0x2e	/* 5e */
-#define NTSC_VBI_BLANKING	0x2e	/* 5f */
-#define NTSC_DAC_CONTROL	0x11	/* 61 */
-#define NTSC_BURST_AMP		0x3f	/* 62 */
-#define NTSC_SUBC3		0x1f	/* 63 */
-#define NTSC_SUBC2		0x7c	/* 64 */
-#define NTSC_SUBC1		0xf0	/* 65 */
-#define NTSC_SUBC0		0x21	/* 66 */
-#define NTSC_HTRIG		0x72	/* 6c */
-#define NTSC_VTRIG		0x00	/* 6c */
-#define NTSC_MULTI		0x30	/* 6e */
-#define NTSC_CCTTX		0x11	/* 6f */
-#define NTSC_FIRST_ACTIVE	0x12	/* 7a */
-#define NTSC_LAST_ACTIVE	0x02	/* 7b */
-#define NTSC_MSB_VERTICAL	0x40	/* 7c */
-
-#define PAL_BURST_START		0x21	/* 28 */
-#define PAL_BURST_END		0x1d	/* 29 */
-#define PAL_CHROMA_PHASE	0x3f	/* 5a */
-#define PAL_GAINU		0x7d	/* 5b */
-#define PAL_GAINV		0xaf	/* 5c */
-#define PAL_BLACK_LEVEL		0x23	/* 5d */
-#define PAL_BLANKING_LEVEL	0x35	/* 5e */
-#define PAL_VBI_BLANKING	0x35	/* 5f */
-#define PAL_DAC_CONTROL		0x02	/* 61 */
-#define PAL_BURST_AMP		0x2f	/* 62 */
-#define PAL_SUBC3		0xcb	/* 63 */
-#define PAL_SUBC2		0x8a	/* 64 */
-#define PAL_SUBC1		0x09	/* 65 */
-#define PAL_SUBC0		0x2a	/* 66 */
-#define PAL_HTRIG		0x86	/* 6c */
-#define PAL_VTRIG		0x04	/* 6d */
-#define PAL_MULTI		0x20	/* 6e */
-#define PAL_CCTTX		0x15	/* 6f */
-#define PAL_FIRST_ACTIVE	0x16	/* 7a */
-#define PAL_LAST_ACTIVE		0x36	/* 7b */
-#define PAL_MSB_VERTICAL	0x40	/* 7c */
-
-/* Initialization Sequence */
-
-static __u8 init7121ntsc[] = {
-	0x26, 0x0,	0x27, 0x0,
-	0x28, NTSC_BURST_START,		0x29, NTSC_BURST_END,
-	0x2a, 0x0,	0x2b, 0x0,	0x2c, 0x0,	0x2d, 0x0,
-	0x2e, 0x0,	0x2f, 0x0,	0x30, 0x0,	0x31, 0x0,
-	0x32, 0x0,	0x33, 0x0,	0x34, 0x0,	0x35, 0x0,
-	0x36, 0x0,	0x37, 0x0,	0x38, 0x0,	0x39, 0x0,
-	0x3a, 0x03,	0x3b, 0x0,	0x3c, 0x0,	0x3d, 0x0,
-	0x3e, 0x0,	0x3f, 0x0,	0x40, 0x0,	0x41, 0x0,
-	0x42, 0x0,	0x43, 0x0,	0x44, 0x0,	0x45, 0x0,
-	0x46, 0x0,	0x47, 0x0,	0x48, 0x0,	0x49, 0x0,
-	0x4a, 0x0,	0x4b, 0x0,	0x4c, 0x0,	0x4d, 0x0,
-	0x4e, 0x0,	0x4f, 0x0,	0x50, 0x0,	0x51, 0x0,
-	0x52, 0x0,	0x53, 0x0,	0x54, 0x0,	0x55, 0x0,
-	0x56, 0x0,	0x57, 0x0,	0x58, 0x0,	0x59, 0x0,
-	0x5a, NTSC_CHROMA_PHASE,	0x5b, NTSC_GAINU,
-	0x5c, NTSC_GAINV,		0x5d, NTSC_BLACK_LEVEL,
-	0x5e, NTSC_BLANKING_LEVEL,	0x5f, NTSC_VBI_BLANKING,
-	0x60, 0x0,			0x61, NTSC_DAC_CONTROL,
-	0x62, NTSC_BURST_AMP,		0x63, NTSC_SUBC3,
-	0x64, NTSC_SUBC2,		0x65, NTSC_SUBC1,
-	0x66, NTSC_SUBC0,		0x67, 0x80,	0x68, 0x80,
-	0x69, 0x80,	0x6a, 0x80,	0x6b, 0x29,
-	0x6c, NTSC_HTRIG,		0x6d, NTSC_VTRIG,
-	0x6e, NTSC_MULTI,		0x6f, NTSC_CCTTX,
-	0x70, 0xc9,	0x71, 0x68,	0x72, 0x60,	0x73, 0x0,
-	0x74, 0x0,	0x75, 0x0,	0x76, 0x0,	0x77, 0x0,
-	0x78, 0x0,	0x79, 0x0,	0x7a, NTSC_FIRST_ACTIVE,
-	0x7b, NTSC_LAST_ACTIVE,		0x7c, NTSC_MSB_VERTICAL,
-	0x7d, 0x0,	0x7e, 0x0,	0x7f, 0x0
-};
-#define INIT7121LEN	(sizeof(init7121ntsc)/2)
-
-static __u8 init7121pal[] = {
-	0x26, 0x0,	0x27, 0x0,
-	0x28, PAL_BURST_START,		0x29, PAL_BURST_END,
-	0x2a, 0x0,	0x2b, 0x0,	0x2c, 0x0,	0x2d, 0x0,
-	0x2e, 0x0,	0x2f, 0x0,	0x30, 0x0,	0x31, 0x0,
-	0x32, 0x0,	0x33, 0x0,	0x34, 0x0,	0x35, 0x0,
-	0x36, 0x0,	0x37, 0x0,	0x38, 0x0,	0x39, 0x0,
-	0x3a, 0x03,	0x3b, 0x0,	0x3c, 0x0,	0x3d, 0x0,
-	0x3e, 0x0,	0x3f, 0x0,	0x40, 0x0,	0x41, 0x0,
-	0x42, 0x0,	0x43, 0x0,	0x44, 0x0,	0x45, 0x0,
-	0x46, 0x0,	0x47, 0x0,	0x48, 0x0,	0x49, 0x0,
-	0x4a, 0x0,	0x4b, 0x0,	0x4c, 0x0,	0x4d, 0x0,
-	0x4e, 0x0,	0x4f, 0x0,	0x50, 0x0,	0x51, 0x0,
-	0x52, 0x0,	0x53, 0x0,	0x54, 0x0,	0x55, 0x0,
-	0x56, 0x0,	0x57, 0x0,	0x58, 0x0,	0x59, 0x0,
-	0x5a, PAL_CHROMA_PHASE,		0x5b, PAL_GAINU,
-	0x5c, PAL_GAINV,		0x5d, PAL_BLACK_LEVEL,
-	0x5e, PAL_BLANKING_LEVEL,	0x5f, PAL_VBI_BLANKING,
-	0x60, 0x0,			0x61, PAL_DAC_CONTROL,
-	0x62, PAL_BURST_AMP,		0x63, PAL_SUBC3,
-	0x64, PAL_SUBC2,		0x65, PAL_SUBC1,
-	0x66, PAL_SUBC0,		0x67, 0x80,	0x68, 0x80,
-	0x69, 0x80,	0x6a, 0x80,	0x6b, 0x29,
-	0x6c, PAL_HTRIG,		0x6d, PAL_VTRIG,
-	0x6e, PAL_MULTI,		0x6f, PAL_CCTTX,
-	0x70, 0xc9,	0x71, 0x68,	0x72, 0x60,	0x73, 0x0,
-	0x74, 0x0,	0x75, 0x0,	0x76, 0x0,	0x77, 0x0,
-	0x78, 0x0,	0x79, 0x0,	0x7a, PAL_FIRST_ACTIVE,
-	0x7b, PAL_LAST_ACTIVE,		0x7c, PAL_MSB_VERTICAL,
-	0x7d, 0x0,	0x7e, 0x0,	0x7f, 0x0
-};
-#endif
diff --git a/drivers/media/video/saa7146.h b/drivers/media/video/saa7146.h
deleted file mode 100644
index 9fadb33..0000000
--- a/drivers/media/video/saa7146.h
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
-    saa7146.h - definitions philips saa7146 based cards
-    Copyright (C) 1999 Nathan Laredo (laredo@gnu.org)
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#ifndef __SAA7146__
-#define __SAA7146__
-
-#define SAA7146_VERSION_CODE 0x000101
-
-#include <linux/types.h>
-#include <linux/wait.h>
-
-#ifndef O_NONCAP
-#define O_NONCAP	O_TRUNC
-#endif
-
-#define MAX_GBUFFERS	2
-#define FBUF_SIZE	0x190000
-
-#ifdef __KERNEL__
-
-struct saa7146_window
-{
-	int x, y;
-	ushort width, height;
-	ushort bpp, bpl;
-	ushort swidth, sheight;
-	short cropx, cropy;
-	ushort cropwidth, cropheight;
-	unsigned long vidadr;
-	int color_fmt;
-	ushort depth;
-};
-
-/*  Per-open data for handling multiple opens on one device */
-struct device_open
-{
-	int	     isopen;
-	int	     noncapturing;
-	struct saa7146  *dev;
-};
-#define MAX_OPENS 3
-
-struct saa7146
-{
-	struct video_device video_dev;
-	struct video_picture picture;
-	struct video_audio audio_dev;
-	struct video_info vidinfo;
-	int user;
-	int cap;
-	int capuser;
-	int irqstate;		/* irq routine is state driven */
-	int writemode;
-	int playmode;
-	unsigned int nr;
-	unsigned long irq;          /* IRQ used by SAA7146 card */
-	unsigned short id;
-	unsigned char revision;
-	unsigned char boardcfg[64];	/* 64 bytes of config from eeprom */
-	unsigned long saa7146_adr;   /* bus address of IO mem from PCI BIOS */
-	struct saa7146_window win;
-	unsigned char __iomem *saa7146_mem; /* pointer to mapped IO memory */
-	struct device_open open_data[MAX_OPENS];
-#define MAX_MARKS 16
-	/* for a/v sync */
-	int endmark[MAX_MARKS], endmarkhead, endmarktail;
-	u32 *dmaRPS1, *pageRPS1, *dmaRPS2, *pageRPS2, *dmavid1, *dmavid2,
-		*dmavid3, *dmaa1in, *dmaa1out, *dmaa2in, *dmaa2out,
-		*pagedebi, *pagevid1, *pagevid2, *pagevid3, *pagea1in,
-		*pagea1out, *pagea2in, *pagea2out;
-	wait_queue_head_t i2cq, debiq, audq, vidq;
-	u8  *vidbuf, *audbuf, *osdbuf, *dmadebi;
-	int audhead, vidhead, osdhead, audtail, vidtail, osdtail;
-	spinlock_t lock;	/* the device lock */
-};
-#endif
-
-#ifdef _ALPHA_SAA7146
-#define saawrite(dat,adr)    writel((dat), saa->saa7146_adr+(adr))
-#define saaread(adr)         readl(saa->saa7146_adr+(adr))
-#else
-#define saawrite(dat,adr)    writel((dat), saa->saa7146_mem+(adr))
-#define saaread(adr)         readl(saa->saa7146_mem+(adr))
-#endif
-
-#define saaand(dat,adr)      saawrite((dat) & saaread(adr), adr)
-#define saaor(dat,adr)       saawrite((dat) | saaread(adr), adr)
-#define saaaor(dat,mask,adr) saawrite((dat) | ((mask) & saaread(adr)), adr)
-
-/* bitmask of attached hardware found */
-#define SAA7146_UNKNOWN		0x00000000
-#define SAA7146_SAA7111		0x00000001
-#define SAA7146_SAA7121		0x00000002
-#define SAA7146_IBMMPEG		0x00000004
-
-#endif
diff --git a/drivers/media/video/saa7146reg.h b/drivers/media/video/saa7146reg.h
deleted file mode 100644
index 80ec2c1..0000000
--- a/drivers/media/video/saa7146reg.h
+++ /dev/null
@@ -1,283 +0,0 @@
-/*
-    saa7146.h - definitions philips saa7146 based cards
-    Copyright (C) 1999 Nathan Laredo (laredo@gnu.org)
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-#ifndef __SAA7146_REG__
-#define __SAA7146_REG__
-#define SAA7146_BASE_ODD1	0x00
-#define SAA7146_BASE_EVEN1	0x04
-#define SAA7146_PROT_ADDR1	0x08
-#define SAA7146_PITCH1		0x0c
-#define SAA7146_PAGE1		0x10
-#define SAA7146_NUM_LINE_BYTE1	0x14
-#define SAA7146_BASE_ODD2	0x18
-#define SAA7146_BASE_EVEN2	0x1c
-#define SAA7146_PROT_ADDR2	0x20
-#define SAA7146_PITCH2		0x24
-#define SAA7146_PAGE2		0x28
-#define SAA7146_NUM_LINE_BYTE2	0x2c
-#define SAA7146_BASE_ODD3	0x30
-#define SAA7146_BASE_EVEN3	0x34
-#define SAA7146_PROT_ADDR3	0x38
-#define SAA7146_PITCH3		0x3c
-#define SAA7146_PAGE3		0x40
-#define SAA7146_NUM_LINE_BYTE3	0x44
-#define SAA7146_PCI_BT_V1	0x48
-#define SAA7146_PCI_BT_V2	0x49
-#define SAA7146_PCI_BT_V3	0x4a
-#define SAA7146_PCI_BT_DEBI	0x4b
-#define SAA7146_PCI_BT_A	0x4c
-#define SAA7146_DD1_INIT	0x50
-#define SAA7146_DD1_STREAM_B	0x54
-#define SAA7146_DD1_STREAM_A	0x56
-#define SAA7146_BRS_CTRL	0x58
-#define SAA7146_HPS_CTRL	0x5c
-#define SAA7146_HPS_V_SCALE	0x60
-#define SAA7146_HPS_V_GAIN	0x64
-#define SAA7146_HPS_H_PRESCALE	0x68
-#define SAA7146_HPS_H_SCALE	0x6c
-#define SAA7146_BCS_CTRL	0x70
-#define SAA7146_CHROMA_KEY_RANGE	0x74
-#define SAA7146_CLIP_FORMAT_CTRL	0x78
-#define SAA7146_DEBI_CONFIG	0x7c
-#define SAA7146_DEBI_COMMAND	0x80
-#define SAA7146_DEBI_PAGE	0x84
-#define SAA7146_DEBI_AD		0x88
-#define SAA7146_I2C_TRANSFER	0x8c
-#define SAA7146_I2C_STATUS	0x90
-#define SAA7146_BASE_A1_IN	0x94
-#define SAA7146_PROT_A1_IN	0x98
-#define SAA7146_PAGE_A1_IN	0x9C
-#define SAA7146_BASE_A1_OUT	0xa0
-#define SAA7146_PROT_A1_OUT	0xa4
-#define SAA7146_PAGE_A1_OUT	0xa8
-#define SAA7146_BASE_A2_IN	0xac
-#define SAA7146_PROT_A2_IN	0xb0
-#define SAA7146_PAGE_A2_IN	0xb4
-#define SAA7146_BASE_A2_OUT	0xb8
-#define SAA7146_PROT_A2_OUT	0xbc
-#define SAA7146_PAGE_A2_OUT	0xc0
-#define SAA7146_RPS_PAGE0	0xc4
-#define SAA7146_RPS_PAGE1	0xc8
-#define SAA7146_RPS_THRESH0	0xcc
-#define SAA7146_RPS_THRESH1	0xd0
-#define SAA7146_RPS_TOV0	0xd4
-#define SAA7146_RPS_TOV1	0xd8
-#define SAA7146_IER		0xdc
-#define SAA7146_GPIO_CTRL	0xe0
-#define SAA7146_EC1SSR		0xe4
-#define SAA7146_EC2SSR		0xe8
-#define SAA7146_ECT1R		0xec
-#define SAA7146_ECT2R		0xf0
-#define SAA7146_ACON1		0xf4
-#define SAA7146_ACON2		0xf8
-#define SAA7146_MC1		0xfc
-#define SAA7146_MC2		0x100
-#define SAA7146_RPS_ADDR0	0x104
-#define SAA7146_RPS_ADDR1	0x108
-#define SAA7146_ISR		0x10c
-#define SAA7146_PSR		0x110
-#define SAA7146_SSR		0x114
-#define SAA7146_EC1R		0x118
-#define SAA7146_EC2R		0x11c
-#define SAA7146_VDP1		0x120
-#define SAA7146_VDP2		0x124
-#define SAA7146_VDP3		0x128
-#define SAA7146_ADP1		0x12c
-#define SAA7146_ADP2		0x130
-#define SAA7146_ADP3		0x134
-#define SAA7146_ADP4		0x138
-#define SAA7146_DDP		0x13c
-#define SAA7146_LEVEL_REP	0x140
-#define SAA7146_FB_BUFFER1	0x144
-#define SAA7146_FB_BUFFER2	0x148
-#define SAA7146_A_TIME_SLOT1	0x180
-#define SAA7146_A_TIME_SLOT2	0x1C0
-
-/* bitfield defines */
-#define MASK_31			0x80000000
-#define MASK_30			0x40000000
-#define MASK_29			0x20000000
-#define MASK_28			0x10000000
-#define MASK_27			0x08000000
-#define MASK_26			0x04000000
-#define MASK_25			0x02000000
-#define MASK_24			0x01000000
-#define MASK_23			0x00800000
-#define MASK_22			0x00400000
-#define MASK_21			0x00200000
-#define MASK_20			0x00100000
-#define MASK_19			0x00080000
-#define MASK_18			0x00040000
-#define MASK_17			0x00020000
-#define MASK_16			0x00010000
-#define MASK_15			0x00008000
-#define MASK_14			0x00004000
-#define MASK_13			0x00002000
-#define MASK_12			0x00001000
-#define MASK_11			0x00000800
-#define MASK_10			0x00000400
-#define MASK_09			0x00000200
-#define MASK_08			0x00000100
-#define MASK_07			0x00000080
-#define MASK_06			0x00000040
-#define MASK_05			0x00000020
-#define MASK_04			0x00000010
-#define MASK_03			0x00000008
-#define MASK_02			0x00000004
-#define MASK_01			0x00000002
-#define MASK_00			0x00000001
-#define MASK_B0			0x000000ff
-#define MASK_B1			0x0000ff00
-#define MASK_B2			0x00ff0000
-#define MASK_B3			0xff000000
-#define MASK_W0			0x0000ffff
-#define MASK_W1			0xffff0000
-#define MASK_PA			0xfffffffc
-#define MASK_PR			0xfffffffe
-#define MASK_ER			0xffffffff
-#define MASK_NONE		0x00000000
-
-#define SAA7146_PAGE_MAP_EN	MASK_11
-/* main control register 1 */
-#define SAA7146_MC1_MRST_N	MASK_15
-#define SAA7146_MC1_ERPS1	MASK_13
-#define SAA7146_MC1_ERPS0	MASK_12
-#define SAA7146_MC1_EDP		MASK_11
-#define SAA7146_MC1_EVP		MASK_10
-#define SAA7146_MC1_EAP		MASK_09
-#define SAA7146_MC1_EI2C	MASK_08
-#define SAA7146_MC1_TR_E_DEBI	MASK_07
-#define SAA7146_MC1_TR_E_1	MASK_06
-#define SAA7146_MC1_TR_E_2	MASK_05
-#define SAA7146_MC1_TR_E_3	MASK_04
-#define SAA7146_MC1_TR_E_A2_OUT	MASK_03
-#define SAA7146_MC1_TR_E_A2_IN	MASK_02
-#define SAA7146_MC1_TR_E_A1_OUT	MASK_01
-#define SAA7146_MC1_TR_E_A1_IN	MASK_00
-/* main control register 2 */
-#define SAA7146_MC2_RPS_SIG4	MASK_15
-#define SAA7146_MC2_RPS_SIG3	MASK_14
-#define SAA7146_MC2_RPS_SIG2	MASK_13
-#define SAA7146_MC2_RPS_SIG1	MASK_12
-#define SAA7146_MC2_RPS_SIG0	MASK_11
-#define SAA7146_MC2_UPLD_D1_B	MASK_10
-#define SAA7146_MC2_UPLD_D1_A	MASK_09
-#define SAA7146_MC2_UPLD_BRS	MASK_08
-#define SAA7146_MC2_UPLD_HPS_H	MASK_06
-#define SAA7146_MC2_UPLD_HPS_V	MASK_05
-#define SAA7146_MC2_UPLD_DMA3	MASK_04
-#define SAA7146_MC2_UPLD_DMA2	MASK_03
-#define SAA7146_MC2_UPLD_DMA1	MASK_02
-#define SAA7146_MC2_UPLD_DEBI	MASK_01
-#define SAA7146_MC2_UPLD_I2C	MASK_00
-/* Primary Status Register and Interrupt Enable/Status Registers */
-#define SAA7146_PSR_PPEF	MASK_31
-#define SAA7146_PSR_PABO	MASK_30
-#define SAA7146_PSR_PPED	MASK_29
-#define SAA7146_PSR_RPS_I1	MASK_28
-#define SAA7146_PSR_RPS_I0	MASK_27
-#define SAA7146_PSR_RPS_LATE1	MASK_26
-#define SAA7146_PSR_RPS_LATE0	MASK_25
-#define SAA7146_PSR_RPS_E1	MASK_24
-#define SAA7146_PSR_RPS_E0	MASK_23
-#define SAA7146_PSR_RPS_TO1	MASK_22
-#define SAA7146_PSR_RPS_TO0	MASK_21
-#define SAA7146_PSR_UPLD	MASK_20
-#define SAA7146_PSR_DEBI_S	MASK_19
-#define SAA7146_PSR_DEBI_E	MASK_18
-#define SAA7146_PSR_I2C_S	MASK_17
-#define SAA7146_PSR_I2C_E	MASK_16
-#define SAA7146_PSR_A2_IN	MASK_15
-#define SAA7146_PSR_A2_OUT	MASK_14
-#define SAA7146_PSR_A1_IN	MASK_13
-#define SAA7146_PSR_A1_OUT	MASK_12
-#define SAA7146_PSR_AFOU	MASK_11
-#define SAA7146_PSR_V_PE	MASK_10
-#define SAA7146_PSR_VFOU	MASK_09
-#define SAA7146_PSR_FIDA	MASK_08
-#define SAA7146_PSR_FIDB	MASK_07
-#define SAA7146_PSR_PIN3	MASK_06
-#define SAA7146_PSR_PIN2	MASK_05
-#define SAA7146_PSR_PIN1	MASK_04
-#define SAA7146_PSR_PIN0	MASK_03
-#define SAA7146_PSR_ECS		MASK_02
-#define SAA7146_PSR_EC3S	MASK_01
-#define SAA7146_PSR_EC0S	MASK_00
-/* Secondary Status Register */
-#define SAA7146_SSR_PRQ		MASK_31
-#define SAA7146_SSR_PMA		MASK_30
-#define SAA7146_SSR_RPS_RE1	MASK_29
-#define SAA7146_SSR_RPS_PE1	MASK_28
-#define SAA7146_SSR_RPS_A1	MASK_27
-#define SAA7146_SSR_RPS_RE0	MASK_26
-#define SAA7146_SSR_RPS_PE0	MASK_25
-#define SAA7146_SSR_RPS_A0	MASK_24
-#define SAA7146_SSR_DEBI_TO	MASK_23
-#define SAA7146_SSR_DEBI_EF	MASK_22
-#define SAA7146_SSR_I2C_EA	MASK_21
-#define SAA7146_SSR_I2C_EW	MASK_20
-#define SAA7146_SSR_I2C_ER	MASK_19
-#define SAA7146_SSR_I2C_EL	MASK_18
-#define SAA7146_SSR_I2C_EF	MASK_17
-#define SAA7146_SSR_V3P		MASK_16
-#define SAA7146_SSR_V2P		MASK_15
-#define SAA7146_SSR_V1P		MASK_14
-#define SAA7146_SSR_VF3		MASK_13
-#define SAA7146_SSR_VF2		MASK_12
-#define SAA7146_SSR_VF1		MASK_11
-#define SAA7146_SSR_AF2_IN	MASK_10
-#define SAA7146_SSR_AF2_OUT	MASK_09
-#define SAA7146_SSR_AF1_IN	MASK_08
-#define SAA7146_SSR_AF1_OUT	MASK_07
-#define SAA7146_SSR_VGT		MASK_05
-#define SAA7146_SSR_LNQG	MASK_04
-#define SAA7146_SSR_EC5S	MASK_03
-#define SAA7146_SSR_EC4S	MASK_02
-#define SAA7146_SSR_EC2S	MASK_01
-#define SAA7146_SSR_EC1S	MASK_00
-/* I2C status register */
-#define SAA7146_I2C_ABORT	MASK_07
-#define SAA7146_I2C_SPERR	MASK_06
-#define SAA7146_I2C_APERR	MASK_05
-#define SAA7146_I2C_DTERR	MASK_04
-#define SAA7146_I2C_DRERR	MASK_03
-#define SAA7146_I2C_AL		MASK_02
-#define SAA7146_I2C_ERR		MASK_01
-#define SAA7146_I2C_BUSY	MASK_00
-/* output formats */
-#define SAA7146_YUV422	0
-#define SAA7146_RGB16	0
-#define SAA7146_YUV444	1
-#define SAA7146_RGB24	1
-#define SAA7146_ARGB32	2
-#define SAA7146_YUV411	3
-#define SAA7146_ARGB15  3
-#define SAA7146_YUV2	4
-#define SAA7146_RGAB15	4
-#define SAA7146_Y8	6
-#define SAA7146_YUV8	7
-#define SAA7146_RGB8	7
-#define SAA7146_YUV444p	8
-#define SAA7146_YUV422p	9
-#define SAA7146_YUV420p	10
-#define SAA7146_YUV1620	11
-#define SAA7146_Y1	13
-#define SAA7146_Y2	14
-#define SAA7146_YUV1	15
-#endif
-- 
1.7.7.6



