Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788Ab2LGWKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 17:10:35 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:34599 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2LGWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 17:10:34 -0500
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC v1 RESEND 01/16] lib: devres: don't enclose pcim_*() functions in CONFIG_HAS_IOPORT
Date: Fri,  7 Dec 2012 23:10:04 +0100
Message-Id: <1354918219-32364-2-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354918219-32364-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1354918219-32364-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcim_*() functions are used by the libata-sff subsystem, and this
subsystem is used for many SATA drivers on ARM platforms that do not
necessarily have I/O ports.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 lib/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/devres.c b/lib/devres.c
index 80b9c76..5639c3e 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -195,6 +195,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 			       devm_ioport_map_match, (void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
+#endif /* CONFIG_HAS_IOPORT */
 
 #ifdef CONFIG_PCI
 /*
@@ -400,4 +401,3 @@ void pcim_iounmap_regions(struct pci_dev *pdev, int mask)
 }
 EXPORT_SYMBOL(pcim_iounmap_regions);
 #endif /* CONFIG_PCI */
-#endif /* CONFIG_HAS_IOPORT */
-- 
1.7.9.5

