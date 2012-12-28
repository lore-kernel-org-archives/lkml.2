Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2L1TlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:41:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55350 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153Ab2L1TSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:37 -0500
Message-Id: <20121228190350.765365454@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Aaron Lu <aaron.lu@intel.com>,
        Phillip Wood <phillip.wood@dunelm.org.uk>,
        Szymon Janc <szymon@janc.net.pl>, Dutra Julio <dutra.julio@gmail.com>,
        Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 098/173] libata: set dma_mode to 0xff in reset
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 5416912af75de9cba5d1c75b99a7888b0bbbd2fb upstream.

ata_device->dma_mode's initial value is zero, which is not a valid dma
mode, but ata_dma_enabled will return true for this value. This patch
sets dma_mode to 0xff in reset function, so that ata_dma_enabled will
not return true for this case, or it will cause problem for pata_acpi.

The corrsponding bugzilla page is at:
https://bugzilla.kernel.org/show_bug.cgi?id=49151

Reported-by: Phillip Wood <phillip.wood@dunelm.org.uk>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Szymon Janc <szymon@janc.net.pl>
Tested-by: Dutra Julio <dutra.julio@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-core.c |    1 +
 drivers/ata/libata-eh.c   |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index caffe73..583f26d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2559,6 +2559,7 @@ int ata_bus_probe(struct ata_port *ap)
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = 0xff;
 
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index e60437c..bf039b0 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2657,6 +2657,7 @@ int ata_eh_reset(struct ata_link *link, int classify,
 		 * bus as we may be talking too fast.
 		 */
 		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = 0xff;
 
 		/* If the controller has a pio mode setup function
 		 * then use it to set the chipset to rights. Don't


