Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0EBNz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 09:55:27 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:50628 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab0EBNzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 09:55:24 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4][RFC] perf bench: prepare framework for parallel oriented benchmarking
Date: Sun,  2 May 2010 22:55:15 +0900
Message-Id: <1272808519-4743-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I made a change on "perf bench" and made patch series
for parallel oriented benchmarking.

Previous perf bench provided only least
framework for each benchmark programs,
but I felt this was not enough.

Because it seems that lots of today's performance issue
is found by multi thread/process programs.

So I made perf bench to provide the framework
for easy parallel benchmark writing.

And this is a preparation for "perf bench syscall".
Because each benchmarks of system call
will be required parallel workloads,
but parallel frameworks for each benchmarks will be fat code.

Request for comments!

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>

Hitoshi Mitake (4):
  perf bench: add "sample" subsystem and "sample" suite as sample
    benchmark program
  perf bench: fix "mem" subsystem to adopt new style of perf bench
  perf bench: fix "sched" subsystem to adopt new style of perf bench
  perf bench: improve perf bench for parallel oriented benchmarking

 tools/perf/Makefile                |    5 +
 tools/perf/bench/bench.h           |   32 ++
 tools/perf/bench/mem-memcpy.c      |  182 ++++--------
 tools/perf/bench/mem.h             |    4 +
 tools/perf/bench/sample-sample.c   |   98 +++++++
 tools/perf/bench/sample.h          |    4 +
 tools/perf/bench/sched-messaging.c |  553 ++++++++++++++++++++----------------
 tools/perf/bench/sched-pipe.c      |  146 +++++-----
 tools/perf/bench/sched.h           |    8 +
 tools/perf/builtin-bench.c         |  227 +++++++++++----
 10 files changed, 762 insertions(+), 497 deletions(-)
 create mode 100644 tools/perf/bench/mem.h
 create mode 100644 tools/perf/bench/sample-sample.c
 create mode 100644 tools/perf/bench/sample.h
 create mode 100644 tools/perf/bench/sched.h

