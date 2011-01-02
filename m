Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1ABHYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:36126 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab1ABHYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:09 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 153/260] hostap_pci: set dev->base_addr during probe
Date: Sun,  2 Jan 2011 02:17:29 -0500
Message-Id: <1293952756-15010-154-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:58.0322 (UTC) FILETIME=[E1889720:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John W. Linville <linville@tuxdriver.com>

commit 0f4da2d77e1bf424ac36424081afc22cbfc3ff2b upstream.

"hostap: Protect against initialization interrupt" (which reinstated
"wireless: hostap, fix oops due to early probing interrupt")
reintroduced Bug 16111.  This is because hostap_pci wasn't setting
dev->base_addr, which is now checked in prism2_interrupt.  As a result,
initialization was failing for PCI-based hostap devices.  This corrects
that oversight.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/hostap/hostap_pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_pci.c b/drivers/net/wireless/hostap/hostap_pci.c
index d24dc7d..972a9c3 100644
--- a/drivers/net/wireless/hostap/hostap_pci.c
+++ b/drivers/net/wireless/hostap/hostap_pci.c
@@ -330,6 +330,7 @@ static int prism2_pci_probe(struct pci_dev *pdev,
 
         dev->irq = pdev->irq;
         hw_priv->mem_start = mem;
+	dev->base_addr = (unsigned long) mem;
 
 	prism2_pci_cor_sreset(local);
 
-- 
1.7.3.3

