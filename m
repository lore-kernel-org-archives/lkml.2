Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966114Ab2C3VVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:21:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966100Ab2C3VVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:45 -0400
Message-Id: <20120330194844.835227748@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Brian Norris <computersforpeace@gmail.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 098/175] ahci_platform: add STRICT_AHCI platform type
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <computersforpeace@gmail.com>

commit d408e2b14fba4fa214fa5bc24b7baae8a55e563c upstream.

Some platforms need to make use of the AHCI_HFLAG_DELAY_ENGINE flag.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_platform.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -26,6 +26,7 @@
 enum ahci_type {
 	AHCI,		/* standard platform ahci */
 	IMX53_AHCI,	/* ahci on i.mx53 */
+	STRICT_AHCI,	/* delayed DMA engine start */
 };
 
 static struct platform_device_id ahci_devtype[] = {
@@ -36,6 +37,9 @@ static struct platform_device_id ahci_de
 		.name = "imx53-ahci",
 		.driver_data = IMX53_AHCI,
 	}, {
+		.name = "strict-ahci",
+		.driver_data = STRICT_AHCI,
+	}, {
 		/* sentinel */
 	}
 };
@@ -56,6 +60,13 @@ static const struct ata_port_info ahci_p
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_pmp_retry_srst_ops,
 	},
+	[STRICT_AHCI] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_DELAY_ENGINE),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static struct scsi_host_template ahci_platform_sht = {


