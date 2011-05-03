Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab1ECT7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:59:44 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:35226 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab1ECT7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:59:41 -0400
Subject: [PATCH 11/16] hpsa: remove atrophied hpsa_scsi_setup function
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Tue, 03 May 2011 14:59:41 -0500
Message-ID: <20110503195941.5478.4259.stgit@beardog.cce.hp.com>
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

hpsa_scsi_setup at one time contained enough code to justify
its existence, but that time has passed.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2a90e9a..ca92141 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -929,13 +929,6 @@ static void hpsa_slave_destroy(struct scsi_device *sdev)
 	/* nothing to do. */
 }
 
-static void hpsa_scsi_setup(struct ctlr_info *h)
-{
-	h->ndevices = 0;
-	h->scsi_host = NULL;
-	spin_lock_init(&h->devlock);
-}
-
 static void hpsa_free_sg_chain_blocks(struct ctlr_info *h)
 {
 	int i;
@@ -3970,7 +3963,9 @@ static int __devinit hpsa_init_one(struct pci_dev *pdev,
 	h->scan_finished = 1; /* no scan currently in progress */
 
 	pci_set_drvdata(pdev, h);
-	hpsa_scsi_setup(h);
+	h->ndevices = 0;
+	h->scsi_host = NULL;
+	spin_lock_init(&h->devlock);
 
 	/* Turn the interrupts on so we can service requests */
 	h->access.set_intr_mask(h, HPSA_INTR_ON);

