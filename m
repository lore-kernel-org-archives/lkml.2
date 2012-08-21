Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab2HUPlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:41:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60047 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2HUPlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:41:07 -0400
Date: Tue, 21 Aug 2012 08:40:49 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-b25085be457b4292a563c0bf2fab2ef5b7bb3c45@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, tglx@linutronix.de,
        namhyung@gmail.com, jolsa@redhat.com
In-Reply-To: <1344522713-27951-4-git-send-email-fweisbec@gmail.com>
References: <1344522713-27951-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix /etc config related installation
Git-Commit-ID: b25085be457b4292a563c0bf2fab2ef5b7bb3c45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:40:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b25085be457b4292a563c0bf2fab2ef5b7bb3c45
Gitweb:     http://git.kernel.org/tip/b25085be457b4292a563c0bf2fab2ef5b7bb3c45
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Thu, 9 Aug 2012 16:31:53 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Aug 2012 15:59:40 -0300

perf tools: Fix /etc config related installation

Fix missing /etc/bash_completion.d directory creation, otherwise
the installation fails miserably on systems that don't have bash
completion installed yet or on specific target:

	   $ make DESTDIR=/tmp/junk-perf O=/tmp/pbuild -C tools/perf/ install
	   ...
	   install -m 755 bash_completion /tmp/junk-perf/etc/bash_completion.d/perf
	   install: cannot create regular file
	   `/tmp/junk-perf/etc/bash_completion.d/perf': No such file or directory
	   make: *** [install] Error 1
	   make: Leaving directory `/opt/sw/ahern/perf.git/tools/perf'

Also use sysconfdir variable instead of the hardcoded /etc to handle
overriden conf directory.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1344522713-27951-4-git-send-email-fweisbec@gmail.com
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 84b4227..a9458b9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -700,6 +700,7 @@ perfexecdir_SQ = $(subst ','\'',$(perfexecdir))
 template_dir_SQ = $(subst ','\'',$(template_dir))
 htmldir_SQ = $(subst ','\'',$(htmldir))
 prefix_SQ = $(subst ','\'',$(prefix))
+sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
 
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 
@@ -951,7 +952,8 @@ install: all
 	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
-	$(INSTALL) -m 755 bash_completion $(DESTDIR_SQ)/etc/bash_completion.d/perf
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
+	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
 
 install-python_ext:
 	$(PYTHON_WORD) util/setup.py --quiet install --root='/$(DESTDIR_SQ)'
