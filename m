Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2FETmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 15:42:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54096 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2FETmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 15:42:16 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Salisbury <salisbury.joseph@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/2] staging/wlan-ng: prsim2fw.c coding style cleanup
Date: Wed,  6 Jun 2012 01:12:06 +0530
Message-Id: <1338925326-23584-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes the coding style problems found by using checkpatch.pl

drivers/staging/wlan-ng/prism2fw.c:175: ERROR: "foo * bar" should be "foo *bar"
drivers/staging/wlan-ng/prism2fw.c:210: WARNING: line over 80 characters
drivers/staging/wlan-ng/prism2fw.c:596: WARNING: line over 80 characters
drivers/staging/wlan-ng/prism2fw.c:658: ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/wlan-ng/prism2fw.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 3c40096..f13cdc9 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -172,7 +172,7 @@ static int read_cardpda(struct pda *pda, wlandevice_t *wlandev);
 static int mkpdrlist(struct pda *pda);
 
 static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
-	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda);
+	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda *pda);
 
 static int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
 	     struct s3crcrec *s3crc, unsigned int ns3crc);
@@ -207,7 +207,8 @@ int prism2_fwtry(struct usb_device *udev, wlandevice_t *wlandev)
 
 	printk(KERN_INFO "prism2_usb: Checking for firmware %s\n",
 	       PRISM2_USB_FWFILE);
-	if (request_ihex_firmware(&fw_entry, PRISM2_USB_FWFILE, &udev->dev) != 0) {
+	if (request_ihex_firmware(&fw_entry,
+				  PRISM2_USB_FWFILE, &udev->dev) != 0) {
 		printk(KERN_INFO
 		       "prism2_usb: Firmware not available, but not essential\n");
 		printk(KERN_INFO
@@ -593,7 +594,8 @@ int mkpdrlist(struct pda *pda)
 	       le16_to_cpu(pda16[curroff + 1]) != HFA384x_PDR_END_OF_PDA) {
 		pda->rec[pda->nrec] = (hfa384x_pdrec_t *) &(pda16[curroff]);
 
-		if (le16_to_cpu(pda->rec[pda->nrec]->code) == HFA384x_PDR_NICID) {
+		if (le16_to_cpu(pda->rec[pda->nrec]->code) ==
+		    HFA384x_PDR_NICID) {
 			memcpy(&nicid, &pda->rec[pda->nrec]->data.nicid,
 			       sizeof(nicid));
 			nicid.id = le16_to_cpu(nicid.id);
@@ -655,7 +657,7 @@ int mkpdrlist(struct pda *pda)
 *	~0	failure
 ----------------------------------------------------------------*/
 int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
-	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda * pda)
+	      struct s3plugrec *s3plug, unsigned int ns3plug, struct pda *pda)
 {
 	int result = 0;
 	int i;			/* plug index */
-- 
1.7.9.5

