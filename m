Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab1LOPbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:31:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1LOPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:31:04 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/3] perf tool: Add new event group management
Date: Thu, 15 Dec 2011 16:30:36 +0100
Message-Id: <1323963039-7602-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support for creating event groups based on the way they
are specified on the command line.

As reading through some lkml postings like:
http://marc.info/?t=130105133700002&r=1&w=2
http://marc.info/?t=129065042800002&r=1&w=2

it seems decided to use bison/flex for event parsing first,
and do the group management on the top of it.. and thats what
I'm trying to do in this patchset.

Since this is quite hot code I expect some discussion/reposts ;),
so sending it first as RFC..

attached patches:
  1/3 perf, tool: Add parser generator for events parsing
  2/3 perf, tool: Add new event group management
  3/3 perf, tool: Add more automated tests for event parsing

thanks for comments,
jirka
---
 tools/perf/Makefile                  |   23 ++
 tools/perf/builtin-record.c          |    8 +-
 tools/perf/builtin-stat.c            |   10 +-
 tools/perf/builtin-test.c            |  245 ++++++++++++++++++-
 tools/perf/builtin-top.c             |    8 +-
 tools/perf/perf.h                    |    2 +-
 tools/perf/util/evsel.c              |   28 ++-
 tools/perf/util/evsel.h              |    9 +-
 tools/perf/util/group.c              |   23 ++
 tools/perf/util/group.h              |   25 ++
 tools/perf/util/parse-events-bison.y |  119 +++++++++
 tools/perf/util/parse-events-flex.l  |  111 ++++++++
 tools/perf/util/parse-events.c       |  465 ++++++++++++----------------------
 tools/perf/util/parse-events.h       |    9 +
 tools/perf/util/python.c             |    4 +
 tools/perf/util/top.h                |    2 +-
 16 files changed, 760 insertions(+), 331 deletions(-)
