Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2JFXQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 19:16:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2JFXQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 19:16:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, arnd@arndb.de, hpa@zytor.com, catalin.marinas@arm.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, ralf@linux-mips.org, ddaney.cavm@gmail.com
Subject: 
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Sun, 07 Oct 2012 00:15:39 +0100
Message-ID: <22758.1349565339@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain


Hi Linus,

Could you pull this branch please?  It contains some fixups for the UAPI stuff.

There are four main parts:

 (1) I found I needed some more fixups in the wake of testing Arm64 (some
     asm/unistd.h files had weird guards that caused problems - mostly in
     arches for which I don't have a compiler) and some __KERNEL__ splitting
     needed to take place in Arm64.

 (2) I found that c6x was missing some __KERNEL__ guards in its asm/signal.h.
     Mark Salter pointed me at a tree with a patch to remove that file
     entirely and use the asm-generic variant instead.  I pulled his tree
     since it also give me a defconfig for c6x to use in testing.

 (3) m68k turned out to have a header installation problem due to it lacking a
     kvm_para.h file.

     The conditional installation bits for linux/kvm_para.h, linux/kvm.h and
     linux/a.out.h weren't very well specified - and didn't work if an arch
     didn't have the asm/ version of that file, but there *was* an
     asm-generic/ version.

     It seems the "ifneq $((wildcard ...),)" for each of those three headers
     in include/kernel/Kbuild is invoked twice during header installation, and
     the second time it matches on the just installed asm-generic/kvm_para.h
     file and thus incorrectly installs linux/kvm_para.h as well.

     Most arches actually have an asm/kvm_para.h, so this wasn't detectable in
     those.

 (4) Fix problems with libfdt.h by reverting the changes to that particular
     header file.

Signed-off-by: David Howells <dhowells@redhat.com>
---
The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23 -0700)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/uapi-prep-20121007

for you to fetch changes up to cb6c88a13060f67ce556a06e279fadf46cc7f244:

  UAPI: Fix libfdt.h's #includes (2012-10-07 00:05:00 +0100)

----------------------------------------------------------------
(from the branch description for uapi-prep local branch)

clone of "master"
UAPI prep branch on 2012-10-07

----------------------------------------------------------------
David Howells (5):
      UAPI: Fix the guards on various asm/unistd.h files
      UAPI: Split compound conditionals containing __KERNEL__ in Arm64
      Merge remote-tracking branch 'c6x/for-linux-next' into uapi-prep
      UAPI: Fix conditional header installation handling (notably kvm_para.h on m68k)
      UAPI: Fix libfdt.h's #includes

Mark Salter (2):
      c6x: make dsk6455 the default config
      c6x: remove c6x signal.h

 arch/arm64/include/asm/hwcap.h      |  4 +++-
 arch/arm64/include/asm/stat.h       |  4 +++-
 arch/arm64/include/asm/unistd.h     |  8 +++-----
 arch/arm64/include/asm/unistd32.h   |  4 ----
 arch/c6x/Makefile                   |  2 ++
 arch/c6x/include/asm/Kbuild         |  1 +
 arch/c6x/include/asm/signal.h       | 17 -----------------
 arch/c6x/include/asm/unistd.h       |  4 ----
 arch/hexagon/include/asm/unistd.h   |  5 -----
 arch/openrisc/include/asm/unistd.h  |  5 -----
 arch/score/include/asm/unistd.h     |  5 -----
 arch/tile/include/asm/unistd.h      |  5 -----
 arch/unicore32/include/asm/unistd.h |  4 ----
 include/asm-generic/unistd.h        |  4 ----
 include/linux/Kbuild                |  9 +++------
 include/linux/libfdt.h              |  4 ++--
 16 files changed, 17 insertions(+), 68 deletions(-)
 delete mode 100644 arch/c6x/include/asm/signal.h

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUHC7lxOxKuMESys7AQK5wA/+Plgrr5QspuJhsovvE31lTIYPT3UYWQlt
DbRMWzrrNhYxtXIR0shOF3MDb8snZRzmv4dupe64vrT8enJYfLOKw8RENYUU3mMA
oSeEjeR7bMfeZ7j8sodGssaZ3nS18VvQWQYQBK+5V4HMJRpjPG/+51isLtMY2Ktg
72KKDC7cSpUusV8bWah7LTpRgH9YFN2vdaa4kGsYUVzAw9WGwjGMsNlDnw4LAzMV
wiNRKbhN9O9BE3SBk8Cbfo0MO2RvmZOoBrzi63VBGhZ5DF1SswWOAkaG2Xh/AUml
9iJopFSFm4Yulx/KPQkN29/DVJN/vB6RaLi7jbbvr2CwBGfJswm5uVOCY590E2rd
3lNL2DXjIykocIuV+GCZRwmZk0oCsIftrSzKextY7rAPyQGU8IFve9mYzb147WA+
Yx3cTqlI2fm3rTGwh/N2Cm6hZMYadE1dL0C7wddMHL3fhN5UdIetiWBFF9zjMEO7
Fd1je1qhAOMID84rfmJnuI/VRdKVJ55X4wcCEkzKFlD/Gs/ySzbISr0gTEpEoiii
n5ogKvKWH3FPcS/Qb2Ie4/jyprupQNnNkj+RtQwtucyp5i5gKaNzTJA4M6UL9Ekr
EY47pieTJVNNuTJYdlShtbKmZzf7AlBKhPJx4tht8wwqzeLGGNZ7uGOVO23j9RY1
9Z5MNlf1bSw=
=SFfq
-----END PGP SIGNATURE-----
--=-=-=--
