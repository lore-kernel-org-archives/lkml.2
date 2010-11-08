Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0KHBN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 20:13:57 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58168 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0KHBNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 20:13:47 -0500
Date: Mon, 8 Nov 2010 10:13:27 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 2.6.37-rc2
Message-ID: <20101108011327.GA10728@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed at kernel summit, here's the first attempt at bringing the
SH/R-Mobile bits in to a more coherent branch topology within the SH tree
proper. Following this I'll be killing off my ARM tree completely and
simply sticking with this approach.

There's nothing really exciting here, with the exception of the FSIDIV
clock addition. This is something that the HDMI audio depends on and has
up until now been blocked on core infrastructure patches in the SH tree,
all of which were merged during -rc1. These have all been sitting in
-next for the last few weeks and have had extensive out-of-tree testing
since well before that, so there should be no real surprises here.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-fixes-for-linus

Which contains:

Guennadi Liakhovetski (1):
      ARM: mach-shmobile: fix sh7372 after a recent clock framework rework

Kuninori Morimoto (2):
      ARM: mach-shmobile: clock-sh7372: Add FSIDIV clock support
      ARM: mach-shmobile: ap4evb: Add HDMI sound support

Magnus Damm (1):
      ARM: shmobile: remove sh_timer_config clk member

Paul Mundt (3):
      ARM: mach-shmobile: include drivers/sh/Kconfig
      ARM: mach-shmobile: Allow GPIO chips to register IRQ mappings.
      mmc: sh_mmcif: Convert extern inline to static inline.

 arch/arm/mach-shmobile/Kconfig               |    2 +
 arch/arm/mach-shmobile/board-ap4evb.c        |   46 +++++++++++-
 arch/arm/mach-shmobile/clock-sh7372.c        |  102 ++++++++++++++++++++++++++
 arch/arm/mach-shmobile/include/mach/gpio.h   |    4 +-
 arch/arm/mach-shmobile/include/mach/sh7372.h |    2 +
 drivers/clocksource/sh_cmt.c                 |   10 +--
 drivers/clocksource/sh_mtu2.c                |   10 +--
 drivers/clocksource/sh_tmu.c                 |   10 +--
 include/linux/mmc/sh_mmcif.h                 |   18 ++--
 include/linux/sh_timer.h                     |    1 -
 10 files changed, 171 insertions(+), 34 deletions(-)
