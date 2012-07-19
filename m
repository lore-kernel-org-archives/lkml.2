Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2GSBrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:47:52 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:26138 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2GSBrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:47:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1342662470!25481648!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 51/90] staging: comedi: cb_pcimdas: remove BADR1 from the private data
Date: Wed, 18 Jul 2012 18:47:46 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181847.47217.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pci resource bar 1 address is not used in the driver. Remove
it from the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 9e4bac1..3902c85bc 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -57,7 +57,6 @@ See http://www.mccdaq.com/PDFs/Manuals/pcim-das1602-16.pdf for more details.
 
 /* sizes of io regions (bytes) */
 #define BADR0_SIZE 2		/* ?? */
-#define BADR1_SIZE 4
 #define BADR2_SIZE 6
 #define BADR3_SIZE 16
 #define BADR4_SIZE 4
@@ -139,7 +138,6 @@ struct cb_pcimdas_private {
 
 	/* base addresses */
 	unsigned long BADR0;
-	unsigned long BADR1;
 	unsigned long BADR2;
 	unsigned long BADR3;
 	unsigned long BADR4;
@@ -236,7 +234,6 @@ static int cb_pcimdas_attach(struct comedi_device *dev,
 	}
 
 	devpriv->BADR0 = pci_resource_start(devpriv->pci_dev, 0);
-	devpriv->BADR1 = pci_resource_start(devpriv->pci_dev, 1);
 	devpriv->BADR2 = pci_resource_start(devpriv->pci_dev, 2);
 	devpriv->BADR3 = pci_resource_start(devpriv->pci_dev, 3);
 	devpriv->BADR4 = pci_resource_start(devpriv->pci_dev, 4);
-- 
1.7.11

