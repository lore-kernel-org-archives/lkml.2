Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1ECUAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:00:03 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:24110 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab1ECT75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:59:57 -0400
Subject: [PATCH 14/16] hpsa: remove superfluous sleeps around reset code
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 03 May 2011 14:59:56 -0500
Message-ID: <20110503195956.5478.65695.stgit@beardog.cce.hp.com>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
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
 drivers/scsi/hpsa.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6fe77d0..ca8ee92 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3217,7 +3217,6 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 		 */
 		dev_info(&pdev->dev, "using doorbell to reset controller\n");
 		writel(use_doorbell, vaddr + SA5_DOORBELL);
-		msleep(1000);
 	} else { /* Try to do it the PCI power state way */
 
 		/* Quoting from the Open CISS Specification: "The Power
@@ -3248,8 +3247,6 @@ static int hpsa_controller_hard_reset(struct pci_dev *pdev,
 		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
 		pmcsr |= PCI_D0;
 		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
-
-		msleep(500);
 	}
 	return 0;
 }

