Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2FSGOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:14:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:62481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab2FSGNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:13:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159348683"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/4] mei: mei_irq_thread_write_handler check for overflow
Date: Tue, 19 Jun 2012 09:13:36 +0300
Message-Id: <1340086417-23090-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1340086417-23090-1-git-send-email-tomas.winkler@intel.com>
References: <1340086417-23090-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check for overflow when retrieving empty write slots

Change-Id: Icdbe6c671686e55c322de66901dada365a3ea105
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 86380fd..7ea0254 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -1204,6 +1204,9 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 		return 0;
 	}
 	*slots = mei_count_empty_write_slots(dev);
+	if (*slots <= 0)
+		return -EMSGSIZE;
+
 	/* complete all waiting for write CB */
 	dev_dbg(&dev->pdev->dev, "complete all waiting for write cb.\n");
 
-- 
1.7.4.4

