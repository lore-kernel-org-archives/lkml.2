Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0DXCFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:05:38 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61498 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0DXCFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=tGgYRxSMDFvU8EWEOZSrCIlvBDeTCSQhwvw2MqOOcU8GnvJSH4b57MtNMfuRlal9vS
         HcMsQtrRucsH+S5UgT+TERZUdJy2C1tuEo3ucYMz4nqJPbFcmWKUJ0MoSe+qKqLB5B0A
         N+pHF/1d5Rmgn6xeh26iAOSIM0HgvTbFLshgM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       William Cohen <wcohen@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Li Zefan <lizf@cn.fujitsu.com>,
       Stephane Eranian <eranian@google.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [GIT PULL] perf tools updates
Date: Sat, 24 Apr 2010 04:05:33 +0200
Message-Id: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
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
      perf: Generalize perf lock's sample event reordering to the session layer
      perf: Use generic sample reordering in perf sched
      perf: Use generic sample reordering in perf kmem
      perf: Use generic sample reordering in perf trace
      perf: Use generic sample reordering in perf timechart
      perf: Add a perf trace option to check samples ordering reliability

Hitoshi Mitake (1):
      perf lock: Fix state machine to recognize lock sequence

Stephane Eranian (1):
      perf: Fix initialization bug in parse_single_tracepoint_event()

William Cohen (1):
      perf: Some perf-kvm documentation edits


 tools/perf/Documentation/perf-kvm.txt |    9 +-
 tools/perf/builtin-kmem.c             |    6 +-
 tools/perf/builtin-lock.c             |  595 ++++++++++++++++++++-------------
 tools/perf/builtin-sched.c            |    8 +-
 tools/perf/builtin-timechart.c        |  112 +------
 tools/perf/builtin-trace.c            |   13 +
 tools/perf/util/parse-events.c        |   13 +-
 tools/perf/util/session.c             |  179 ++++++++++-
 tools/perf/util/session.h             |   10 +
 9 files changed, 583 insertions(+), 362 deletions(-)
