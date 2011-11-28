Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1K1QOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:14:46 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:47259 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K1QOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:14:45 -0500
Subject: [PATCH 1/2] cciss: Add IRQF_SHARED back in for the non-MSI(X)
	interrupt handler
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Mon, 28 Nov 2011 10:14:42 -0600
Message-ID: <20111128161442.25472.71410.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

IRQF_SHARED is required for older controllers that don't support MSI(X)
and which may end up sharing an interrupt.

Also remove deprecated IRQF_DISABLED.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8004ac3..6f22ed0 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4880,7 +4880,7 @@ static int cciss_request_irq(ctlr_info_t *h,
 {
 	if (h->msix_vector || h->msi_vector) {
 		if (!request_irq(h->intr[h->intr_mode], msixhandler,
-				IRQF_DISABLED, h->devname, h))
+				0, h->devname, h))
 			return 0;
 		dev_err(&h->pdev->dev, "Unable to get msi irq %d"
 			" for %s\n", h->intr[h->intr_mode],
@@ -4889,7 +4889,7 @@ static int cciss_request_irq(ctlr_info_t *h,
 	}
 
 	if (!request_irq(h->intr[h->intr_mode], intxhandler,
-			IRQF_DISABLED, h->devname, h))
+			IRQF_SHARED, h->devname, h))
 		return 0;
 	dev_err(&h->pdev->dev, "Unable to get irq %d for %s\n",
 		h->intr[h->intr_mode], h->devname);

