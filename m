Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab1ECUBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:01:17 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38805 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1ECUBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:01:11 -0400
Subject: [PATCH 09/16] cciss: clarify messages around reset behavior
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:36 -0500
Message-ID: <20110503195336.5154.53358.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
References: <20110503194919.5154.78352.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

When waiting for the board to become "not ready"
don't print a message saying "waiting for board to
become ready" (possibly followed by a message saying
"failed waiting for board to become not ready".  Instead,
it should be "waiting for board to reset" and "failed
waiting for board to reset."

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
"
---
 drivers/block/cciss.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 1a4dff0..3b55723 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4586,11 +4586,11 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	msleep(CCISS_POST_RESET_PAUSE_MSECS);
 
 	/* Wait for board to become not ready, then ready. */
-	dev_info(&pdev->dev, "Waiting for board to become ready.\n");
+	dev_info(&pdev->dev, "Waiting for board to reset.\n");
 	rc = cciss_wait_for_board_state(pdev, vaddr, BOARD_NOT_READY);
 	if (rc) /* Don't bail, might be E500, etc. which can't be reset */
 		dev_warn(&pdev->dev,
-			"failed waiting for board to become not ready\n");
+			"failed waiting for board to reset\n");
 	rc = cciss_wait_for_board_state(pdev, vaddr, BOARD_READY);
 	if (rc) {
 		dev_warn(&pdev->dev,
@@ -4641,6 +4641,7 @@ static __devinit int cciss_init_reset_devices(struct pci_dev *pdev)
 		return -ENODEV;
 
 	/* Now try to get the controller to respond to a no-op */
+	dev_warn(&pdev->dev, "Waiting for controller to respond to no-op\n");
 	for (i = 0; i < CCISS_POST_RESET_NOOP_RETRIES; i++) {
 		if (cciss_noop(pdev) == 0)
 			break;

