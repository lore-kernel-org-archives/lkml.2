Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2KIVre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:47:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:38567 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/21] perf tests: Move attr.py temp dir cleanup into finally section
Date: Fri,  9 Nov 2012 18:42:53 -0300
Message-Id: <1352497390-17716-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently if there's 'Unsup' exception raised, we do not clean up the
temp directory. Solving this by adding 'finally' to make the cleanup in
any case.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352390461-15404-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.py |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index 9b25b33c..e702b82 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -228,24 +228,26 @@ class Test(object):
     def run(self):
         tempdir = tempfile.mkdtemp();
 
-        # run the test script
-        self.run_cmd(tempdir);
+        try:
+            # run the test script
+            self.run_cmd(tempdir);
 
-        # load events expectation for the test
-        log.info("  loading result events");
-        for f in glob.glob(tempdir + '/event*'):
-            self.load_events(f, self.result);
+            # load events expectation for the test
+            log.info("  loading result events");
+            for f in glob.glob(tempdir + '/event*'):
+                self.load_events(f, self.result);
 
-        # resolve group_fd to event names
-        self.resolve_groups(self.expect);
-        self.resolve_groups(self.result);
+            # resolve group_fd to event names
+            self.resolve_groups(self.expect);
+            self.resolve_groups(self.result);
 
-        # do the expectation - results matching - both ways
-        self.compare(self.expect, self.result)
-        self.compare(self.result, self.expect)
+            # do the expectation - results matching - both ways
+            self.compare(self.expect, self.result)
+            self.compare(self.result, self.expect)
 
-        # cleanup
-        shutil.rmtree(tempdir)
+        finally:
+            # cleanup
+            shutil.rmtree(tempdir)
 
 
 def run_tests(options):
-- 
1.7.9.2.358.g22243

