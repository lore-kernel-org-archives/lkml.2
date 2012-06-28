Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab2F1JTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:19:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:64692 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab2F1JTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:19:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159147483"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v4 0/5] perf script: Add general event support to event handler of python script
Date: Thu, 28 Jun 2012 17:15:29 +0800
Message-Id: <1340874934-25661-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Current python script can only handle trace point type of events, this
patch serie try to follow Robert Richter's idea in commit 37a058ea0
	"perf script: Add generic perl handler to process events"
to similarly add a python handler for general events other than
trace points.

Also in v4, we added 2 RFC python scripts: EventClass.py as a libary and
event_analyzing_sample.py as a sample to show to handle the general
events.

Here is a sample output of using the 2 scripts:

feng@feng-i7:/dev/shm$perf record -a tree
feng@feng-i7:/dev/shm$perf script -s process_event.py

One note for the histgram is: the sample number may be very large,
so we print out '#' log2(num) times for each number.

---------------------------------
There is 100 records in gen_events table
Statistics about the general events grouped by thread/symbol/dso:

            comm   number         histgram
==========================================
         swapper       56     ######
            tree       20     #####
            perf       10     ####
            sshd        8     ####
     kworker/7:2        4     ###
     ksoftirqd/7        1     #
 plugin-containe        1     #

                          symbol   number         histgram
==========================================================
           native_write_msr_safe       40     ######
                  __lock_acquire        8     ####
             ftrace_graph_caller        4     ###
           prepare_ftrace_return        4     ###
                      intel_idle        3     ##
              native_sched_clock        3     ##
                  Unknown_symbol        2     ##
                      do_softirq        2     ##
                    lock_release        2     ##
           lock_release_holdtime        2     ##
               trace_graph_entry        2     ##
                        _IO_putc        1     #
                  __d_lookup_rcu        1     #
                      __do_fault        1     #
                      __schedule        1     #
                  _raw_spin_lock        1     #
                       delay_tsc        1     #
             generic_exec_single        1     #
                generic_fillattr        1     #

                                     dso   number         histgram
==================================================================
                       [kernel.kallsyms]       95     #######
                     /lib/libc-2.12.1.so        5     ###

Thanks,
Feng

Feng Tang (5):
  perf script: Add general python handler to process non-tracepoint
    events
  perf script: Replace "struct thread" with "struct addr_location" as a
    parameter for "process_event()"
  perf script/python: Pass event/thread/dso name and symbol info to
    event handler in python
  perf script: Add a python library EventClass.py
  perf script: Add event_analyzing_sample.py as a sample for general
    event handling

 tools/perf/builtin-script.c                        |    5 +-
 .../Perf-Trace-Util/lib/Perf/Trace/EventClass.py   |   95 ++++++++++
 .../perf/scripts/python/event_analyzing_sample.py  |  193 ++++++++++++++++++++
 .../perf/util/scripting-engines/trace-event-perl.c |   13 +-
 .../util/scripting-engines/trace-event-python.c    |   95 +++++++++-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    5 +-
 7 files changed, 391 insertions(+), 17 deletions(-)
 create mode 100755 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
 create mode 100644 tools/perf/scripts/python/event_analyzing_sample.py

