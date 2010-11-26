Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0KZPCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:02:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:40182 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab0KZPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:02:06 -0500
Date: Fri, 26 Nov 2010 15:01:25 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101117222055.982965150@chello.nl>
References: <20101117222055.982965150@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Fixup Kconfig deps
Message-ID: <tip-cc2067a51424dd25c10c1b1230b4222d8baec94d@git.kernel.org>
Git-Commit-ID: cc2067a51424dd25c10c1b1230b4222d8baec94d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:01:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc2067a51424dd25c10c1b1230b4222d8baec94d
Gitweb:     http://git.kernel.org/tip/cc2067a51424dd25c10c1b1230b4222d8baec94d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 16 Nov 2010 21:49:01 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:00:58 +0100

perf, x86: Fixup Kconfig deps

This leads to a Kconfig dep inversion, x86 selects PERF_EVENT (due to
a hw_breakpoint dep) but doesn't unconditionally provide
HAVE_PERF_EVENT.

(This can cause build failures on M386/M486 kernel .config's.)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101117222055.982965150@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..e330da2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -21,7 +21,7 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
-	select HAVE_PERF_EVENTS if (!M386 && !M486)
+	select HAVE_PERF_EVENTS
 	select HAVE_IRQ_WORK
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
