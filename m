Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1CWKGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:06:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab1CWKGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=c8d6TD2FUILo2vet78t2ydhwxK8fqwal/s0A6fAhs3UgWU5a8Knm7qszE809TZp/tS
         vhZGLd5GvPwz0TXl00KvHVeHfVNiZBMjpJ+cudEPpkwIYbXzSQJKmXsZgXeY2zZpqDYI
         bM1uuvhy/BxoNYHU+1qK1Z6v+uPBYy3f3BEsQ=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/20] signal: Remove superflous try_to_freeze() loop in do_signal_stop()
Date: Wed, 23 Mar 2011 11:05:49 +0100
Message-Id: <1300874766-12941-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
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
index e26274a..f4db769 100644
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

