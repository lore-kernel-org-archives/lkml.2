Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1JJNlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 09:41:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60233 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1JJNlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 09:41:39 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=KisFuIn10osA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=nOUs0YPHjS8oAN3oflsA:9 a=FR8L27bqEJlcB35sbR0A:7 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=NbPVo96nMWXKFiTwPdkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010133852.829771373@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 09:38:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/20] [GIT PULL][v3.2] tracing: queued updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

With kernel.org down, I've queued up quite a lot of patches for 3.2.
As the list is slowly growing, I would like to get these into tip
so we can focus on the new patches.

I removed the trace_printk() patches as Peter and I are still discussing
how they should work. But the rest of the patches are good to go.

-- Steve


Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core

Head SHA1: 87912fdfc1378a7e7e54a169ef9eebeafa1af04f


Jiri Olsa (10):
      tracing/filter: Use static allocation for filter predicates
      tracing/filter: Separate predicate init and filter addition
      tracing/filter: Remove field_name from filter_pred struct
      tracing/filter: Simplify tracepoint event lookup
      tracing/filter: Unify predicate tree walking, change check_pred_tree =
function to use it
      tracing/filter: Change count_leafs function to use walk_pred_tree
      tracing/filter: Change fold_pred_tree function to use walk_pred_tree
      tracing/filter: Change fold_pred function to use walk_pred_tree
      tracing/filter: Change filter_match_preds function to use walk_pred_t=
ree
      tracing/filter: Add startup tests for events filter

Kevin Winchester (1):
      x86: jump_label: arch_jump_label_text_poke_early: add missing __init

Mathieu Desnoyers (1):
      Tracepoint: Dissociate from module mutex

Steven Rostedt (6):
      tracing: Clean up tb_fmt to not give faulty compile warning
      tracing: Add preempt disable for filter self test
      tracing: Add a counter clock for those that do not trust clocks
      tracing: Fix preemptirqsoff tracer to not stop at preempt off
      tracing: Warn on output if the function tracer was found corrupted
      tracing: Do not allocate buffer for trace_marker

Vaibhav Nagarnaik (2):
      trace: Add a new readonly entry to report total buffer size
      trace: Add ring buffer stats to measure rate of events

----
 arch/x86/kernel/jump_label.c            |    2 +-
 include/linux/module.h                  |   12 -
 include/linux/ring_buffer.h             |    2 +
 include/linux/trace_clock.h             |    1 +
 include/linux/tracepoint.h              |   25 +-
 kernel/module.c                         |   47 --
 kernel/trace/Makefile                   |    2 +
 kernel/trace/ftrace.c                   |    8 +
 kernel/trace/ring_buffer.c              |   70 +++-
 kernel/trace/trace.c                    |  173 ++++++--
 kernel/trace/trace.h                    |   16 +-
 kernel/trace/trace_clock.c              |   12 +
 kernel/trace/trace_events_filter.c      |  795 ++++++++++++++++++---------=
----
 kernel/trace/trace_events_filter_test.h |   50 ++
 kernel/trace/trace_irqsoff.c            |    4 +-
 kernel/trace/trace_printk.c             |   19 +-
 kernel/tracepoint.c                     |  169 ++++++-
 17 files changed, 928 insertions(+), 479 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOkvYQAAoJEIy3vGnGbaoAy9YQALYGcvDSGrSlWRZSwSBIsamb
F44bbRkrMNb2WmLyjoFjwoKJu5OvmckQc8ATXkiXISjnb6Yh4ghd73224jq7tPuw
GX3eutZ5k1Yisbwl51BQY6sWy80ePGp4JlpakQpWrfgkvhuH6tVu00jHkKKiCAYc
9ex75pPPzrFmPuPBfNLU2Nivhhjv1NMCInTxjcKHY4XmVzfZMdf/iI2Cq2WlleVp
plpZXbB7Wl0vLQWyBW9Ym3ag4Q94LsiG3hCid756Vmca2Yo5vSID/RBTYVcQCP0Y
MnWyFCyFiqUgGSF4swO+RvQ7flIazWjVSvCLu2QJn8TGRTCKfA9R5JIsTnQwSHKh
zUSWc0pS6LTQ17AUh8718GZ11CuUZq6yIxPKaCm+o70bnkYInaTj3BOGxyPsckwI
O+EYuREfMll2PHZB8QeBFjuZEUF504z9wu5rskiabw2BYxzF/ye28kDovs3dtgKN
eIkFQd//ehBgWAHcUOXXBrXw0VA5gPppMkJe6UdUrHtpmwKR6TbBgF29NHFJnecC
qcM3tJMgkR+T5P5iXkhf1x5SJonnX48EnhN8mzN97PGSUWgT9Q6+NOUgovren4LS
hLyr7KAOdU8ejWubaKf+RETP6fu1p0D8E5kit4u1grSR6B5apK4J3llpoySaiJgf
i/EIogKUfqu2rlDbn2Ho
=2/4f
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
