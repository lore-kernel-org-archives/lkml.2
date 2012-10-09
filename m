Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab2JIJRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab2JIJQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:16:07 -0400
From: David Howells <dhowells@redhat.com>
To: cmetcalf@tilera.com
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for tile [ver #2]
Date: Tue, 09 Oct 2012 10:16:02 +0100
Message-ID: <21212.1349774162@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the tile tree please.

This is to complete part of the UAPI disintegration for which the preparatory
patches were pulled recently.

Now that the fixups and the asm-generic chunk have been merged, I've
regenerated the patches to get rid of those dependencies and to take account of
any changes made so far in the merge window.  If you have already pulled the
older version of the branch aimed at you, then please feel free to ignore this
request.

The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-tile-20121009

for you to fetch changes up to df842f79f0e2aed9092a73f611f41f03630a3823:

  UAPI: (Scripted) Disintegrate arch/tile/include/asm (2012-10-09 09:47:47 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (2):
      UAPI: (Scripted) Disintegrate arch/tile/include/arch
      UAPI: (Scripted) Disintegrate arch/tile/include/asm

 arch/tile/include/arch/Kbuild                      | 17 -----
 arch/tile/include/arch/spr_def.h                   | 12 +--
 arch/tile/include/asm/Kbuild                       |  3 -
 arch/tile/include/asm/hardwall.h                   | 33 +-------
 arch/tile/include/asm/ptrace.h                     | 72 +-----------------
 arch/tile/include/asm/setup.h                      |  7 +-
 arch/tile/include/asm/signal.h                     | 12 +--
 arch/tile/include/asm/unistd.h                     | 25 +-----
 arch/tile/include/uapi/arch/Kbuild                 | 17 +++++
 arch/tile/include/{ => uapi}/arch/abi.h            |  0
 arch/tile/include/{ => uapi}/arch/chip.h           |  0
 arch/tile/include/{ => uapi}/arch/chip_tile64.h    |  0
 arch/tile/include/{ => uapi}/arch/chip_tilegx.h    |  0
 arch/tile/include/{ => uapi}/arch/chip_tilepro.h   |  0
 arch/tile/include/{ => uapi}/arch/icache.h         |  0
 arch/tile/include/{ => uapi}/arch/interrupts.h     |  0
 arch/tile/include/{ => uapi}/arch/interrupts_32.h  |  0
 arch/tile/include/{ => uapi}/arch/interrupts_64.h  |  0
 arch/tile/include/{ => uapi}/arch/opcode.h         |  0
 arch/tile/include/{ => uapi}/arch/opcode_tilegx.h  |  0
 arch/tile/include/{ => uapi}/arch/opcode_tilepro.h |  0
 arch/tile/include/{ => uapi}/arch/sim.h            |  0
 arch/tile/include/{ => uapi}/arch/sim_def.h        |  0
 arch/tile/include/uapi/arch/spr_def.h              | 26 +++++++
 arch/tile/include/{ => uapi}/arch/spr_def_32.h     |  6 +-
 arch/tile/include/{ => uapi}/arch/spr_def_64.h     |  6 +-
 arch/tile/include/uapi/asm/Kbuild                  | 15 ++++
 arch/tile/include/{ => uapi}/asm/auxvec.h          |  0
 arch/tile/include/{ => uapi}/asm/bitsperlong.h     |  0
 arch/tile/include/{ => uapi}/asm/byteorder.h       |  0
 arch/tile/include/{ => uapi}/asm/cachectl.h        |  0
 arch/tile/include/uapi/asm/hardwall.h              | 51 +++++++++++++
 arch/tile/include/{ => uapi}/asm/kvm_para.h        |  0
 arch/tile/include/{ => uapi}/asm/mman.h            |  0
 arch/tile/include/uapi/asm/ptrace.h                | 88 ++++++++++++++++++++++
 arch/tile/include/uapi/asm/setup.h                 | 21 ++++++
 arch/tile/include/{ => uapi}/asm/sigcontext.h      |  0
 arch/tile/include/{ => uapi}/asm/siginfo.h         |  0
 arch/tile/include/uapi/asm/signal.h                | 27 +++++++
 arch/tile/include/{ => uapi}/asm/stat.h            |  0
 arch/tile/include/{ => uapi}/asm/swab.h            |  0
 arch/tile/include/uapi/asm/unistd.h                | 34 +++++++++
 42 files changed, 295 insertions(+), 177 deletions(-)
 rename arch/tile/include/{ => uapi}/arch/abi.h (100%)
 rename arch/tile/include/{ => uapi}/arch/chip.h (100%)
 rename arch/tile/include/{ => uapi}/arch/chip_tile64.h (100%)
 rename arch/tile/include/{ => uapi}/arch/chip_tilegx.h (100%)
 rename arch/tile/include/{ => uapi}/arch/chip_tilepro.h (100%)
 rename arch/tile/include/{ => uapi}/arch/icache.h (100%)
 rename arch/tile/include/{ => uapi}/arch/interrupts.h (100%)
 rename arch/tile/include/{ => uapi}/arch/interrupts_32.h (100%)
 rename arch/tile/include/{ => uapi}/arch/interrupts_64.h (100%)
 rename arch/tile/include/{ => uapi}/arch/opcode.h (100%)
 rename arch/tile/include/{ => uapi}/arch/opcode_tilegx.h (100%)
 rename arch/tile/include/{ => uapi}/arch/opcode_tilepro.h (100%)
 rename arch/tile/include/{ => uapi}/arch/sim.h (100%)
 rename arch/tile/include/{ => uapi}/arch/sim_def.h (100%)
 create mode 100644 arch/tile/include/uapi/arch/spr_def.h
 rename arch/tile/include/{ => uapi}/arch/spr_def_32.h (98%)
 rename arch/tile/include/{ => uapi}/arch/spr_def_64.h (98%)
 rename arch/tile/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/tile/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/tile/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/tile/include/{ => uapi}/asm/cachectl.h (100%)
 create mode 100644 arch/tile/include/uapi/asm/hardwall.h
 rename arch/tile/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/tile/include/{ => uapi}/asm/mman.h (100%)
 create mode 100644 arch/tile/include/uapi/asm/ptrace.h
 create mode 100644 arch/tile/include/uapi/asm/setup.h
 rename arch/tile/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/tile/include/{ => uapi}/asm/siginfo.h (100%)
 create mode 100644 arch/tile/include/uapi/asm/signal.h
 rename arch/tile/include/{ => uapi}/asm/stat.h (100%)
 rename arch/tile/include/{ => uapi}/asm/swab.h (100%)
 create mode 100644 arch/tile/include/uapi/asm/unistd.h
.
