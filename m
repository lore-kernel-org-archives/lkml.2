Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2LNW3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:29:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:38592 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab2LNW3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:29:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Ball <cjb@laptop.org>
Subject: [ 02/28] Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"
Date: Fri, 14 Dec 2012 14:26:19 -0800
Message-Id: <20121214222251.000647141@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222250.501309822@linuxfoundation.org>
References: <20121214222250.501309822@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ball <cjb@laptop.org>

commit 6984f3c31bb57cb7491dbec1be44b74bd00f4648 upstream.

This reverts commit 8464dd52d3198dd05, which was a misapplied debugging
version of the patch, not the final patch itself.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sh_mmcif.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1191,10 +1191,6 @@ static irqreturn_t sh_mmcif_intr(int irq
 		host->sd_error = true;
 		dev_dbg(&host->pd->dev, "int err state = %08x\n", state);
 	}
-	if (host->state == STATE_IDLE) {
-		dev_info(&host->pd->dev, "Spurious IRQ status 0x%x", state);
-		return IRQ_HANDLED;
-	}
 	if (state & ~(INT_CMD12RBE | INT_CMD12CRE)) {
 		if (!host->dma_active)
 			return IRQ_WAKE_THREAD;


