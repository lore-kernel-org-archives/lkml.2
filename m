Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0KEXNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:13:34 -0400
Received: from mail.perches.com ([173.55.12.10]:4360 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab0KEXMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:12:43 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] fs/gfs2/glock.c: Convert sprintf_symbol to %pS
Date: Fri,  5 Nov 2010 16:12:36 -0700
Message-Id: <1288998760-11775-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288998760-11775-1-git-send-email-joe@perches.com>
References: <1288998760-11775-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/gfs2/glock.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 8777885..08dd4a2 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1627,18 +1627,17 @@ static const char *hflags2str(char *buf, unsigned flags, unsigned long iflags)
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
1.7.3.2.146.gca209

