Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1ECTxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:53:23 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27597 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1ECTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:53:21 -0400
Subject: [PATCH 06/16] cciss: fix reply pool and block fetch table memory leaks
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 03 May 2011 14:53:21 -0500
Message-ID: <20110503195321.5154.35671.stgit@beardog.cce.hp.com>
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


---
 drivers/block/cciss.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 63fe05a..d604489 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4988,6 +4988,10 @@ static void __devexit cciss_remove_one(struct pci_dev *pdev)
 		kfree(h->scatter_list[j]);
 	kfree(h->scatter_list);
 	cciss_free_sg_chain_blocks(h->cmd_sg_list, h->nr_cmds);
+	kfree(h->blockFetchTable);
+	if (h->reply_pool)
+		pci_free_consistent(h->pdev, h->max_commands * sizeof(__u64),
+				h->reply_pool, h->reply_pool_dhandle);
 	/*
 	 * Deliberately omit pci_disable_device(): it does something nasty to
 	 * Smart Array controllers that pci_enable_device does not undo

