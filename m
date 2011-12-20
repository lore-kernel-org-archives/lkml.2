Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1LTK3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:29:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1LTK3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:29:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/2] perf tool: parser generator for events parsing
Date: Tue, 20 Dec 2011 11:29:13 +0100
Message-Id: <1324376955-3187-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1324044159.18942.104.camel@twins>
References: <1324044159.18942.104.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding an event parser generator to handle the '-e' option data.
I strip this version of the event grouping enhancement, so it's
more straightforward. I'll send those patches later.

Attached patches:
  - 1/2 perf, tool: Add parser generator for events parsing
  - 2/2 perf, tool: Add more automated tests for event parsing

v2 changes:
  1/2 perf, tool: Add parser generator for events parsing
   - added a way to specify config[12] for raw events
   - added direct symbol -> raw mapping in parser itself
   - fixed modifier syntax to allow all correct precise
     values
   - added generated parser as part of the patch, however..
     flex and bison dont care about the linux kernel
     coding standard, checkpatch.pl complains quite a lot:

       total: 728 errors, 1316 warnings, 5379 lines checked

     after I tried cleanpatch scripts I've got:

       total: 664 errors, 1287 warnings, 5382 lines checked

     so I'm not sure it's worth to do that (the cleanup),
     considering it needs to be regenerated each time we change
     the parser grammar.
   - added 'event-parser' Makefile target to generate
     the parser out of the flex/bison sources

thanks,
jirka
---
 tools/perf/Makefile                  |   18 +
 tools/perf/builtin-test.c            |  276 +++++-
 tools/perf/util/parse-events-bison.c | 1743 ++++++++++++++++++++++++++
 tools/perf/util/parse-events-bison.h |   78 ++
 tools/perf/util/parse-events-flex.c  | 2256 ++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events-flex.h  |  317 +++++
 tools/perf/util/parse-events.c       |  475 +++-----
 tools/perf/util/parse-events.h       |   10 +
 tools/perf/util/parse-events.l       |  114 ++
 tools/perf/util/parse-events.y       |  131 ++
 10 files changed, 5094 insertions(+), 324 deletions(-)
