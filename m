Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab0GVBjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:39:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58891 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab0GVBjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=D5geh5RL4E5dyk1lZVU6Ytg/qmHrSZ4s2NEAWyCMB7TdJIQFsH2/2dxgvavNufZAgm
         0SVjRYK2VCh2muOdty5tlOgcLWrfwXQXXjvGuk1P88iWRpvNAFGDZPaXwlvIJ414I6KX
         clnpWPZ72v2EdL+YmBoQ4iX7jpHnUpy8D3ZUk=
From: ehames@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, ehames@gmail.com
Subject: [PATCH 2/2] Staging: wlan-ng: removed typedef from prism2fw.c
Date: Wed, 21 Jul 2010 22:31:56 -0300
Message-Id: <4c479f5e.19eb640a.387a.6ce5@mx.google.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1279762316-31076-1-git-send-email-y>
References: <1279762316-31076-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edgardo Hames <ehames@gmail.com>

Removed multiple typedef and fixed long lines.

Signed-off-by: Edgardo Hames <ehames@gmail.com>
---
 drivers/staging/wlan-ng/prism2fw.c |  102 ++++++++++++++++++------------------
 1 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index d20c879..f8fe17f 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -73,26 +73,26 @@ MODULE_FIRMWARE(PRISM2_USB_FWFILE);
 /*================================================================*/
 /* Local Types */
 
-typedef struct s3datarec {
+struct s3datarec {
 	u32 len;
 	u32 addr;
 	u8 checksum;
 	u8 *data;
-} s3datarec_t;
+};
 
-typedef struct s3plugrec {
+struct s3plugrec {
 	u32 itemcode;
 	u32 addr;
 	u32 len;
-} s3plugrec_t;
+};
 
-typedef struct s3crcrec {
+struct s3crcrec {
 	u32 addr;
 	u32 len;
 	unsigned int dowrite;
-} s3crcrec_t;
+};
 
-typedef struct s3inforec {
+struct s3inforec {
 	u16 len;
 	u16 type;
 	union {
@@ -101,20 +101,20 @@ typedef struct s3inforec {
 		u16 buildseq;
 		hfa384x_compident_t platform;
 	} info;
-} s3inforec_t;
+};
 
-typedef struct pda {
+struct pda {
 	u8 buf[HFA384x_PDA_LEN_MAX];
 	hfa384x_pdrec_t *rec[HFA384x_PDA_RECS_MAX];
 	unsigned int nrec;
-} pda_t;
+};
 
-typedef struct imgchunk {
+struct imgchunk {
 	u32 addr;	/* start address */
 	u32 len;	/* in bytes */
 	u16 crc;	/* CRC value (if it falls at a chunk boundary) */
 	u8 *data;
-} imgchunk_t;
+};
 
 /*================================================================*/
 /* Local Static Definitions */
@@ -124,26 +124,26 @@ typedef struct imgchunk {
 
 /* Data records */
 unsigned int ns3data;
-s3datarec_t s3data[S3DATA_MAX];
+struct s3datarec s3data[S3DATA_MAX];
 
 /* Plug records */
 unsigned int ns3plug;
-s3plugrec_t s3plug[S3PLUG_MAX];
+struct s3plugrec s3plug[S3PLUG_MAX];
 
 /* CRC records */
 unsigned int ns3crc;
-s3crcrec_t s3crc[S3CRC_MAX];
+struct s3crcrec s3crc[S3CRC_MAX];
 
 /* Info records */
 unsigned int ns3info;
-s3inforec_t s3info[S3INFO_MAX];
+struct s3inforec s3info[S3INFO_MAX];
 
 /* S7 record (there _better_ be only one) */
 u32 startaddr;
 
 /* Load image chunks */
 unsigned int nfchunks;
-imgchunk_t fchunk[CHUNKS_MAX];
+struct imgchunk fchunk[CHUNKS_MAX];
 
 /* Note that for the following pdrec_t arrays, the len and code */
 /*   fields are stored in HOST byte order. The mkpdrlist() function */
@@ -151,7 +151,7 @@ imgchunk_t fchunk[CHUNKS_MAX];
 /*----------------------------------------------------------------*/
 /* PDA, built from [card|newfile]+[addfile1+addfile2...] */
 
-pda_t pda;
+struct pda pda;
 hfa384x_compident_t nicid;
 hfa384x_caplevel_t rfid;
 hfa384x_caplevel_t macid;
@@ -165,21 +165,21 @@ wlandevice_t *wlandev);
 
 static int read_fwfile(const struct ihex_binrec *rfptr);
 
-static int mkimage(imgchunk_t *clist, unsigned int *ccnt);
+static int mkimage(struct imgchunk *clist, unsigned int *ccnt);
 
-static int read_cardpda(pda_t *pda, wlandevice_t *wlandev);
+static int read_cardpda(struct pda *pda, wlandevice_t *wlandev);
 
-static int mkpdrlist(pda_t *pda);
+static int mkpdrlist(struct pda *pda);
 
-static int plugimage(imgchunk_t *fchunk, unsigned int nfchunks,
-	      s3plugrec_t *s3plug, unsigned int ns3plug, pda_t * pda);
+static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
+	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda);
 
-static int crcimage(imgchunk_t *fchunk, unsigned int nfchunks,
-	     s3crcrec_t *s3crc, unsigned int ns3crc);
+static int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
+	     struct s3crcrec *s3crc, unsigned int ns3crc);
 
-static int writeimage(wlandevice_t *wlandev, imgchunk_t *fchunk,
+static int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 	       unsigned int nfchunks);
-static void free_chunks(imgchunk_t *fchunk, unsigned int *nfchunks);
+static void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks);
 
 static void free_srecs(void);
 
@@ -375,8 +375,8 @@ int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
 *	0	success
 *	~0	failure
 ----------------------------------------------------------------*/
-int crcimage(imgchunk_t *fchunk, unsigned int nfchunks, s3crcrec_t *s3crc,
-	     unsigned int ns3crc)
+int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
+	     struct s3crcrec *s3crc, unsigned int ns3crc)
 {
 	int result = 0;
 	int i;
@@ -397,15 +397,14 @@ int crcimage(imgchunk_t *fchunk, unsigned int nfchunks, s3crcrec_t *s3crc,
 		for (c = 0; c < nfchunks; c++) {
 			cstart = fchunk[c].addr;
 			cend = fchunk[c].addr + fchunk[c].len;
-			/*  the line below does an address & len match search */
-			/*  unfortunately, I've found that the len fields of */
-			/*  some crc records don't match with the length of */
-			/*  the actual data, so we're not checking right */
-			/*  now */
-			/* if ( crcstart-2 >= cstart && crcend <= cend ) break; */
+			/* the line below does an address & len match search */
+			/* unfortunately, I've found that the len fields of */
+			/* some crc records don't match with the length of */
+			/* the actual data, so we're not checking right now */
+			/* if (crcstart-2 >= cstart && crcend <= cend) break; */
 
 			/* note the -2 below, it's to make sure the chunk has */
-			/*   space for the CRC value */
+			/* space for the CRC value */
 			if (crcstart - 2 >= cstart && crcstart < cend)
 				break;
 		}
@@ -440,7 +439,7 @@ int crcimage(imgchunk_t *fchunk, unsigned int nfchunks, s3crcrec_t *s3crc,
 * Returns:
 *	nothing
 ----------------------------------------------------------------*/
-void free_chunks(imgchunk_t *fchunk, unsigned int *nfchunks)
+void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks)
 {
 	int i;
 	for (i = 0; i < *nfchunks; i++) {
@@ -490,7 +489,7 @@ void free_srecs(void)
 *	0	- success
 *	~0	- failure (probably an errno)
 ----------------------------------------------------------------*/
-int mkimage(imgchunk_t *clist, unsigned int *ccnt)
+int mkimage(struct imgchunk *clist, unsigned int *ccnt)
 {
 	int result = 0;
 	int i;
@@ -583,7 +582,7 @@ int mkimage(imgchunk_t *clist, unsigned int *ccnt)
 *	0	- success
 *	~0	- failure (probably an errno)
 ----------------------------------------------------------------*/
-int mkpdrlist(pda_t *pda)
+int mkpdrlist(struct pda *pda)
 {
 	int result = 0;
 	u16 *pda16 = (u16 *) pda->buf;
@@ -656,8 +655,8 @@ int mkpdrlist(pda_t *pda)
 *	0	success
 *	~0	failure
 ----------------------------------------------------------------*/
-int plugimage(imgchunk_t *fchunk, unsigned int nfchunks,
-	      s3plugrec_t *s3plug, unsigned int ns3plug, pda_t * pda)
+int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
+	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda)
 {
 	int result = 0;
 	int i;			/* plug index */
@@ -675,7 +674,7 @@ int plugimage(imgchunk_t *fchunk, unsigned int nfchunks,
 		pstart = s3plug[i].addr;
 		pend = s3plug[i].addr + s3plug[i].len;
 		/* find the matching PDR (or filename) */
-		if (s3plug[i].itemcode != 0xffffffffUL) {	/* not filename */
+		if (s3plug[i].itemcode != 0xffffffffUL) { /* not filename */
 			for (j = 0; j < pda->nrec; j++) {
 				if (s3plug[i].itemcode ==
 				    le16_to_cpu(pda->rec[j]->code))
@@ -684,7 +683,7 @@ int plugimage(imgchunk_t *fchunk, unsigned int nfchunks,
 		} else {
 			j = -1;
 		}
-		if (j >= pda->nrec && j != -1) {	/*  if no matching PDR, fail */
+		if (j >= pda->nrec && j != -1) { /*  if no matching PDR, fail */
 			printk(KERN_WARNING
 			       "warning: Failed to find PDR for "
 			       "plugrec 0x%04x.\n", s3plug[i].itemcode);
@@ -764,7 +763,7 @@ int plugimage(imgchunk_t *fchunk, unsigned int nfchunks,
 *	0	- success
 *	~0	- failure (probably an errno)
 ----------------------------------------------------------------*/
-int read_cardpda(pda_t *pda, wlandevice_t *wlandev)
+int read_cardpda(struct pda *pda, wlandevice_t *wlandev)
 {
 	int result = 0;
 	p80211msg_p2req_readpda_t msg;
@@ -839,7 +838,7 @@ int read_cardpda(pda_t *pda, wlandevice_t *wlandev)
 *                ssssttttdd..dd
 *                s - Size in words (little endian)
 *                t - Info type (little endian), see #defines and
-*                    s3inforec_t for details about types.
+*                    struct s3inforec for details about types.
 *                d - (s - 1) little endian words giving the contents of
 *                    the given info type.
 *
@@ -978,7 +977,7 @@ int read_fwfile(const struct ihex_binrec *record)
 *	0	success
 *	~0	failure
 ----------------------------------------------------------------*/
-int writeimage(wlandevice_t *wlandev, imgchunk_t *fchunk,
+int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 	       unsigned int nfchunks)
 {
 	int result = 0;
@@ -1052,11 +1051,12 @@ int writeimage(wlandevice_t *wlandev, imgchunk_t *fchunk,
 		nwrites += (fchunk[i].len % WRITESIZE_MAX) ? 1 : 0;
 		curroff = 0;
 		for (j = 0; j < nwrites; j++) {
-			currlen =
-			    (fchunk[i].len - (WRITESIZE_MAX * j)) >
-			    WRITESIZE_MAX ? WRITESIZE_MAX : (fchunk[i].len -
-							     (WRITESIZE_MAX *
-							      j));
+			/* TODO Move this to a separate function */
+			int lenleft = fchunk[i].len - (WRITESIZE_MAX * j);
+			if (fchunk[i].len > WRITESIZE_MAX)
+				currlen = WRITESIZE_MAX;
+			else
+				currlen = lenleft;
 			curroff = j * WRITESIZE_MAX;
 			currdaddr = fchunk[i].addr + curroff;
 			/* Setup the message */
-- 
1.6.3.3

