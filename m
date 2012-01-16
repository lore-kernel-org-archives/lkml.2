Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2APMcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:32:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab2APMcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:32:19 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFCv3 0/9] perf tool: parser generator for events parsing
Date: Mon, 16 Jan 2012 13:31:34 +0100
Message-Id: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <20120109152855.GA1597@m.brq.redhat.com>--suppress-cc=author>
References: <20120109152855.GA1597@m.brq.redhat.com>--suppress-cc=author>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I'd never imagine how much code I need to introduce before
I could push through the event grouping patch.. ;)

Here's new version of event parsing patchset. To summarize:
 - adding event parser bison/flex generator
 - the event syntax stays as it was
 - adding event format file sysfs attribute
   for pmu device
 - adding new syntax to specify raw events based
   on the sysfs pmu's format attribute
   eg. "cpu/config=1,config1=2,config2=3/u"

There are helping patches 1-4, which I did not want to
mangle with the actual change. Patches 5-9 implement
the feature itself.

I consider this patchset as RFC. Everything seems to work,
but I did not want to spend much time over it before any
fundamental design comments.. ;)

Attached patches:
 1/9 perf, tool: Make perf_evlist__splice_list_tail global
 2/9 perf, tool: Remove unused functions from debugfs object
 3/9 perf, tool: Add sysfs mountpoint interface
 4/9 perf, tool: Add bitmap_or function into bitmap object
 5/9 perf: Add sysfs format attribute for pmu device
 6/9 perf, tool: Add parser generator for events parsing
 7/9 perf, tool: Add config options support for event parsing
 8/9 perf, tool: Add perf pmu object to access pmu format
 9/9 perf, tool: Add support to specify pmu style event

thanks for comments,
jirka
---
 include/linux/perf_event.h             |    6 +
 kernel/events/core.c                   |   23 +
 tools/perf/Makefile                    |   32 +
 tools/perf/builtin-test.c              |   46 +
 tools/perf/util/bitmap.c               |   10 +
 tools/perf/util/debugfs.c              |  141 --
 tools/perf/util/debugfs.h              |    6 -
 tools/perf/util/evlist.c               |    6 +-
 tools/perf/util/evlist.h               |    5 +
 tools/perf/util/include/linux/bitmap.h |   11 +
 tools/perf/util/parse-events-bison.c   | 1813 ++++++++++++++++++++++++++
 tools/perf/util/parse-events-bison.h   |   81 ++
 tools/perf/util/parse-events-flex.c    | 2232 ++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events-flex.h    |  316 +++++
 tools/perf/util/parse-events.c         |  552 ++++-----
 tools/perf/util/parse-events.h         |   37 +
 tools/perf/util/parse-events.l         |  107 ++
 tools/perf/util/parse-events.y         |  191 +++
 tools/perf/util/pmu-bison.c            | 1623 +++++++++++++++++++++++
 tools/perf/util/pmu-bison.h            |   72 +
 tools/perf/util/pmu-flex.c             | 1821 ++++++++++++++++++++++++++
 tools/perf/util/pmu-flex.h             |  316 +++++
 tools/perf/util/pmu.c                  |  409 ++++++
 tools/perf/util/pmu.h                  |   42 +
 tools/perf/util/pmu.l                  |   50 +
 tools/perf/util/pmu.y                  |   76 ++
 tools/perf/util/sysfs.c                |   60 +
 tools/perf/util/sysfs.h                |    6 +
 28 files changed, 9613 insertions(+), 477 deletions(-)
