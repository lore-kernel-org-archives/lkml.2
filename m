Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762850Ab2KBNkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:40:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2KBNfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:00 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fz1N-I78POgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xd8suKrzqM0A:10 a=VwQbUJbxAAAA:8 a=RRjX4gSIN2mM1jyp2sgA:9 a=QEXdDO2ut3YA:10 a=LqS25OiqWZ3DsDmMaFsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133251.998500247@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:32:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/22] [GIT PULL][3.8] tracing: updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

I've been focusing on -rt related things lately and let my tracing
queue pile up on me. I've ran these through my own vigorous tests,
and think they are ready for 3.8.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 9b194e6cb864506da693d26149370cb7272af99f


Daniel Walter (1):
      tracing: Replace strict_strto* with kstrto*

David Sharp (4):
      tracing: Trivial cleanup
      tracing,x86: Add a TSC trace_clock
      tracing: Reset ring buffer when changing trace_clocks
      tracing: Format non-nanosec times from tsc clock without a decimal po=
int.

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

Yoshihiro YUNOMAE (2):
      ring-buffer: Change unsigned long type of ring_buffer_oldest_event_ts=
() to u64
      tracing: Show raw time stamp on stats per cpu using counter or tsc mo=
de for trace_clock

----
 Documentation/kernel-parameters.txt  |   16 ++
 arch/alpha/include/asm/Kbuild        |    1 +
 arch/arm/include/asm/Kbuild          |    1 +
 arch/arm64/include/asm/Kbuild        |    1 +
 arch/avr32/include/asm/Kbuild        |    1 +
 arch/blackfin/include/asm/Kbuild     |    1 +
 arch/c6x/include/asm/Kbuild          |    1 +
 arch/cris/include/asm/Kbuild         |    1 +
 arch/frv/include/asm/Kbuild          |    1 +
 arch/h8300/include/asm/Kbuild        |    1 +
 arch/hexagon/include/asm/Kbuild      |    1 +
 arch/ia64/include/asm/Kbuild         |    1 +
 arch/m32r/include/asm/Kbuild         |    1 +
 arch/m68k/include/asm/Kbuild         |    1 +
 arch/microblaze/include/asm/Kbuild   |    1 +
 arch/mips/include/asm/Kbuild         |    1 +
 arch/mn10300/include/asm/Kbuild      |    1 +
 arch/openrisc/include/asm/Kbuild     |    1 +
 arch/parisc/include/asm/Kbuild       |    2 +-
 arch/powerpc/include/asm/Kbuild      |    1 +
 arch/s390/include/asm/Kbuild         |    1 +
 arch/score/include/asm/Kbuild        |    1 +
 arch/sh/include/asm/Kbuild           |    1 +
 arch/sparc/include/asm/Kbuild        |    1 +
 arch/tile/include/asm/Kbuild         |    1 +
 arch/um/include/asm/Kbuild           |    1 +
 arch/unicore32/include/asm/Kbuild    |    1 +
 arch/x86/include/asm/trace_clock.h   |   16 ++
 arch/x86/kernel/Makefile             |    1 +
 arch/x86/kernel/trace_clock.c        |   21 ++
 arch/xtensa/include/asm/Kbuild       |    1 +
 include/asm-generic/trace_clock.h    |   16 ++
 include/linux/ftrace_event.h         |   20 +-
 include/linux/kernel.h               |    7 +-
 include/linux/ring_buffer.h          |    3 +-
 include/linux/trace_clock.h          |    2 +
 include/trace/ftrace.h               |    3 +-
 include/trace/syscall.h              |   23 --
 kernel/trace/Kconfig                 |    1 +
 kernel/trace/ftrace.c                |    6 +-
 kernel/trace/ring_buffer.c           |   51 ++++-
 kernel/trace/trace.c                 |  411 ++++++++++++++++++------------=
----
 kernel/trace/trace.h                 |   18 +-
 kernel/trace/trace_branch.c          |    4 +-
 kernel/trace/trace_events.c          |   51 +++--
 kernel/trace/trace_events_filter.c   |    4 +-
 kernel/trace/trace_functions.c       |    5 +-
 kernel/trace/trace_functions_graph.c |    6 +-
 kernel/trace/trace_irqsoff.c         |   14 +-
 kernel/trace/trace_kprobe.c          |   10 +-
 kernel/trace/trace_output.c          |   80 ++++---
 kernel/trace/trace_probe.c           |   14 +-
 kernel/trace/trace_sched_switch.c    |    4 +-
 kernel/trace/trace_sched_wakeup.c    |   10 +-
 kernel/trace/trace_selftest.c        |   13 +-
 kernel/trace/trace_syscalls.c        |   61 +++--
 kernel/trace/trace_uprobe.c          |    2 +-
 57 files changed, 539 insertions(+), 382 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8v9AAoJEOdOSU1xswtM5z4IAJ7dTsKdqnLDVbx+FvQd1kDd
CWoYO5RrmSn4yUgGRuES+1pvJ9znyQL5LSpw1BmIqOcZR26gXif7PJS0sUwRKS7/
zXWxcQJQ9feOm/yASmCzlRUZQh8G2BJjtF3D+UwgKL9sJfRun8lX4iwuf2mHdxTc
mC/uyYHiTbB9apugxDVHReSRmRA/BMTN2P3k0F72hA9mfJv9iPAR0xj7lvTgrhS6
L3UMm7lGqIARLZbtQyVPgVlKy3k+PtkVwSiy8IdpzMYZnTuzVHwgEvdZP+3PC+Tx
wrpRWSE9KBolgQ0uOftqqwb4PrjVELU+MsweggbxFiYiIwUVaOHGZPLX4RfX9zw=
=0mdX
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
