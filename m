Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab2GQVlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:41:01 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39573 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2GQVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:40:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 10/17] omap_udc: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:29 -0400
Message-Id: <1342560756-18737-11-git-send-email-tytso@mit.edu>
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
feature-removal-schedule, so this patch is preparation for the final
removal of this flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/omap_udc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index a460e8c..2980100 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2944,7 +2944,7 @@ known:
 
 	/* USB general purpose IRQ:  ep0, state changes, dma, etc */
 	status = request_irq(pdev->resource[1].start, omap_udc_irq,
-			IRQF_SAMPLE_RANDOM, driver_name, udc);
+			     0, driver_name, udc);
 	if (status != 0) {
 		ERR("can't get irq %d, err %d\n",
 			(int) pdev->resource[1].start, status);
@@ -2953,7 +2953,7 @@ known:
 
 	/* USB "non-iso" IRQ (PIO for all but ep0) */
 	status = request_irq(pdev->resource[2].start, omap_udc_pio_irq,
-			IRQF_SAMPLE_RANDOM, "omap_udc pio", udc);
+			     0, "omap_udc pio", udc);
 	if (status != 0) {
 		ERR("can't get irq %d, err %d\n",
 			(int) pdev->resource[2].start, status);
-- 
1.7.11.1.108.gb129051

