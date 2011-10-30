Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1J3UGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 16:06:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36351 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1J3UGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 16:06:23 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.21.55]
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 30 Oct 2011 22:06:00 +0200
Message-ID: <CAK=WgbZso1qk5XUTjB1bLXYbezv80SbgyEXJ3Q32U28+cQMfZA@mail.gmail.com>
Subject: [GIT PULL] hwspinlock changes for 3.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org, "Gutierrez, Juan" <jgutierrez@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git for-linus

To receive hwspinlock updates for 3.2.

The only noticeable change is a new hwspinlock driver for
ST-Ericsson's u8500 platform by Mathieu; the rest of the changes are
either cleanups or trivial fixes (one of the fixes also trivially
changes a mach-omap2 file, and is Acked by Tony).

All of the patches have been tested in linux-next and currently there
are no merge conflicts, though I expect one to happen with the arm-sco
tree, as reported (and fixed) by Stephen earlier this month (see
http://www.spinics.net/lists/linux-next/msg16931.html).

I've flagged one of the fixes as stable material (the one from Juan).
Normally I would only send you stable-worthy patches during the rc
cycle and not wait until the merge window, but since the hwspinlock
tree and its upstream path have only materialized quite late in the
cycle (see https://lkml.org/lkml/2011/9/21/249), I've decided this
time to wait for the merge window.

Hope it's ok; please tell me if there are any issues.

Thanks,
Ohad.

The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ohad/hwspinlock.git for-linus

Juan Gutierrez (1):
      hwspinlock/core: use a mutex to protect the radix tree

Mathieu J. Poirier (1):
      hwspinlock/u8500: add hwspinlock driver

Ohad Ben-Cohen (8):
      hwspinlock/core: simplify Kconfig
      hwspinlock/core: simplify 'owner' handling
      hwspinlock/omap: simplify allocation scheme
      hwspinlock/core/omap: fix id issues on multiple hwspinlock devices
      hwspinlock/core: remove stubs for register/unregister
      hwspinlock/core: register a bank of hwspinlocks in a single API call
      hwspinlock/omap: omap_hwspinlock_remove should be __devexit
      hwspinlock: add MAINTAINERS entries

 Documentation/hwspinlock.txt             |   74 +++++++-----
 MAINTAINERS                              |   14 ++
 arch/arm/mach-omap2/hwspinlock.c         |    8 +-
 drivers/hwspinlock/Kconfig               |   27 +++--
 drivers/hwspinlock/Makefile              |    1 +
 drivers/hwspinlock/hwspinlock_core.c     |  204 +++++++++++++++++++-----------
 drivers/hwspinlock/hwspinlock_internal.h |   40 ++++--
 drivers/hwspinlock/omap_hwspinlock.c     |  127 +++++++------------
 drivers/hwspinlock/u8500_hsem.c          |  198 +++++++++++++++++++++++++++++
 include/linux/hwspinlock.h               |   46 +++++--
 10 files changed, 514 insertions(+), 225 deletions(-)
 create mode 100644 drivers/hwspinlock/u8500_hsem.c
