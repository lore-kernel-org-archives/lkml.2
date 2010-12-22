Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0LVL0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:26:13 -0500
Received: from mail-bw0-f67.google.com ([209.85.214.67]:59798 "EHLO
	mail-bw0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab0LVL0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:26:12 -0500
X-Greylist: delayed 739 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Dec 2010 06:25:44 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qGAaG8g5BkyDBjy4jBhCBvCrASjhDsgu9r6NN2i/AxkNORC63inwErfl9Rwpls3G4V
         X7x/+ESQGCUrgcbe1ICa3nNRtW9yTtfVQdN1SfSrPUHqKmCQ0GptB1g4SXcjP+gUhBb8
         ciVZvOgppKGyGKGY8JGTfpzVxjjIBybUiFUoY=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] signal: remove superflous try_to_freeze() loop in do_signal_stop()
Date: Wed, 22 Dec 2010 12:13:17 +0100
Message-Id: <1293016398-18001-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293016398-18001-1-git-send-email-tj@kernel.org>
References: <1293016398-18001-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_signal_stop() is used only by get_signal_to_deliver() and after a
successful signal stop, it always calls try_to_freeze(), so the
try_to_freeze() loop around schedule() in do_signal_stop() is
superflous and confusing.  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/signal.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index fe004b5..0a6816a 100644
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

