Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab1CWHI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:08:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64329 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1CWHIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=w4zG2buMDewKTx3s3F49XbSFFx+6jjTcLPPBYRgmbxeemw5pg5Z9nejqzzcOmwg2gR
         rCR+6um0XInC9mAIYPEQ9VXMfoHMpussBvn8gs+K3GPTXoWUzXZZXVLpNszeKqWsWWZw
         FlZSrRnfpZMeZcZqZM/k5S9NoIVMOMzx2TepI=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Stano Lanci <chl.pixo@gmail.com>,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] staging: ft1000-pcmcia: Fix ft1000_dnld() to work also on 64bit architectures.
Date: Wed, 23 Mar 2011 08:08:08 +0100
Message-Id: <1300864088-24438-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: pixo <pixo@pixo-LIFEBOOK-E8310.(none)>

Firmware file needs to be read by 4bytes also on 64 bit architectures.
Change long type to u32 and also extend checking. Tested on 32 and also
64 bit architectures.

Signed-off-by: Stano Lanci <chl.pixo@gmail.com>
Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>

Tested-by: Stano Lanci <chl.pixo@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |   78 ++++++++++----------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
index b0729fc..fb375ea 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -95,47 +95,47 @@ void put_request_value(struct net_device *dev, long lvalue);
 USHORT hdr_checksum(PPSEUDO_HDR pHdr);
 
 typedef struct _DSP_FILE_HDR {
-	long build_date;
-	long dsp_coff_date;
-	long loader_code_address;
-	long loader_code_size;
-	long loader_code_end;
-	long dsp_code_address;
-	long dsp_code_size;
-	long dsp_code_end;
-	long reserved[8];
+	u32  build_date;
+	u32  dsp_coff_date;
+	u32  loader_code_address;
+	u32  loader_code_size;
+	u32  loader_code_end;
+	u32  dsp_code_address;
+	u32  dsp_code_size;
+	u32  dsp_code_end;
+	u32  reserved[8];
 } __attribute__ ((packed)) DSP_FILE_HDR, *PDSP_FILE_HDR;
 
 typedef struct _DSP_FILE_HDR_5 {
-	long version_id;	// Version ID of this image format.
-	long package_id;	// Package ID of code release.
-	long build_date;	// Date/time stamp when file was built.
-	long commands_offset;	// Offset to attached commands in Pseudo Hdr format.
-	long loader_offset;	// Offset to bootloader code.
-	long loader_code_address;	// Start address of bootloader.
-	long loader_code_end;	// Where bootloader code ends.
-	long loader_code_size;
-	long version_data_offset;	// Offset were scrambled version data begins.
-	long version_data_size;	// Size, in words, of scrambled version data.
-	long nDspImages;	// Number of DSP images in file.
+	u32  version_id;	// Version ID of this image format.
+	u32  package_id;	// Package ID of code release.
+	u32  build_date;	// Date/time stamp when file was built.
+	u32  commands_offset;	// Offset to attached commands in Pseudo Hdr format.
+	u32  loader_offset;	// Offset to bootloader code.
+	u32  loader_code_address;	// Start address of bootloader.
+	u32  loader_code_end;	// Where bootloader code ends.
+	u32  loader_code_size;
+	u32  version_data_offset;	// Offset were scrambled version data begins.
+	u32  version_data_size;	// Size, in words, of scrambled version data.
+	u32  nDspImages;	// Number of DSP images in file.
 } __attribute__ ((packed)) DSP_FILE_HDR_5, *PDSP_FILE_HDR_5;
 
 typedef struct _DSP_IMAGE_INFO {
-	long coff_date;		// Date/time when DSP Coff image was built.
-	long begin_offset;	// Offset in file where image begins.
-	long end_offset;	// Offset in file where image begins.
-	long run_address;	// On chip Start address of DSP code.
-	long image_size;	// Size of image.
-	long version;		// Embedded version # of DSP code.
+	u32  coff_date;		// Date/time when DSP Coff image was built.
+	u32  begin_offset;	// Offset in file where image begins.
+	u32  end_offset;	// Offset in file where image begins.
+	u32  run_address;	// On chip Start address of DSP code.
+	u32  image_size;	// Size of image.
+	u32  version;		// Embedded version # of DSP code.
 } __attribute__ ((packed)) DSP_IMAGE_INFO, *PDSP_IMAGE_INFO;
 
 typedef struct _DSP_IMAGE_INFO_V6 {
-	long coff_date;		// Date/time when DSP Coff image was built.
-	long begin_offset;	// Offset in file where image begins.
-	long end_offset;	// Offset in file where image begins.
-	long run_address;	// On chip Start address of DSP code.
-	long image_size;	// Size of image.
-	long version;		// Embedded version # of DSP code.
+	u32  coff_date;		// Date/time when DSP Coff image was built.
+	u32  begin_offset;	// Offset in file where image begins.
+	u32  end_offset;	// Offset in file where image begins.
+	u32  run_address;	// On chip Start address of DSP code.
+	u32  image_size;	// Size of image.
+	u32  version;		// Embedded version # of DSP code.
 	unsigned short checksum;	// Dsp File checksum
 	unsigned short pad1;
 } __attribute__ ((packed)) DSP_IMAGE_INFO_V6, *PDSP_IMAGE_INFO_V6;
@@ -846,8 +846,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 			break;
 
 		case STATE_DONE_DWNLD:
-			if (((UINT) (pUcFile) - (UINT) pFileStart) >=
-				(UINT) FileLength) {
+			if (((unsigned long) (pUcFile) - (unsigned long) pFileStart) >=
+				(unsigned long) FileLength) {
 				uiState = STATE_DONE_FILE;
 				break;
 			}
@@ -901,11 +901,11 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 								  &info->prov_list);
 						// Move to next entry if available
 						pUcFile =
-							(UCHAR *) ((UINT) pUcFile +
-								   (UINT) ((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(PSEUDO_HDR));
-						if ((UINT) (pUcFile) -
-							(UINT) (pFileStart) >=
-							(UINT) FileLength) {
+							(UCHAR *) ((unsigned long) pUcFile +
+								   (unsigned long) ((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(PSEUDO_HDR));
+						if ((unsigned long) (pUcFile) -
+							(unsigned long) (pFileStart) >=
+							(unsigned long) FileLength) {
 							uiState =
 								STATE_DONE_FILE;
 						}
-- 
1.7.1

