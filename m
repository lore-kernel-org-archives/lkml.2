Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2A1QQa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 11:16:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2A1QQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 11:16:28 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=xg_K_7MrwW4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=MW9TR38vLfj99IOdX0wA:9 a=QEXdDO2ut3YA:10 a=mPq7HgvETZYscd12SH8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120128160925.275163704@goodmis.org>
User-Agent: quilt/0.50-1
Date: Sat, 28 Jan 2012 11:09:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2 or 5 byte nops
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This is the second round with the suggestions made by Peter and Andrew
incorporated (and tested).

We can still let this code sit on LKML for a little bit, to give time
for anyone else that wants to complain about them ;-)

Changes for v2:
	Used GENERIC_NOP5_ATOMIC instead of open coding the nop.
	 (suggested by H. Peter Anvin)

	I also added a comment to the code that explains that the
	JUMP_LABEL_INIT_NOP must match the update_jump_label.c code.

	Used const pointers for default_nop and short_nop.
	 (suggested by Andrew Morton)

Please pull (again, if everyone is OK with them) the latest
 tip/perf/jump-label-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/jump-label-2

Head SHA1: 78498e6a36ca3d192ee6a151d8c081525e6c9abe


Steven Rostedt (5):
      x86/jump-label: Use best default nops for inital jump label calls
      x86/jump-label: Do not bother updating nops if they are correct
      x86/jump-label: Add safety checks to jump label conversions
      jump labels: Add infrastructure to update jump labels at compile time
      x86/jump labels: Use etiher 5 byte or 2 byte jumps

----
 Makefile                          |    7 +
 arch/Kconfig                      |    6 +
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/jump_label.h |   14 ++-
 arch/x86/kernel/jump_label.c      |  109 +++++++++++-
 scripts/Makefile                  |    1 +
 scripts/Makefile.build            |   15 ++-
 scripts/update_jump_label.c       |  341 +++++++++++++++++++++++++++++++++=
++++
 scripts/update_jump_label.h       |  208 ++++++++++++++++++++++
 9 files changed, 688 insertions(+), 14 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPJB9WAAoJEIy3vGnGbaoA5/YQAISPlJdgxMuGh4knhsU3PA9D
IljvADzhq9FH3v0P49IYodVQ4RAxdFVg8eKQXzG6eWW+zkg1U6lPJV0YyinvaybP
YEidtNONhwFOdDh1CG5KYjjFlfHkkQ1i12ctNip1y3iNo8e3j3+S+GlptNfebQ2r
vIsTelMpEnL0PHyk2UuaMTJK5wB5es/kdTmDZjD9dONmXW7S9guuXtfrzI0kAOdT
ZHyniiGOt5WBanJVgVEWXdMm3m+RFYBrU7Xcl52TW6RKVWWLOvkoiQG1596kNXnD
fE1Om8WWItn4nQ9TWSHKdY38KRAZk9X5lqMYkXeBSFkzGAi8YiVGVMD8M61VgBEj
6ImDLUhNPH9hYvH5SOMIaHsu6bMhzWHtiVHcBBE+c6Jo/RMs2Piiq7Pm7ojBEp4m
m0S5EnxugkbNacaENyE4Da/OtA9fduPmJR9EgcAz3K5jP2UaOv04rTf20JC/0KDV
a4nsD94xCU14/5bg/eKeM5ppcc4LaEbtLzXbKeXvEeYTn8qA1p/imFKYU2TM5nLH
ZbsfU3x0O8qSAzEfR0vS5Z5S/zs1+LvnwL6kbAge77YfM4MZ7mdDlc54ch+RDy6v
aZHKUfs87noUOQ3FoSTODh7J6Lmzsii0eEEskmF6HeS43xtdqBZlQMPaiwwtzoCH
bbGAwcJrAGrlZkORKnq8
=lVfS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
