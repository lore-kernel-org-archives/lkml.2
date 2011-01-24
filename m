Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab1AXRk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:40:59 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52063 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1AXRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:40:58 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sQp7J3M9NPKfiEFm4WLiy
Date: Mon, 24 Jan 2011 09:40:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.38-rc2
Message-ID: <20110124174043.GA13589@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

This is mostly to fix issues with recent omap1_defconfig and sched_clock
changes.

We need both the MPU timer and the 32KiHz timer usable together for
omap1_defconfig. This is needed as the 32KiHz timer is not available on
omap15xx or 730. Did not notice this earlier with omap1_defconfig as it
does not have CONFIG_PRINTK_TIME set currently..

Regards,

Tony


The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Adrian Hunter (1):
      omap: DMA: clear interrupt status correctly

Daniel Morsing (1):
      OMAP3: Devkit8000: Fix tps65930 pullup/pulldown configuration

Felipe Balbi (1):
      OMAP: PRCM: remove duplicated headers

Igor Grinberg (2):
      arm: omap3: cm-t3517: rtc fix
      arm: omap3: cm-t3517: minor comment fix

Paul Walmsley (2):
      OMAP: counter_32k: init clocksource as part of machine timer init
      OMAP4: clockdomain: bypass unimplemented wake-up dependency functions on OMAP4

Tony Lindgren (4):
      Merge branch 'fixes_a_2.6.38rc' of git://git.pwsan.com/linux-2.6 into omap-fixes
      omap1: Fix sched_clock for the MPU timer
      omap1: Fix booting for 15xx and 730 with omap1_defconfig
      omap1: Fix sched_clock implementation when both MPU timer and 32K timer are used

 arch/arm/mach-omap1/Kconfig                 |    2 +
 arch/arm/mach-omap1/Makefile                |    3 +-
 arch/arm/mach-omap1/time.c                  |  101 +++++++++++++++++++++++++--
 arch/arm/mach-omap1/timer32k.c              |   13 ++--
 arch/arm/mach-omap2/board-cm-t3517.c        |   29 ++++++--
 arch/arm/mach-omap2/board-devkit8000.c      |    3 +-
 arch/arm/mach-omap2/clock44xx_data.c        |    1 -
 arch/arm/mach-omap2/clockdomain.c           |   30 +++++++-
 arch/arm/mach-omap2/clockdomains44xx_data.c |    2 -
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c  |    1 -
 arch/arm/mach-omap2/timer-gp.c              |   10 ++-
 arch/arm/plat-omap/Kconfig                  |    8 +--
 arch/arm/plat-omap/counter_32k.c            |   22 ++++--
 arch/arm/plat-omap/dma.c                    |    7 +-
 arch/arm/plat-omap/include/plat/common.h    |    3 +
 15 files changed, 184 insertions(+), 51 deletions(-)
