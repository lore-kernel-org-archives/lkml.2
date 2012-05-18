Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946512Ab2ERXXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:23:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946489Ab2ERXE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:59 -0400
Message-Id: <20120518211603.770753091@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 47/54] SCSI: hpsa: Add IRQF_SHARED back in for the non-MSI(X) interrupt handler
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4037,10 +4037,10 @@ static int hpsa_request_irq(struct ctlr_
 
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


