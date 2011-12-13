Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab1LMLmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:42:19 -0500
Received: from mail.nonattached.net ([193.160.39.30]:58726 "EHLO
	mail.nonattached.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1LMLmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:42:16 -0500
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Dec 2011 06:42:15 EST
From: Dan Luedtke <mail@danrl.de>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Luedtke <mail@danrl.de>
Subject: [PATCH] staging: wlan-ng: prism: coding style fixes, removed space-indentations
Date: Tue, 13 Dec 2011 12:35:37 +0100
Message-Id: <1323776137-458-1-git-send-email-mail@danrl.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues. Converted multiple spaces to tabs.

(Please provide feedback on problems, it's my first kernel patch ever)

Signed-off-by: Dan Luedtke <mail@danrl.de>
---
 drivers/staging/wlan-ng/prism2fw.c |  190 +++++++++++++++++++-----------------
 1 files changed, 99 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 3c40096..e035839 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -172,13 +172,14 @@ static int read_cardpda(struct pda *pda, wlandevice_t *wlandev);
 static int mkpdrlist(struct pda *pda);
 
 static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
-	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda);
+	struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda);
 
 static int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
-	     struct s3crcrec *s3crc, unsigned int ns3crc);
+				struct s3crcrec *s3crc, unsigned int ns3crc);
 
 static int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
-	       unsigned int nfchunks);
+							unsigned int nfchunks);
+
 static void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks);
 
 static void free_srecs(void);
@@ -200,23 +201,23 @@ static int validate_identity(void);
 * Returns:
 *	0	- success
 *	~0	- failure
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
 {
 	const struct firmware *fw_entry = NULL;
 
 	printk(KERN_INFO "prism2_usb: Checking for firmware %s\n",
-	       PRISM2_USB_FWFILE);
+		PRISM2_USB_FWFILE);
 	if (request_ihex_firmware(&fw_entry, PRISM2_USB_FWFILE, &udev->dev) != 0) {
 		printk(KERN_INFO
-		       "prism2_usb: Firmware not available, but not essential\n");
+			"prism2_usb: Firmware not available, but not essential\n");
 		printk(KERN_INFO
-		       "prism2_usb: can continue to use card anyway.\n");
+			"prism2_usb: can continue to use card anyway.\n");
 		return 1;
 	}
 
 	printk(KERN_INFO "prism2_usb: %s will be processed, size %zu\n",
-	       PRISM2_USB_FWFILE, fw_entry->size);
+		PRISM2_USB_FWFILE, fw_entry->size);
 	prism2_fwapply((const struct ihex_binrec *)fw_entry->data, wlandev);
 
 	release_firmware(fw_entry);
@@ -235,7 +236,7 @@ int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
 * Returns:
 *	0	- success
 *	~0	- failure
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
 {
 	signed int result = 0;
@@ -374,9 +375,9 @@ int prism2_fwapply(const struct ihex_binrec *rfptr, wlandevice_t *wlandev)
 * Returns:
 *	0	success
 *	~0	failure
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
-	     struct s3crcrec *s3crc, unsigned int ns3crc)
+				struct s3crcrec *s3crc, unsigned int ns3crc)
 {
 	int result = 0;
 	int i;
@@ -410,10 +411,10 @@ int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
 		}
 		if (c >= nfchunks) {
 			printk(KERN_ERR
-			       "Failed to find chunk for "
-			       "crcrec[%d], addr=0x%06x len=%d , "
-			       "aborting crc.\n",
-			       i, s3crc[i].addr, s3crc[i].len);
+				"Failed to find chunk for "
+				"crcrec[%d], addr=0x%06x len=%d , "
+				"aborting crc.\n",
+				i, s3crc[i].addr, s3crc[i].len);
 			return 1;
 		}
 
@@ -438,7 +439,7 @@ int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
 *
 * Returns:
 *	nothing
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks)
 {
 	int i;
@@ -460,7 +461,7 @@ void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks)
 *
 * Returns:
 *	nothing
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 void free_srecs(void)
 {
 	ns3data = 0;
@@ -487,7 +488,7 @@ void free_srecs(void)
 * Returns:
 *	0	- success
 *	~0	- failure (probably an errno)
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int mkimage(struct imgchunk *clist, unsigned int *ccnt)
 {
 	int result = 0;
@@ -521,7 +522,8 @@ int mkimage(struct imgchunk *clist, unsigned int *ccnt)
 			/* their beginning bound */
 			for (j = 0; j < ns3crc; j++) {
 				if (s3crc[j].dowrite &&
-				    s3crc[j].addr == clist[currchunk].addr) {
+					s3crc[j].addr ==
+					clist[currchunk].addr) {
 					clist[currchunk].addr -= 2;
 					clist[currchunk].len += 2;
 				}
@@ -537,7 +539,7 @@ int mkimage(struct imgchunk *clist, unsigned int *ccnt)
 		clist[i].data = kzalloc(clist[i].len, GFP_KERNEL);
 		if (clist[i].data == NULL) {
 			printk(KERN_ERR
-			       "failed to allocate image space, exitting.\n");
+				"failed to allocate image space, exitting.\n");
 			return 1;
 		}
 		pr_debug("chunk[%d]: addr=0x%06x len=%d\n",
@@ -556,8 +558,8 @@ int mkimage(struct imgchunk *clist, unsigned int *ccnt)
 		}
 		if (((unsigned int)j) >= (*ccnt)) {
 			printk(KERN_ERR
-			       "s3rec(a=0x%06x,l=%d), no chunk match, exiting.\n",
-			       s3start, s3data[i].len);
+				"s3rec(a=0x%06x,l=%d), no chunk match, exiting.\n",
+				s3start, s3data[i].len);
 			return 1;
 		}
 		coffset = s3start - cstart;
@@ -580,7 +582,7 @@ int mkimage(struct imgchunk *clist, unsigned int *ccnt)
 * Returns:
 *	0	- success
 *	~0	- failure (probably an errno)
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int mkpdrlist(struct pda *pda)
 {
 	int result = 0;
@@ -590,30 +592,30 @@ int mkpdrlist(struct pda *pda)
 	pda->nrec = 0;
 	curroff = 0;
 	while (curroff < (HFA384x_PDA_LEN_MAX / 2) &&
-	       le16_to_cpu(pda16[curroff + 1]) != HFA384x_PDR_END_OF_PDA) {
+		le16_to_cpu(pda16[curroff + 1]) != HFA384x_PDR_END_OF_PDA) {
 		pda->rec[pda->nrec] = (hfa384x_pdrec_t *) &(pda16[curroff]);
 
 		if (le16_to_cpu(pda->rec[pda->nrec]->code) == HFA384x_PDR_NICID) {
 			memcpy(&nicid, &pda->rec[pda->nrec]->data.nicid,
-			       sizeof(nicid));
+				sizeof(nicid));
 			nicid.id = le16_to_cpu(nicid.id);
 			nicid.variant = le16_to_cpu(nicid.variant);
 			nicid.major = le16_to_cpu(nicid.major);
 			nicid.minor = le16_to_cpu(nicid.minor);
 		}
 		if (le16_to_cpu(pda->rec[pda->nrec]->code) ==
-		    HFA384x_PDR_MFISUPRANGE) {
+			HFA384x_PDR_MFISUPRANGE) {
 			memcpy(&rfid, &pda->rec[pda->nrec]->data.mfisuprange,
-			       sizeof(rfid));
+				sizeof(rfid));
 			rfid.id = le16_to_cpu(rfid.id);
 			rfid.variant = le16_to_cpu(rfid.variant);
 			rfid.bottom = le16_to_cpu(rfid.bottom);
 			rfid.top = le16_to_cpu(rfid.top);
 		}
 		if (le16_to_cpu(pda->rec[pda->nrec]->code) ==
-		    HFA384x_PDR_CFISUPRANGE) {
+			HFA384x_PDR_CFISUPRANGE) {
 			memcpy(&macid, &pda->rec[pda->nrec]->data.cfisuprange,
-			       sizeof(macid));
+				sizeof(macid));
 			macid.id = le16_to_cpu(macid.id);
 			macid.variant = le16_to_cpu(macid.variant);
 			macid.bottom = le16_to_cpu(macid.bottom);
@@ -626,8 +628,8 @@ int mkpdrlist(struct pda *pda)
 	}
 	if (curroff >= (HFA384x_PDA_LEN_MAX / 2)) {
 		printk(KERN_ERR
-		       "no end record found or invalid lengths in "
-		       "PDR data, exiting. %x %d\n", curroff, pda->nrec);
+			"no end record found or invalid lengths in "
+			"PDR data, exiting. %x %d\n", curroff, pda->nrec);
 		return 1;
 	}
 	if (le16_to_cpu(pda16[curroff + 1]) == HFA384x_PDR_END_OF_PDA) {
@@ -653,9 +655,9 @@ int mkpdrlist(struct pda *pda)
 * Returns:
 *	0	success
 *	~0	failure
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
-	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda)
+	struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda)
 {
 	int result = 0;
 	int i;			/* plug index */
@@ -676,7 +678,7 @@ int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 		if (s3plug[i].itemcode != 0xffffffffUL) { /* not filename */
 			for (j = 0; j < pda->nrec; j++) {
 				if (s3plug[i].itemcode ==
-				    le16_to_cpu(pda->rec[j]->code))
+					le16_to_cpu(pda->rec[j]->code))
 					break;
 			}
 		} else {
@@ -684,8 +686,8 @@ int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 		}
 		if (j >= pda->nrec && j != -1) { /*  if no matching PDR, fail */
 			printk(KERN_WARNING
-			       "warning: Failed to find PDR for "
-			       "plugrec 0x%04x.\n", s3plug[i].itemcode);
+				"warning: Failed to find PDR for "
+				"plugrec 0x%04x.\n", s3plug[i].itemcode);
 			continue;	/* and move on to the next PDR */
 #if 0
 			/* MSM: They swear that unless it's the MAC address,
@@ -703,9 +705,9 @@ int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 		/* Validate plug len against PDR len */
 		if (j != -1 && s3plug[i].len < le16_to_cpu(pda->rec[j]->len)) {
 			printk(KERN_ERR
-			       "error: Plug vs. PDR len mismatch for "
-			       "plugrec 0x%04x, abort plugging.\n",
-			       s3plug[i].itemcode);
+				"error: Plug vs. PDR len mismatch for "
+				"plugrec 0x%04x, abort plugging.\n",
+				s3plug[i].itemcode);
 			result = 1;
 			continue;
 		}
@@ -719,8 +721,8 @@ int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 		}
 		if (c >= nfchunks) {
 			printk(KERN_ERR
-			       "error: Failed to find image chunk for "
-			       "plugrec 0x%04x.\n", s3plug[i].itemcode);
+				"error: Failed to find image chunk for "
+				"plugrec 0x%04x.\n", s3plug[i].itemcode);
 			result = 1;
 			continue;
 		}
@@ -761,7 +763,7 @@ int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 * Returns:
 *	0	- success
 *	~0	- failure (probably an errno)
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int read_cardpda(struct pda *pda, wlandevice_t *wlandev)
 {
 	int result = 0;
@@ -851,7 +853,7 @@ int read_cardpda(struct pda *pda, wlandevice_t *wlandev)
 * Returns:
 *	0	- success
 *	~0	- failure (probably an errno)
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int read_fwfile(const struct ihex_binrec *record)
 {
 	int		i;
@@ -878,9 +880,9 @@ int read_fwfile(const struct ihex_binrec *record)
 		case S3ADDR_START:
 			startaddr = *ptr32;
 			pr_debug("  S7 start addr, record=%d "
-				      " addr=0x%08x\n",
-				      rcnt,
-				      startaddr);
+					" addr=0x%08x\n",
+					rcnt,
+					startaddr);
 			break;
 		case S3ADDR_PLUG:
 			s3plug[ns3plug].itemcode = *ptr32;
@@ -888,15 +890,16 @@ int read_fwfile(const struct ihex_binrec *record)
 			s3plug[ns3plug].len = *(ptr32 + 2);
 
 			pr_debug("  S3 plugrec, record=%d "
-				      "itemcode=0x%08x addr=0x%08x len=%d\n",
-				      rcnt,
-				      s3plug[ns3plug].itemcode,
-				      s3plug[ns3plug].addr,
-				      s3plug[ns3plug].len);
+					"itemcode=0x%08x addr=0x%08x len=%d\n",
+					rcnt,
+					s3plug[ns3plug].itemcode,
+					s3plug[ns3plug].addr,
+					s3plug[ns3plug].len);
 
 			ns3plug++;
 			if (ns3plug == S3PLUG_MAX) {
-				printk(KERN_ERR "S3 plugrec limit reached - aborting\n");
+				printk(KERN_ERR "S3 plugrec limit reached"
+						" - aborting\n");
 				return 1;
 			}
 			break;
@@ -906,14 +909,15 @@ int read_fwfile(const struct ihex_binrec *record)
 			s3crc[ns3crc].dowrite = *(ptr32 + 2);
 
 			pr_debug("  S3 crcrec, record=%d "
-				      "addr=0x%08x len=%d write=0x%08x\n",
-				      rcnt,
-				      s3crc[ns3crc].addr,
-				      s3crc[ns3crc].len,
-				      s3crc[ns3crc].dowrite);
+					"addr=0x%08x len=%d write=0x%08x\n",
+					rcnt,
+					s3crc[ns3crc].addr,
+					s3crc[ns3crc].len,
+					s3crc[ns3crc].dowrite);
 			ns3crc++;
 			if (ns3crc == S3CRC_MAX) {
-				printk(KERN_ERR "S3 crcrec limit reached - aborting\n");
+				printk(KERN_ERR "S3 crcrec limit reached"
+					" - aborting\n");
 				return 1;
 			}
 			break;
@@ -922,17 +926,19 @@ int read_fwfile(const struct ihex_binrec *record)
 			s3info[ns3info].type = *(ptr16 + 1);
 
 			pr_debug("  S3 inforec, record=%d "
-			      "len=0x%04x type=0x%04x\n",
-				      rcnt,
-				      s3info[ns3info].len,
-				      s3info[ns3info].type);
-			if (((s3info[ns3info].len - 1) * sizeof(u16)) > sizeof(s3info[ns3info].info)) {
-				printk(KERN_ERR " S3 inforec length too long - aborting\n");
+					"len=0x%04x type=0x%04x\n",
+					rcnt,
+					s3info[ns3info].len,
+					s3info[ns3info].type);
+			if (((s3info[ns3info].len - 1) * sizeof(u16)) >
+				sizeof(s3info[ns3info].info)) {
+				printk(KERN_ERR " S3 inforec length too long"
+					" - aborting\n");
 				return 1;
 			}
 
 			tmpinfo = (u16 *)&(s3info[ns3info].info.version);
-			pr_debug("            info=");
+			pr_debug("	     info=");
 			for (i = 0; i < s3info[ns3info].len - 1; i++) {
 				tmpinfo[i] = *(ptr16 + 2 + i);
 				pr_debug("%04x ", tmpinfo[i]);
@@ -941,7 +947,8 @@ int read_fwfile(const struct ihex_binrec *record)
 
 			ns3info++;
 			if (ns3info == S3INFO_MAX) {
-				printk(KERN_ERR "S3 inforec limit reached - aborting\n");
+				printk(KERN_ERR "S3 inforec limit reached"
+					" - aborting\n");
 				return 1;
 			}
 			break;
@@ -951,7 +958,8 @@ int read_fwfile(const struct ihex_binrec *record)
 			s3data[ns3data].data = (uint8_t *) record->data;
 			ns3data++;
 			if (ns3data == S3DATA_MAX) {
-				printk(KERN_ERR "S3 datarec limit reached - aborting\n");
+				printk(KERN_ERR "S3 datarec limit reached"
+					" - aborting\n");
 				return 1;
 			}
 			break;
@@ -975,9 +983,9 @@ int read_fwfile(const struct ihex_binrec *record)
 * Returns:
 *	0	success
 *	~0	failure
-----------------------------------------------------------------*/
+*----------------------------------------------------------------*/
 int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
-	       unsigned int nfchunks)
+		unsigned int nfchunks)
 {
 	int result = 0;
 	struct p80211msg_p2req_ramdl_state rstatemsg;
@@ -1032,15 +1040,15 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 	result = prism2mgmt_ramdl_state(wlandev, msgp);
 	if (result) {
 		printk(KERN_ERR
-		       "writeimage state enable failed w/ result=%d, "
-		       "aborting download\n", result);
+			"writeimage state enable failed w/ result=%d, "
+			"aborting download\n", result);
 		return result;
 	}
 	resultcode = rstatemsg.resultcode.data;
 	if (resultcode != P80211ENUM_resultcode_success) {
 		printk(KERN_ERR
-		       "writeimage()->xxxdl_state msg indicates failure, "
-		       "w/ resultcode=%d, aborting download.\n", resultcode);
+			"writeimage()->xxxdl_state msg indicates failure, "
+			"w/ resultcode=%d, aborting download.\n", resultcode);
 		return 1;
 	}
 
@@ -1062,12 +1070,12 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 			rwritemsg.addr.data = currdaddr;
 			rwritemsg.len.data = currlen;
 			memcpy(rwritemsg.data.data,
-			       fchunk[i].data + curroff, currlen);
+				fchunk[i].data + curroff, currlen);
 
 			/* Send flashdl_write(pda) */
 			pr_debug
-			    ("Sending xxxdl_write message addr=%06x len=%d.\n",
-			     currdaddr, currlen);
+				("Sending xxxdl_write message addr=%06x len=%d.\n",
+				currdaddr, currlen);
 
 			msgp = (struct p80211msg *) &rwritemsg;
 			result = prism2mgmt_ramdl_write(wlandev, msgp);
@@ -1075,16 +1083,16 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 			/* Check the results */
 			if (result) {
 				printk(KERN_ERR
-				       "writeimage chunk write failed w/ result=%d, "
-				       "aborting download\n", result);
+					"writeimage chunk write failed w/ result=%d, "
+					"aborting download\n", result);
 				return result;
 			}
 			resultcode = rstatemsg.resultcode.data;
 			if (resultcode != P80211ENUM_resultcode_success) {
 				printk(KERN_ERR
-				       "writeimage()->xxxdl_write msg indicates failure, "
-				       "w/ resultcode=%d, aborting download.\n",
-				       resultcode);
+					"writeimage()->xxxdl_write msg indicates failure, "
+					"w/ resultcode=%d, aborting download.\n",
+					resultcode);
 				return 1;
 			}
 
@@ -1100,15 +1108,15 @@ int writeimage(wlandevice_t *wlandev, struct imgchunk *fchunk,
 	result = prism2mgmt_ramdl_state(wlandev, msgp);
 	if (result) {
 		printk(KERN_ERR
-		       "writeimage state disable failed w/ result=%d, "
-		       "aborting download\n", result);
+			"writeimage state disable failed w/ result=%d, "
+			"aborting download\n", result);
 		return result;
 	}
 	resultcode = rstatemsg.resultcode.data;
 	if (resultcode != P80211ENUM_resultcode_success) {
 		printk(KERN_ERR
-		       "writeimage()->xxxdl_state msg indicates failure, "
-		       "w/ resultcode=%d, aborting download.\n", resultcode);
+			"writeimage()->xxxdl_state msg indicates failure, "
+			"w/ resultcode=%d, aborting download.\n", resultcode);
 		return 1;
 	}
 	return result;
@@ -1148,25 +1156,25 @@ int validate_identity(void)
 
 			/* MAC compat range */
 			if ((s3info[i].info.compat.role == 1) &&
-			    (s3info[i].info.compat.id == 2)) {
+				(s3info[i].info.compat.id == 2)) {
 				if (s3info[i].info.compat.variant !=
-				    macid.variant) {
+					macid.variant) {
 					result = 2;
 				}
 			}
 
 			/* PRI compat range */
 			if ((s3info[i].info.compat.role == 1) &&
-			    (s3info[i].info.compat.id == 3)) {
+				(s3info[i].info.compat.id == 3)) {
 				if ((s3info[i].info.compat.bottom > priid.top)
-				    || (s3info[i].info.compat.top <
+					|| (s3info[i].info.compat.top <
 					priid.bottom)) {
 					result = 3;
 				}
 			}
 			/* SEC compat range */
 			if ((s3info[i].info.compat.role == 1) &&
-			    (s3info[i].info.compat.id == 4)) {
+				(s3info[i].info.compat.id == 4)) {
 				/* FIXME: isn't something missing here? */
 			}
 
@@ -1189,7 +1197,7 @@ int validate_identity(void)
 			if (nicid.minor != s3info[i].info.version.minor)
 				continue;
 			if ((nicid.variant != s3info[i].info.version.variant) &&
-			    (nicid.id != 0x8008))
+				(nicid.id != 0x8008))
 				continue;
 
 			trump = 1;
-- 
1.7.3.4

