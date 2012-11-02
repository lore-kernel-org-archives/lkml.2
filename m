Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab2KBSOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:14:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602Ab2KBSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:31 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=n-KLrdUYVzoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-UbjtAS9mJwA:10 a=VwQbUJbxAAAA:8 a=CdcsjU14Wdp5J3HyGRoA:9 a=QEXdDO2ut3YA:10 a=mc44_r0X0dS75VJgpikA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181331.513782854@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/19] [GIT PULL][3.8] tracing: updates (v2)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

I removed the few problem patches (and their dependencies) and
retested the result.

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core-2

Head SHA1: 7bcfaf54f591a0775254c4ea679faf615152ee3a


Daniel Walter (1):
      tracing: Replace strict_strto* with kstrto*

David Sharp (2):
      tracing: Trivial cleanup
      tracing: Reset ring buffer when changing trace_clocks

Hiraku Toyooka (1):
      tracing: Change tracer's integer flags to bool

Michal Hocko (1):
      linux/kernel.h: Remove duplicate trace_printk declaration

Slava Pestov (1):
      ring-buffer: Add a 'dropped events' counter

Steven Rostedt (11):
      tracing: Allow tracers to start at core initcall
      tracing: Expand ring buffer when trace_printk() is used
      tracing: Enable comm recording if trace_printk() is used
      tracing: Have tracing_sched_wakeup_trace() use standard unlock_commit
      tracing: Cache comms only after an event occurred
      tracing: Separate open function from set_event and available_events
      tracing: Remove unused function unregister_tracer()
      tracing: Make tracing_enabled be equal to tracing_on
      tracing: Remove deprecated tracing_enabled file
      tracing: Use irq_work for wake ups and remove *_nowake_*() functions
      tracing: Add trace_options kernel command line parameter

Vaibhav Nagarnaik (1):
      tracing: Cleanup unnecessary function declarations

Yoshihiro YUNOMAE (1):
      ring-buffer: Change unsigned long type of ring_buffer_oldest_event_ts=
() to u64

----
 Documentation/kernel-parameters.txt  |   16 ++
 include/linux/ftrace_event.h         |   14 +-
 include/linux/kernel.h               |    7 +-
 include/linux/ring_buffer.h          |    3 +-
 include/trace/ftrace.h               |    3 +-
 include/trace/syscall.h              |   23 ---
 kernel/trace/Kconfig                 |    1 +
 kernel/trace/ftrace.c                |    6 +-
 kernel/trace/ring_buffer.c           |   51 ++++-
 kernel/trace/trace.c                 |  372 +++++++++++++++++-------------=
----
 kernel/trace/trace.h                 |   14 +-
 kernel/trace/trace_branch.c          |    4 +-
 kernel/trace/trace_events.c          |   51 +++--
 kernel/trace/trace_events_filter.c   |    4 +-
 kernel/trace/trace_functions.c       |    5 +-
 kernel/trace/trace_functions_graph.c |    6 +-
 kernel/trace/trace_irqsoff.c         |   14 +-
 kernel/trace/trace_kprobe.c          |   10 +-
 kernel/trace/trace_probe.c           |   14 +-
 kernel/trace/trace_sched_switch.c    |    4 +-
 kernel/trace/trace_sched_wakeup.c    |   10 +-
 kernel/trace/trace_selftest.c        |   13 +-
 kernel/trace/trace_syscalls.c        |   61 +++---
 kernel/trace/trace_uprobe.c          |    2 +-
 24 files changed, 365 insertions(+), 343 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2DAAoJEOdOSU1xswtM2jsH/R8iPBkqKL9Z8JnVHS8w8Dce
BGFyrxS4nA9AE8AGgdaJBK+lOn2siVKR3a3vAlSHZyd2+xuShEEnwSaEDWR/ICKx
ryhOXmrrUoIOX72v6e/LDkXoFOSpWdh7Kr2llJXwt+hJ8twyZXigCHv3WLJoboNf
wE+bMYSwVMnqRE3Ci/C9HVaB8hMOZdFTaFL8mot2K1ZYBA4xjV7LhGTcE3bxS3o+
WOqN8TZyNhIEpfNF6tbOui4unQswTvfIwYpzy8fePm4/hyNAqhNnXKiI1JFyoWHw
eh7yx/gjQi5Xlas2dEWPdAbQMe/Ci/aqPGiTIJs6sJ+tw6tx0Oia3gWC778xMNc=
=EP4v
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
