Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab1GOM0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 08:26:31 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46030 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1GOM0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 08:26:30 -0400
X-AuditID: b753bd60-a32aeba0000019f4-2e-4e2031f2389f
X-AuditID: b753bd60-a32aeba0000019f4-2e-4e2031f2389f
Message-ID: <4E2031D8.3090902@hitachi.com>
Date: Fri, 15 Jul 2011 21:26:00 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip  00/13]tracing/kprobes: Dynamic events on module
 support
References: <20110627072626.6528.41792.stgit@fedora15> <1310729328.27864.61.camel@gandalf.stny.rr.com>
In-Reply-To: <1310729328.27864.61.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/15 20:28), Steven Rostedt wrote:
> On Mon, 2011-06-27 at 16:26 +0900, Masami Hiramatsu wrote:
>> Hi Steven,
>>
>> Here, I'd like to push updates of dynamic events and perf-probe
>> for supporting dynamic events on module.
>>
>> The main part of this series is 1-5th patches for kprobes and
>> dynamic event tracer, which allows us to add events on offline
>> kernel module. This means we can put events even on the init
>> functions of the drivers before loading. The requirement of
>> this feature comes from my recent experience of a driver
>> debugging. It had a timing bug in the initialization routine,
>> and it was hard to catch them without tracing the behavior.
>>
>> I added some perf-probe updates (which including some resent
>> patches), And it's OK to pull only the main part (kprobes and
>> ftrace patches) without perf updates.
>>
> 
> OK I pulled in everything but patch 10, as that seemed to have an issue
> with the message that David Ahern brought up. I left that one out as it
> really wasn't necessary for the other patches. If you want to just
> resend that one patch with an update, I can pull that one in too.

Thanks, and patch 10, I've found that that actually fixed a bug
of perf probe itself and have sent it to Ingo as another bugfix,
so feel free to drop it from your tree.

Thank you,

> 
> -- Steve
> 
>>
>> Thank you,
>>
>> ---
>>
>> Masami Hiramatsu (13):
>>       perf probe: Support adding probes on offline kernel modules
>>       perf probe: Add probed module in front of function
>>       [RESEND]perf probe: Introduce debuginfo to encapsulate dwarf information
>>       [RESEND]perf probe: Warn when more than two lines are given
>>       [RESEND][CLEANUP]perf-probe: Move dwarf library routines to dwarf-aux.{c,h}
>>       [RESEND][CLEANUP]perf probe: Remove redundant dwarf functions
>>       [RESEND][CLEANUP]perf probe: Move strtailcmp to string.c
>>       [RESEND][CLEANUP]perf probe: Rename DIE_FIND_CB_FOUND to DIE_FIND_CB_END
>>       tracing/kprobe: Update symbol reference when loading module
>>       tracing/kprobes: Support module init function probing
>>       kprobes: Return -ENOENT if probe point doesn't exist
>>       [CLEANUP]tracing/kprobes: merge trace probe enable/disable functions
>>       [CLEANUP]tracing/kprobes: Rename probe_* to trace_probe_*
>>
>>
>>  Documentation/trace/kprobetrace.txt     |    9 
>>  kernel/kprobes.c                        |   33 +
>>  kernel/trace/trace_kprobe.c             |  314 +++++++++----
>>  tools/perf/Documentation/perf-probe.txt |    6 
>>  tools/perf/Makefile                     |    2 
>>  tools/perf/builtin-probe.c              |   14 -
>>  tools/perf/util/dwarf-aux.c             |  663 +++++++++++++++++++++++++++
>>  tools/perf/util/dwarf-aux.h             |  100 ++++
>>  tools/perf/util/probe-event.c           |  165 +++++--
>>  tools/perf/util/probe-event.h           |    1 
>>  tools/perf/util/probe-finder.c          |  752 ++++---------------------------
>>  tools/perf/util/probe-finder.h          |   43 +-
>>  tools/perf/util/string.c                |   19 +
>>  tools/perf/util/util.h                  |    1 
>>  14 files changed, 1304 insertions(+), 818 deletions(-)
>>  create mode 100644 tools/perf/util/dwarf-aux.c
>>  create mode 100644 tools/perf/util/dwarf-aux.h
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
