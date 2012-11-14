Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab2KNHc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:32:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2KNHc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:32:58 -0500
Date: Tue, 13 Nov 2012 23:32:10 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-d4fcf0a8b96b23a245a21065c9424e09c8080819@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1352390461-15404-1-git-send-email-jolsa@redhat.com>
References: <1352390461-15404-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Move attr.
 py temp dir cleanup into finally section
Git-Commit-ID: d4fcf0a8b96b23a245a21065c9424e09c8080819
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:32:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4fcf0a8b96b23a245a21065c9424e09c8080819
Gitweb:     http://git.kernel.org/tip/d4fcf0a8b96b23a245a21065c9424e09c8080819
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 8 Nov 2012 17:01:01 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Nov 2012 13:16:19 -0300

perf tests: Move attr.py temp dir cleanup into finally section

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
 1 files changed, 16 insertions(+), 14 deletions(-)

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
