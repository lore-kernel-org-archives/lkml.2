Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2JYGA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:00:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:28748 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab2JYGAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:00:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,645,1344236400"; 
   d="scan'208";a="160355052"
Date: Wed, 24 Oct 2012 23:04:00 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <len.brown@intel.com>,
        Bin Gao <bin.gao@linux.intel.com>
Subject: arch/x86/Kconfig: not select X86_MPPARSE when SFI is present
Message-ID: <20121025060400.GB38419@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

