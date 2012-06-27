Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2F0Ayp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:54:45 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:11757 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2F0Ayo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:54:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-127.messagelabs.com!1340758483!6930214!1
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/36] staging: comedi: cb_pcidas: remove the PCI BAR index defines
Date: Tue, 26 Jun 2012 17:54:38 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261754.38423.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The defines for the "indices of the base address regions" don't
add much to the readability of the code. They are only used in
the pci_resource_start() calls to get the base address for
the various io regions and the names of the variables provide
adequate documentation.

Remove the defines and just use the open-coded values for the
BARs. Also, remove the incomplete comment above the initialization
of the variables.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 32 ++++++++----------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index 990e6ab..4e5f1ba 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -92,14 +92,6 @@ analog triggering on 1602 series
 #define NUM_CHANNELS_8402 2
 #define NUM_CHANNELS_DAC08 1
 
-/* PCI-DAS base addresses */
-
-/* indices of base address regions */
-#define S5933_BADRINDEX 0
-#define CONT_STAT_BADRINDEX 1
-#define ADC_FIFO_BADRINDEX 2
-#define PACER_BADRINDEX 3
-#define AO_BADRINDEX 4
 /* sizes of io regions */
 #define CONT_STAT_SIZE 10
 #define ADC_FIFO_SIZE 4
@@ -1670,22 +1662,14 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 			"Failed to enable PCI device and request regions\n");
 		return -EIO;
 	}
-	/*
-	 * Initialize devpriv->control_status and devpriv->adc_fifo to point to
-	 * their base address.
-	 */
-	devpriv->s5933_config =
-	    pci_resource_start(devpriv->pci_dev, S5933_BADRINDEX);
-	devpriv->control_status =
-	    pci_resource_start(devpriv->pci_dev, CONT_STAT_BADRINDEX);
-	devpriv->adc_fifo =
-	    pci_resource_start(devpriv->pci_dev, ADC_FIFO_BADRINDEX);
-	devpriv->pacer_counter_dio =
-	    pci_resource_start(devpriv->pci_dev, PACER_BADRINDEX);
-	if (thisboard->ao_nchan) {
-		devpriv->ao_registers =
-		    pci_resource_start(devpriv->pci_dev, AO_BADRINDEX);
-	}
+
+	devpriv->s5933_config = pci_resource_start(devpriv->pci_dev, 0);
+	devpriv->control_status = pci_resource_start(devpriv->pci_dev, 1);
+	devpriv->adc_fifo = pci_resource_start(devpriv->pci_dev, 2);
+	devpriv->pacer_counter_dio = pci_resource_start(devpriv->pci_dev, 3);
+	if (thisboard->ao_nchan)
+		devpriv->ao_registers = pci_resource_start(devpriv->pci_dev, 4);
+
 	/*  disable and clear interrupts on amcc s5933 */
 	outl(INTCSR_INBOX_INTR_STATUS,
 	     devpriv->s5933_config + AMCC_OP_REG_INTCSR);
-- 
1.7.11

