Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2KSFbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:40 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45050 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2KSFbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:37 -0500
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 39/58] kernel/events/core.c: Add prototype for __weak stub of arch_perf_update_userpage
Date: Sun, 18 Nov 2012 21:28:18 -0800
Message-Id: <1353302917-13995-40-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/events/core.c defines an empty stub of arch_perf_update_userpage
with __weak, for use on architectures without an alternate
implementation.  Define a prototype of that function, to satisfy gcc
(-Wmissing-prototypes) and Sparse (-Wdecl).

arch/x86/kernel/cpu/perf_event.c:1692:6: warning: no previous prototype for ‘arch_perf_update_userpage’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/events/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 543638a..69ab633 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3353,6 +3353,8 @@ static void calc_timer_values(struct perf_event *event,
 	*running = ctx_time - event->tstamp_running;
 }
 
+void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now);
+
 void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 }
-- 
1.7.10.4

