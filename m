Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab0KXHit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:38:49 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46849 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0KXHir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:38:47 -0500
Date: Wed, 24 Nov 2010 16:38:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.37-rc4
Message-ID: <20101124073800.GA2212@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A fairly straightforward set of fixes. Now that we're later in .37, I've
also opted to kill off an unused API call in the clock framework, isolate
legacy support, and update the users accordingly. This will prevent new
users being added in .38, which are already popping up.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh-fixes-for-linus

Which contains:

Giuseppe CAVALLARO (3):
      sh: avoid to flush all cache in sys_cacheflush
      sh: fix vsyscall compilation due to .eh_frame issue
      sh: Use GCC __builtin_prefetch() to implement prefetch().

Paul Mundt (4):
      sh: clkfwk: Kill off unused clk_set_rate_ex().
      sh: clkfwk: Kill off now unused algo_id in set_rate op.
      sh: clkfwk: Disable init clk op for non-legacy clocks.
      sh: clkfwk: Build fix for non-legacy CPG changes.

 Documentation/DocBook/sh.tmpl            |    4 ---
 Documentation/sh/clk.txt                 |   32 ----------------------------
 arch/arm/mach-shmobile/clock-sh7372.c    |    6 +---
 arch/sh/include/asm/processor_32.h       |    7 ++++-
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c   |    2 +-
 arch/sh/kernel/sys_sh.c                  |    2 +-
 arch/sh/kernel/vsyscall/vsyscall-trapa.S |    2 +-
 drivers/sh/clk/core.c                    |   16 +++++--------
 drivers/sh/clk/cpg.c                     |    7 ++---
 include/linux/sh_clk.h                   |   34 ++---------------------------
 10 files changed, 22 insertions(+), 90 deletions(-)
 delete mode 100644 Documentation/sh/clk.txt
