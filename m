Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282Ab2JYVEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:04:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:36504 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945908Ab2JYVEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:04:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,648,1344236400"; 
   d="scan'208";a="240202148"
Date: Thu, 25 Oct 2012 09:35:44 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <len.brown@intel.com>,
        Bin Gao <bin.gao@linux.intel.com>
Subject: arch/x86/Kconfig: allow turning off CONFIG_X86_MPPARSE when either
 ACPI or SFI is present
Message-ID: <20121025163544.GB38477@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MPS tables are not needed for systems that have proper ACPI support.
This is also true for systems that have SFI in place.

So this patch allows the configuration (turning off) of CONFIG_X86_MPPARSE
when either ACPI or SFI is present.

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

