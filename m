Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2GaEtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:49:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:51338 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab2GaEtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="173432441"
From: Feng Tang <feng.tang@intel.com>
To: len.brown@intel.com, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        Feng Tang <feng.tang@intel.com>, Thomas Renninger <trenn@suse.de>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: [PATCH v2] ACPI processor: Fix a typo error in commit 99b725084
Date: Tue, 31 Jul 2012 12:44:43 +0800
Message-Id: <1343709883-16801-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 99b725084 "ACPI processor hotplug: Delay acpi_processor_start()
call for hotplugged cores", acpi_processor_hotplug(pr) was wrongly replaced
by acpi_processor_cst_has_changed() inside the acpi_cpu_soft_notify(). This
patch will restore it back, which also fixes a tick_broadcast_mask regression:
	https://lkml.org/lkml/2012/7/30/169

[Resend to ACPI mail list and Cc stable kernel]

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> # 3.3+
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

