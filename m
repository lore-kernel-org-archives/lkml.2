Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab2FAPA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:00:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8445 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab2FAPA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:00:58 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=q6E-Bh13THwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=jjtBtDzv-8ZTsxaYZnEA:9 a=QEXdDO2ut3YA:10 a=ObvkPf1i8bUTJAiDNwkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120601145702.428441016@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Jun 2012 10:57:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 0/5 v2] [RFC] ftrace: Fix bug with function tracing and lockdep
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


This is an updated version with input from H. Peter Anvin and Peter Zijlstr=
a.
It may still not be up to par to actually pull. I would like to hear
more comments from people.

Yes, the NMI/INT3/Lockdep is complex. But I believe this is the nature
of the beast. If someone can come up with a simpler solution, I'm all ears.
Right now, the upstream tree has a bug when enabling function tracer
when lockdep is enabled that may crash the system.

Thoughts on this?

-- Steve

These are in the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-2

Head SHA1: 5963e317b1e9d2a4511503916d8fd664bb8fa8fb


Steven Rostedt (5):
      ftrace: Synchronize variable setting with breakpoints
      ftrace: Use breakpoint method to update ftrace caller
      x86: Reset the debug_stack update counter
      x86: Allow nesting of the debug stack IDT setting
      ftrace/x86: Do not change stacks in DEBUG when calling lockdep

----
 arch/x86/include/asm/ftrace.h |    2 +-
 arch/x86/kernel/cpu/common.c  |    8 +++-
 arch/x86/kernel/entry_64.S    |   44 ++++++++++++++++--
 arch/x86/kernel/ftrace.c      |  102 +++++++++++++++++++++++++++++++++++++=
+---
 arch/x86/kernel/nmi.c         |    6 ++-
 arch/x86/kernel/traps.c       |    8 +++-
 6 files changed, 154 insertions(+), 16 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPyNklAAoJEIy3vGnGbaoAsUcQAKUh2lrjTYSR3vCmXC/fzxk7
KGKgHX9+6uxgcOFNboL2tKEWECY9X2XxTaXu2ViS7vTfk4fq8kQLMjclVrIGMcnT
20coUUtIRwzxeVERZdBgYYwxyPjNC+kXOg71PFb2b0QpAxSzQXUkzAmcdmbljOTj
teLXbtEQjFA2sW57CB3IxSkXQYrltNXnidqHliYsJs1gTk864gLcNvGsBJ+u2JRw
0E49BSGfywi9ccvdchRP/kVrIp3gWle18qTTA6Ez8Wh1hDkHD94fPc65R7wVSwEc
NBBqboXNX4kFxy+65OBxZLDokgZzj0K2Yu0N99LRCmG+pFyKyZ9w4IlgzYlHX1n0
CSEMqZFBK41IISsanMRBS6cW7j7TTtKZnOQwKBc5rELpNf+Wm/nMX10xOVJWgTXH
aLlrQzB63ca68BYh7mvSPqu6+z9lLnvBhXPDKLAenbTTgyAngT3s91SWP1hUhZYc
8EOIfxA2x6d3q6RxEqNf+pFxwozfWJx5F5StmbG69I9KDvxl7Kokit8Ef7gDZvGP
ojFHAOJ/o0qmtDg/d0KwnQY9OA698j0pfiYyMbmuFltMyrPV3FpUg9GX20L7K5ib
oLebhyECmUqTtG+KxrPhApgWff6cVB2M6vpH0ZkPwnFApPHVasyiistfpy+HWVXA
kD3KSwKqODzqM2mG8gLj
=2L8D
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
