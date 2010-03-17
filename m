Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0CQPwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:52:36 -0400
Received: from n11b.bullet.mail.mud.yahoo.com ([209.191.125.178]:46692 "HELO
	n11b.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751566Ab0CQPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:52:34 -0400
X-Yahoo-Newman-Id: 352946.17659.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
  b=bzY4839oCZBpP0rDwH8oV9BsfoDLiplHKa44TkI2X7M88nOAA4Z/IWcmtJXooEkggBnQDfoUrgDxe0HBsH0qukwoWHMVgVN1J53LvwrRg3Q0imRwyR2mSE44X0t0Ccvd14XMPJ6iLQ0LpbsjDipnqeB/S3VbUnRyUUOPlz6UT6s=  ;
X-Yahoo-SMTP: LYwhiGuswBC9DGnmQEHq6t4kOq0-
X-YMail-OSG: SBBDdOAVM1lrYzuLnEDdBrKGs_GkA2Ws.DpsvSCZBEF5Y4YK3NR3tg2mtD2Y_mSlBYuNDdnk2tR9mPrKzWKESc3_N0RJYaY.MSPxHvs0GaGzsh0g8_tnUcHkx.PYyR6Hw49Bp7kaAqTYaVpTG9rEqtJYF3h3lw2anVv0dlExQbPrkT7hqNHZ_iSkomtr6J5bAyRI0gxvZSQ6Flw.s03kbQ9wkQFaeJza_odJzqC6y2XjtK7Ti6737uVefo95oxthkPSdbZWMm1enxuEjpPr5tC4Ve6AN.qQ2Gw--
X-Yahoo-Newman-Property: ymail-3
From: jsd_syd@yahoo.com.au
To: gregkh@suse.de, wfp5p@virginia.edu, hohndel@infradead.org, jkosina@suse.cz
Cc: jsd_syd@yahoo.com.au, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Jacob David <jacobselvin@gmail.com>
Subject: [PATCH] Staging: comedi: fixes the checkpatch error in skel.c This is a patch to the skel.c file that fixes the 80 line exceeding warning and the printk warning found by chekpatch.pl tool Signed-off-by: Jacob S David <jacobselvin@gmail.com>
Date: Thu, 18 Mar 2010 02:52:27 +1100
Message-Id: <1268841147-6185-1-git-send-email-jsd_syd@yahoo.com.au>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob David <jacobselvin@gmail.com>

---
 drivers/staging/comedi/drivers/skel.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index aba57d9..58658b0 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -130,8 +130,10 @@ MODULE_DEVICE_TABLE(pci, skel_pci_table);
 #define thisboard ((const struct skel_board *)dev->board_ptr)
 
 /* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device
+ * struct.
+ */
 struct skel_private {
 
 	int data;
@@ -211,7 +213,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: skel: ", dev->minor);
+	printk(KERN_INFO "comedi%d: skel: ", dev->minor);
 
 /*
  * If you can probe the device to determine what device in a series
@@ -297,7 +299,7 @@ static int skel_attach(struct comedi_device *dev, struct comedi_devconfig *it)
  */
 static int skel_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: skel: remove\n", dev->minor);
+	printk(KERN_INFO "comedi%d: skel: remove\n", dev->minor);
 
 	return 0;
 }
@@ -336,7 +338,7 @@ static int skel_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		if (i == TIMEOUT) {
 			/* printk() should be used instead of printk()
 			 * whenever the code can be called from real-time. */
-			printk("timeout\n");
+			printk(KERN_INFO "timeout\n");
 			return -ETIMEDOUT;
 		}
 
@@ -397,7 +399,9 @@ static int skel_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique and mutually
+	 * compatible
+	 */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
@@ -529,7 +533,7 @@ static int skel_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-	printk("skel_ao_winsn\n");
+	printk(KERN_INFO "skel_ao_winsn\n");
 	/* Writing a list of values to an AO channel is probably not
 	 * very useful, but that's how the interface is defined. */
 	for (i = 0; i < insn->n; i++) {
@@ -623,6 +627,9 @@ static int skel_dio_insn_config(struct comedi_device *dev,
  * as necessary.
  */
 COMEDI_INITCLEANUP(driver_skel);
-/* If you are writing a PCI driver you should use COMEDI_PCI_INITCLEANUP instead.
-*/
+/* If you are writing a PCI driver you should use COMEDI_PCI_INITCLEANUP
+ * instead.
+ */
+
 /* COMEDI_PCI_INITCLEANUP(driver_skel, skel_pci_table) */
+
-- 
1.6.3.3


