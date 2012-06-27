Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2F0OOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:14:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:13687 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab2F0OO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161312337"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        lekensteyn@gmail.com, Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc fix for 3.5] mei: pci_resume: set IRQF_ONESHOT for msi request_threaded_irq
Date: Wed, 27 Jun 2012 17:14:20 +0300
Message-Id: <1340806460-21646-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when the default irq quick handler is used then IRQF_ONESHOT must be set
otherwise the request fails and following error is displayed:

mei 0000:00:16.0: irq 48 for MSI/MSI-X
genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq 48
mei 0000:00:16.0: request_threaded_irq failed: irq = 48.
dpm_run_callback(): pci_pm_resume+0x0/0x140 returns -22
PM: Device 0000:00:16.0 failed to resume async: error -22

Reported-by: Lekensteyn <lekensteyn@gmail.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 7de1389..783fcd7 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -1147,7 +1147,7 @@ static int mei_pci_resume(struct device *device)
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

