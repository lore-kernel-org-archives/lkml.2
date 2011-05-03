Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1ECTyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:54:00 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27696 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab1ECTx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:53:57 -0400
Subject: [PATCH 13/16] cciss: remove superfluous sleeps around reset code
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:57 -0500
Message-ID: <20110503195357.5154.72006.stgit@beardog.cce.hp.com>
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

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 23b0ba4..7990b98 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4477,7 +4477,6 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 		 */
 		dev_info(&pdev->dev, "using doorbell to reset controller\n");
 		writel(use_doorbell, vaddr + SA5_DOORBELL);
-		msleep(1000);
 	} else { /* Try to do it the PCI power state way */
 
 		/* Quoting from the Open CISS Specification: "The Power
@@ -4508,8 +4507,6 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= PCI_D0;
 		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
-
-		msleep(500);
 	}
 	return 0;
 }

