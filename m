Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2EUHhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:37:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab2EUHhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:37:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: zheng.z.yan@intel.com
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, andi@firstfloor.org,
        eranian@google.com, jolsa@redhat.com, ming.m.lin@intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/5] perf, tool: uncore related changes
Date: Mon, 21 May 2012 09:36:48 +0200
Message-Id: <1337585813-3349-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
References: <1337144403-30841-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset is based on parsing fixies I just sent out
and CC-ed you.

I found a way to reuse the event parsing grammar for just
term parsing. I had to make some other changes as well:

  - we end up with 2 start symbols for event grammar to differentiate
    between event parsing and terms parsing

  - we have now 2 diferent structures with parser arguments
    for each event parsing and terms parsing

  - I kept the reentrant parser.. it's not needed but I think
    it's better than non reentrant ;)
    I'm passing yyscanner instead of yylval and yytext as you did,
    because you can get yylval and yytext out of yyscanner,
    also I think it's more generic

  - added automated tests for terms parsing, but we need automated
    tests for term aliasing (patch 4/5) .. similar pmu tests as
    for pmu format parsing

attached patches:
  1/5 perf, tool: Use data struct for arg passing in event parse function
  2/5 perf, tool: Make the event parser reentrantable
  3/5 perf, tool: Add support to reuse event grammar to parse out terms
  4/5 perf, tool: Add pmu event alias support
  5/5 perf, tool: Add automated test for pure terms parsing

thanks for comments,
jirka
---
 tools/perf/util/parse-events-test.c |  122 +++++++++++++++++++++++++++-
 tools/perf/util/parse-events.c      |   71 ++++++++++++++---
 tools/perf/util/parse-events.h      |   15 +++-
 tools/perf/util/parse-events.l      |  129 ++++++++++++++++++-----------
 tools/perf/util/parse-events.y      |   71 ++++++++++++-----
 tools/perf/util/pmu.c               |  152 +++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.h               |   11 +++-
 7 files changed, 483 insertions(+), 88 deletions(-)
