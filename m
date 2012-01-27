Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2A0OhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:37:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab2A0Oew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:34:52 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv4 0/9] perf tool: parser generator for events parsing
Date: Fri, 27 Jan 2012 15:34:19 +0100
Message-Id: <1327674868-10486-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Here's new version of event parsing patchset. To summarize:
 - adding event parser bison/flex generator
 - the event syntax stays as it was
 - adding event format sysfs group attribute
   for pmu device
 - adding new syntax to specify raw events based
   on the sysfs pmu's format attribute
   eg. "cpu/config=1,config1=2,config2=3/u"

There are helping patches 1-4, which I did not want to
mangle with the actual change. Patches 5-9 implement
the feature itself.

v4 changes:
 - 5/9 changed sysfs pmu format definitions to the group attribute,
       each line (in previous patch) is now represented by single
       sysfs attribute under format group
 - 6/9 fix raw events so the number is always considered to be hex number
 - 8/9 move config[12] definitions to be processed by the parser

Attached patches:
 1/9 perf, tool: Make perf_evlist__splice_list_tail global
 2/9 perf, tool: Remove unused functions from debugfs object
 3/9 perf, tool: Add sysfs mountpoint interface
 4/9 perf, tool: Add bitmap_or function into bitmap object
 5/9 perf: Adding sysfs group format attribute for pmu device
 6/9 perf, tool: Add parser generator for events parsing
 7/9 perf, tool: Add config options support for event parsing
 8/9 perf, tool: Add perf pmu object to access pmu format definition
 9/9 perf, tool: Add support to specify pmu style event


thanks,
jirka
---
 .../testing/sysfs-bus-event_source-devices-format  |   14 +
 include/linux/perf_event.h                         |   22 +
 kernel/events/core.c                               |   22 +
 tools/perf/Makefile                                |   31 +
 tools/perf/builtin-test.c                          |   52 +-
 tools/perf/util/bitmap.c                           |   10 +
 tools/perf/util/debugfs.c                          |  141 --
 tools/perf/util/debugfs.h                          |    6 -
 tools/perf/util/evlist.c                           |    6 +-
 tools/perf/util/evlist.h                           |    5 +
 tools/perf/util/include/linux/bitmap.h             |   11 +
 tools/perf/util/parse-events-bison.c               | 1813 ++++++++++++++++
 tools/perf/util/parse-events-bison.h               |   81 +
 tools/perf/util/parse-events-flex.c                | 2225 ++++++++++++++++++++
 tools/perf/util/parse-events-flex.h                |  316 +++
 tools/perf/util/parse-events.c                     |  552 ++---
 tools/perf/util/parse-events.h                     |   37 +
 tools/perf/util/parse-events.l                     |  107 +
 tools/perf/util/parse-events.y                     |  191 ++
 tools/perf/util/pmu-bison.c                        | 1663 +++++++++++++++
 tools/perf/util/pmu-bison.h                        |   73 +
 tools/perf/util/pmu-flex.c                         | 1821 ++++++++++++++++
 tools/perf/util/pmu-flex.h                         |  316 +++
 tools/perf/util/pmu.c                              |  462 ++++
 tools/perf/util/pmu.h                              |   41 +
 tools/perf/util/pmu.l                              |   43 +
 tools/perf/util/pmu.y                              |   93 +
 tools/perf/util/sysfs.c                            |   60 +
 tools/perf/util/sysfs.h                            |    6 +
 29 files changed, 9740 insertions(+), 480 deletions(-)
