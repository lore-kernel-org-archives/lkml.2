Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2KSF34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:56 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34824 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2KSF3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:54 -0500
X-Originating-IP: 217.70.178.143
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alex Shi <alex.shi@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 22/58] arch/x86/kernel/cpu/common.c: Mark cpu_detect_tlb static
Date: Sun, 18 Nov 2012 21:28:01 -0800
Message-Id: <1353302917-13995-23-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of arch/x86/kernel/cpu/common.c references
cpu_detect_tlb, so mark it static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/cpu/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7505f7b..eb12c08 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -482,7 +482,7 @@ u16 __read_mostly tlb_lld_4m[NR_INFO];
  */
 s8  __read_mostly tlb_flushall_shift = -1;
 
-void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
+static void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
 {
 	if (this_cpu->c_detect_tlb)
 		this_cpu->c_detect_tlb(c);
-- 
1.7.10.4

