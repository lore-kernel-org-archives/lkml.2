Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab2KZRP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:15:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006Ab2KZRPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 255/270] freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD
Date: Mon, 26 Nov 2012 14:59:05 -0200
Message-Id: <1353949160-26803-256-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b40a79591ca918e7b91b0d9b6abd5d00f2e88c19 upstream.

flush_old_exec() clears PF_KTHREAD but forgets about PF_NOFREEZE.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index e95aeed..8726a93 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1110,7 +1110,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;		/* We're using it now */
 
 	set_fs(USER_DS);
-	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD);
+	current->flags &=
+		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 
-- 
1.7.9.5

