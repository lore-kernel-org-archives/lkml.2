Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669Ab2JaUJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:09:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:37294 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725Ab2JaUJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:09:39 -0400
Date: Wed, 31 Oct 2012 13:09:27 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] proc: add "Seccomp" to status
Message-ID: <20121031200926.GA22988@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the seccomp mode to the /proc/$pid/status file so the state of
seccomp can be externally examined.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/proc/array.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c1c207c..135d6ac 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -327,6 +327,13 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 	render_cap_t(m, "CapBnd:\t", &cap_bset);
 }
 
+static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
+{
+#ifdef CONFIG_SECCOMP
+	seq_printf(m, "Seccomp:\t%d\n", p->seccomp.mode);
+#endif
+}
+
 static inline void task_context_switch_counts(struct seq_file *m,
 						struct task_struct *p)
 {
@@ -360,6 +367,7 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 	}
 	task_sig(m, task);
 	task_cap(m, task);
+	task_seccomp(m, task);
 	task_cpus_allowed(m, task);
 	cpuset_task_status_allowed(m, task);
 	task_context_switch_counts(m, task);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
