Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2JLU2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:28:51 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:17318 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2JLU2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:28:50 -0400
Message-ID: <50787D80.9040202@tilera.com>
Date: Fri, 12 Oct 2012 16:28:48 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile updates for 3.7
References: <21212.1349774162@warthog.procyon.org.uk>
In-Reply-To: <21212.1349774162@warthog.procyon.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

Note that this is not based off the 3.6.0 release but off an intermediate
point that includes David Howell's uapi disintegration work; the bulk
of this change is the tile uapi disintegration.  There is also a one-line
change in here to enable interrupts in do_work_pending() to avoid a
WARN_ON in _local_bh_enable_ip().

----------------------------------------------------------------
Chris Metcalf (2):
      Merge tag 'tags/disintegrate-tile-20121009' into for-linus
      arch/tile: enable interrupts in do_work_pending()

David Howells (2):
      UAPI: (Scripted) Disintegrate arch/tile/include/arch
      UAPI: (Scripted) Disintegrate arch/tile/include/asm

 arch/tile/include/arch/Kbuild                      |   17 ----
 arch/tile/include/arch/spr_def.h                   |   12 +--
 arch/tile/include/asm/Kbuild                       |    3 -
 arch/tile/include/asm/hardwall.h                   |   33 +-------
 arch/tile/include/asm/ptrace.h                     |   72 +---------------
 arch/tile/include/asm/setup.h                      |    7 +-
 arch/tile/include/asm/signal.h                     |   12 +--
 arch/tile/include/asm/unistd.h                     |   25 +-----
 arch/tile/include/uapi/arch/Kbuild                 |   17 ++++
 arch/tile/include/{ => uapi}/arch/abi.h            |    0
 arch/tile/include/{ => uapi}/arch/chip.h           |    0
 arch/tile/include/{ => uapi}/arch/chip_tile64.h    |    0
 arch/tile/include/{ => uapi}/arch/chip_tilegx.h    |    0
 arch/tile/include/{ => uapi}/arch/chip_tilepro.h   |    0
 arch/tile/include/{ => uapi}/arch/icache.h         |    0
 arch/tile/include/{ => uapi}/arch/interrupts.h     |    0
 arch/tile/include/{ => uapi}/arch/interrupts_32.h  |    0
 arch/tile/include/{ => uapi}/arch/interrupts_64.h  |    0
 arch/tile/include/{ => uapi}/arch/opcode.h         |    0
 arch/tile/include/{ => uapi}/arch/opcode_tilegx.h  |    0
 arch/tile/include/{ => uapi}/arch/opcode_tilepro.h |    0
 arch/tile/include/{ => uapi}/arch/sim.h            |    0
 arch/tile/include/{ => uapi}/arch/sim_def.h        |    0
 arch/tile/include/uapi/arch/spr_def.h              |   26 ++++++
 arch/tile/include/{ => uapi}/arch/spr_def_32.h     |    6 +-
 arch/tile/include/{ => uapi}/arch/spr_def_64.h     |    6 +-
 arch/tile/include/uapi/asm/Kbuild                  |   15 ++++
 arch/tile/include/{ => uapi}/asm/auxvec.h          |    0
 arch/tile/include/{ => uapi}/asm/bitsperlong.h     |    0
 arch/tile/include/{ => uapi}/asm/byteorder.h       |    0
 arch/tile/include/{ => uapi}/asm/cachectl.h        |    0
 arch/tile/include/uapi/asm/hardwall.h              |   51 ++++++++++++
 arch/tile/include/{ => uapi}/asm/kvm_para.h        |    0
 arch/tile/include/{ => uapi}/asm/mman.h            |    0
 arch/tile/include/uapi/asm/ptrace.h                |   88 ++++++++++++++++++++
 arch/tile/include/uapi/asm/setup.h                 |   21 +++++
 arch/tile/include/{ => uapi}/asm/sigcontext.h      |    0
 arch/tile/include/{ => uapi}/asm/siginfo.h         |    0
 arch/tile/include/uapi/asm/signal.h                |   27 ++++++
 arch/tile/include/{ => uapi}/asm/stat.h            |    0
 arch/tile/include/{ => uapi}/asm/swab.h            |    0
 arch/tile/include/uapi/asm/unistd.h                |   34 ++++++++
 arch/tile/kernel/process.c                         |    3 +
 43 files changed, 298 insertions(+), 177 deletions(-)
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

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

