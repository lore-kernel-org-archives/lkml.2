Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2KQA3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:29:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2KQA3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:29:48 -0500
Date: Fri, 16 Nov 2012 16:28:59 -0800
From: tip-bot for Alexander Duyck <alexander.h.duyck@intel.com>
Message-ID: <tip-40276eb3568125e86014d703bae48dbfcb3c20f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alexander.h.duyck@intel.com, pavel@ucw.cz, tglx@linutronix.de,
        hpa@linux.intel.com, rjw@sisk.pl, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        alexander.h.duyck@intel.com, pavel@ucw.cz, tglx@linutronix.de,
        hpa@linux.intel.com, rjw@sisk.pl, len.brown@intel.com
In-Reply-To: <20121116215737.8521.51167.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116215737.8521.51167.stgit@ahduyck-cp1.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/acpi:
  Use __pa_symbol instead of __pa on C visible symbols
Git-Commit-ID: 40276eb3568125e86014d703bae48dbfcb3c20f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Nov 2012 16:29:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40276eb3568125e86014d703bae48dbfcb3c20f3
Gitweb:     http://git.kernel.org/tip/40276eb3568125e86014d703bae48dbfcb3c20f3
Author:     Alexander Duyck <alexander.h.duyck@intel.com>
AuthorDate: Fri, 16 Nov 2012 13:57:43 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Nov 2012 15:20:50 -0800

x86/acpi: Use __pa_symbol instead of __pa on C visible symbols

This change just updates one spot where __pa was being used when __pa_symbol
should have been used.  By using __pa_symbol we are able to drop a few extra
lines of code as we don't have to test to see if the virtual pointer is a
part of the kernel text or just standard virtual memory.

Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Acked-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Link: http://lkml.kernel.org/r/20121116215737.8521.51167.stgit@ahduyck-cp1.jf.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/acpi/sleep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
