Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab1F0I2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 04:28:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:49663 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab1F0I0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 04:26:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,431,1304319600"; 
   d="scan'208";a="19009076"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, mjg59@srcf.ucam.org
Subject: [PATCH -v2 1/4] ACPI, APEI, GHES, Prevent GHES to be built as module
Date: Mon, 27 Jun 2011 16:25:57 +0800
Message-Id: <1309163160-3201-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309163160-3201-1-git-send-email-ying.huang@intel.com>
References: <1309163160-3201-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GHES (Generic Hardware Error Source) is used to process hardware error
notification in firmware first mode.  But because firmware first mode
can be turned on but can not be turned off, it is unreasonable to
unload the GHES module with firmware first mode turned on.  To avoid
confusion, this patch makes GHES can be enable/disable in
configuration time, but not built as module and unload at run time.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/apei/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -10,7 +10,7 @@ config ACPI_APEI
 	  error injection.
 
 config ACPI_APEI_GHES
-	tristate "APEI Generic Hardware Error Source"
+	bool "APEI Generic Hardware Error Source"
 	depends on ACPI_APEI && X86
 	select ACPI_HED
 	help
