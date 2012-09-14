Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2INMll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:41:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab2INMlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:41:40 -0400
Date: Fri, 14 Sep 2012 14:43:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Cong Wang <amwang@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Jiri Moskovcak <jmoskovc@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] coredump: use SUID_DUMPABLE_ENABLED rather than hardcoded 1
Message-ID: <20120914124332.GA32193@redhat.com>
References: <20120913172817.GA11337@redhat.com> <20120913152559.d0a9ade0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913152559.d0a9ade0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic. Change setup_new_exec() and task_dumpable() to use
SUID_DUMPABLE_ENABLED for /bin/grep.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c      |    2 +-
 fs/proc/base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 905e94b..1d3dfc5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1125,7 +1125,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
-		set_dumpable(current->mm, 1);
+		set_dumpable(current->mm, SUID_DUMPABLE_ENABLED);
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 21fb230..7f40bb7 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1398,7 +1398,7 @@ static int task_dumpable(struct task_struct *task)
 	if (mm)
 		dumpable = get_dumpable(mm);
 	task_unlock(task);
-	if(dumpable == 1)
+	if(dumpable == SUID_DUMPABLE_ENABLED)
 		return 1;
 	return 0;
 }
-- 
1.5.5.1


