Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2HPNZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:25:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:33328 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab2HPNZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:25:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="181480245"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.6] mei: fix device stall after wd is stopped
Date: Thu, 16 Aug 2012 16:25:33 +0300
Message-Id: <1345123533-13349-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After watchdog was disabled the driver would stall
due to wrong calculation of credits reduction

The cat&paste bug was introduced in the commit
7bdf72d3d8059a50214069ea4b87c2174645f40f
mei: introduce mei_data2slots wrapper

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index c6ffbbe..d78c05e 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -1253,7 +1253,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			if (dev->wd_timeout)
 				*slots -= mei_data2slots(MEI_START_WD_DATA_SIZE);
 			else
-				*slots -= mei_data2slots(MEI_START_WD_DATA_SIZE);
+				*slots -= mei_data2slots(MEI_WD_PARAMS_SIZE);
 		}
 	}
 	if (dev->stop)
-- 
1.7.4.4

