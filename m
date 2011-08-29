Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1H2IU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:20:58 -0400
Received: from linux-sh.org ([111.68.239.195]:34077 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097Ab1H2IUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:20:47 -0400
Date: Mon, 29 Aug 2011 17:20:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.1-rc5
Message-ID: <20110829082013.GK31809@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up some unaligned access instruction pairs for SH-2A
toolchains, and other misc fixes. The only thing particularly noteworthy
are the serial runtime PM bits which properly enable context restore on
parts that make effective use of deep sleep states (mostly the R-Mobile
parts at this point), fixing up loss of console issues.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-3.x.git sh-fixes-for-linus

Which contains:

David Engraf (1):
      shwdt: fix usage of mod_timer

Magnus Damm (4):
      clocksource: sh_cmt: wait for CMCNT on init V2
      sh: intc: enable both edges GPIO interrupts on sh7372
      serial: sh-sci: fix DMA build by including dma-mapping.h
      serial: sh-sci: console Runtime PM support

Paul Gortmaker (1):
      sh: Fix conflicting definitions of ptrace_triggered

Paul Mundt (2):
      serial: sh-sci: Fix up default regtype probing.
      sh: Fix up fallout from cpuidle changes.

Phil Edworthy (2):
      sh: Fix unaligned memory access for branches without delay slots
      sh: Add unaligned memory access for PC relative intructions

Takashi YOSHII (1):
      serial: sh-sci: report CTS as active for get_mctrl

Yoshihiro Shimoda (1):
      sh: fix the compile error in setup-sh7757.c

 arch/sh/include/asm/ptrace.h           |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |    1 +
 arch/sh/kernel/idle.c                  |    2 +-
 arch/sh/kernel/traps_32.c              |   37 ++++++++++++++++
 drivers/clocksource/sh_cmt.c           |   34 ++++++++++++++-
 drivers/sh/intc/chip.c                 |    3 +
 drivers/tty/serial/sh-sci.c            |   71 +++++++++++++++++++++++++++-----
 7 files changed, 135 insertions(+), 15 deletions(-)
