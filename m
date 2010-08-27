Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0H0Lg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:36:56 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44974 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab0H0Lgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:36:53 -0400
X-AuditID: b753bd60-a78bfba000005a63-7d-4c77a35220b8
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  0/5] Perf and tracing/kprobe fixes
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp
Date: Fri, 27 Aug 2010 20:38:37 +0900
Message-ID: <20100827113837.22882.92630.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches fixes a memory leak and perf probe bugs.
It also adds a check of invalid argument name for special characters
which will cause a fail on perf-trace event format parsing, and
assigns "argN" name for no-name arguments.

Thank you,

---

Masami Hiramatsu (5):
      tracing/kprobe: Check invalid argument name
      tracing/kprobes: Set a name for each argument automatically
      perf probe: Don't make argument names from raw parameters
      perf probe: Fix return probe support
      tracing/kprobe: Fix a memory leak in error case


 kernel/trace/trace_kprobe.c    |   43 +++++++++++++++++++++++-----------------
 tools/perf/util/probe-event.c  |    1 +
 tools/perf/util/probe-finder.c |   42 +++++++++++++++++++++++++++------------
 3 files changed, 55 insertions(+), 31 deletions(-)

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

