Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0EUOFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:05:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48158 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0EUOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=caH+pRIvK6zF3P3YJjG0+MDgEJesm9gcfrGMigjrJzaHPrObJYJlykxn3ZX0mVWhJ9
         Irpb4dmIhrswjEKQ+btW47N4AeYmuvGm/gdTe3pE2ZKRcYc0jRMoypg9LIpJCyMTFgvK
         pigwYnXyPyDSZEnl5WPqRXtTwwLg/LQIgi5B4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 0/4] perf: Tasks and irq exclusion
Date: Fri, 21 May 2010 16:05:11 +0200
Message-Id: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The new task and irq exclusion handling can let you
confine tracing and profiling to about everything you
want.

May be the only class of event I haven't tested yet is the
breakpoints and non-tracepoint software events.
Otherwise it works fine for hardware and tracepoints.

Thanks.

(Can be pulled there if you think it's fine:
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
	perf/exclusion)

Frederic Weisbecker (4):
  irq: Support to compute context on top of a given preempt_count
    offset
  perf: Add exclude_task perf event attribute
  perf: Support for irq exclusion
  perf: Support for task/softirq/hardirq exclusion on tools

 include/linux/hardirq.h        |   17 +++++++--
 include/linux/perf_event.h     |    7 +++-
 kernel/perf_event.c            |   79 ++++++++++++++++++++++++++++++++--------
 tools/perf/util/parse-events.c |   37 +++++++++++++------
 4 files changed, 107 insertions(+), 33 deletions(-)

