Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0EXITo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 04:19:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab0EXITn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 04:19:43 -0400
Message-ID: <4BFA3728.3000701@cn.fujitsu.com>
Date: Mon, 24 May 2010 16:22:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] tracing: further shrinking trace events
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch 1-2: reduce per trace event foot print
patch 3-5: convert some trace events to DEFINE_EVENT
patch 6-8: do some cleanups and thus shrink text size a bit

Save ~5.7K in text and ~2.9K in data:

   text    data     bss     dec     hex filename
7018612 2034376 7251132 16304120         f8c7f8 vmlinux.o.orig
7012847 2031440 7251132 16295419         f8a5fb vmlinux.o

And save considerable memory allocated by trace_define_event().

---
 include/linux/syscalls.h           |    2 -
 include/trace/events/ext4.h        |   61 +++--------
 include/trace/events/sched.h       |   32 ++-----
 include/trace/events/timer.h       |   80 ++++++--------
 include/trace/syscall.h            |    1 -
 kernel/trace/trace.h               |    2 +
 kernel/trace/trace_events.c        |  209 ++++++++++++++++--------------------
 kernel/trace/trace_events_filter.c |   27 +++--
 kernel/trace/trace_export.c        |    8 +--
 kernel/trace/trace_kprobe.c        |   10 +--
 kernel/trace/trace_syscalls.c      |    7 +-
 11 files changed, 174 insertions(+), 265 deletions(-)
