Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab1DMRsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:48:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:50140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab1DMRsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,205,1301900400"; 
   d="scan'208";a="678640002"
From: "Luck, Tony" <tony.luck@intel.com>
To: len.brown@intel.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix Kconfig dependencies for apei->pstore
In-reply-to: <20110413103109.76b9bb3d.rdunlap@xenotime.net>
Date: Wed, 13 Apr 2011 10:48:12 -0700
Message-Id: <4da5e1dc16852d7b29@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven's dependency checker kicked out this warning:

+ warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies (MISC_FILESYSTEMS):  => N/A

Randy confirmed that the fix was to "select MISC_FILESYSTEMS" too.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index 66a03ca..f739a70 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -1,5 +1,6 @@
 config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
+	select MISC_FILESYSTEMS
 	select PSTORE
 	depends on X86
 	help
