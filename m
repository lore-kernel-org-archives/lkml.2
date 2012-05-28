Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2E1DoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:44:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52090 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908Ab2E1D3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:32 -0400
Message-Id: <20120528031214.184742874@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 082/117] [SCSI] hpsa: Add IRQF_SHARED back in for the non-MSI(X) interrupt
 handler
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 45bcf018d1a4779d592764ef57517c92589d55d7 upstream.

IRQF_SHARED is required for older controllers that don't support MSI(X)
and which may end up sharing an interrupt.  All the controllers hpsa
normally supports have MSI(X) capability, but older controllers may be
encountered via the hpsa_allow_any=1 module parameter.

Also remove deprecated IRQF_DISABLED.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


