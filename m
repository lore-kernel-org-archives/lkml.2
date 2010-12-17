Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0LQMqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab0LQMqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:08 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/15] GFS2: fs/gfs2/glock.c: Convert sprintf_symbol to %pS
Date: Fri, 17 Dec 2010 12:24:08 +0000
Message-Id: <1292588661-14350-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 5a56568..13155f6 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1626,18 +1626,17 @@ static const char *hflags2str(char *buf, unsigned flags, unsigned long iflags)
 static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
 {
 	struct task_struct *gh_owner = NULL;
-	char buffer[KSYM_SYMBOL_LEN];
 	char flags_buf[32];
 
-	sprint_symbol(buffer, gh->gh_ip);
 	if (gh->gh_owner_pid)
 		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
-	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %s\n",
-		  state2str(gh->gh_state),
-		  hflags2str(flags_buf, gh->gh_flags, gh->gh_iflags),
-		  gh->gh_error, 
-		  gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
-		  gh_owner ? gh_owner->comm : "(ended)", buffer);
+	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %pS\n",
+		       state2str(gh->gh_state),
+		       hflags2str(flags_buf, gh->gh_flags, gh->gh_iflags),
+		       gh->gh_error,
+		       gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
+		       gh_owner ? gh_owner->comm : "(ended)",
+		       (void *)gh->gh_ip);
 	return 0;
 }
 
-- 
1.7.3.3

