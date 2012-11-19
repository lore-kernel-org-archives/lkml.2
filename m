Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2KSFa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:30:58 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48869 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:30:56 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 31/58] perf: cgroup: Drop unused perf_cgroup_switch stub
Date: Sun, 18 Nov 2012 21:28:10 -0800
Message-Id: <1353302917-13995-32-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/events/core.c defines a no-op stub of perf_cgroup_switch when
CONFIG_CGROUP_PERF=n.  However, nothing actually calls
perf_cgroup_switch outside of an #ifdef CONFIG_CGROUP_PERF.  So, drop
the stub.

This also eliminates a warning from gcc (-Wmissing-prototypes) and from
Sparse (-Wdecl).

kernel/events/core.c:604:1: warning: no previous prototype for ‘perf_cgroup_switch’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/events/core.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 01ba4db..543638a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -600,11 +600,6 @@ perf_cgroup_set_timestamp(struct task_struct *task,
 {
 }
 
-void
-perf_cgroup_switch(struct task_struct *task, struct task_struct *next)
-{
-}
-
 static inline void
 perf_cgroup_set_shadow_time(struct perf_event *event, u64 now)
 {
-- 
1.7.10.4

