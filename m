Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab1GGVBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:01:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42794 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1GGVBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:01:45 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=B16erYzLEJUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=hhBPFgKUky337QqXyrYA:9 a=OH4Lhotphzmfd_F6Zf0A:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110707205755.992304506@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 07 Jul 2011 16:57:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3 v2] [GIT PULL][v3.0] tracing: various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I rebased the last two patches but only changed the change logs.
The first patch I rephrased the subject, the second patch I rewrote
the change log to something that explains things much better.

I also added a third patch that fixes a regression that was reported
to me earlier today.

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent-2

Head SHA1: 43dd61c9a09bd413e837df829e6bfb42159be52a


Steven Rostedt (3):
      tracing: Fix bug when reading system filters on module removal
      tracing: Have "enable" file use refcounts like the "filter" file
      ftrace: Fix regression of :mod:module function enabling

----
 include/linux/ftrace.h             |    3 +-
 kernel/trace/ftrace.c              |   12 +---
 kernel/trace/trace.h               |    1 +
 kernel/trace/trace_events.c        |  113 ++++++++++++++++++++++++++++++------
 kernel/trace/trace_events_filter.c |    6 ++
 kernel/trace/trace_functions.c     |    3 +-
 6 files changed, 109 insertions(+), 29 deletions(-)
