Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1CILWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:22:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:35114 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1CILWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:22:47 -0500
Date: Wed, 9 Mar 2011 11:21:52 GMT
From: tip-bot for Sedat Dilek <sedat.dilek@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        heukelum@fastmail.fm, sedat.dilek@googlemail.com, pavel@ucw.cz,
        tglx@linutronix.de, rjw@sisk.pl, mingo@elte.hu, sedat.dilek@gmail.com,
        hjl.tools@gmail.com, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sedat.dilek@googlemail.com, heukelum@fastmail.fm, pavel@ucw.cz,
        tglx@linutronix.de, rjw@sisk.pl, len.brown@intel.com,
        hjl.tools@gmail.com, sedat.dilek@gmail.com, mingo@elte.hu
In-Reply-To: <1299620364-21644-1-git-send-email-sedat.dilek@gmail.com>
References: <1299620364-21644-1-git-send-email-sedat.dilek@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trampoline] x86: Fix binutils-2.21 symbol related build failures
Message-ID: <tip-2ae9d293b14d17f35eff624272cfecac7979a2ee@git.kernel.org>
Git-Commit-ID: 2ae9d293b14d17f35eff624272cfecac7979a2ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Mar 2011 11:21:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ae9d293b14d17f35eff624272cfecac7979a2ee
Gitweb:     http://git.kernel.org/tip/2ae9d293b14d17f35eff624272cfecac7979a2ee
Author:     Sedat Dilek <sedat.dilek@googlemail.com>
AuthorDate: Tue, 8 Mar 2011 22:39:24 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Mar 2011 10:25:45 +0100

x86: Fix binutils-2.21 symbol related build failures

New binutils version 2.21.0.20110302-1 started checking that the symbol
parameter to the .size directive matches the entry name's
symbol parameter, unearthing two mismatches:

  AS      arch/x86/kernel/acpi/wakeup_rm.o
  arch/x86/kernel/acpi/wakeup_rm.S: Assembler messages:
  arch/x86/kernel/acpi/wakeup_rm.S:12: Error: .size expression with symbol `wakeup_code_start' does not evaluate to a constant

  arch/x86/kernel/entry_32.S: Assembler messages:
  arch/x86/kernel/entry_32.S:1421: Error: .size expression with
  symbol `apf_page_fault' does not evaluate to a constant

The problem was discovered while using Debian's binutils
(2.21.0.20110302-1) and experimenting with binutils from
upstream.

Thanks Alexander and H.J. for the vital help.

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
LKML-Reference: <1299620364-21644-1-git-send-email-sedat.dilek@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/wakeup_rm.S |    2 +-
 arch/x86/kernel/entry_32.S       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup_rm.S b/arch/x86/kernel/acpi/wakeup_rm.S
index 6ce81ee..63b8ab5 100644
--- a/arch/x86/kernel/acpi/wakeup_rm.S
+++ b/arch/x86/kernel/acpi/wakeup_rm.S
@@ -9,4 +9,4 @@
 	.globl	acpi_wakeup_code
 acpi_wakeup_code:
 	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
-	.size	wakeup_code_start, .-wakeup_code_start
+	.size	acpi_wakeup_code, .-acpi_wakeup_code
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c8b4efa..9ca3b0e 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1413,7 +1413,7 @@ ENTRY(async_page_fault)
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
-END(apf_page_fault)
+END(async_page_fault)
 #endif
 
 /*
