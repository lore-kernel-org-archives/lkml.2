Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab0CaD7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:59:01 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63074 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab0CaD6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ah0k1egS5vRgftfnap3FNz5yaEosMVi+UHRSILdvMUSpYjwt3g/4O5m0u/7X59F0Bh
         GkcBWbWCgmRl83F47QiKE2AwogHbkVDxEqrPsufOZFYaVVzhV6tw3M7MezLwBJ4OOkD/
         ojgDak7IKzozrt+Uo7A7ECVuX2FeqRijPyQzw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       "2.6.33" <stable@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] x86,kgdb: Always initialize the hw breakpoint attribute
Date: Wed, 31 Mar 2010 05:58:47 +0200
Message-Id: <1270007927-6391-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1270007927-6391-1-git-send-regression-fweisbec@gmail.com>
References: <1270007927-6391-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

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
-- 
1.6.2.3

