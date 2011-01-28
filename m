Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1A1PJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:09:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1A1PJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:09:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ldivRz53oquh7C15p5HZUnL8tmTFlTGm2NUnlzOih7PXQbV8CGO+B3NACRc+GMMfTc
         X75XcHjfubHoiO0SOagH/Ivp2/WRcvguLdKiLC25MGrz/qj4th1qxGubmJl4s366wRfD
         Ib/FX4tbT8Uunk6jq4GARPh6BasO4egzKcka0=
From: Tejun Heo <tj@kernel.org>
To: roland@redhat.com, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] signal: remove superflous try_to_freeze() loop in do_signal_stop()
Date: Fri, 28 Jan 2011 16:08:37 +0100
Message-Id: <1296227324-25295-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296227324-25295-1-git-send-email-tj@kernel.org>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
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

