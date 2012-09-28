Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab2I1Hii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:38:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:23450 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709Ab2I1Hig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:38:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,499,1344236400"; 
   d="scan'208,223";a="227634165"
Message-ID: <1348817955.10877.322.camel@rui.sh.intel.com>
Subject: [RFC PATCH 2/6] Introduce ACPI style match in platform_match
From: Zhang Rui <rui.zhang@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Zhang, Rui" <rui.zhang@intel.com>
Date: Fri, 28 Sep 2012 15:39:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5d7ecd12c2994b8c5905d52718c2870c3b62746e Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Fri, 28 Sep 2012 14:51:03 +0800
Subject: [RFC PATCH 2/6] Introduce ACPI style match in platform_match

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/base/platform.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index a1a7225..90e64c6f 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/acpi.h>
 
 #include "base.h"
 
@@ -635,6 +636,13 @@ static const struct platform_device_id *platform_match_id(
 			struct platform_device *pdev)
 {
 	while (id->name[0]) {
+#ifdef CONFIG_ACPI
+		/* attempt ACPI style match */
+		if (acpi_match_device_id(&pdev->dev, id->name) == 0) {
+			pdev->id_entry = id;
+			return id;
+		}
+#endif
 		if (strcmp(pdev->name, id->name) == 0) {
 			pdev->id_entry = id;
 			return id;
-- 
1.7.7.6



