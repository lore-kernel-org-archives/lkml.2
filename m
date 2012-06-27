Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab2F0WIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:08:15 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:37899 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab2F0WIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:08:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1340834880!6676788!7
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/19] staging: comedi: adl_pci6208: cleanup pci6208_attach()
Date: Wed, 27 Jun 2012 15:07:56 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271507.56418.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For aesthetic reasons, set the dev->board_name as soon as the
thisboard pointer is available.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index aa2db5d..cb14ffd 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -213,17 +213,16 @@ static int pci6208_attach(struct comedi_device *dev,
 		return -EIO;
 	thisboard = comedi_board(dev);
 
+	dev->board_name = thisboard->name;
+
 	ret = comedi_pci_enable(devpriv->pci_dev, "adl_pci6208");
 	if (ret) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
 		return ret;
 	}
-
 	dev->iobase = pci_resource_start(devpriv->pci_dev, 2);
 
-	dev->board_name = thisboard->name;
-
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
 		return ret;
-- 
1.7.11

