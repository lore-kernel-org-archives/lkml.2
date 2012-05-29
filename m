Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab2E2NjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:39:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:55463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2E2NjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:39:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158216598"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        devel@linuxdriverproject.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/4] misc: mei: set IRQF_ONESHOT for msi request_threaded_irq
Date: Tue, 29 May 2012 16:39:10 +0300
Message-Id: <1338298752-15445-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
References: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when the default irq quick handler is used then IRQF_ONESHOT must be set
otherwise the request fails and following error is displayed:

genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq ...

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index c703332..88e5953 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -982,7 +982,7 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 		err = request_threaded_irq(pdev->irq,
 			NULL,
 			mei_interrupt_thread_handler,
-			0, mei_driver_name, dev);
+			IRQF_ONESHOT, mei_driver_name, dev);
 	else
 		err = request_threaded_irq(pdev->irq,
 			mei_interrupt_quick_handler,
-- 
1.7.4.4

