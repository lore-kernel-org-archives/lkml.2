Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2GKWTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:19:05 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:46966 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2GKWTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:19:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1342045140!8421002!3
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/30] staging: comedi: adl_pci7230: remove private data
Date: Wed, 11 Jul 2012 15:18:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207111518.57768.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data is no longer needed by this driver. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci7230.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index b61dafe..c1f83ea 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -42,12 +42,6 @@ Configuration Options:
 
 #define PCI_DEVICE_ID_PCI7230 0x7230
 
-struct adl_pci7230_private {
-	int data;
-};
-
-#define devpriv ((struct adl_pci7230_private *)dev->private)
-
 static int adl_pci7230_do_insn_bits(struct comedi_device *dev,
 	struct comedi_subdevice *s,
 	struct comedi_insn *insn,
@@ -107,9 +101,6 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 
 	dev->board_name = "pci7230";
 
-	if (alloc_private(dev, sizeof(struct adl_pci7230_private)) < 0)
-		return -ENOMEM;
-
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
 		return ret;
-- 
1.7.11

