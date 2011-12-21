Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1LUMiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:38:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1LUMiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:38:05 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=gRRkkxu2b6wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=i26QP3RLheeyMYKB6-gA:9 a=QEXdDO2ut3YA:10 a=-ih6mO1-NhmgiRZhwRoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111221123624.193898256@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 07:36:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no stop-machine, update stack tracer
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This patch set contains a few things.

1) various fixes and cleanups, one is even marked as stable, but its
   a minor bug fix that probably is not worth pushing to mainline this
   late in the -rc.

2) The infrastructure to use ftrace function tracing without stop_machine.
  Although x86 doesn't have the iret code finished to do this yet,
  other archs like PPC can. This will also test out the code better.
  Note, it's just a single patch left that converts x86 to use this code.

3) Moving the stack tracer to its own function list. As Jiri is
   working on having perf do function tracing, he found a few bugs
   that were hard to find without another user outside the global users.
   It makes sense to have the stack tracer separate from the function
   tracer anyway, and it gives a good test bed for perf and function
   tracing as well.

-- Steve

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 38b78eb855409a05f9d370228bec1955e6878e08


Jiri Olsa (1):
      ftrace: Fix unregister ftrace_ops accounting

Steven Rostedt (14):
      ftrace: Do not function trace inlined functions
      ftrace: Allow archs to modify code without stop machine
      ftrace: Remove usage of "freed" records
      ftrace: Allocate the mcount record pages as groups
      ftrace: Replace record newlist with record page list
      ftrace: Sort the mcount records on each page
      ftrace: Use bsearch to find record ip
      ftrace: Fix ftrace hash record update with notrace
      ftrace: Create ftrace_hash_empty() helper routine
      ftrace: Allow other users of function tracing to use the output listi=
ng
      ftrace: Decouple hash items from showing filtered functions
      tracing: Have stack_tracer use a separate list of functions
      ftrace: Allow access to the boot time function enabling
      tracing: Have stack tracing set filtered functions at boot

Tejun Heo (1):
      tracing: Factorize filter creation

----
 Documentation/kernel-parameters.txt |    8 +
 include/linux/compiler-gcc.h        |    5 +
 include/linux/ftrace.h              |   76 ++++-
 kernel/trace/ftrace.c               |  715 +++++++++++++++++++++++++------=
----
 kernel/trace/trace_events_filter.c  |  283 +++++++-------
 kernel/trace/trace_stack.c          |   30 ++-
 6 files changed, 767 insertions(+), 350 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO8dMgAAoJEIy3vGnGbaoA4skQAOcgF68fO3ug4MhsMuUbPV4D
7IXQg85c7zpdTVC+1qq4Ff29vr5mGyKDhBdh/FdJnXZoRFphJIKld5YeyjEXiPgu
Wu+lbpxZBz6eET2WDAtFMEPIkp1YXXSGY2f1TPDG4CfL0l4kSH8HrB5sLwh/wV8I
HCSWH2OWMtryvi4bTV32UnRA6ENL+2o6ygseuMOkTjWa039d+qVw+vWgRuXGp4dI
ptoxR3rFORHrB8H9owRlp0CVMcYz0paOb7koHeFbnmHddrVzBbQbEOp7APDeLt1R
idmgU5je+AIBeC1lM55zZnAv5meTEo43heujqgCQCr0SfBtug0QFANs8I10p5nID
G2gzCT9jkL2M7dZU/GKvipxAtKkYjhqsHDUd0pw3N2B5taxDtuM6eavnL6KdiDdp
sdsWdp8iiv1Mnp6GPeFlAg6K7kwPid3bdFthBINlfbJS9nAI6Xat0zx9sI2pueo+
o/PSHIm2MCq8a1goB3+pXXelaThE+dUcq72L4BhJVX6EcHt6JoS8CsfKelBHUV67
mLdLkGXpLPSVg4RVbDqm0jc/7z/W0epW9ZhpvOPWm5g//oez4xC+EaqO3e8I9sZZ
hX63Ig7CRlfBjgrWwpd3VkTAqYe3aTTWUczouhCfzkqXEkBaLotFI4w5TlHJ4G8p
YOEO8wMpJPJZoIpqpMF/
=fSuQ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
