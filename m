Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab2JYAVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:21:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:59294 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab2JYAVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:21:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,643,1344236400"; 
   d="scan'208,223";a="160267971"
Date: Wed, 24 Oct 2012 17:25:09 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: linux-kernel@vger.kernel.org
Subject: Exclude X86_MPPARSE when either ACPI or SFI is present
Message-ID: <20121025002509.GA37301@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-arch-x86-Kconfig-not-select-X86_MPPARSE-when-SFI-is-.patch"

>From 6f439bdcc027fe9c0cb4ce2ca4f7d1879d84097d Mon Sep 17 00:00:00 2001
From: Bin Gao <bin.gao@intel.com>
Date: Thu, 18 Oct 2012 16:13:46 -0700
Subject: [PATCH] arch/x86/Kconfig: not select X86_MPPARSE when SFI is present

MPS tables are not needed for systems that have proper ACPI support.
This is also true for systems that have SFI in place.

So this patch is to exclude X86_MPPARSE when either ACPI or SFI is present.

Signed-off-by: Bin Gao <bin.gao@intel.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 46c3bff..b1494bd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -310,7 +310,7 @@ config X86_X2APIC
 	  If you don't know what to do here, say N.
 
 config X86_MPPARSE
-	bool "Enable MPS table" if ACPI
+	bool "Enable MPS table" if ACPI || SFI
 	default y
 	depends on X86_LOCAL_APIC
 	---help---
-- 
1.7.4.4


--sdtB3X0nJg68CQEu--
