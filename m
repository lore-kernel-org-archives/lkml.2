Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1BKMd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:33:29 -0500
Received: from ni.piap.pl ([195.187.100.4]:38279 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898Ab1BKMd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:33:28 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ben Collins <bcollins@bluecherry.net>, linux-kernel@vger.kernel.org
References: <m3sjvurd2f.fsf@t19.piap.pl>
Date: Fri, 11 Feb 2011 13:33:26 +0100
In-Reply-To: <m3sjvurd2f.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 11 Feb 2011 13:05:44 +0100")
MIME-Version: 1.0
Message-ID: <m34o8arbs9.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 5/7] Solo6x10: remove unneeded __solo parameter from SOLO_*_EXT_ADDR macros.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110211 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/solo6x10/solo6010-disp.c b/drivers/staging/solo6x10/solo6010-disp.c
index f866f84..99d1461 100644
--- a/drivers/staging/solo6x10/solo6010-disp.c
+++ b/drivers/staging/solo6x10/solo6010-disp.c
@@ -135,7 +135,7 @@ static void solo_disp_config(struct solo6010_dev *solo_dev)
 
 	solo_reg_write(solo_dev, SOLO_VO_DISP_CTRL, SOLO_VO_DISP_ON |
 		       SOLO_VO_DISP_ERASE_COUNT(8) |
-		       SOLO_VO_DISP_BASE(SOLO_DISP_EXT_ADDR(solo_dev)));
+		       SOLO_VO_DISP_BASE(SOLO_DISP_EXT_ADDR));
 
 	solo_reg_write(solo_dev, SOLO_VO_DISP_ERASE, SOLO_VO_DISP_ERASE_ON);
 
diff --git a/drivers/staging/solo6x10/solo6010-enc.c b/drivers/staging/solo6x10/solo6010-enc.c
index 743734d..7a3c4d5 100644
--- a/drivers/staging/solo6x10/solo6010-enc.c
+++ b/drivers/staging/solo6x10/solo6010-enc.c
@@ -93,8 +93,7 @@ static void solo_capture_config(struct solo6010_dev *solo_dev)
 
 	/* Clear OSD */
 	solo_reg_write(solo_dev, SOLO_VE_OSD_CH, 0);
-	solo_reg_write(solo_dev, SOLO_VE_OSD_BASE,
-		       SOLO_EOSD_EXT_ADDR(solo_dev) >> 16);
+	solo_reg_write(solo_dev, SOLO_VE_OSD_BASE, SOLO_EOSD_EXT_ADDR >> 16);
 	solo_reg_write(solo_dev, SOLO_VE_OSD_CLR,
 		       0xF0 << 16 | 0x80 << 8 | 0x80);
 	solo_reg_write(solo_dev, SOLO_VE_OSD_OPT, 0);
@@ -107,7 +106,7 @@ static void solo_capture_config(struct solo6010_dev *solo_dev)
 	for (i = 0; i < solo_dev->nr_chans; i++) {
 		for (j = 0; j < SOLO_EOSD_EXT_SIZE; j += OSG_BUFFER_SIZE) {
 			solo_p2m_dma(solo_dev, SOLO_P2M_DMA_ID_MP4E, 1, buf,
-				     SOLO_EOSD_EXT_ADDR(solo_dev) +
+				     SOLO_EOSD_EXT_ADDR +
 				     (i * SOLO_EOSD_EXT_SIZE) + j,
 				     OSG_BUFFER_SIZE);
 		}
@@ -143,7 +142,7 @@ int solo_osd_print(struct solo_enc_dev *solo_enc)
 		}
 	}
 
-	solo_p2m_dma(solo_dev, 0, 1, buf, SOLO_EOSD_EXT_ADDR(solo_dev) +
+	solo_p2m_dma(solo_dev, 0, 1, buf, SOLO_EOSD_EXT_ADDR +
 		     (solo_enc->ch * SOLO_EOSD_EXT_SIZE), SOLO_EOSD_EXT_SIZE);
 	reg |= (1 << solo_enc->ch);
 	solo_reg_write(solo_dev, SOLO_VE_OSD_CH, reg);
diff --git a/drivers/staging/solo6x10/solo6010-offsets.h b/drivers/staging/solo6x10/solo6010-offsets.h
index 2431de9..b176003 100644
--- a/drivers/staging/solo6x10/solo6010-offsets.h
+++ b/drivers/staging/solo6x10/solo6010-offsets.h
@@ -21,24 +21,20 @@
 #define __SOLO6010_OFFSETS_H
 
 /* Offsets and sizes of the external address */
-#define SOLO_DISP_EXT_ADDR(__solo)		0x00000000
+#define SOLO_DISP_EXT_ADDR			0x00000000
 #define SOLO_DISP_EXT_SIZE			0x00480000
 
-#define SOLO_DEC2LIVE_EXT_ADDR(__solo) \
-		(SOLO_DISP_EXT_ADDR(__solo) + SOLO_DISP_EXT_SIZE)
+#define SOLO_DEC2LIVE_EXT_ADDR (SOLO_DISP_EXT_ADDR + SOLO_DISP_EXT_SIZE)
 #define SOLO_DEC2LIVE_EXT_SIZE			0x00240000
 
-#define SOLO_OSG_EXT_ADDR(__solo) \
-		(SOLO_DEC2LIVE_EXT_ADDR(__solo) + SOLO_DEC2LIVE_EXT_SIZE)
+#define SOLO_OSG_EXT_ADDR (SOLO_DEC2LIVE_EXT_ADDR + SOLO_DEC2LIVE_EXT_SIZE)
 #define SOLO_OSG_EXT_SIZE			0x00120000
 
-#define SOLO_EOSD_EXT_ADDR(__solo) \
-		(SOLO_OSG_EXT_ADDR(__solo) + SOLO_OSG_EXT_SIZE)
+#define SOLO_EOSD_EXT_ADDR (SOLO_OSG_EXT_ADDR + SOLO_OSG_EXT_SIZE)
 #define SOLO_EOSD_EXT_SIZE			0x00010000
 
-#define SOLO_MOTION_EXT_ADDR(__solo) \
-		(SOLO_EOSD_EXT_ADDR(__solo) + \
-		 (SOLO_EOSD_EXT_SIZE * __solo->nr_chans))
+#define SOLO_MOTION_EXT_ADDR(__solo) (SOLO_EOSD_EXT_ADDR +	\
+				      (SOLO_EOSD_EXT_SIZE * __solo->nr_chans))
 #define SOLO_MOTION_EXT_SIZE			0x00080000
 
 #define SOLO_G723_EXT_ADDR(__solo) \
diff --git a/drivers/staging/solo6x10/solo6010-v4l2.c b/drivers/staging/solo6x10/solo6010-v4l2.c
index a8491dc..4e24e92 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2.c
+++ b/drivers/staging/solo6x10/solo6010-v4l2.c
@@ -280,7 +280,7 @@ static void solo_fillbuf(struct solo_filehandle *fh,
 	sg_dma = sg_dma_address(sg);
 	sg_size_left = sg_dma_len(sg);
 
-	fdma_addr = SOLO_DISP_EXT_ADDR(solo_dev) + (fh->old_write *
+	fdma_addr = SOLO_DISP_EXT_ADDR + (fh->old_write *
 			(SOLO_HW_BPL * solo_vlines(solo_dev)));
 
 	for (i = 0; i < solo_vlines(solo_dev); i++) {

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
