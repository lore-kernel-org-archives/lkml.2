Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1BBHIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 02:08:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:49331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab1BBHHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 02:07:49 -0500
Date: Wed, 2 Feb 2011 07:06:54 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove verbose build messages for the python binding
Message-ID: <tip-067187fc9f1d09738fc833392e117f125cb6bbad@git.kernel.org>
Git-Commit-ID: 067187fc9f1d09738fc833392e117f125cb6bbad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 07:06:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  067187fc9f1d09738fc833392e117f125cb6bbad
Gitweb:     http://git.kernel.org/tip/067187fc9f1d09738fc833392e117f125cb6bbad
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Feb 2011 14:57:02 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 1 Feb 2011 14:57:02 -0200

perf tools: Remove verbose build messages for the python binding

Also now it builds it in a well known location:

[acme@felicio linux]$ rm -rf ../build/perf/
[acme@felicio linux]$ mkdir ../build/perf
[acme@felicio linux]$ make -j2 O=~acme/git/build/perf -C tools/perf/
<SNIP>
[acme@felicio linux]$ ls -la ../build/perf/python/
total 152
-rwxrwxr-x 1 acme acme 147957 Feb  1 14:56 perf.so
drwxrwxr-x 3 acme acme     17 Feb  1 14:56 temp
[acme@felicio linux]$

[root@felicio ~]# strip ~acme/git/build/perf/python/perf.so
[root@felicio ~]# ls -la ~acme/git/build/perf/python/perf.so
-rwxrwxr-x 1 acme acme 46264 Feb  1 14:58 /home/acme/git/build/perf/python/perf.so

[root@felicio ~]# export PYTHONPATH=~acme/git/build/perf/python/
[root@felicio ~]# ~acme/git/linux/tools/perf/python/twatch.py
cpu:  0, pid: 7751, tid: 7751 { type: exit, pid: 7751, ppid: 7751, tid: 7751, ptid: 7751, time: 54562393512356}
cpu:  0, pid: 13700, tid: 13700 { type: fork, pid: 7756, ppid: 13700, tid: 7756, ptid: 13700, time: 54562393746739}
cpu:  1, pid: 7756, tid: 7756 { type: fork, pid: 7757, ppid: 7756, tid: 7757, ptid: 7756, time: 54562394246152}
cpu:  1, pid: 7757, tid: 7757 { type: comm, pid: 7757, tid: 7757, comm: awk }
cpu:  1, pid: 7757, tid: 7757 { type: exit, pid: 7757, ppid: 7757, tid: 7757, ptid: 7757, time: 54562395456813}

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 67a9f4d..d1984ee 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -325,9 +325,9 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-pyrf: $(PYRF_OBJS)
-	python util/setup.py build --build-base='$(OUTPUT)'
-
+$(OUTPUT)python/perf.so: $(PYRF_OBJS)
+	@python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
+						--build-temp='$(OUTPUT)python/temp'
 #
 # No Perl scripts right now:
 #
@@ -348,12 +348,14 @@ PROGRAMS += $(EXTRA_PROGRAMS)
 #
 PROGRAMS += $(OUTPUT)perf
 
+LANG_BINDINGS = $(OUTPUT)python/perf.so
+
 # List built-in command $C whose implementation cmd_$C() is not in
 # builtin-$C.o but is linked in as part of some other command.
 #
 
 # what 'all' will build and 'install' will install, in perfexecdir
-ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS) pyrf
+ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS) $(LANG_BINDINGS)
 
 # what 'all' will build but not install in perfexecdir
 OTHER_PROGRAMS = $(OUTPUT)perf$X
@@ -1298,6 +1300,8 @@ clean:
 	$(RM) $(htmldocs).tar.gz $(manpages).tar.gz
 	$(MAKE) -C Documentation/ clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-BUILD-OPTIONS
+	@python util/setup.py clean --build-lib='$(OUTPUT)python' \
+				   --build-temp='$(OUTPUT)python/temp'
 
 .PHONY: all install clean strip
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
