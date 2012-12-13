Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab2LMOKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:10:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44747 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844Ab2LMOK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:10:28 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Ball <cjb@laptop.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 157/241] Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"
Date: Thu, 13 Dec 2012 11:58:42 -0200
Message-Id: <1355407206-17100-158-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ball <cjb@laptop.org>

commit 6984f3c31bb57cb7491dbec1be44b74bd00f4648 upstream.

This reverts commit 8464dd52d3198dd05, which was a misapplied debugging
version of the patch, not the final patch itself.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mmc/host/sh_mmcif.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index 3b8236b..724b35e 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1191,10 +1191,6 @@ static irqreturn_t sh_mmcif_intr(int irq, void *dev_id)
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
-- 
1.7.9.5

