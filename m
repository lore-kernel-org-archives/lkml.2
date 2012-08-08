Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2HHKDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:03:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:64865 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab2HHKDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:03:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,732,1336374000"; 
   d="scan'208";a="177396281"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Robert Richter <robert.richter@amd.com>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH v5 0/5] perf script: Add general event support to event handler of python script
Date: Wed,  8 Aug 2012 17:57:50 +0800
Message-Id: <1344419875-21665-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo and all,

Current python script can only handle trace point type of events, this
patch serie try to follow Robert Richter's idea in commit 37a058ea0
	"perf script: Add generic perl handler to process events"
to similarly add a python handler for general events other than
tracepoints.

The first 3 patches have been reviewed and modified several times, 
and 1/2 have your signed-off, Could you consider to pick them up?
I've have rebased them on top of you perf/core branch with top
commit 9782243.

Also in v4, we added 2 RFC python scripts: EventClass.py as a libary and
process_event.py as a sample to show to handle the general events.

Here is a sample output of using the 2 scripts:

feng@feng-i7:/dev/shm$perf record -a tree
feng@feng-i7:/dev/shm$perf script -s process_event.py

---------------------------------
There is 67 records in gen_events table
Statistics about the general events grouped by thread/symbol/dso:

               comm   number         histgram
=============================================
            swapper       51     =====#
               perf       10     =
               tree        4     ####
        kworker/1:3        1     #
               sshd        1     #

                          symbol   number         histgram
==========================================================
           native_write_msr_safe       40     ====
                  __lock_acquire        5     #####
                      intel_idle        2     ##
              native_sched_clock        2     ##
                   __might_sleep        1     #
                     __slab_free        1     #
                   cpuidle_enter        1     #
             generic_exec_single        1     #
              generic_permission        1     #
             hpet_msi_next_event        1     #
                        irq_exit        1     #
                  ktime_get_real        1     #
                    load_balance        1     #
                          memset        1     #
                      n_tty_poll        1     #
           prepare_ftrace_return        1     #
                 sched_clock_cpu        1     #
smp_call_function_single_interrupt        1     #
                          strtok        1     #
                task_waking_fair        1     #
       tick_nohz_stop_sched_tick        1     #

                                             dso   number         histgram
==========================================================================
                               [kernel.kallsyms]       66     ======######
                             /lib/libc-2.12.1.so        1     #



Please help to revew, thanks.

- Feng

-----------------------------
Change logs:
	Since v4:
	* rebased with Arnaldo's git perf/core branch on top of
	  commmit 9782243

	Since v3:
	* Add 2 RFC scripts: EventClass.py and process_event.py
	* Rebased upon 3.5-rc4 d1346a6
	* Add a check for whether the dso info exist
	
	Since v2:
	* Correct some __unused usage
	* Add a new parameter: event name to event handler

	Since v1:
	* Use dictory as the paramter passwd from c to python
	* Use "process_event" name to comply with perl


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
 .../perf/util/scripting-engines/trace-event-perl.c |   11 +-
 .../util/scripting-engines/trace-event-python.c    |   85 +++++++++-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    5 +-
 7 files changed, 384 insertions(+), 12 deletions(-)
 create mode 100755 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
 create mode 100644 tools/perf/scripts/python/event_analyzing_sample.py

