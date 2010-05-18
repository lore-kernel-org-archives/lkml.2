Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab0ERCoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 22:44:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab0ERCoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 22:44:15 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/4] perf-probe updates: string support, etc.
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 17 May 2010 22:49:19 -0400
Message-ID: <20100518024919.25275.58125.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here is a series of patches which improves perf probe to
add below features.

- String support, which enables dynamic events to trace string
  variables instead of its address.

- Fixed-index array entry support, which allows user to trace
  an array entry with digit index, e.g. array[0].

- Global/static variable support, which allows user to trace
  global or static variables, as same as local one.


TODOs (possible features):
  - Support dynamic array-indexing (var[var2])
  - Support force type-casting ((type)var)
  - Show what deta-structure member is assigned to each argument.
  - Better support for probes on modules
  - More debugger like enhancements(%next, --disasm, etc.)

Thank you,

---

Masami Hiramatsu (4):
      perf probe: Support static and global variables
      perf probe: Support tracing an entry of array
      perf probe: Support "string" type
      tracing/kprobes: Support "string" type


 Documentation/trace/kprobetrace.txt     |    2 
 kernel/trace/trace_kprobe.c             |  356 ++++++++++++++++++++++++-------
 tools/perf/Documentation/perf-probe.txt |    4 
 tools/perf/util/probe-event.c           |   71 ++++--
 tools/perf/util/probe-event.h           |    1 
 tools/perf/util/probe-finder.c          |  192 +++++++++++++----
 6 files changed, 484 insertions(+), 142 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
