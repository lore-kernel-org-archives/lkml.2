Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2GRPqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:46:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52056 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab2GRPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:46:12 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8656:0:7184:e4bc:3df8:f1e4]
Date: Wed, 18 Jul 2012 08:46:11 -0700
Message-ID: <CAOesGMhKG00w90iddbDDvtfuQw13o6acRs9baoXmicK4pv4-Ug@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes for 3.5
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As mentioned below, these are quite late by this time due to a chance
in submaintainers and their ramp-up time. But they are all valid and
well-contained fixes. Line count is high since it involved renaming
clocks, the net negative delta is due to a handful of long lines are
no longer needed to be wrapped when clock names were shortened.

In addition to this we did have one branch of at91 fixes pending, but
it needs more work/review and will have to wait for 3.6+stable at this
point.


Please pull, or if you think it's too much churn too late in the cycle
just let us know and we'll queue it for 3.6+stable instead.


Thanks!


-Olof


The following changes since commit 84a1caf1453c3d44050bd22db958af4a7f99315c:

  Linux 3.5-rc7 (2012-07-14 15:40:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

for you to fetch changes up to bae7641ba0c4a0026c2f7e67a0436c890fe16ce3:

  Merge branch 'for-3.5-spear-fixes' of
http://git.stlinux.com/spear/linux-2.6 into fixes (2012-07-17 22:43:53
-0700)

----------------------------------------------------------------

ARM: SoC fixes for SPEAr

These are arriving very late in the release cycle, but there has been
a change of maintainers on the SPEAr platform and they have needed a
while to get going.

The patch count is higher than I would like at this point, but they're
all relevant fixes and well-contained in their own platform code. I still
think it's suitable 3.5 material and I don't think it should increase
the need for a -rc8 since they are so contained.

----------------------------------------------------------------
Olof Johansson (1):
      Merge branch 'for-3.5-spear-fixes' of
http://git.stlinux.com/spear/linux-2.6 into fixes

Stefan Roese (1):
      ARM: SPEAr600: Fix timer interrupt definition in spear600.dtsi

Vipul Kumar Samar (9):
      clk:spear1340:Fix: Rename clk ids within predefined limit
      clk:spear1310:Fix: Rename clk ids within predefined limit
      Clk:spear3xx:Fix: Rename clk ids within predefined limit
      Clk:spear6xx:Fix: Rename clk ids within predefined limit
      ARM: SPEAr13xx: Fix Interrupt bindings
      clk: SPEAr1340: Fix clk enable register for uart1 and i2c1.
      Clk: SPEAr1340: Update sys clock parent array
      ARM: dts: SPEAr320: Fix compatible string
      ARM: dts: SPEAr320: Boot the board in EXTENDED_MODE

 arch/arm/boot/dts/spear13xx.dtsi    |  11 +-
 arch/arm/boot/dts/spear320-evb.dts  |   6 +-
 arch/arm/boot/dts/spear600.dtsi     |   1 +
 arch/arm/mach-spear3xx/spear3xx.c   |   2 +-
 arch/arm/mach-spear6xx/spear6xx.c   |   2 +-
 drivers/clk/spear/spear1310_clock.c | 312 ++++++++++++++++++------------------
 drivers/clk/spear/spear1340_clock.c | 279 ++++++++++++++++----------------
 drivers/clk/spear/spear3xx_clock.c  | 180 ++++++++++-----------
 drivers/clk/spear/spear6xx_clock.c  | 122 +++++++-------
 9 files changed, 451 insertions(+), 464 deletions(-)
