Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1CHVjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:39:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58611 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1CHVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gwIHGyqUUSDf2vC2xQCfNPvEY6j/K3HYQQugsD3q/yzocSiSD58z6SQmQbjrA8oN2D
         +YWueqTgfV+qLKQ5X/FxGHiFGCtQuLsj5uqWsupgNL2Vw6S7SVtvRwZhMv2ZRBmZ1bdA
         ykqVmSYB80Y0Iuqmjpld6pvgaj0rHd5rfNlgg=
From: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H.J. Lu" <hjl.tools@gmail.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: [PATCH] x86: Fix ACPI wakeup build failure
Date: Tue,  8 Mar 2011 22:39:24 +0100
Message-Id: <1299620364-21644-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.4.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following breakage in linux-next (next-20110308):
  AS      arch/x86/kernel/acpi/wakeup_rm.o
  arch/x86/kernel/acpi/wakeup_rm.S: Assembler messages:
  arch/x86/kernel/acpi/wakeup_rm.S:12: Error: .size expression with symbol `wakeup_code_start' does not evaluate to a constant

The issue was introduced by commit d1ee433539ea5963a8f946f3428b335d1c5fdb20:
"x86, trampoline: Use the unified trampoline setup for ACPI wakeup"

The problem was discovered while using Debian's binutils (2.21.0.20110302-1)
and experimenting with binutils from upstream.

Thanks Alexander and H.J. for the vital help.

CC: Alexander van Heukelum <heukelum@fastmail.fm>
CC: "H.J. Lu" <hjl.tools@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
CC: linux-pm@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org
CC: linux-next@vger.kernel.org
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 arch/x86/kernel/acpi/wakeup_rm.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.7.4.1

