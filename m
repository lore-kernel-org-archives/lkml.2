Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2KSF3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:49 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:55570 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2KSF3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:47 -0500
X-Originating-IP: 217.70.178.150
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 20/58] kernel/events/hw_breakpoint.c: Make hw_breakpoint_weight static
Date: Sun, 18 Nov 2012 21:27:59 -0800
Message-Id: <1353302917-13995-21-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f93a20541134fa767e8dc4eb32e956d30b9f6b92, in April 2010, added
the ability for hardware breakpoints to have variable "weight" in
allocations, and added a __weak function hw_breakpoint_weight that
architectures could override to set the weight of a breakpoint.  No
architecture has ever done so.

For now, change the function from __weak to static.  If this
functionality continues to go unused, the abstraction should probably go
away entirely.

This also eliminates a warning:

kernel/events/hw_breakpoint.c:80:27: warning: no previous prototype for ‘hw_breakpoint_weight’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/events/hw_breakpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 9a7b487..4a3867a 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -77,7 +77,7 @@ struct bp_busy_slots {
 /* Serialize accesses to the above constraints */
 static DEFINE_MUTEX(nr_bp_mutex);
 
-__weak int hw_breakpoint_weight(struct perf_event *bp)
+static int hw_breakpoint_weight(struct perf_event *bp)
 {
 	return 1;
 }
-- 
1.7.10.4

