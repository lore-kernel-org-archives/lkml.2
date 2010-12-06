Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0LFQ6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:59713 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab0LFQ61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:27 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/16] signal: remove superflous try_to_freeze() loop in do_signal_stop()
Date: Mon,  6 Dec 2010 17:56:51 +0100
Message-Id: <1291654624-6230-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal_stop() is used only by get_signal_to_deliver() and after a
successful signal stop, it always calls try_to_freeze(), so the
try_to_freeze() loop around schedule() in do_signal_stop() is
superflous and confusing.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 0411131..7211c9f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1781,9 +1781,7 @@ static int do_signal_stop(int signr)
 	}
 
 	/* Now we don't run again until woken by SIGCONT or SIGKILL */
-	do {
-		schedule();
-	} while (try_to_freeze());
+	schedule();
 
 	tracehook_finish_jctl();
 	current->exit_code = 0;
-- 
1.7.1

