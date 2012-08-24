Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab2HXJEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:04:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653Ab2HXJBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [RFC 00/13] perf test: Add perf_event_attr tests
Date: Fri, 24 Aug 2012 11:00:31 +0200
Message-Id: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this code tests the link between perf stat/record command line
options and final perf_event_attr struct values. Also it tests
the group fd linkage.

It's probably missing many command line option combinations
worth testing. I wanted to check with others for more ideas
before diving into this.

You can check this also here:

git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/attr_tests4

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile                                 |   1 +
 tools/perf/builtin-test.c                           |   4 +
 tools/perf/perf.c                                   |   2 +
 tools/perf/perf.h                                   |  11 ++
 tools/perf/util/test-attr.c                         | 142 ++++++++++++++++++++++++++
 tools/perf/util/test-attr.py                        | 272 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/test-attr/base-record               |  39 ++++++++
 tools/perf/util/test-attr/base-stat                 |  39 ++++++++
 tools/perf/util/test-attr/test-record-basic         |   5 +
 tools/perf/util/test-attr/test-record-count         |   8 ++
 tools/perf/util/test-attr/test-record-freq          |   6 ++
 tools/perf/util/test-attr/test-record-graph-default |   6 ++
 tools/perf/util/test-attr/test-record-graph-dwarf   |   6 ++
 tools/perf/util/test-attr/test-record-graph-fp      |   6 ++
 tools/perf/util/test-attr/test-record-group         |  17 ++++
 tools/perf/util/test-attr/test-record-no-inherit    |   7 ++
 tools/perf/util/test-attr/test-record-no-samples    |   6 ++
 tools/perf/util/test-attr/test-record-period        |   7 ++
 tools/perf/util/test-attr/test-stat-basic           |   6 ++
 tools/perf/util/test-attr/test-stat-group           |  15 +++
 tools/perf/util/test-attr/test-stat-no-inherit      |   7 ++
 21 files changed, 612 insertions(+)
