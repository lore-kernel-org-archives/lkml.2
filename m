Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2JEWFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 18:05:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:46823 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab2JEWFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 18:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="230551625"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Renninger <trenn@suse.de>
Subject: [PATCH] X86 ACPI: Use #ifdef not #if for CONFIG_X86 check
Cc: lenb@kernel.org, initramfs@vger.kernel.org, robert.moore@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, hpa@zytor.com
In-Reply-To: <201209251712.17678.trenn@suse.de>
Date: Fri, 05 Oct 2012 15:05:34 -0700
Message-Id: <506f59ae9600b36a4@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a build warning on ia64:

include/linux/acpi.h:437:5: warning: "CONFIG_X86" is not defined

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 4f42332..f70f18d 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -434,7 +434,7 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 
 acpi_status acpi_os_prepare_sleep(u8 sleep_state,
 				  u32 pm1a_control, u32 pm1b_control);
-#if CONFIG_X86
+#ifdef CONFIG_X86
 void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
 #else
 static inline void arch_reserve_mem_area(acpi_physical_address addr,
