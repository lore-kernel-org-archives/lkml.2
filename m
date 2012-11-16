Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2KPV6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:58:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:11130 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab2KPV6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:58:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="250452900"
Subject: [PATCH v4 7/8] x86/acpi: Use __pa_symbol instead of __pa on C
 visible symbols
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Date: Fri, 16 Nov 2012 13:57:43 -0800
Message-ID: <20121116215737.8521.51167.stgit@ahduyck-cp1.jf.intel.com>
In-Reply-To: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change just updates one spot where __pa was being used when __pa_symbol
should have been used.  By using __pa_symbol we are able to drop a few extra
lines of code as we don't have to test to see if the virtual pointer is a
part of the kernel text or just standard virtual memory.

Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/kernel/acpi/sleep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 11676cf..f146a3c 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -69,7 +69,7 @@ int acpi_suspend_lowlevel(void)
 
 #ifndef CONFIG_64BIT
 	header->pmode_entry = (u32)&wakeup_pmode_return;
-	header->pmode_cr3 = (u32)__pa(&initial_page_table);
+	header->pmode_cr3 = (u32)__pa_symbol(initial_page_table);
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP

