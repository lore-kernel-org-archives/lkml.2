Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab1GMFOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:14:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:9791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1GMFOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:14:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,523,1304319600"; 
   d="scan'208";a="27048194"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH 07/17] ACPI, APEI, GHES, Prevent GHES to be built as module
Date: Wed, 13 Jul 2011 13:14:18 +0800
Message-Id: <1310534068-30547-8-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
References: <1310534068-30547-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GHES (Generic Hardware Error Source) is used to process hardware error
notification in firmware first mode.  But because firmware first mode
can be turned on but can not be turned off, it is unreasonable to
unload the GHES module with firmware first mode turned on.  To avoid
confusion, this patch makes GHES can be enabled/disabled in
configuration time, but not built as module and unloaded at run time.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Matthew Garrett <mjg@redhat.com>
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
