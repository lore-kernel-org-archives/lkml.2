Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1LMKkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:40:25 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52178 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab1LMKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:40:20 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [GIT PULL] User API split: Preliminary patches
Date: Tue, 13 Dec 2011 10:03:56 +0000
Message-Id: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Can you pull the following into linux-next, please?

Here's the first part of the first installment of patches to clean up the
kernel header files and sort out the inclusion recursion problems.  The patches
can be found here:

	http://git.infradead.org/users/dhowells/linux-headers.git

at the:

	uapi-preliminary

tag.

This batch is just the static fixes to things and can be divided into three
groups:

 (1) Fixes that should probably be applied anyway.
 
	Tag: uapi-fixes

     Fixes for ELF, a loop in Sparc's headers and a separation for MIPS's
     Kbuild.

 (2) sys/param.h cleanup.

	Tag: uapi-params

     Make MN10300, M32R and FRV use asm-generic/param.h.

 (3) Guard cleanup and simple rearrangement.

	Tag: uapi-preliminary

     Add missing header file guards and split __KERNEL__ combo guards to make
     them easier for the UAPI splitter to handle.

     Do a little rearrangement of some headers to make them more amenable to
     the UAPI split (some need the UAPI headers #including in the middle of the
     file, after some definitions have been made).

Could you also the second part into linux-next at this time?  That involves
some scripted stuff and may need regenerating.  You can see those patches from
the uapi-preliminary tag up to the uapi-prep tag in the GIT tree.

That then would set the stage for Linus to apply the UAPI disintegration
patches (uapi-prep -> uapi-post-split) after -rc1 if he's willing.  However,
those definitely *will* need regenerating.

I have tried building it with the defconfigs for the following arches: alpha,
arm, blackfin, frv, h8300, m32r, m68k, mips, mn10300, powerpc, s390, sh, sparc,
x86 (i386 and x86_64) and xtensa.

David
---
The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.infradead.org/users/dhowells/linux-headers.git ..BRANCH.NOT.VERIFIED..

David Howells (17):
      UAPI: Fix arch/mips/include/asm/Kbuild to have separate header-y lines
      UAPI: Don't include linux/compat.h in sparc's asm/siginfo.h
      UAPI: elf_read_implies_exec() is a kernel-only feature - so hide from userspace
      UAPI: Make MN10300 use asm-generic/param.h
      UAPI: Make M32R use asm-generic/param.h
      UAPI: Make FRV use asm-generic/param.h
      UAPI: Rearrange definition of HZ in asm-generic/param.h
      UAPI: Guard linux/sound.h
      UAPI: Guard linux/isdn_divertif.h
      UAPI: Guard linux/pmu.h
      UAPI: Guard linux/cuda.h
      UAPI: Alter the S390 asm include guards to be recognisable by the UAPI splitter
      UAPI: Fix nested __KERNEL__ guards in video/edid.h
      UAPI: Make linux/patchkey.h easier to parse
      UAPI: Fix AHZ multiple inclusion when __KERNEL__ is removed
      UAPI: Don't have a #elif clause in a __KERNEL__ guard in linux/soundcard.h
      UAPI: Split trivial #if defined(__KERNEL__) && X conditionals

 arch/arm/include/asm/hwcap.h       |    4 +++-
 arch/arm/include/asm/swab.h        |    7 +++++--
 arch/arm/include/asm/unistd.h      |    4 +++-
 arch/frv/include/asm/param.h       |   16 +---------------
 arch/ia64/include/asm/intrinsics.h |   21 +++++++++++++--------
 arch/m32r/include/asm/param.h      |   18 +-----------------
 arch/mips/include/asm/Kbuild       |    4 +++-
 arch/mips/include/asm/types.h      |   10 +++++++---
 arch/mn10300/include/asm/param.h   |   18 +-----------------
 arch/s390/include/asm/chpid.h      |    2 +-
 arch/s390/include/asm/itcw.h       |    2 +-
 arch/s390/include/asm/mman.h       |    4 +++-
 arch/sparc/include/asm/siginfo.h   |    2 --
 arch/tile/include/asm/signal.h     |    4 +++-
 include/asm-generic/param.h        |   13 +++++++------
 include/linux/acct.h               |    3 +++
 include/linux/cuda.h               |    5 +++++
 include/linux/elf.h                |   18 +++++++++---------
 include/linux/isdn_divertif.h      |    4 ++++
 include/linux/mroute6.h            |    4 +++-
 include/linux/patchkey.h           |    4 +++-
 include/linux/pmu.h                |    4 ++++
 include/linux/sound.h              |    4 ++++
 include/linux/soundcard.h          |    4 +++-
 include/video/edid.h               |    6 ++----
 25 files changed, 92 insertions(+), 93 deletions(-)

