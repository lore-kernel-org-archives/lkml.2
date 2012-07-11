Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab2GKAYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 20:24:20 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:3153 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596Ab2GKAYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 20:24:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1341966257!12377064!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 79/83] staging: comedi: rtd520: remove thisboard macro
Date: Tue, 10 Jul 2012 17:24:10 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101724.11242.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro 'thisboard' relies on a local variable having a specific
name and yeilds a pointer derived from that local variable. Replace
the macro with a local variable where used and use the comedi_board()
helper to get the pointer.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 8ea0db1..92f806d 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -328,11 +328,6 @@ static const struct rtdBoard rtd520Boards[] = {
 };
 
 /*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct rtdBoard *)dev->board_ptr)
-
-/*
    This structure is for data unique to this hardware driver.
    This is also unique for each board in the system.
 */
@@ -447,6 +442,7 @@ static int rtd_ns_to_timer(unsigned int *ns, int round_mode)
 static unsigned short rtdConvertChanGain(struct comedi_device *dev,
 					 unsigned int comediChan, int chanIndex)
 {				/* index in channel list */
+	const struct rtdBoard *thisboard = comedi_board(dev);
 	struct rtdPrivate *devpriv = dev->private;
 	unsigned int chan, range, aref;
 	unsigned short r = 0;
@@ -1611,6 +1607,7 @@ static int rtd_dio_insn_config(struct comedi_device *dev,
 
 static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {				/* board name and options flags */
+	const struct rtdBoard *thisboard;
 	struct rtdPrivate *devpriv;
 	struct comedi_subdevice *s;
 	struct pci_dev *pcidev;
@@ -1671,6 +1668,7 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	}
 	devpriv->pci_dev = pcidev;
+	thisboard = comedi_board(dev);
 	dev->board_name = thisboard->name;
 
 	ret = comedi_pci_enable(pcidev, DRV_NAME);
-- 
1.7.11

