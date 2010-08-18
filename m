Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab0HRXqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:46:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0HRXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:46:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=v6WQUZmGs0SH6kW9VbroCfo82e9QM34mQSrQEp1SiOfpfjDbm3HK8z0TE3ZCawwCZg
         enLy3f26v1ovemVUm1/WUlGW5EZvMO3BPw9ZIwl8KFTbIrCRw0ckVWhmE03Ry9Jypt6J
         kI39YuAPl3LSXMxMgDwYN6IbWXiNr8yiePj24=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perf callchains updates
Date: Thu, 19 Aug 2010 01:46:09 +0200
Message-Id: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      perf: Drop unappropriate tests on arch callchains
      perf: Generalize callchain_store()
      perf: Generalize some arch callchain code
      perf: Factorize callchain context handling
      perf: Fix race in callchains
      perf: Humanize the number of contexts

Namhyung Kim (1):
      perf, tracing: add missing __percpu markups


 arch/arm/kernel/perf_event.c         |   62 +--------
 arch/powerpc/kernel/perf_callchain.c |   86 ++++--------
 arch/sh/kernel/perf_callchain.c      |   50 +------
 arch/sparc/kernel/perf_event.c       |   69 +++------
 arch/x86/kernel/cpu/perf_event.c     |   82 +++--------
 include/linux/ftrace_event.h         |    4 +-
 include/linux/perf_event.h           |   30 +++-
 kernel/perf_event.c                  |  259 ++++++++++++++++++++++++++++++----
 kernel/trace/trace_event_perf.c      |   21 ++--
 kernel/trace/trace_functions_graph.c |    2 +-
 10 files changed, 342 insertions(+), 323 deletions(-)
