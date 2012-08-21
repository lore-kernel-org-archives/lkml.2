Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2HUPhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:37:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2HUPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:37:30 -0400
Date: Tue, 21 Aug 2012 08:37:06 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-87b6a3ad40ba304ec468b972e979e7e410852476@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        peterz@infradead.org, namhyung@kernel.org, robert.richter@amd.com,
        dsahern@gmail.com, tglx@linutronix.de, feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        peterz@infradead.org, namhyung@kernel.org, robert.richter@amd.com,
        dsahern@gmail.com, tglx@linutronix.de, feng.tang@intel.com
In-Reply-To: <20120809134613.067104c4@feng-i7>
References: <20120809134613.067104c4@feng-i7>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script python:
  Correct handler check and spelling errors
Git-Commit-ID: 87b6a3ad40ba304ec468b972e979e7e410852476
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:37:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87b6a3ad40ba304ec468b972e979e7e410852476
Gitweb:     http://git.kernel.org/tip/87b6a3ad40ba304ec468b972e979e7e410852476
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Thu, 9 Aug 2012 13:46:13 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 9 Aug 2012 13:26:19 -0300

perf script python: Correct handler check and spelling errors

Correct the checking for handler returned by PyDict_GetItemString(),
also fix some spelling error and remove some data code in
event_analyzing_sample.py, as suggested by Namhyung Kim.

v2: restore back the wrongly removed trace_unhandled() func

Signed-off-by: Feng Tang <feng.tang@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20120809134613.067104c4@feng-i7
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../Perf-Trace-Util/lib/Perf/Trace/EventClass.py   |    4 +-
 .../perf/scripts/python/event_analyzing_sample.py  |   30 ++++++++-----------
 .../util/scripting-engines/trace-event-python.c    |    8 ++---
 3 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
index 6372431..9e098579 100755
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
@@ -1,12 +1,12 @@
 # EventClass.py
 #
-# This is a libray defining some events typs classes, which could
+# This is a library defining some events types classes, which could
 # be used by other scripts to analyzing the perf samples.
 #
 # Currently there are just a few classes defined for examples,
 # PerfEvent is the base class for all perf event sample, PebsEvent
 # is a HW base Intel x86 PEBS event, and user could add more SW/HW
-# event classes based on requriements.
+# event classes based on requirements.
 
 import struct
 
diff --git a/tools/perf/scripts/python/event_analyzing_sample.py b/tools/perf/scripts/python/event_analyzing_sample.py
index 46f05aa..163c39f 100644
--- a/tools/perf/scripts/python/event_analyzing_sample.py
+++ b/tools/perf/scripts/python/event_analyzing_sample.py
@@ -1,15 +1,15 @@
-# process_event.py: general event handler in python
+# event_analyzing_sample.py: general event handler in python
 #
-# Current perf report is alreay very powerful with the anotation integrated,
+# Current perf report is already very powerful with the annotation integrated,
 # and this script is not trying to be as powerful as perf report, but
 # providing end user/developer a flexible way to analyze the events other
 # than trace points.
 #
 # The 2 database related functions in this script just show how to gather
 # the basic information, and users can modify and write their own functions
-# according to their specific requirment.
+# according to their specific requirement.
 #
-# The first sample "show_general_events" just does a baisc grouping for all
+# The first function "show_general_events" just does a basic grouping for all
 # generic events with the help of sqlite, and the 2nd one "show_pebs_ll" is
 # for a x86 HW PMU event: PEBS with load latency data.
 #
@@ -85,7 +85,7 @@ def process_event(param_dict):
         else:
                 symbol = "Unknown_symbol"
 
-        # Creat the event object and insert it to the right table in database
+        # Create the event object and insert it to the right table in database
         event = create_event(name, comm, dso, symbol, raw_buf)
         insert_db(event)
 
@@ -109,7 +109,7 @@ def trace_end():
 
 #
 # As the event number may be very big, so we can't use linear way
-# to show the histgram in real number, but use a log2 algorithm.
+# to show the histogram in real number, but use a log2 algorithm.
 #
 
 def num2sym(num):
@@ -130,18 +130,18 @@ def show_general_events():
 
          # Group by thread
         commq = con.execute("select comm, count(comm) from gen_events group by comm order by -count(comm)")
-        print "\n%16s %8s %16s\n%s" % ("comm", "number", "histgram", "="*42)
+        print "\n%16s %8s %16s\n%s" % ("comm", "number", "histogram", "="*42)
         for row in commq:
              print "%16s %8d     %s" % (row[0], row[1], num2sym(row[1]))
 
         # Group by symbol
-        print "\n%32s %8s %16s\n%s" % ("symbol", "number", "histgram", "="*58)
+        print "\n%32s %8s %16s\n%s" % ("symbol", "number", "histogram", "="*58)
         symbolq = con.execute("select symbol, count(symbol) from gen_events group by symbol order by -count(symbol)")
         for row in symbolq:
              print "%32s %8d     %s" % (row[0], row[1], num2sym(row[1]))
 
         # Group by dso
-        print "\n%40s %8s %16s\n%s" % ("dso", "number", "histgram", "="*74)
+        print "\n%40s %8s %16s\n%s" % ("dso", "number", "histogram", "="*74)
         dsoq = con.execute("select dso, count(dso) from gen_events group by dso order by -count(dso)")
         for row in dsoq:
              print "%40s %8d     %s" % (row[0], row[1], num2sym(row[1]))
@@ -163,31 +163,27 @@ def show_pebs_ll():
 
         # Group by thread
         commq = con.execute("select comm, count(comm) from pebs_ll group by comm order by -count(comm)")
-        print "\n%16s %8s %16s\n%s" % ("comm", "number", "histgram", "="*42)
+        print "\n%16s %8s %16s\n%s" % ("comm", "number", "histogram", "="*42)
         for row in commq:
              print "%16s %8d     %s" % (row[0], row[1], num2sym(row[1]))
 
         # Group by symbol
-        print "\n%32s %8s %16s\n%s" % ("symbol", "number", "histgram", "="*58)
+        print "\n%32s %8s %16s\n%s" % ("symbol", "number", "histogram", "="*58)
         symbolq = con.execute("select symbol, count(symbol) from pebs_ll group by symbol order by -count(symbol)")
         for row in symbolq:
              print "%32s %8d     %s" % (row[0], row[1], num2sym(row[1]))
 
         # Group by dse
         dseq = con.execute("select dse, count(dse) from pebs_ll group by dse order by -count(dse)")
-        print "\n%32s %8s %16s\n%s" % ("dse", "number", "histgram", "="*58)
+        print "\n%32s %8s %16s\n%s" % ("dse", "number", "histogram", "="*58)
         for row in dseq:
              print "%32s %8d     %s" % (row[0], row[1], num2sym(row[1]))
 
         # Group by latency
         latq = con.execute("select lat, count(lat) from pebs_ll group by lat order by lat")
-        print "\n%32s %8s %16s\n%s" % ("latency", "number", "histgram", "="*58)
+        print "\n%32s %8s %16s\n%s" % ("latency", "number", "histogram", "="*58)
         for row in latq:
              print "%32s %8d     %s" % (row[0], row[1], num2sym(row[1]))
 
 def trace_unhandled(event_name, context, event_fields_dict):
 		print ' '.join(['%s=%s'%(k,str(v))for k,v in sorted(event_fields_dict.items())])
-
-def print_header(event_name, cpu, secs, nsecs, pid, comm):
-	print "%-20s %5u %05u.%09u %8u %-20s " % \
-	(event_name, cpu, secs, nsecs, pid, comm),
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 7e3f576..afba097 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -343,7 +343,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 					 struct perf_sample *sample,
 					 struct perf_evsel *evsel,
 					 struct machine *machine __unused,
-					 struct addr_location *al __unused)
+					 struct addr_location *al)
 {
 	PyObject *handler, *retval, *t, *dict;
 	static char handler_name[64];
@@ -352,7 +352,7 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 
 	/*
 	 * Use the MAX_FIELDS to make the function expandable, though
-	 * currently there is only one itme for the tuple.
+	 * currently there is only one item for the tuple.
 	 */
 	t = PyTuple_New(MAX_FIELDS);
 	if (!t)
@@ -365,10 +365,8 @@ static void python_process_general_event(union perf_event *perf_event __unused,
 	snprintf(handler_name, sizeof(handler_name), "%s", "process_event");
 
 	handler = PyDict_GetItemString(main_dict, handler_name);
-	if (handler && !PyCallable_Check(handler)) {
-		handler = NULL;
+	if (!handler || !PyCallable_Check(handler))
 		goto exit;
-	}
 
 	PyDict_SetItemString(dict, "ev_name", PyString_FromString(perf_evsel__name(evsel)));
 	PyDict_SetItemString(dict, "attr", PyString_FromStringAndSize(
