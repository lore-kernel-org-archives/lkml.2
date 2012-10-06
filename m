Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab2JFAUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 20:20:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2JFAUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 20:20:19 -0400
Date: Fri, 5 Oct 2012 17:20:01 -0700
From: "tip-bot for Luck, Tony" <tony.luck@intel.com>
Message-ID: <tip-385ddeac7ed99cf7dc62d76274d55fbd7cae1b5a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        lenb@kernel.org, trenn@suse.de, tony.luck@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        trenn@suse.de, hpa@linux.intel.com
In-Reply-To: <506f59ae9600b36a4@agluck-desktop.sc.intel.com>
References: <506f59ae9600b36a4@agluck-desktop.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/acpi] X86 ACPI: Use #ifdef not #if for CONFIG_X86 check
Git-Commit-ID: 385ddeac7ed99cf7dc62d76274d55fbd7cae1b5a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 17:20:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  385ddeac7ed99cf7dc62d76274d55fbd7cae1b5a
Gitweb:     http://git.kernel.org/tip/385ddeac7ed99cf7dc62d76274d55fbd7cae1b5a
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Fri, 5 Oct 2012 15:05:34 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 5 Oct 2012 15:59:07 -0700

X86 ACPI: Use #ifdef not #if for CONFIG_X86 check

Fix a build warning on ia64:

include/linux/acpi.h:437:5: warning: "CONFIG_X86" is not defined

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/506f59ae9600b36a4@agluck-desktop.sc.intel.com
Cc: Len Brown <lenb@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/acpi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d14081c..49fe586 100644
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
