Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0C3TGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:06:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:61141 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0C3TGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:06:22 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       Ingo Molnar <mingo@elte.hu>, stable@kernel.org
Subject: [PATCH 1/1] x86,kgdb: Always initialize the hw breakpoint attribute
Date: Tue, 30 Mar 2010 14:05:07 -0500
Message-Id: <1269975907-27602-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 30 Mar 2010 19:05:07.0745 (UTC) FILETIME=[E9C9E110:01CAD03B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is required to call hw_breakpoint_init() on an attr before using it
in any other calls.  This fixes the problem where kgdb will sometimes
fail to initialize on x86_64.

CC: Ingo Molnar <mingo@elte.hu>
CC: stable@kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
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
-- 
1.5.4.3

