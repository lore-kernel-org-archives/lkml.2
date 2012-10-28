Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2J1Xps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:45:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41908 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558Ab2J1X1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:25 -0400
Message-Id: <20121028231605.897184835@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:09 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 093/105] freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit b40a79591ca918e7b91b0d9b6abd5d00f2e88c19 upstream.

flush_old_exec() clears PF_KTHREAD but forgets about PF_NOFREEZE.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[bwh: Backported to 3.2: PF_FORKNOEXEC is cleared elsewhere]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1095,7 +1095,7 @@ int flush_old_exec(struct linux_binprm *
 	bprm->mm = NULL;		/* We're using it now */
 
 	set_fs(USER_DS);
-	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD);
+	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD | PF_NOFREEZE);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 


