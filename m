Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0JVHXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:23:50 -0400
Received: from statler.bytemark.co.uk ([212.110.162.18]:44925 "EHLO
	statler.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab0JVHXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:23:48 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 07/30] staging/vme/tsi148: remove double freeing of the IRQ in .remove
Date: Fri, 22 Oct 2010 02:36:29 -0400
Message-Id: <1287729412-24356-8-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

tsi148_irq_exit is called twice in .remove, which causes an oops.

Remove the second call, which apart from being redundant cannot
possibly work; the CR/CSR space has been already unmapped.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_tsi148.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 660968e..acfbd59 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2612,8 +2612,6 @@ static void tsi148_remove(struct pci_dev *pdev)
 		kfree(master_image);
 	}
 
-	tsi148_irq_exit(bridge, pdev);
-
 	iounmap(bridge->base);
 
 	pci_release_regions(pdev);
-- 
1.7.1

