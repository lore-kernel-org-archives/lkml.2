Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2L1TXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:23:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55728 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932484Ab2L1TT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:57 -0500
Message-Id: <20121228190335.879473774@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Ball <cjb@laptop.org>
Subject: [ 028/173] Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ball <cjb@laptop.org>

commit 6984f3c31bb57cb7491dbec1be44b74bd00f4648 upstream.

This reverts commit 8464dd52d3198dd05, which was a misapplied debugging
version of the patch, not the final patch itself.

Signed-off-by: Chris Ball <cjb@laptop.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/sh_mmcif.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1003,10 +1003,6 @@ static irqreturn_t sh_mmcif_intr(int irq
 		host->sd_error = true;
 		dev_dbg(&host->pd->dev, "int err state = %08x\n", state);
 	}
-	if (host->state == STATE_IDLE) {
-		dev_info(&host->pd->dev, "Spurious IRQ status 0x%x", state);
-		return IRQ_HANDLED;
-	}
 	if (state & ~(INT_CMD12RBE | INT_CMD12CRE))
 		complete(&host->intr_wait);
 	else


