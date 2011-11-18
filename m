Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1KRRh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:37:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47849 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab1KRRhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:37:25 -0500
Date: Fri, 18 Nov 2011 11:37:03 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, richard@nod.at,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, oleg@redhat.com, dhowells@redhat.com
Subject: [PATCH 1/1] __send_signal: pass q->info, not info, to
 userns_fixup_signal_uid
Message-ID: <20111118173703.GA11823@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Biederman pointed out that passing info is a bug and could lead
to a NULL pointer deref to boot.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index c0f0782..2751f79 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1118,7 +1118,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			break;
 		}
 
-		userns_fixup_signal_uid(info, t);
+		userns_fixup_signal_uid(q->info, t);
 
 	} else if (!is_si_special(info)) {
 		if (sig >= SIGRTMIN && info->si_code != SI_USER) {
-- 
1.7.5.4

