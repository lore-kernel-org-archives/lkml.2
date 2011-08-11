Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1HKTim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:38:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab1HKThr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:37:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=NeveLwwM+4saEj/Z7dYb19SmG6bOIBBlEWM6KxYDuJUWYp8Mi9kygV6n4ca9gNZjV
	lqxN6JKEBcinWmVTvLrlw==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 5/5] trace-cmd: Update man pages for 'check-events' option
Date: Thu, 11 Aug 2011 12:37:39 -0700
Message-Id: <1313091459-12049-5-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
References: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new option added to the 'report' target to check event
formats of the events recorded in a trace data file. This patch updates
the documentation in the man page.

This patch also adds a new man page for 'check-events' target which
verifies event formats on the local machine.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 Documentation/trace-cmd-check-events.1.txt |   45 ++++++++++++++++++++++++++++
 Documentation/trace-cmd-report.1.txt       |    5 +++
 Documentation/trace-cmd.1.txt              |    9 ++++--
 3 files changed, 56 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/trace-cmd-check-events.1.txt

diff --git a/Documentation/trace-cmd-check-events.1.txt b/Documentation/trace-cmd-check-events.1.txt
new file mode 100644
index 0000000..73ec1a8
--- /dev/null
+++ b/Documentation/trace-cmd-check-events.1.txt
@@ -0,0 +1,45 @@
+TRACE-CMD-CHECK_EVENTS(1)
+=========================
+
+NAME
+----
+trace-cmd-check-events - parse the event formats on local system
+
+SYNOPSIS
+--------
+*trace-cmd check-events* ['OPTIONS']
+
+DESCRIPTION
+-----------
+The trace-cmd(1) check-events parses format strings for all the events on the
+local system. It returns whether all the format strings can be parsed
+correctly. It will load plugins unless specified otherwise.
+
+This is useful to check for any trace event format strings which may contain
+some internal kernel function references which cannot be decoded outside of
+the kernel. This may mean that either the unparsed format strings of the trace
+events need to be changed or that a plugin needs to be created to parse them.
+
+OPTIONS
+-------
+*-N* - Don't load plugins
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-stop(1),
+trace-cmd-extract(1), trace-cmd-reset(1), trace-cmd-split(1),
+trace-cmd-list(1), trace-cmd-listen(1), trace-cmd-start(1)
+
+AUTHOR
+------
+Written by Vaibhav Nagarnaik, <vnagarnaik@google.com>
+
+RESOURCES
+---------
+git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+
+COPYING
+-------
+Copyright \(C) 2011 Google, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
diff --git a/Documentation/trace-cmd-report.1.txt b/Documentation/trace-cmd-report.1.txt
index 9c9a8e7..6b1cebe 100644
--- a/Documentation/trace-cmd-report.1.txt
+++ b/Documentation/trace-cmd-report.1.txt
@@ -41,6 +41,11 @@ OPTIONS
 *--events*::
     This will list the event formats that are stored in the trace.dat file.
 
+*--check-events*::
+    This will parse the event format strings that are stored in the trace.dat
+    file and return whether the formats can be parsed correctly. It will load
+    plugins unless *-N* is specified.
+
 *-F* 'filter'::
     Add a filter to limit what events are displayed. The format of the filter
     is:
diff --git a/Documentation/trace-cmd.1.txt b/Documentation/trace-cmd.1.txt
index f416b74..a34b39b 100644
--- a/Documentation/trace-cmd.1.txt
+++ b/Documentation/trace-cmd.1.txt
@@ -49,11 +49,14 @@ COMMANDS
 
   stack   - run and display the stack tracer
 
+  check-events - parse format strings for all trace events and return
+                 whether all formats are parseable
+
 OPTIONS
 -------
 
-*-h, --help::
-    Displace the help text.
+*-h*, --help::
+    Display the help text.
 
 Other options see the man page for the corresponding command.
 
@@ -63,7 +66,7 @@ trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
 trace-cmd-stop(1), trace-cmd-extract(1), trace-cmd-reset(1),
 trace-cmd-restore(1), trace-cmd-stack(1),
 trace-cmd-split(1), trace-cmd-list(1), trace-cmd-listen(1),
-trace-cmd.dat(5)
+trace-cmd.dat(5), trace-cmd-check-events(1)
 
 AUTHOR
 ------
-- 
1.7.3.1

