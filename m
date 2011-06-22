Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab1FVSme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:42:34 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:49891 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757970Ab1FVSma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:42:30 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [14/15] staging: ft1000-pcmcia: remove firmware download typedefs
Date: Wed, 22 Jun 2011 20:42:22 +0200
User-Agent: KMail/1.9.10
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106222042.24798.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove firmware download typedefs:
DFP_FILE_HDR, DSP_FILE_HDR_5, DSP_IMAGE_INFO, DSP_IMAGE_INFO_V6

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -93,7 +93,7 @@ long get_request_value(struct net_device *dev);
 void put_request_value(struct net_device *dev, long lvalue);
 USHORT hdr_checksum(struct pseudo_hdr *pHdr);
 
-typedef struct _DSP_FILE_HDR {
+struct dsp_file_hdr {
 	u32  build_date;
 	u32  dsp_coff_date;
 	u32  loader_code_address;
@@ -103,9 +103,9 @@ typedef struct _DSP_FILE_HDR {
 	u32  dsp_code_size;
 	u32  dsp_code_end;
 	u32  reserved[8];
-} __attribute__ ((packed)) DSP_FILE_HDR, *PDSP_FILE_HDR;
+} __attribute__ ((packed));
 
-typedef struct _DSP_FILE_HDR_5 {
+struct dsp_file_hdr_5 {
 	u32  version_id;	// Version ID of this image format.
 	u32  package_id;	// Package ID of code release.
 	u32  build_date;	// Date/time stamp when file was built.
@@ -117,18 +117,18 @@ typedef struct _DSP_FILE_HDR_5 {
 	u32  version_data_offset;	// Offset were scrambled version data begins.
 	u32  version_data_size;	// Size, in words, of scrambled version data.
 	u32  nDspImages;	// Number of DSP images in file.
-} __attribute__ ((packed)) DSP_FILE_HDR_5, *PDSP_FILE_HDR_5;
+} __attribute__ ((packed));
 
-typedef struct _DSP_IMAGE_INFO {
+struct dsp_image_info {
 	u32  coff_date;		// Date/time when DSP Coff image was built.
 	u32  begin_offset;	// Offset in file where image begins.
 	u32  end_offset;	// Offset in file where image begins.
 	u32  run_address;	// On chip Start address of DSP code.
 	u32  image_size;	// Size of image.
 	u32  version;		// Embedded version # of DSP code.
-} __attribute__ ((packed)) DSP_IMAGE_INFO, *PDSP_IMAGE_INFO;
+} __attribute__ ((packed));
 
-typedef struct _DSP_IMAGE_INFO_V6 {
+struct dsp_image_info_v6 {
 	u32  coff_date;		// Date/time when DSP Coff image was built.
 	u32  begin_offset;	// Offset in file where image begins.
 	u32  end_offset;	// Offset in file where image begins.
@@ -137,7 +137,7 @@ typedef struct _DSP_IMAGE_INFO_V6 {
 	u32  version;		// Embedded version # of DSP code.
 	unsigned short checksum;	// Dsp File checksum
 	unsigned short pad1;
-} __attribute__ ((packed)) DSP_IMAGE_INFO_V6, *PDSP_IMAGE_INFO_V6;
+} __attribute__ ((packed));
 
 void card_bootload(struct net_device *dev)
 {
@@ -317,15 +317,15 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 	USHORT handshake;
 	struct pseudo_hdr *pHdr;
 	USHORT usHdrLength;
-	PDSP_FILE_HDR pFileHdr;
+	struct dsp_file_hdr *pFileHdr;
 	long word_length;
 	USHORT request;
 	USHORT temp;
 	struct prov_record *pprov_record;
 	PUCHAR pbuffer;
-	PDSP_FILE_HDR_5 pFileHdr5;
-	PDSP_IMAGE_INFO pDspImageInfo = NULL;
-	PDSP_IMAGE_INFO_V6 pDspImageInfoV6 = NULL;
+	struct dsp_file_hdr_5 *pFileHdr5;
+	struct dsp_image_info *pDspImageInfo = NULL;
+	struct dsp_image_info_v6 *pDspImageInfoV6 = NULL;
 	long requested_version;
 	BOOLEAN bGoodVersion = 0;
 	struct drv_msg *pMailBoxData;
@@ -351,8 +351,8 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 
 	uiState = STATE_START_DWNLD;
 
-	pFileHdr = (PDSP_FILE_HDR) pFileStart;
-	pFileHdr5 = (PDSP_FILE_HDR_5) pFileStart;
+	pFileHdr = (struct dsp_file_hdr *) pFileStart;
+	pFileHdr5 = (struct dsp_file_hdr_5 *) pFileStart;
 
 	switch (file_version) {
 	case 5:
@@ -714,11 +714,11 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 						get_request_value(dev);
 					if (file_version == 5) {
 						pDspImageInfo =
-							(PDSP_IMAGE_INFO) ((long)
+							(struct dsp_image_info *) ((long)
 									   pFileStart
 									   +
 									   sizeof
-									   (DSP_FILE_HDR_5));
+									   (struct dsp_file_hdr_5));
 						for (imageN = 0;
 							 imageN <
 							 pFileHdr5->nDspImages;
@@ -761,11 +761,11 @@ int card_download(struct net_device *dev, const u8 *pFileStart, UINT FileLength)
 						}
 					} else {
 						pDspImageInfoV6 =
-							(PDSP_IMAGE_INFO_V6) ((long)
+							(struct dsp_image_info_v6 *) ((long)
 									  pFileStart
 									  +
 									  sizeof
-									  (DSP_FILE_HDR_5));
+									  (struct dsp_file_hdr_5));
 						for (imageN = 0;
 							 imageN <
 							 pFileHdr5->nDspImages;

-- 
Ondrej Zary
