Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2A0UUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:20:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2A0UUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:20:32 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=NQ0dQ-J0xrQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=o8b9V7M6zOvQT65sEHAA:9 a=QEXdDO2ut3YA:10 a=BrAv_YvV46-0P4df9tsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120127201442.080360013@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 27 Jan 2012 15:14:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL] x86/jump label: Paranoid checks and 2 or 5 byte nops
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ingo,

I've done some final clean ups of the 2 or 5 byte nop code and I also added
a few generic clean ups of jump label itself. The first 2 patches use the
best nops as defined by Peter when we do not know what the machine is runni=
ng.

The third patch adds paranoid checks, to make sure what we are modifying
is truely what it expects. Otherwise we bug and crash the kernel
(as recommended by Peter).

The last two patches are the clean up versions of the 2 or 5 byte nops.

Note, there is code in the infrastructure that can be shared among
other users in scripts and elsewhere. I rather get this code in first
and then fiddle with seeing who does what and then integrate all the
code together. As that may not be such an easy task, and I don't want
to post pone this code due to it.

Also, I feel that we can let this code sit for a bit on LKML and let
people comment. If everyone gives there acks, then we can pull this code
in. I already tested it, but if there are acks, I can rebase just to
update the acked-bys.

Please pull (if everyone's OK with it) the latest tip/perf/jump-label tree,
 which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/jump-label

Head SHA1: 7837dddecaa7e7f31b732a0c302a4bdd255a8321


Steven Rostedt (5):
      x86/jump-label: Use best default nops for inital jump label calls
      x86/jump-label: Do not bother updating nops if they are correct
      x86/jump-label: Add safety checks to jump label conversions
      jump labels: Add infrastructure to update jump labels at compile time
      jump labels/x86: Use etiher 5 byte or 2 byte jumps

----
 Makefile                          |    7 +
 arch/Kconfig                      |    6 +
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/jump_label.h |    9 +-
 arch/x86/kernel/jump_label.c      |  110 +++++++++++-
 scripts/Makefile                  |    1 +
 scripts/Makefile.build            |   15 ++-
 scripts/update_jump_label.c       |  335 +++++++++++++++++++++++++++++++++=
++++
 scripts/update_jump_label.h       |  208 +++++++++++++++++++++++
 9 files changed, 678 insertions(+), 14 deletions(-)


--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPIwcLAAoJEIy3vGnGbaoATbIQAO2tu6Juep5vUfMfZ4D8ZWYN
kVZJlRRKH4GflK0UfxIdABf+SW/vgCWuZnyfPFoTq+NDA9r/hv40qJ1rwmBqzZ1o
uAJp0Ex1VNCrVnw56u1Hoz40Qmjo7YRqaMzt6k4WMaZ92679BGsQb83dZVoUhvg9
JfHJsgCPMcdF2Yad1Zt9K33oehJFxv8ObrwZaZUXG4/lhHLaBW/yYIW9jlmllsEC
Pn982BJYB0rEIzjiLK9d64wXxgkI8x8z6jIn8tE0+YVMXkEwP/NoaqsG8Qv8/5xj
6Jc+or5rrgsgkgO+P3JVn9Inw9Pn0u9tvpGlKk/sAdeFSzyirfRuo8L0rU3tdeKj
gsLJWUle12G/bqtccWbXWUePQio+kkmiGoH1mppc2J9jIaePP75/h63+qGKmhWez
/k7RSkGai643lzyDGsUee9LkcnxuCpgst/3OBXy0cqk963QpX3Kq8Pp/Eu2MZFUc
wWgPEnToErQtbOOhdIypG3gtzxDsN7DDTQO3Q2aVyLnmrl65emqKkNyPJLNo0AVh
2e63VpT8NlFbimOWm9BZdLrB/x4KswbgIX9ulgywT/1BTP8vFI9VrK0F0U/hl72V
eZMC2rCdcdvIy/fvbV1P+jd20e74kFG3i6TktjiSyoquQ1a6pvKCVf7u60q0YL8d
Pk8Ohqjn1Je91zsTAR4M
=ReWS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
