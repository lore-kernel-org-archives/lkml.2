Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2KNGy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:54:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2KNGy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:54:27 -0500
Date: Tue, 13 Nov 2012 22:53:42 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-d898b241215daf6f2e654b32ebb8341bffc98cc5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-25-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-25-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add attr tests under builtin test command
Git-Commit-ID: d898b241215daf6f2e654b32ebb8341bffc98cc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:53:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d898b241215daf6f2e654b32ebb8341bffc98cc5
Gitweb:     http://git.kernel.org/tip/d898b241215daf6f2e654b32ebb8341bffc98cc5
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:02:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 1 Nov 2012 17:00:40 -0300

perf tests: Add attr tests under builtin test command

The test attr suite is run only if it's run under perf source directory,
or tests are found in installed path.

Otherwise tests are omitted (notification is displayed) and finished as
successful.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-25-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |    9 +++++++++
 tools/perf/perf.h               |    1 +
 tools/perf/tests/attr.c         |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/tests/builtin-test.c |    4 ++++
 4 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1da87a3..4ffcd02 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -898,6 +898,11 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 		'-DPREFIX="$(prefix_SQ)"' \
 		$<
 
+$(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+		'-DBINDIR="$(bindir_SQ)"' \
+		$<
+
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
@@ -1062,6 +1067,10 @@ install: all try-install-man
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
 	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
+	$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+	$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 0047264..054182e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -178,6 +178,7 @@ extern bool test_attr__enabled;
 void test_attr__init(void);
 void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 		     int fd, int group_fd, unsigned long flags);
+int  test_attr__run(void);
 
 static inline int
 sys_perf_event_open(struct perf_event_attr *attr,
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 55e9a87..aacad82 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -26,9 +26,12 @@
 #include <linux/kernel.h>
 #include "../perf.h"
 #include "util.h"
+#include "exec_cmd.h"
 
 #define ENV "PERF_TEST_ATTR"
 
+extern int verbose;
+
 bool test_attr__enabled;
 
 static char *dir;
@@ -138,3 +141,35 @@ void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
 
 	errno = errno_saved;
 }
+
+static int run_dir(const char *d, const char *perf)
+{
+	char cmd[3*PATH_MAX];
+
+	snprintf(cmd, 3*PATH_MAX, "python %s/attr.py -d %s/attr/ -p %s %s",
+		 d, d, perf, verbose ? "-v" : "");
+
+	return system(cmd);
+}
+
+int test_attr__run(void)
+{
+	struct stat st;
+	char path_perf[PATH_MAX];
+	char path_dir[PATH_MAX];
+
+	/* First try developement tree tests. */
+	if (!lstat("./tests", &st))
+		return run_dir("./tests", "./perf");
+
+	/* Then installed path. */
+	snprintf(path_dir,  PATH_MAX, "%s/tests", perf_exec_path());
+	snprintf(path_perf, PATH_MAX, "%s/perf", BINDIR);
+
+	if (!lstat(path_dir, &st) &&
+	    !lstat(path_perf, &st))
+		return run_dir(path_dir, path_perf);
+
+	fprintf(stderr, " (ommitted)");
+	return 0;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index f6c6424..1aa9e99 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -1455,6 +1455,10 @@ static struct test {
 		.func = test__syscall_open_tp_fields,
 	},
 	{
+		.desc = "struct perf_event_attr setup",
+		.func = test_attr__run,
+	},
+	{
 		.func = NULL,
 	},
 };
