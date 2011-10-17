Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1JQGJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 02:09:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:7081 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab1JQGJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 02:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="63844292"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH v3] staging: mei: clean the TODO file from done tasks.
Date: Mon, 17 Oct 2011 08:06:17 +0200
Message-Id: <1318831577-4743-1-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) We move the AMT Watchdog to use the kernel watchdog core.
the new code is still part of the MEI driver.
we didn't find any good reason to extract the the MEI driver watchdog code
from the MEI Driver to a new module.

2) Since the watchdog remains in the mei driver, exposing in-kernel
API just for AMTHI is unnecessary.

MEI new Watchdog Core Interface Patches set:
https://lkml.org/lkml/2011/9/7/26

3) Code cleanup (init and probe, bug_on usage, headers and etc) was
submitted in previous patches.

Patches:
https://lkml.org/lkml/2011/9/21/231
https://lkml.org/lkml/2011/6/15/358
https://lkml.org/lkml/2011/7/7/177
https://lkml.org/lkml/2011/9/7/38
https://lkml.org/lkml/2011/9/7/37
https://lkml.org/lkml/2011/9/7/28


4) mei.txt was updated with additional information.

Patch:
https://lkml.org/lkml/2011/10/16/52


Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
v3 - Fix Grammar and trying to make the commit message to more readable.
 drivers/staging/mei/TODO |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/mei/TODO b/drivers/staging/mei/TODO
index 3b6a667..7d9a13b 100644
--- a/drivers/staging/mei/TODO
+++ b/drivers/staging/mei/TODO
@@ -1,14 +1,4 @@
 TODO:
-	- Create in-kernel Client API. Examples of in-kernel clients are watchdog and AMTHI.
-	- ME Watchdog Driver to expose standard Linux watchdog interface
-	- Rewrite AMTHI to use in-kernel client interface
-	- Cleanup init and probe functions
-	- Review BUG/BUG_ON usage
-	- Cleanup and reorganize header files
-	- Rewrite client data structure
-	- Make state machine more readable
-	- Add mei.txt with driver explanation and it's driver
-	- Fix Kconfig
 	- Cleanup and split the timer function
 Upon Unstaging:
 	- move mei.h to include/linux/mei.h
-- 
1.7.4.1

