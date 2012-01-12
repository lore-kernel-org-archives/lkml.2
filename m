Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab2ALI0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:26:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46177 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2ALI0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:26:22 -0500
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] USB: EHCI: Don't use NO_IRQ in xilinx ehci driver
Date: Thu, 12 Jan 2012 09:26:17 +0100
Message-Id: <1326356777-24135-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers shouldn't use NO_IRQ. This driver is used
by Microblaze and PPC. PPC defines NO_IRQ as 0
and Microblaze has removed it.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: linux-usb@vger.kernel.org
CC: devicetree-discuss@lists.ozlabs.org
---
 drivers/usb/host/ehci-xilinx-of.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
index 32793ce..9c2cc46 100644
--- a/drivers/usb/host/ehci-xilinx-of.c
+++ b/drivers/usb/host/ehci-xilinx-of.c
@@ -183,7 +183,7 @@ static int __devinit ehci_hcd_xilinx_of_probe(struct platform_device *op)
 	}
 
 	irq = irq_of_parse_and_map(dn, 0);
-	if (irq == NO_IRQ) {
+	if (!irq) {
 		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
 		rv = -EBUSY;
 		goto err_irq;
-- 
1.7.5.4

