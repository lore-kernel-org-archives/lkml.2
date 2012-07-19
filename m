Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab2GSCBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:01:41 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:64162 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab2GSCBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:01:38 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-127.messagelabs.com!1342663297!9000412!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 76/90] staging: comedi: dyna_pci10xx: fix detach
Date: Wed, 18 Jul 2012 19:01:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181901.34411.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The detach for this driver is missing the check to make sure
that the pci device is enabled before disabling it.

It's also missing the pci_dev_put().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 6821f87..064be9a 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -346,7 +346,9 @@ static void dyna_pci10xx_detach(struct comedi_device *dev)
 	if (devpriv)
 		mutex_destroy(&devpriv->mutex);
 	if (pcidev) {
-		comedi_pci_disable(pcidev);
+		if (dev->iobase)
+			comedi_pci_disable(pcidev);
+		pci_dev_put(pcidev);
 	}
 }
 
-- 
1.7.11

