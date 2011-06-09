Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab1FILqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:46:16 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:36577 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab1FILqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QTOLJfMgqbO7fynsfHhI7NS0giezo4tWP2iqzNP2ptoJnLW6w+h9egXwBkRTVU2Pg0
         uhJgg2VtnpVzZFXha+vWdYKmWfJdOD0veOyBHw7D1trrca/s9slFhTxYWsUiSD2AOa59
         hoaD+lsvc2OmUnZkAmDCr7CN2j+QQYoNUlvjY=
Date: Thu, 9 Jun 2011 17:30:30 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: comedi: dyna_pci10xx: check for NULL value
Message-ID: <20110609120030.GA15307@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check NULL value for devpriv during detach callback

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 50abb6e..d8821b9 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -410,14 +410,12 @@ found:
 
 static int dyna_pci10xx_detach(struct comedi_device *dev)
 {
-	if (devpriv->pci_dev)
+	if (devpriv && devpriv->pci_dev)
 		comedi_pci_disable(devpriv->pci_dev);
 
 	return 0;
 }
 
-/* COMEDI_PCI_INITCLEANUP(dyna_pci10xx_driver, dyna_pci10xx_pci_table); */
-
 static int __devinit driver_dyna_pci10xx_pci_probe(struct pci_dev *dev,
 					      const struct pci_device_id *ent)
 {
-- 
1.7.1

