Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2KSFb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:31:58 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42298 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2KSFb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:31:56 -0500
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 42/58] kernel/events/hw_breakpoint.c: Add prototype for __weak stub of arch_unregister_hw_breakpoint
Date: Sun, 18 Nov 2012 21:28:21 -0800
Message-Id: <1353302917-13995-43-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/events/hw_breakpoint.c defines an empty stub of
arch_unregister_hw_breakpoint with __weak, for use on architectures
without an alternate implementation.  Define a prototype of that
function, to satisfy gcc (-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/events/hw_breakpoint.c:247:28: warning: no previous prototype for ‘arch_unregister_hw_breakpoint’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/events/hw_breakpoint.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 4a3867a..a792001 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -244,6 +244,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 /*
  * Function to perform processor-specific cleanup during unregistration
  */
+void arch_unregister_hw_breakpoint(struct perf_event *bp);
 __weak void arch_unregister_hw_breakpoint(struct perf_event *bp)
 {
 	/*
-- 
1.7.10.4

