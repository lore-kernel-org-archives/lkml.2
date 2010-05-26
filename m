Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0EZULp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:11:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab0EZULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:11:43 -0400
X-Authority-Analysis: v=1.1 cv=EbJB9AiBqsyZPMVATYsj78CfMiBiOs+4P7kRKNQkfg0= c=1 sm=0 a=CBfHqtown2AA:10 a=uEzv4HemXiYA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=ltkfGT8aeF6ZghgOVuUA:9 a=b-YAVmOPHWTRFUxewTEA:7 a=kdabkbDlUEL95QDitH4jHDO_VNAA:4 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100526201036.951395509@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 26 May 2010 16:10:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL] tracing: more shrinking of TRACE_EVENT() code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is built on my last pull request, and both would be good for
2.6.35.

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core-2


Li Zefan (7):
      tracing: Use a global field list for all syscall exit events
      tracing: Don't allocate common fields for every trace events
      tracing: Convert some timer events to DEFINE_EVENT
      tracing: Conver more sched events to DEFINE_EVENT
      tracing: Remove test of NULL define_fields callback
      tracing: Remove redundant raw_init callbacks
      tracing: Remove open-coded __trace_add_event_call()

----
 include/linux/syscalls.h           |    2 -
 include/trace/events/sched.h       |   32 ++-----
 include/trace/events/timer.h       |   80 ++++++--------
 include/trace/syscall.h            |    1 -
 kernel/trace/trace.h               |    2 +
 kernel/trace/trace_events.c        |  209 ++++++++++++++++--------------------
 kernel/trace/trace_events_filter.c |   27 +++--
 kernel/trace/trace_export.c        |    8 +--
 kernel/trace/trace_kprobe.c        |   10 +--
 kernel/trace/trace_syscalls.c      |    7 +-
 10 files changed, 157 insertions(+), 221 deletions(-)
