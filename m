Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab1BQUlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:41:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:46919 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1BQUlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:41:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/5] perf python: Add cgroup.c to setup.py to get it building again
Date: Thu, 17 Feb 2011 18:41:27 -0200
Message-Id: <1297975291-12792-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297975291-12792-1-git-send-email-acme@infradead.org>
References: <1297975291-12792-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 
-- 
1.6.2.5

