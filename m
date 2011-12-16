Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979Ab1LPXGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:06:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760964Ab1LPXGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:06:16 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=YMl1IyYa2xAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=U8XTnzPkunAKrTWDl7sA:9 a=QEXdDO2ut3YA:10 a=PDeFtCnoCjg3enjj3-QA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111216225906.481643317@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 16 Dec 2011 17:59:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 0/6] [GIT PULL] x86: Workaround for NMI iret woes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

As there hasn't been much discussion about these patches, and I know
that Thomas would really like to get rid of the stop-machine requirement
for ftrace, jump_labels and kprobes, this is the required patch set
for such.

Nothing changed since the RFCs except I added the debug stack counter
to address the issue that Mathieu Desnoyers brought up.

I have the ftrace patches pretty much ready, but I would like to get
these in under the x86 branch. I hope to get this patch series into
3.3, and then I'll push the x86 ftrace patches on top of these for
3.4, along with jump_labels and kprobes.

I'll have ftrace patches that get all the infrastructure needed
for removing stop_machine() out for 3.3 too. This way I can let
powerpc use it and be our guinea pig ;)

Thanks!

-- Steve

Please pull the latest tip/x86/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/x86/core

Head SHA1: babcd54c41922214ff5dae3a6d832638d105f1d0


Linus Torvalds (1):
      x86: Do not schedule while still in NMI context

Steven Rostedt (5):
      x86: Document the NMI handler about not using paranoid_exit
      x86: Add workaround to NMI iret woes
      x86: Keep current stack in NMI breakpoints
      x86: Allow NMIs to hit breakpoints in i386
      x86: Add counter when debug stack is used with interrupts enabled

----
 arch/x86/include/asm/desc.h      |   12 ++
 arch/x86/include/asm/processor.h |   10 ++
 arch/x86/kernel/cpu/common.c     |   34 ++++++
 arch/x86/kernel/entry_64.S       |  208 ++++++++++++++++++++++++++++++++--=
----
 arch/x86/kernel/head_64.S        |    4 +
 arch/x86/kernel/nmi.c            |  101 ++++++++++++++++++
 arch/x86/kernel/traps.c          |   20 ++++
 7 files changed, 356 insertions(+), 33 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO687OAAoJEIy3vGnGbaoAVSkP/3n+Jk55KuD9MEL64bO2iyYC
bjDsBzyCHVAPuoXnkcREVENGcNV5ZAgR2E/JuRAypkhQcEl7vNgPo/jB+VitN9Zw
o5dOtkzQHYPBcn/i/OCJF3IsNEY57GJXSY2t64cMoCREnd4UFBHnF1kl6hjldMdT
jYa9sR36ZaeTMQgd38btl6Am+pDi07QDmwvqmkE/6b7vxqai8IFtnEtLnz7i7Xmp
/nY4oUzHv+h5ooUE9R23GFxRLFNKMDBjvPGnevxYlQ4+mTd/R4IlHNuJAiWL8pEa
LhMYp9zET+fZvnHzVnKSmV3hAnCo/fzvwR2rO6Q2ClMXPEe4MyCtm9O8T2AzyYgj
rwEXGQYE8baXqBeZVDVwram664cs1RHDikBFlYtPBgV4rHDxTlwOFp5lwe0+YdB4
EVdXfCurLnT87hjDgAaaQozG6db6YOLQ7rbjUYozc9ziSEuvyUIKKX1G+JIA9ERy
C+TE01PDWfnwv0P2Q3GdLQfm2MlwMIOhKN+rAav8Q7MiEgnNGljDJ4pgDEgqGDCQ
shqwm/X/LDv6DUEGc1qmCvavE9mHGPHK97AwMoAQIyBD34Ty6H+lvomdclaSzsGn
L6tByNTt7sC/eqHsVpfRgONwk3kBn8GLcf0FhmgKzrKyKnFsrjcoWkKC+ODKYLaN
Y9v056UQniqD/OOVom7L
=b43s
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
