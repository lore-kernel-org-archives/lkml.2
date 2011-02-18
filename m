Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1BRKhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:37:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:53264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1BRKh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:37:26 -0500
Date: Fri, 18 Feb 2011 10:36:50 GMT
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
Subject: [tip:perf/core] perf python: Add cgroup.c to setup.py to get it building again
Message-ID: <tip-4498062e72fd55b2a9a4ac1b44fab8cb44ad5367@git.kernel.org>
Git-Commit-ID: 4498062e72fd55b2a9a4ac1b44fab8cb44ad5367
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 10:36:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4498062e72fd55b2a9a4ac1b44fab8cb44ad5367
Gitweb:     http://git.kernel.org/tip/4498062e72fd55b2a9a4ac1b44fab8cb44ad5367
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Feb 2011 10:07:42 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Feb 2011 10:07:42 -0200

perf python: Add cgroup.c to setup.py to get it building again

The 023695d cset added a new file, util/cgroup.c, that is referenced from
util/evsel.c, so it needs to be present in util/setup.py so that the python
shared object binding works, fixing this:

[root@emilia linux]# export PYTHONPATH=~acme/git/build/perf/python/
[root@emilia linux]# ./tools/perf/python/twatch.py
Traceback (most recent call last):
  File "./tools/perf/python/twatch.py", line 16, in <module>
    import perf
ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol: close_cgroup

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
 tools/perf/util/setup.py |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 1947b04..e24ffad 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -5,7 +5,7 @@ from distutils.core import setup, Extension
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
 			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
-			     'util/util.c', 'util/xyarray.c'],
+			     'util/util.c', 'util/xyarray.c', 'util/cgroup.c'],
 		  include_dirs = ['util/include'],
 		  extra_compile_args = ['-fno-strict-aliasing', '-Wno-write-strings'])
 
