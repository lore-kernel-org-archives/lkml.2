Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab2HRBQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:16:52 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:25714 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab2HRBQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:16:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1345252594!6075082!3
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/20] staging: comedi: adv_pci1723: remove function trace messages
Date: Fri, 17 Aug 2012 18:16:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171816.18930.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the DPRINTK function trace messages. These should not be
in the final driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1723.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index dfde0f6..3c4978a 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -168,7 +168,6 @@ struct pci1723_private {
 static int pci1723_reset(struct comedi_device *dev)
 {
 	int i;
-	DPRINTK("adv_pci1723 EDBG: BGN: pci1723_reset(...)\n");
 
 	outw(0x01, dev->iobase + PCI1723_SYN_SET);
 					       /* set synchronous output mode */
@@ -190,7 +189,6 @@ static int pci1723_reset(struct comedi_device *dev)
 	/* set asynchronous output mode */
 	outw(0, dev->iobase + PCI1723_SYN_SET);
 
-	DPRINTK("adv_pci1723 EDBG: END: pci1723_reset(...)\n");
 	return 0;
 }
 
@@ -201,7 +199,6 @@ static int pci1723_insn_read_ao(struct comedi_device *dev,
 	int n, chan;
 
 	chan = CR_CHAN(insn->chanspec);
-	DPRINTK(" adv_PCI1723 DEBUG: pci1723_insn_read_ao() -----\n");
 	for (n = 0; n < insn->n; n++)
 		data[n] = devpriv->ao_data[chan];
 
@@ -218,8 +215,6 @@ static int pci1723_ao_write_winsn(struct comedi_device *dev,
 	int n, chan;
 	chan = CR_CHAN(insn->chanspec);
 
-	DPRINTK("PCI1723: the pci1723_ao_write_winsn() ------\n");
-
 	for (n = 0; n < insn->n; n++) {
 
 		devpriv->ao_data[chan] = data[n];
-- 
1.7.11

