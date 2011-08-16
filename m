Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1HPP15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:27:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:44478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab1HPP1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:27:54 -0400
Date: Tue, 16 Aug 2011 15:27:18 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-fab1167c4698e3ff11ebb06281d78def6c53728b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, rdunlap@xenotime.net,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        rdunlap@xenotime.net, hpa@linux.intel.com
In-Reply-To: <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
References: <CA+55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5+fqMp_exQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vsyscall: Add missing <asm/fixmap.h> to arch/x86/mm/fault.c
Git-Commit-ID: fab1167c4698e3ff11ebb06281d78def6c53728b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Aug 2011 15:27:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fab1167c4698e3ff11ebb06281d78def6c53728b
Gitweb:     http://git.kernel.org/tip/fab1167c4698e3ff11ebb06281d78def6c53728b
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 15 Aug 2011 22:28:56 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 16 Aug 2011 08:04:02 -0700

x86, vsyscall: Add missing <asm/fixmap.h> to arch/x86/mm/fault.c

arch/x86/mm/fault.c now depend on having the symbol VSYSCALL_START
defined, which is best handled by including <asm/fixmap.h> (it isn't
unreasonable we may want other fixed addresses in this file in the
future, and so it is cleaner than including <asm/vsyscall.h>
directly.)

This addresses an x86-64 allnoconfig build failure.  On other
configurations it was masked by an indirect path:

<asm/smp.h> -> <asm/apic.h> -> <asm/fixmap.h> -> <asm/vsyscall.h>

... however, the first such include is conditional on CONFIG_X86_LOCAL_APIC.

Originally-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/CA%2B55aFxsOMc9=p02r8-QhJ=h=Mqwckk4_Pnx9LQt5%2BfqMp_exQ@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/fault.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 247aae3..f2d4c9d 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -17,6 +17,7 @@
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
+#include <asm/fixmap.h>			/* VSYSCALL_START		*/
 
 /*
  * Page fault error code bits:
