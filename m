Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2GaCYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 22:24:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:63481 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab2GaCYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 22:24:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="173400458"
From: Feng Tang <feng.tang@intel.com>
To: len.brown@intel.com, linux-kernel@vger.kernel.org, lenb@kernel.org
Cc: paulmck@linux.vnet.ibm.com, Feng Tang <feng.tang@intel.com>,
        Thomas Renninger <trenn@suse.de>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: [PATCH] ACPI processor: Fix a typo error in commit 99b725084
Date: Tue, 31 Jul 2012 10:19:38 +0800
Message-Id: <1343701178-15998-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 99b725084
	ACPI processor hotplug: Delay acpi_processor_start() call for hotplugged cores

acpi_processor_hotplug(pr) was wrongly replaced by acpi_processor_cst_has_changed,
this patch will just restore it back.

Cc: Thomas Renninger <trenn@suse.de>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/acpi/processor_driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index ff8e04f..bfc31cb 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -437,7 +437,7 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
 		/* Normal CPU soft online event */
 		} else {
 			acpi_processor_ppc_has_changed(pr, 0);
-			acpi_processor_cst_has_changed(pr);
+			acpi_processor_hotplug(pr);
 			acpi_processor_reevaluate_tstate(pr, action);
 			acpi_processor_tstate_has_changed(pr);
 		}
-- 
1.7.1

