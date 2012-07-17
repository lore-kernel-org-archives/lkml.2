Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab2GQVkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:40:14 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39570 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830Ab2GQVkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:40:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 09/17] goku_udc: remove IRQF_SAMPLE_RANDOM which was commented out
Date: Tue, 17 Jul 2012 17:32:28 -0400
Message-Id: <1342560756-18737-10-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1342560756-18737-1-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
no-op; interrupt randomness is now collected unconditionally in a very
low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
flag was scheduled to be removed in 2009 on the
feature-removal-schedule.

The flag was only commented-out in the driver, but we should just
remove it altogether.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/goku_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 3d28fb9..9fd7886 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1836,7 +1836,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* init to known state, then setup irqs */
 	udc_reset(dev);
 	udc_reinit (dev);
-	if (request_irq(pdev->irq, goku_irq, IRQF_SHARED/*|IRQF_SAMPLE_RANDOM*/,
+	if (request_irq(pdev->irq, goku_irq, IRQF_SHARED,
 			driver_name, dev) != 0) {
 		DBG(dev, "request interrupt %d failed\n", pdev->irq);
 		retval = -EBUSY;
-- 
1.7.11.1.108.gb129051

