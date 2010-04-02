Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0DBTGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:06:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:47703 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab0DBTGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:06:40 -0400
Date: Fri, 2 Apr 2010 19:06:22 GMT
From: tip-bot for Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, jason.wessel@windriver.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, jason.wessel@windriver.com, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1269975907-27602-1-git-send-email-jason.wessel@windriver.com>
References: <1269975907-27602-1-git-send-email-jason.wessel@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86,kgdb: Always initialize the hw breakpoint attribute
Message-ID: <tip-ab310b5edb8b601bcb02491ed6f7676da4fd1757@git.kernel.org>
Git-Commit-ID: ab310b5edb8b601bcb02491ed6f7676da4fd1757
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:06:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab310b5edb8b601bcb02491ed6f7676da4fd1757
Gitweb:     http://git.kernel.org/tip/ab310b5edb8b601bcb02491ed6f7676da4fd1757
Author:     Jason Wessel <jason.wessel@windriver.com>
AuthorDate: Tue, 30 Mar 2010 14:05:07 -0500
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 1 Apr 2010 08:26:32 +0200

x86,kgdb: Always initialize the hw breakpoint attribute

It is required to call hw_breakpoint_init() on an attr before using it
in any other calls.  This fixes the problem where kgdb will sometimes
fail to initialize on x86_64.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: 2.6.33 <stable@kernel.org>
LKML-Reference: <1269975907-27602-1-git-send-email-jason.wessel@windriver.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index bfba601..b2258ca 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -618,8 +618,8 @@ int kgdb_arch_init(void)
 	 * portion of kgdb because this operation requires mutexs to
 	 * complete.
 	 */
+	hw_breakpoint_init(&attr);
 	attr.bp_addr = (unsigned long)kgdb_arch_init;
-	attr.type = PERF_TYPE_BREAKPOINT;
 	attr.bp_len = HW_BREAKPOINT_LEN_1;
 	attr.bp_type = HW_BREAKPOINT_W;
 	attr.disabled = 1;
