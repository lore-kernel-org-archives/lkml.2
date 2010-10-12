Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab0JLIZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:25:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63540 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757119Ab0JLIZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RZnjicEPYgQQz82qeydSg9M1mtejrLrlM7Jzqw6pX7DY2Ij9RmYEsNdYrYDJzuesnM
         dM9km3io/4ROy5NbjAOm2Q+1pOCrY5mx8S+qUcNvoJyGcE1KGN8gG6WLtIb3fooGWsv9
         8T2KUhN4MFUuFCTfaqKSpfKESE9qZKGGW3TdA=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vasiliy Kulikov <segooon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 4/4] staging:ft1000: get rid of typedef usage.
Date: Tue, 12 Oct 2010 10:26:43 +0200
Message-Id: <1286872003-12449-5-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
References: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   42 +++++---------------
 1 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 1f7c7a6..bbb2430 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -85,20 +85,7 @@
 #define  DWNLD_MAG1_SIZE_LOC          0x02
 #define  DWNLD_MAG1_PS_HDR_LOC        0x03
 
-#pragma pack (push, pack_save, 1)
-typedef struct _DSP_FILE_HDR {
-   long        build_date;
-   long        dsp_coff_date;
-   long        loader_code_address;
-   long        loader_code_size;
-   long        loader_code_end;
-   long        dsp_code_address;
-   long        dsp_code_size;
-   long        dsp_code_end;
-   long        reserved[8];
-} DSP_FILE_HDR, *PDSP_FILE_HDR;
-
-typedef struct _DSP_FILE_HDR_5 {
+struct dsp_file_hdr {
    long              version_id;          // Version ID of this image format.
    long              package_id;          // Package ID of code release.
    long              build_date;          // Date/time stamp when file was built.
@@ -110,18 +97,10 @@ typedef struct _DSP_FILE_HDR_5 {
    long              version_data_offset; // Offset were scrambled version data begins.
    long              version_data_size;   // Size, in words, of scrambled version data.
    long              nDspImages;          // Number of DSP images in file.
-} DSP_FILE_HDR_5, * PDSP_FILE_HDR_5;
+};
 
-typedef struct _DSP_IMAGE_INFO {
-   long              coff_date;           // Date/time when DSP Coff image was built.
-   long              begin_offset;        // Offset in file where image begins.
-   long              end_offset;          // Offset in file where image begins.
-   long              run_address;         // On chip Start address of DSP code.
-   long              image_size;          // Size of image.
-   long              version;             // Embedded version # of DSP code.
-} DSP_IMAGE_INFO, *PDSP_IMAGE_INFO;
-
-typedef struct _DSP_IMAGE_INFO_V6 {
+#pragma pack(1)
+struct dsp_image_info {
    long              coff_date;           // Date/time when DSP Coff image was built.
    long              begin_offset;        // Offset in file where image begins.
    long              end_offset;          // Offset in file where image begins.
@@ -130,7 +109,8 @@ typedef struct _DSP_IMAGE_INFO_V6 {
    long              version;             // Embedded version # of DSP code.
    unsigned short    checksum;            // DSP File checksum
    unsigned short    pad1;
-} DSP_IMAGE_INFO_V6, *PDSP_IMAGE_INFO_V6;
+};
+
 
 //---------------------------------------------------------------------------
 // Function:    check_usb_db
@@ -867,14 +847,13 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
    PPSEUDO_HDR             pHdr;
    USHORT                  usHdrLength;
    //PPROV_RECORD            pProvRecord;
-   PDSP_FILE_HDR           pFileHdr;
    long                    word_length;
    USHORT                  request;
    USHORT                  temp;
    USHORT                  tempword;
 
-   PDSP_FILE_HDR_5         pFileHdr5;
-   PDSP_IMAGE_INFO_V6      pDspImageInfoV6 = NULL;
+	struct dsp_file_hdr *pFileHdr5;
+	struct dsp_image_info *pDspImageInfoV6 = NULL;
    long                    requested_version;
    BOOLEAN                 bGoodVersion;
    PDRVMSG                 pMailBoxData;
@@ -907,8 +886,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 
    uiState = STATE_START_DWNLD;
 
-   pFileHdr = (PDSP_FILE_HDR)pFileStart;
-   pFileHdr5 = (PDSP_FILE_HDR_5)pFileStart;
+   pFileHdr5 = (struct dsp_file_hdr *)pFileStart;
 
    ft1000_write_register (ft1000dev, 0x800, FT1000_REG_MAG_WATERMARK);
 
@@ -1203,7 +1181,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                bGoodVersion = FALSE;
                requested_version = get_request_value(ft1000dev);
 
-                   pDspImageInfoV6 = (PDSP_IMAGE_INFO_V6)(pFileStart + sizeof(DSP_FILE_HDR_5));
+                   pDspImageInfoV6 = (struct dsp_image_info *)(pFileStart + sizeof(struct dsp_file_hdr ));
 
                for (imageN = 0; imageN < pFileHdr5->nDspImages; imageN++)
                {
-- 
1.7.1

