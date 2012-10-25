Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935944Ab2JYRL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:11:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204Ab2JYRLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:11:54 -0400
Date: Thu, 25 Oct 2012 19:12:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [PATCH 1/1] freezer: exec should clear PF_NOFREEZE along with
	PF_KTHREAD
Message-ID: <20121025171256.GB6776@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-5-git-send-email-tj@kernel.org> <20121022183453.GA24687@redhat.com> <20121022211822.GF5951@atj.dyndns.org> <20121023155533.GC16201@redhat.com> <20121024190651.GC12182@atj.dyndns.org> <20121025171236.GA6776@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121025171236.GA6776@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_old_exec() clears PF_KTHREAD but forgets about PF_NOFREEZE.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8b9011b..0039055 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1083,7 +1083,8 @@ int flush_old_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;		/* We're using it now */
 
 	set_fs(USER_DS);
-	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD);
+	current->flags &=
+		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 
-- 
1.5.5.1


