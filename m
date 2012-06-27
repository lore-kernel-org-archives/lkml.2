Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab2F0WIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:08:50 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:39778 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab2F0WIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:08:48 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1340834901!7118444!34
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/19] staging: comedi: adl_pci6208: use the driver_name for the resource name
Date: Wed, 27 Jun 2012 15:08:39 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271508.39556.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the dev->driver->driver_name for the resource name passed to
pci_request_regions(), by way of comedi_pci_enable(), instead of
the open coded string "adl_pci6208".

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index cb14ffd..487fd4a 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -215,7 +215,7 @@ static int pci6208_attach(struct comedi_device *dev,
 
 	dev->board_name = thisboard->name;
 
-	ret = comedi_pci_enable(devpriv->pci_dev, "adl_pci6208");
+	ret = comedi_pci_enable(devpriv->pci_dev, dev->driver->driver_name);
 	if (ret) {
 		dev_err(dev->class_dev,
 			"Failed to enable PCI device and request regions\n");
-- 
1.7.11

