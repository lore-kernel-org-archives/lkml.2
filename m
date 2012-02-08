Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab2BJDLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 22:11:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60040 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab2BJDLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 22:11:42 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 00/21] RFC: Make all arches use <asm-generic/posix_types.h>
Date: Tue,  7 Feb 2012 21:08:44 -0800
Message-Id: <1328677745-20121-1-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc: list trimmed to avoid vger filters]

This patchset changes all architectures that don't already use
<asm-generic/posix_types.h> to do so.  The purpose this threefold:

1. There is a dramatic amount of code removal.
2. New types can now be added in one place rather than having to go
   through most of the architectures.
3. Removal of a bunch of old cruft.

The first two patches in the series tweak <asm-generic/posix_types.h>
to be more generally useful: the __kernel_[ug]id32_t types should
logically default to unsigned int instead of being mirrors of
__kernel_[ug]id_t, and the __kernel_fsid_t type is made overridable.

Patches 3-20 are patches for individual architectures; I would greatly
appreciate it if architecture maintainers would review their
respective architectures and verify that the transformation is
correct.  These patches also remove the per-architecture fd_set
macros.

Patch 21, finally, removes the asm-generic version of the fd_set
macros.  These macros were once upon a time exported to user space,
but that is now historic.  Nowadays, they are nothing more than a
re-implementation of the bitops that we already have in the kernel, so
this final patch just replaces those with the appropriate standard
bitops.

Total diffstat:

 arch/alpha/include/asm/posix_types.h   |  113 +--------------------------
 arch/arm/include/asm/posix_types.h     |   55 ++-----------
 arch/avr32/include/asm/posix_types.h   |  107 +++-----------------------
 arch/cris/include/asm/posix_types.h    |   50 +++----------
 arch/frv/include/asm/posix_types.h     |   53 +++----------
 arch/h8300/include/asm/posix_types.h   |   49 ++----------
 arch/ia64/include/asm/posix_types.h    |  121 +----------------------------
 arch/m32r/include/asm/posix_types.h    |  108 ++------------------------
 arch/m68k/include/asm/posix_types.h    |   53 +++----------
 arch/mips/include/asm/posix_types.h    |  117 ++--------------------------
 arch/mn10300/include/asm/posix_types.h |  111 +++------------------------
 arch/parisc/include/asm/posix_types.h  |  119 ++--------------------------
 arch/powerpc/include/asm/posix_types.h |  120 +++--------------------------
 arch/s390/include/asm/posix_types.h    |   70 +++--------------
 arch/sh/include/asm/posix_types_32.h   |    5 -
 arch/sh/include/asm/posix_types_64.h   |    4 -
 arch/sparc/include/asm/posix_types.h   |  133 ++++----------------------------
 arch/x86/include/asm/posix_types_32.h  |   75 ++----------------
 arch/x86/include/asm/posix_types_64.h  |  106 +------------------------
 arch/xtensa/include/asm/posix_types.h  |   97 ++---------------------
 include/asm-generic/posix_types.h      |   86 ++-------------------
 include/linux/time.h                   |   23 ++++++
 22 files changed, 190 insertions(+), 1585 deletions(-)
