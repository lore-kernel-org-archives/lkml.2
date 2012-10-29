Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373Ab2J2WBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:01:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:47965 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761363Ab2J2Vh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 085/101] freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD
Date: Mon, 29 Oct 2012 14:35:38 -0700
Message-Id: <20121029213249.760820060@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b40a79591ca918e7b91b0d9b6abd5d00f2e88c19 upstream.

flush_old_exec() clears PF_KTHREAD but forgets about PF_NOFREEZE.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1110,7 +1110,8 @@ int flush_old_exec(struct linux_binprm *
 	bprm->mm = NULL;		/* We're using it now */
 
 	set_fs(USER_DS);
-	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD);
+	current->flags &=
+		~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD | PF_NOFREEZE);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 


