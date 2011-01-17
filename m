Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab1AQFtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 00:49:43 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35089 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750761Ab1AQFtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 00:49:41 -0500
Date: Mon, 17 Jan 2011 00:49:37 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, Avik Sil <avik.sil@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [ANNOUNCEMENT] LTTng development roadmap, snapshot 20110116
Message-ID: <20110117054937.GA12175@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 23:57:38 up 54 days, 10:00,  6 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released a development snapshot of the current LTTng so those interested
can start building it in various configurations. The targets of this
development phase were as follows:

1) The size of the kernel patchset has been shrinked for Linux distributions by
   removing all LTTng-specific instrumentation from the tree.

2) The lttng-modules package now implements an ABI based on anonymous file
   descriptors (inspired from perf) rather than the full-blown VFS tree the
   previous LTTng versions were implementing.

3) lttng-modules now exports trace data and metadata in the CTF (Common Trace
   Format).

4) lttng-modules now uses the Generic Ring Buffer Library.


The kernel tree snapshot is available as a tarball at:
http://lttng.org/files/lttng/patch-2.6.37-lttng-dev-snapshot-20110116.tar.bz2

The kernel patchset contains the following subdirectories:

trace-event-merged/                (3 patches, merged in the tracing tree)
 5 files changed, 22 insertions(+), 17 deletions(-)

trace-event-semicolon-removal/     (29 patches)
 37 files changed, 730 insertions(+), 662 deletions(-)

trace-event-assign-macros/         (8 patches)
 10 files changed, 251 insertions(+), 223 deletions(-)

trace-clock/                       (19 patches)
 60 files changed, 2750 insertions(+), 216 deletions(-)

lib-ring-buffer/                   (9 patches)
 34 files changed, 6635 insertions(+), 71 deletions(-)

lttng/                             (3 patches)
 3 files changed, 11 insertions(+), 1 deletion(-)

lib-ring-buffer-improvements/      (7 patches)
 12 files changed, 279 insertions(+), 14 deletions(-)


The LTTng kernel patchset is needed to build the current lttng-modules git tree
(a kernel module package). To fetch it:

git clone git://git.lttng.org/lttng-modules.git
(.c and .h files:   3170 lines total)

I currently have only a rather basic test program to interface with the new ABI
(available at http://lttng.org/files/lttng/test-lttng-ioctl.c), but I am
planning to work on the new strace-like command line program within the next
weeks (note: the location of the debugfs LTTng file will very likely change).
The objective is to create one single command-line tool to control both the
LTTng kernel tracer and the UST user-space tracer.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
