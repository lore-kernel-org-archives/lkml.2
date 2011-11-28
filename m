Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1K1QPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:15:25 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:31880 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1K1QPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:15:23 -0500
Subject: [PATCH] hpsa: Add IRQF_SHARED back in for the non-MSI(X) interrupt
	handler
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mikem@beardog.cce.hp.com
Date: Mon, 28 Nov 2011 10:15:20 -0600
Message-ID: <20111128161520.25516.69112.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

IRQF_SHARED is required for older controllers that don't support MSI(X)
and which may end up sharing an interrupt.  All the controllers hpsa
normally supports have MSI(X) capability, but older controllers may be
encountered via the hpsa_allow_any=1 module parameter.

Also remove deprecated IRQF_DISABLED.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 865d452..594ce83 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4072,10 +4072,10 @@ static int hpsa_request_irq(struct ctlr_info *h,
 
 	if (h->msix_vector || h->msi_vector)
 		rc = request_irq(h->intr[h->intr_mode], msixhandler,
-				IRQF_DISABLED, h->devname, h);
+				0, h->devname, h);
 	else
 		rc = request_irq(h->intr[h->intr_mode], intxhandler,
-				IRQF_DISABLED, h->devname, h);
+				IRQF_SHARED, h->devname, h);
 	if (rc) {
 		dev_err(&h->pdev->dev, "unable to get irq %d for %s\n",
 		       h->intr[h->intr_mode], h->devname);

