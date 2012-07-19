Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2GSCAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:00:14 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:18533 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab2GSCAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:00:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1342663209!9187664!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 72/90] staging: comedi: dyna_pci10xx: remove 'valid' from the private data
Date: Wed, 18 Jul 2012 19:00:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181900.04934.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is set at the end of the attach but never used
in the driver. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 82002c4..24c5cd2 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -101,7 +101,6 @@ static const struct boardtype boardtypes[] = {
 
 struct dyna_pci10xx_private {
 	struct pci_dev *pci_dev;	/*  ptr to PCI device */
-	char valid;			/*  card is usable */
 	struct mutex mutex;
 
 	/* device base address registers */
@@ -342,8 +341,6 @@ static int dyna_pci10xx_attach(struct comedi_device *dev,
 	s->state = 0;
 	s->insn_bits = dyna_pci10xx_do_insn_bits;
 
-	devpriv->valid = 1;
-
 	printk(KERN_INFO "comedi: dyna_pci10xx: %s - device setup completed!\n",
 		thisboard->name);
 
-- 
1.7.11

