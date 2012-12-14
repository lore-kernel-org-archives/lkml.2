Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2LNWGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:06:08 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45176 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab2LNWGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:06:06 -0500
Date: Fri, 14 Dec 2012 14:06:04 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 2/3] ARM: arm-soc: Device-tree updates, take 2
Message-ID: <20121214220604.GC11363@quad.lixom.net>
References: <20121214220441.GA11363@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214220441.GA11363@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This branch contains device-tree updates for the SPEAr platform.
They had dependencies on earlier branches from this merge window,
which is why they were broken out in a separate branch.

Conflicts seen with this merge:

None.

----------------------------------------------------------------

The following changes since commit b035668887bb39bc76d14a5898b597e43b3c5710:

  Merge branch 'next/soc2' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt2

for you to fetch changes up to eabc5fa51c1fae4b66cf883e3a3c2b3ca794494c:

  Merge branch 'spear-for-3.8' of git://git.linaro.org/people/vireshk/linux into next/dt2

----------------------------------------------------------------

Arnd Bergmann (1):
      Merge branch 'spear-for-3.8' of git://git.linaro.org/people/vireshk/linux into next/dt2

Deepak Sikri (1):
      ARM: SPEAr: DT: Modify DT bindings for STMMAC

Shiraz Hashim (6):
      ARM: SPEAr13xx: DT: Add spics gpio controller nodes
      ARM: SPEAr: DT: Update device nodes
      ARM: SPEAr13xx: Remove fields not required for ssp controller
      ARM: SPEAr3xx: shirq: simplify and move the shared irq multiplexor to DT
      ARM: SPEAr3xx: DT: add shirq node for interrupt multiplexor
      ARM: SPEAr320: DT: Add SPEAr 320 HMI board support

Vipin Kumar (1):
      ARM: SPEAr: DT: Update partition info for MTD devices

Vipul Kumar Samar (5):
      ARM: SPEAr: DT: Update pinctrl list
      ARM: SPEAr: DT: Fix existing DT support
      ARM: SPEAr: DT: add uart state to fix warning
      ARM: SPEAr1310: Move 1310 specific misc register into machine specific files
      ARM: SPEAr1310: Fix AUXDATA for compact flash controller

Viresh Kumar (3):
      Merge commit 'pinctrl/devel 4ddb1c2' into spear-for-3.8
      Merge commit 'gpio-lw/devel' into spear-for-3.8
      ARM: SPEAr3xx: Shirq: Move shirq controller out of plat/


 .../devicetree/bindings/arm/spear/shirq.txt     |  48 +++
 arch/arm/boot/dts/Makefile                      |   3 +-
 arch/arm/boot/dts/spear1310-evb.dts             | 165 ++++++++--
 arch/arm/boot/dts/spear1310.dtsi                |  32 +-
 arch/arm/boot/dts/spear1340-evb.dts             | 253 +++++++++++++--
 arch/arm/boot/dts/spear1340.dtsi                |  61 ++++
 arch/arm/boot/dts/spear13xx.dtsi                |  72 ++++-
 arch/arm/boot/dts/spear300-evb.dts              |  20 +-
 arch/arm/boot/dts/spear300.dtsi                 |  14 +-
 arch/arm/boot/dts/spear310-evb.dts              |  30 +-
 arch/arm/boot/dts/spear310.dtsi                 |  18 ++
 arch/arm/boot/dts/spear320-evb.dts              |  35 +-
 arch/arm/boot/dts/spear320-hmi.dts              | 305 ++++++++++++++++++
 arch/arm/boot/dts/spear320.dtsi                 |  39 ++-
 arch/arm/boot/dts/spear3xx.dtsi                 |   5 +-
 arch/arm/boot/dts/spear600-evb.dts              |  46 ++-
 arch/arm/boot/dts/spear600.dtsi                 |  16 +
 arch/arm/mach-spear13xx/include/mach/spear.h    |   8 -
 arch/arm/mach-spear13xx/spear1310.c             |  16 +-
 arch/arm/mach-spear13xx/spear13xx.c             |   2 -
 arch/arm/mach-spear3xx/include/mach/irqs.h      |  10 +-
 arch/arm/mach-spear3xx/spear300.c               | 103 ------
 arch/arm/mach-spear3xx/spear310.c               | 202 ------------
 arch/arm/mach-spear3xx/spear320.c               | 205 +-----------
 arch/arm/mach-spear3xx/spear3xx.c               |   4 +
 arch/arm/plat-spear/Makefile                    |   2 +-
 arch/arm/plat-spear/shirq.c                     | 118 -------
 drivers/clk/spear/spear1310_clock.c             |   1 +
 drivers/irqchip/Makefile                        |   1 +
 drivers/irqchip/spear-shirq.c                   | 316 +++++++++++++++++++
 .../linux/irqchip/spear-shirq.h                 |  49 ++-
 31 files changed, 1425 insertions(+), 774 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/spear/shirq.txt
 create mode 100644 arch/arm/boot/dts/spear320-hmi.dts
 delete mode 100644 arch/arm/plat-spear/shirq.c
 create mode 100644 drivers/irqchip/spear-shirq.c
 rename arch/arm/plat-spear/include/plat/shirq.h => include/linux/irqchip/spear-shirq.h (60%)
