Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab2KETF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:05:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:46029 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab2KETF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:05:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,716,1344236400"; 
   d="scan'208";a="242810086"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v3 7/8] x86/acpi: Use __pa_symbol instead of __pa on C visible
	symbols
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Mon, 05 Nov 2012 11:06:08 -0800
Message-ID: <20121105190605.10205.76277.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
References: <20121105185657.10205.27419.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
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
index d5e0d71..0532f5d 100644
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

