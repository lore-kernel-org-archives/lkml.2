Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0FJDtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 23:49:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32830 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0FJDtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 23:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=nx9YRyk74u/FlmoS8VnWxyR9jePQa/hY9KEGQFHHU8HtJceKqi85JIkcl61pn22RRH
         0SRrPyPfB6DrBVOqmgNKrAXmFol6lWzpEACGiVP7kdLljDQSc8vBlzpfQiu3y7kvRd3r
         A//kHzvxGB4BtCzkVqjuy0aKvbyQCQf0GYqMU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/5] perf events finer grained context instrumentation / context exclusion
Date: Thu, 10 Jun 2010 05:49:15 +0200
Message-Id: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the new version of per context exclusion, based on hooks
on irq_enter/irq_exit. I haven't observed slowdowns but I haven't
actually measured the impact.

It's pullable from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/exclusion-3

It's against latest tip:perf/core.

Thanks.

Frederic Weisbecker (5):
  perf: Provide a proper stop action for software events
  perf: Support disable() after stop() on software events
  perf: New PERF_EVENT_STATE_PAUSED event state
  perf: Introduce task, softirq and hardirq contexts exclusion
  perf: Support for task/softirq/hardirq exclusion on tools

 arch/x86/kernel/cpu/perf_event.c |    6 +-
 include/linux/perf_event.h       |   44 +++++++-
 kernel/perf_event.c              |  232 ++++++++++++++++++++++++++++++++------
 kernel/softirq.c                 |    6 +
 kernel/trace/trace_event_perf.c  |    2 +-
 tools/perf/util/parse-events.c   |   37 +++++--
 6 files changed, 276 insertions(+), 51 deletions(-)

