Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2GSBZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:25:43 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:10046 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2GSBZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:25:40 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1342661138!23127282!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/90] staging: comedi: adl_pci7230: remove the private data
Date: Wed, 18 Jul 2012 18:25:29 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181825.29465.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The private data is no longer needed by this driver. Remove the
struct, devpriv macro, and the allocation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci7230.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index cdf3949..7df4c96 100644
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
@@ -108,9 +102,6 @@ static int adl_pci7230_attach(struct comedi_device *dev,
 
 	dev->board_name = "pci7230";
 
-	if (alloc_private(dev, sizeof(struct adl_pci7230_private)) < 0)
-		return -ENOMEM;
-
 	ret = comedi_alloc_subdevices(dev, 2);
 	if (ret)
 		return ret;
-- 
1.7.11

