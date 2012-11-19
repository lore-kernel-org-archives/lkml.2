Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2KSFdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:33:03 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52940 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2KSFc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:32:59 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 51/58] x86: perf: Add prototype for arch_perf_update_userpage
Date: Sun, 18 Nov 2012 21:28:30 -0800
Message-Id: <1353302917-13995-52-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/cpu/perf_event.c defines a function
arch_perf_update_userpage, overriding a __weak stub for that function
defined in kernel/events/core.c.  Nothing currently prototypes that
function.  Add a prototype right before the definition, to satisfy gcc
(-Wmissing-prototypes) and Sparse (-Wdecl).

arch/x86/kernel/cpu/perf_event.c:1692:6: warning: no previous prototype for ‘arch_perf_update_userpage’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/cpu/perf_event.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4a3374e..2d070cb 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1689,6 +1689,8 @@ static struct pmu pmu = {
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 };
 
+void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now);
+
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 	userpg->cap_usr_time = 0;
-- 
1.7.10.4

