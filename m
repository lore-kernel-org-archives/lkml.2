Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2GJJZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:25:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:43799 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2GJJZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:25:47 -0400
Message-ID: <1341912339.2561.36.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jul 2012 19:25:39 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

It looks like my rewrite of our lazy irq scheme is still exposing
"interesting" issues left and right. The previous fixes are now
causing an occasional BUG_ON to trigger (which this patch turns
into a WARN_ON while at it), due to another issue of disconnect
of the lazy irq state vs. the processor state in the idle loop
on pseries and cell.

This should fix it properly once for all moving the nasty code to a common
helper function.

There's also couple more fixes for some debug stuff that didn't build
(and helped resolving those problems so it's worth having), along with
a compile fix for newer gcc's.

Cheers,
Ben.

The following changes since commit 2437fccfbfc83bcb868ccc7fdfe2b5310bf07835:

  Merge tag 'regulator-3.5' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator (2012-07-09 13:43:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 50fb31cfed9218b439360caf7c0399b00042da15:

  tty/hvc_opal: Fix debug function name (2012-07-10 19:16:25 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (4):
      powerpc: More fixes for lazy IRQ vs. idle
      powerpc: Fix build of some debug irq code
      powerpc/numa: Avoid stupid uninitialized warning from gcc
      tty/hvc_opal: Fix debug function name

 arch/powerpc/include/asm/hw_irq.h               |    6 ++-
 arch/powerpc/kernel/irq.c                       |   48 ++++++++++++++++++++++-
 arch/powerpc/mm/numa.c                          |    2 +-
 arch/powerpc/platforms/cell/pervasive.c         |   11 +++---
 arch/powerpc/platforms/pseries/processor_idle.c |   17 ++++----
 drivers/tty/hvc/hvc_opal.c                      |    2 +-
 6 files changed, 69 insertions(+), 17 deletions(-)


