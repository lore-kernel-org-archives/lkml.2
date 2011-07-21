Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1GUJTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:19:13 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57251 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1GUJSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:18:48 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 10/10] um: Remove dead code
Date: Thu, 21 Jul 2011 11:18:34 +0200
Message-Id: <1311239914-8301-10-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311239914-8301-1-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC 4.6's -Wunused-but-set-variable found some dead code.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/chan_kern.c |    3 +--
 arch/um/drivers/line.c      |    3 +--
 arch/um/kernel/reboot.c     |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 25e1965..d4191fe 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -543,11 +543,10 @@ int parse_chan_pair(char *str, struct line *line, int device,
 		    const struct chan_opts *opts, char **error_out)
 {
 	struct list_head *chans = &line->chan_list;
-	struct chan *new, *chan;
+	struct chan *new;
 	char *in, *out;
 
 	if (!list_empty(chans)) {
-		chan = list_entry(chans->next, struct chan, list);
 		free_chan(chans, 0);
 		INIT_LIST_HEAD(chans);
 	}
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 35dd0b8..d51c404 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -176,10 +176,9 @@ void line_flush_buffer(struct tty_struct *tty)
 {
 	struct line *line = tty->driver_data;
 	unsigned long flags;
-	int err;
 
 	spin_lock_irqsave(&line->lock, flags);
-	err = flush_buffer(line);
+	flush_buffer(line);
 	spin_unlock_irqrestore(&line->lock, flags);
 }
 
diff --git a/arch/um/kernel/reboot.c b/arch/um/kernel/reboot.c
index 869bec9..4d93dff 100644
--- a/arch/um/kernel/reboot.c
+++ b/arch/um/kernel/reboot.c
@@ -20,9 +20,8 @@ static void kill_off_processes(void)
 		os_kill_ptraced_process(userspace_pid[0], 1);
 	else {
 		struct task_struct *p;
-		int pid, me;
+		int pid;
 
-		me = os_getpid();
 		for_each_process(p) {
 			if (p->mm == NULL)
 				continue;
-- 
1.7.6

