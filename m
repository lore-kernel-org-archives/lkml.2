Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0LJHRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:17:09 -0500
Received: from mail.perches.com ([173.55.12.10]:2489 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab0LJHQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:16:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 2/2] x86: smp: Remove unlikely from cpu_is_offline
Date: Thu,  9 Dec 2010 23:16:56 -0800
Message-Id: <95f481d7db923f367bd9cf2d4e0932e344280a3f.1291965374.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <c9efab4f338b1c630072c4b8aa5715dfdbb13533.1291965374.git.joe@perches.com>
References: <c9efab4f338b1c630072c4b8aa5715dfdbb13533.1291965374.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_is_offline already uses unlikely internally.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 513deac..02e53f1 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -114,7 +114,7 @@
  */
 static void native_smp_send_reschedule(int cpu)
 {
-	if (unlikely(cpu_is_offline(cpu))) {
+	if (cpu_is_offline(cpu)) {
 		WARN_ON(1);
 		return;
 	}
-- 
1.7.3.3.398.g0b0cd.dirty

