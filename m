Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258Ab2AFWCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 17:02:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759164Ab2AFWCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 17:02:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org
cc: dhowells@redhat.com, arnd@arndb.de, alan@lxorguk.ukuu.org.uk,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [GIT PULL] User-API header split preliminary patches
Date: Fri, 06 Jan 2012 22:02:03 +0000
Message-ID: <19981.1325887323@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you pull these patches from my GIT repository please?

They prepare the way for splitting out the User API definitions from the
standard kernel internal headers into their own header file directories (there
will be arch-specific directories as well as the common ones).

They have been in linux-next for roughly three weeks.

I have audited them from my initial patch submission to get rid of patches
that are no longer necessary.

I have also built allyesconfig with all the cross-compilers I can create on
the full patch spectrum (on the uapi-split branch in the same tree) and
eliminated the problems created.

Can you please consider pulling the further patchset that actually performs
the split at the end of the merge window.  It *will* need regenerating
whenever it is pulled, but is mostly scripted.

Thanks,
David
---
The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

  Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
  git://git.infradead.org/users/dhowells/linux-headers.git for-next

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
