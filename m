Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab1FPGyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:54:36 -0400
Received: from linux-sh.org ([111.68.239.195]:57826 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1FPGyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:54:24 -0400
Date: Thu, 16 Jun 2011 15:53:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.0-rc4
Message-ID: <20110616065338.GE7252@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only real thing of note here is the dropping of external libgcc
linking in to the compressed kernel images. This has been a necessary
move in order to get compressed kernels working for FDPIC systems (like
SH-2A) that can't mix FDPIC and non-FDPIC objects (previously these would
either fail to link or just crash on boot, depending on the toolchain).
Instead we're now using the routines provided by arch/sh/lib/ for that
stage, which were cribbed from libgcc in the first place, and also gets
around mismatches between the compressed and uncompressed kernel's libgcc
routines. This should hopefully sort out the remaining issues with
compressed kernel utilization on the nommu parts, which has been plaguing
us for some time.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-3.x.git sh-fixes-for-linus

Which contains:

Kuninori Morimoto (2):
      sh: ecovec: Add renesas_usbhs support
      sh: sh7724: Add USBHS DMAEngine support

Magnus Damm (2):
      dmaengine: shdma: SH_DMAC_MAX_CHANNELS message fix
      drivers: sh: resume enabled clocks fix

Mathias Krause (1):
      sh, exec: remove redundant set_fs(USER_DS)

Paul Mundt (1):
      sh: Remove compressed kernel libgcc dependency.

Srinivas KANDAGATLA (2):
      sh: fix wrong icache/dcache address-array start addr in cache-debugfs.
      sh: Fix up xchg/cmpxchg corruption with gUSA RB.

 arch/sh/boards/mach-ecovec24/setup.c   |   48 ++++++++++++++++++++++++++++++++
 arch/sh/boot/compressed/Makefile       |   22 ++++++++++++--
 arch/sh/include/asm/cmpxchg-grb.h      |   21 ++++++++------
 arch/sh/include/asm/processor_64.h     |    1 -
 arch/sh/include/cpu-sh4/cpu/sh7724.h   |    8 +++++
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |   40 ++++++++++++++++++++++++++
 arch/sh/kernel/process_32.c            |    2 -
 arch/sh/mm/cache-debugfs.c             |   25 +++-------------
 drivers/dma/shdma.c                    |   13 ++++----
 drivers/sh/clk/core.c                  |    2 +-
 10 files changed, 140 insertions(+), 42 deletions(-)
