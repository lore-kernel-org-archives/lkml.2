Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab0J2HTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 03:19:10 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:39635 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756199Ab0J2HTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 03:19:07 -0400
Subject: [RFC][PATCH 00/22] sched: SCHED_DEADLINE v3
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, Dario <raistlin@linux.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0idb1rubvU/lFmV8bEne"
Date: Fri, 29 Oct 2010 08:18:47 +0200
Message-ID: <1288333128.8661.137.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0idb1rubvU/lFmV8bEne
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello everyone,

This is the take 3 for the SCHED_DEADLINE patchset. I've done my best to
have something that can be publicly shown by the Kernel Summit. To be
sincere, I didn't make in getting the code to the point I wanted to but,
hey, I hope this can be at least something from where to start the
discussion. :-)

BTW, the patchset introduces a new deadline based real-time task
scheduling policy --called SCHED_DEADLINE-- with bandwidth isolation
(aka "resource reservation") capabilities. It now supports
global/clustered multiprocessor scheduling through dynamic task
migrations.

The code is being jointly developed by ReTiS Lab (http://retis.sssup.it)
and Evidence S.r.l (http://www.evidence.eu.com) in the context of the
ACTORS EU-funded project (http://www.actors-project.eu).
It is also starting to get some users, both in academic and applied
research, considered I'm getting some feedback from Ericsson, MIT and
from Iowa State, Porto (ISEP), Carnegie Mellon, Barcelona and Trento
universities.

=46rom the previous release[*]:
 - all the comments and the fixes coming from the reviews we got have=20
   been considered and applied;
 - global and clustered (e.g., through cpusets) scheduling is now
   available. This means that tasks can migrate among (a subset of) CPUs
   when this is needed, by means of pushes & pulls, like in
   sched_rt.c;
 - (c)group based task admission logic and bandwidth management has=20
   been removed, in favour of a per root_domain tasks bandwidth
   accounting mechanism;
 - finally, all the code underwent major restructuring (many parts=20
   have been almost completely rewritten), to make it easier to read and
   understand, as well as more consistent with kernel mechanisms and
   conventions;
=20
Still missing/incomplete:
 - (c)group based bandwidth management, and maybe scheduling. It seems=20
   some more discussion on what precisely we want is *really* needed=20
   for this point;
 - better handling of rq selection for dynamic task migration, by means
   of a cpupri equivalent for -deadline tasks. Not that hard to do, we
   already have some ideas and hope to have the code soon;
 - bandwidth inheritance (to replace deadline/priority inheritance).
   What's in the patchset is just very few more than a simple
   placeholder. I tried doing something that may fit in the current
   architecture of rt_mutexes (i.e., the pi-chain of waiters) but did
   not get to anything meaningful. We are now working on migrating to
   something similar to what it's probably known here as proxy
   execution... It's not easy at all, but we are on it. :-)

The official page of the project is:
  http://www.evidence.eu.com/sched_deadline.html

while the development is taking place at:
  http://gitorious.org/sched_deadline/pages/Home
  http://gitorious.org/sched_deadline

Check the repositories frequently if you're interested, and feel free to
e-mail me for any issue you run into.

Patchset is on top of tip/master (as of today). The git-tree and patches
for PREEMPT_RT will be available on the project website in the next
days.

Relationship of this patchset with the EDF-throttling one is tight,
although the two implementations add different (new) features and solve
different problems. In case they have to coexist, a lot of code could be
shared and duplications would be easily avoided.

As usual, any kind of feedback is welcome and appreciated.

Thanks in advice and regards,
Dario

[*] http://lwn.net/Articles/376502, http://lwn.net/Articles/353797

Dario Faggioi, SCHED_DEADLINE (22)

 sched: add sched_class->task_dead.
 sched: add extended scheduling interface.
 sched: SCHED_DEADLINE data structures.
 sched: SCHED_DEADLINE SMP-related data structures.
 sched: SCHED_DEADLINE policy implementation.
 sched: SCHED_DEADLINE handles spacial kthreads.
 sched: SCHED_DEADLINE push and pull logic.
 sched: SCHED_DEADLINE avg_update accounting.
 sched: add period support for -deadline tasks.
 sched: add a syscall to wait for the next instance.
 sched: add schedstats for -deadline tasks.
 sched: add runtime reporting for -deadline tasks.
 sched: add resource limits for -deadline tasks.
 sched: add latency tracing for -deadline tasks.
 sched: add traceporints for -deadline tasks.
 sched: add SMP traceporints for -deadline tasks.
 sched: add signaling overrunning -deadline tasks.
 sched: add reclaiming logic to -deadline tasks.
 rtmutex: turn the plist into an rb-tree.
 sched: drafted deadline inheritance logic.
 sched: add bandwidth management for sched_dl.
 sched: add sched_dl documentation.

 Documentation/scheduler/sched-deadline.txt |  147 +++
 arch/arm/include/asm/unistd.h              |    4 +
 arch/arm/kernel/calls.S                    |    4 +
 arch/x86/ia32/ia32entry.S                  |    4 +
 arch/x86/include/asm/unistd_32.h           |    6 +-
 arch/x86/include/asm/unistd_64.h           |    8 +
 arch/x86/kernel/syscall_table_32.S         |    4 +
 include/asm-generic/resource.h             |    7 +-
 include/linux/init_task.h                  |   10 +
 include/linux/rtmutex.h                    |   13 +-
 include/linux/sched.h                      |  208 ++++-
 include/linux/syscalls.h                   |    9 +
 include/trace/events/sched.h               |  312 +++++-
 kernel/fork.c                              |    4 +-
 kernel/hrtimer.c                           |    2 +-
 kernel/posix-cpu-timers.c                  |   55 +
 kernel/rtmutex-debug.c                     |    8 +-
 kernel/rtmutex.c                           |  146 ++-
 kernel/rtmutex_common.h                    |   22 +-
 kernel/sched.c                             | 1046 ++++++++++++++++--
 kernel/sched_debug.c                       |   46 +
 kernel/sched_dl.c                          | 1713 ++++++++++++++++++++++++=
++++
 kernel/sched_fair.c                        |    6 +-
 kernel/sched_rt.c                          |    7 +-
 kernel/sched_stoptask.c                    |    2 +-
 kernel/softirq.c                           |    6 +-
 kernel/sysctl.c                            |   14 +
 kernel/trace/trace_sched_wakeup.c          |   44 +-
 kernel/trace/trace_selftest.c              |   31 +-
 kernel/watchdog.c                          |    3 +-
 30 files changed, 3721 insertions(+), 170 deletions(-)

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-0idb1rubvU/lFmV8bEne
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKZ0cACgkQk4XaBE3IOsTGzgCfXU9GFknpl6d3AeR7uUWZ08/b
NUQAmwYuXAhLMCDbTN1WCjOCXWCLu/5j
=S2qG
-----END PGP SIGNATURE-----

--=-0idb1rubvU/lFmV8bEne--

