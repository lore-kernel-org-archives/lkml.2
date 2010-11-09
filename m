Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab0KIVSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:18:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40558 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab0KIVSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:18:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=co3j9s/kZUQVkmapaQC7TK8Lm3Fe38BX9dBU1Db9yIiyfGPMX5Uhz9WI6EZtOnuuYZ
         4QyRx6qPNwA4toWYB+ploInMRl+qzqOh/sekDtibUD4+i2zMKA0KStUr0cxcAMGJO+CN
         Tnlsa8Imzfsiy9FivjHl3mrRNMokOlHa3WzGE=
From: tzanussi@gmail.com
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, fweisbec@gmail.com
Subject: [PATCH 6/7] perf trace: update Documentation with new perf trace variants
Date: Tue,  9 Nov 2010 15:18:21 -0600
Message-Id: <1289337502-2492-7-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
References: <1289337502-2492-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

Add documentation describing new 'perf trace' command changes
e.g. <command> handling and live-mode/top variants.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 tools/perf/Documentation/perf-trace.txt |   57 ++++++++++++++++++++++++++----
 1 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 122ec9d..26aff6b 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -8,7 +8,11 @@ perf-trace - Read perf.data (created by perf record) and display trace output
 SYNOPSIS
 --------
 [verse]
-'perf trace' {record <script> | report <script> [args] }
+'perf trace' [<options>]
+'perf trace' [<options>] record <script> [<record-options>] <command>
+'perf trace' [<options>] report <script> [script-args]
+'perf trace' [<options>] <script> <required-script-args> [<record-options>] <command>
+'perf trace' [<options>] <top-script> [script-args]
 
 DESCRIPTION
 -----------
@@ -24,23 +28,53 @@ There are several variants of perf trace:
   available via 'perf trace -l').  The following variants allow you to
   record and run those scripts:
 
-  'perf trace record <script>' to record the events required for 'perf
-  trace report'.  <script> is the name displayed in the output of
-  'perf trace --list' i.e. the actual script name minus any language
-  extension.
+  'perf trace record <script> <command>' to record the events required
+  for 'perf trace report'.  <script> is the name displayed in the
+  output of 'perf trace --list' i.e. the actual script name minus any
+  language extension.  If <command> is not specified, the events are
+  recorded using the -a (system-wide) 'perf record' option.
 
-  'perf trace report <script>' to run and display the results of
-  <script>.  <script> is the name displayed in the output of 'perf
+  'perf trace report <script> [args]' to run and display the results
+  of <script>.  <script> is the name displayed in the output of 'perf
   trace --list' i.e. the actual script name minus any language
   extension.  The perf.data output from a previous run of 'perf trace
   record <script>' is used and should be present for this command to
-  succeed.
+  succeed.  [args] refers to the (mainly optional) args expected by
+  the script.
+
+  'perf trace <script> <required-script-args> <command>' to both
+  record the events required for <script> and to run the <script>
+  using 'live-mode' i.e. without writing anything to disk.  <script>
+  is the name displayed in the output of 'perf trace --list' i.e. the
+  actual script name minus any language extension.  If <command> is
+  not specified, the events are recorded using the -a (system-wide)
+  'perf record' option.  If <script> has any required args, they
+  should be specified before <command>.  This mode doesn't allow for
+  optional script args to be specified; if optional script args are
+  desired, they can be specified using separate 'perf trace record'
+  and 'perf trace report' commands, with the stdout of the record step
+  piped to the stdin of the report script, using the '-o -' and '-i -'
+  options of the corresponding commands.
+
+  'perf trace <top-script>' to both record the events required for
+  <top-script> and to run the <top-script> using 'live-mode'
+  i.e. without writing anything to disk.  <top-script> is the name
+  displayed in the output of 'perf trace --list' i.e. the actual
+  script name minus any language extension; a <top-script> is defined
+  as any script name ending with the string 'top'.
+
+  [<record-options>] can be passed to the record steps of 'perf trace
+  record' and 'live-mode' variants; this isn't possible however for
+  <top-script> 'live-mode' or 'perf trace report' variants.
 
   See the 'SEE ALSO' section for links to language-specific
   information on how to write and run your own trace scripts.
 
 OPTIONS
 -------
+<command>...::
+	Any command you can specify in a shell.
+
 -D::
 --dump-raw-trace=::
         Display verbose dump of the trace data.
@@ -64,7 +98,13 @@ OPTIONS
         Generate perf-trace.[ext] starter script for given language,
         using current perf.data.
 
+-a::
+        Force system-wide collection.  Scripts run without a <command>
+        normally use -a by default, while scripts run with a <command>
+        normally don't - this option allows the latter to be run in
+        system-wide mode.
+
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-trace-perl[1],
-- 
Tom Zanussi, Intel Open Source Technology Center

