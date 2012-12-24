Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2LXVpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 16:45:40 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:43086 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab2LXVpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 16:45:38 -0500
From: Stefan Hasko <hasko.stevo@gmail.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Hasko <hasko.stevo@gmail.com>
Subject: [PATCH] drivers: video: fix warnings int-to-pointer-cast
Date: Mon, 24 Dec 2012 22:44:48 +0100
Message-Id: <1356385488-6655-1-git-send-email-hasko.stevo@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed compile warnings cast to pointer from integer of different size

Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
---
 drivers/video/arkfb.c    |    2 +-
 drivers/video/s3fb.c     |    2 +-
 drivers/video/vt8623fb.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/arkfb.c b/drivers/video/arkfb.c
index 555dd4c..3e4ed96 100644
--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -1016,7 +1016,7 @@ static int __devinit ark_pci_probe(struct pci_dev *dev, const struct pci_device_
 
 	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *)(unsigned long) vga_res.start;
 
 	/* FIXME get memsize */
 	regval = vga_rseq(par->state.vgabase, 0x10);
diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
index 1d00736..def0a86 100644
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -1183,7 +1183,7 @@ static int __devinit s3_pci_probe(struct pci_dev *dev, const struct pci_device_i
 
 	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *)(unsigned long) vga_res.start;
 
 	/* Unlock regs */
 	cr38 = vga_rcrt(par->state.vgabase, 0x38);
diff --git a/drivers/video/vt8623fb.c b/drivers/video/vt8623fb.c
index 4e74d26..2516808 100644
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -729,7 +729,7 @@ static int __devinit vt8623_pci_probe(struct pci_dev *dev, const struct pci_devi
 
 	pcibios_bus_to_resource(dev, &vga_res, &bus_reg);
 
-	par->state.vgabase = (void __iomem *) vga_res.start;
+	par->state.vgabase = (void __iomem *)(unsigned long) vga_res.start;
 
 	/* Find how many physical memory there is on card */
 	memsize1 = (vga_rseq(par->state.vgabase, 0x34) + 1) >> 1;
-- 
1.7.10.4

