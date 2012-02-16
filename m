Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2BPMBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 07:01:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2BPMBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 07:01:45 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv5 0/8] perf tool: parser generator for events parsing
Date: Thu, 16 Feb 2012 13:00:44 +0100
Message-Id: <1329393652-6055-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
here's new version of event parsing patchset.

I saw Arnaldo already sent patches 1-3 to Ingo, but they did not make it
to the tree yet, so I'm still attaching them here.

v5 changes:
 4/8 - patch updated by Peter with actual format definitions
       for x86 processors
 6/8 - added hardcoded terms for config[12] and sample_period
       the code is ready to include branch_sample_type once
       this field is available in perf_event_attr, just
       uncommenting one line.. ;) 
     - allow config option to be used without value in which
       case 1 is assigned as value

Overall summarize:
 - adding event parser bison/flex generator
 - the event syntax stays as it was
 - adding event format sysfs group attribute
   for pmu device
 - adding new syntax to specify raw events based
   on the sysfs pmu's format attribute
   eg. "cpu/config=1,config1=2,config2=3/u"

Attached patches:
 1/8 perf, tool: Remove unused functions from debugfs object
 2/8 perf, tool: Add sysfs mountpoint interface
 3/8 perf, tool: Add bitmap_or function into bitmap object
 4/8 perf: Adding sysfs group format attribute for pmu device
 5/8 perf, tool: Add parser generator for events parsing
 6/8 perf, tool: Add config options support for event parsing
 7/8 perf, tool: Add perf pmu object to access pmu format definition
 8/8 perf, tool: Add support to specify pmu style event

thanks,
jirka
---
 .../testing/sysfs-bus-event_source-devices-format  |   14 +
 arch/x86/kernel/cpu/perf_event.c                   |    7 +
 arch/x86/kernel/cpu/perf_event.h                   |    1 +
 arch/x86/kernel/cpu/perf_event_amd.c               |   19 +
 arch/x86/kernel/cpu/perf_event_intel.c             |   36 +
 arch/x86/kernel/cpu/perf_event_p6.c                |   19 +
 include/linux/perf_event.h                         |   14 +
 tools/perf/Makefile                                |   31 +
 tools/perf/builtin-test.c                          |   58 +-
 tools/perf/util/bitmap.c                           |   10 +
 tools/perf/util/debugfs.c                          |  141 --
 tools/perf/util/debugfs.h                          |    6 -
 tools/perf/util/include/linux/bitmap.h             |   11 +
 tools/perf/util/parse-events-bison.c               | 1852 ++++++++++++++++
 tools/perf/util/parse-events-bison.h               |   82 +
 tools/perf/util/parse-events-flex.c                | 2272 ++++++++++++++++++++
 tools/perf/util/parse-events-flex.h                |  316 +++
 tools/perf/util/parse-events.c                     |  590 +++---
 tools/perf/util/parse-events.h                     |   46 +
 tools/perf/util/parse-events.l                     |  126 ++
 tools/perf/util/parse-events.y                     |  217 ++
 tools/perf/util/pmu-bison.c                        | 1663 ++++++++++++++
 tools/perf/util/pmu-bison.h                        |   73 +
 tools/perf/util/pmu-flex.c                         | 1821 ++++++++++++++++
 tools/perf/util/pmu-flex.h                         |  316 +++
 tools/perf/util/pmu.c                              |  469 ++++
 tools/perf/util/pmu.h                              |   41 +
 tools/perf/util/pmu.l                              |   43 +
 tools/perf/util/pmu.y                              |   93 +
 tools/perf/util/sysfs.c                            |   60 +
 tools/perf/util/sysfs.h                            |    6 +
 31 files changed, 9974 insertions(+), 479 deletions(-)
