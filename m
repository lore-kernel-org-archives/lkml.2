Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1CEKhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 05:37:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33838 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1CEKhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 05:37:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=N0b3g9ZKC0SAegDdUv4ZfKZVbiXNWTy2u6olH5tCjf4mz9eg2DZ+C2HwUMG1dkYFHl
         rkdMhfRKMVrRVlwnMyyEUtNBfk4I9zho147FD03ymlCoIG7rH3rLcoERgSHzwSIPOSmG
         pu1s3ajA1qN/ylNf1hnjV8MB1u1JBlbSVB6Tk=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] signal: remove superflous try_to_freeze() loop in do_signal_stop()
Date: Sat,  5 Mar 2011 11:37:00 +0100
Message-Id: <1299321427-15051-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299321427-15051-1-git-send-email-tj@kernel.org>
References: <1299321427-15051-1-git-send-email-tj@kernel.org>
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
Acked-by: Roland McGrath <roland@redhat.com>
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

