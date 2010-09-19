Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab0ISDBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 23:01:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:29657 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0ISDB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 23:01:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,387,1280732400"; 
   d="scan'208";a="326184859"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 1/5] ACPI, APEI, Fix APEI related table size checking
Date: Sun, 19 Sep 2010 11:00:31 +0800
Message-Id: <1284865235-29920-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284865235-29920-1-git-send-email-ying.huang@intel.com>
References: <1284865235-29920-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Both ERST and EINJ table size checking is fixed.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/einj.c |    3 ++-
 drivers/acpi/apei/erst.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 465c885..b184baa 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -426,7 +426,8 @@ DEFINE_SIMPLE_ATTRIBUTE(error_inject_fops, NULL,
 
 static int einj_check_table(struct acpi_table_einj *einj_tab)
 {
-	if (einj_tab->header_length != sizeof(struct acpi_table_einj))
+	if (einj_tab->header_length !=
+	    (sizeof(struct acpi_table_einj) - sizeof(einj_tab->header)))
 		return -EINVAL;
 	if (einj_tab->header.length < sizeof(struct acpi_table_einj))
 		return -EINVAL;
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index a4904f1..40b01c3 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -750,7 +750,8 @@ __setup("erst_disable", setup_erst_disable);
 
 static int erst_check_table(struct acpi_table_erst *erst_tab)
 {
-	if (erst_tab->header_length != sizeof(struct acpi_table_erst))
+	if (erst_tab->header_length !=
+	    (sizeof(struct acpi_table_erst) - sizeof(erst_tab->header)))
 		return -EINVAL;
 	if (erst_tab->header.length < sizeof(struct acpi_table_erst))
 		return -EINVAL;
-- 
1.7.1

