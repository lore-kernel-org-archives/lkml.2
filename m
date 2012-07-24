Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2GXWuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 18:50:06 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:39820 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755714Ab2GXWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 18:50:03 -0400
Date: Tue, 24 Jul 2012 15:49:51 -0700
From: Mike Turquette <mturquette@ti.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] clk: changes for v3.6
Message-ID: <20120724224951.GB3220@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the new stuff for the common clk framework.  It is made up of
roughly equal parts core framework enhancements, platform ports and new
exciting Device Tree bindings.

Thanks much,
Mike


The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:

  git://git.linaro.org/people/mturquette/linux.git tags/clk-for-linus

for you to fetch changes up to 137f8a7213d80c1388ca48280c1ef0856b6fec30:

  clk: fix compile for OF && !COMMON_CLK (2012-07-19 14:07:56 -0700)

----------------------------------------------------------------
The common clk framework changes for 3.6 include a small number of core
framework improvments, platform ports and new DT bindings.

----------------------------------------------------------------
Fabio Estevam (1):
      clk: mxs: Fix the GPMI clock name

Grant Likely (2):
      clk: add DT clock binding support
      clk: add DT fixed-clock binding support

Huang Shijie (1):
      clk: mxs: rename the gpmi clock for imx28

Lauri Hintsala (1):
      clk: mxs: imx28: decrease the frequency of ref_io1 for SSP2 and SSP3

Linus Walleij (4):
      ARM: u300: convert to common clock
      ARM: integrator: put symbolic bus names on devices
      clk: add versatile ICST307 driver
      ARM: integrator: convert to common clock

Mark Brown (2):
      clk: Constify struct clk_init_data
      clk: wm831x: Add initial WM831x clock driver

Mike Turquette (2):
      Merge branch 'clk/mxs-for-3.6' of git://git.linaro.org/people/shawnguo/linux-2.6 into clk-3.6
      Merge branch 'clk/mxs-for-3.6' of git://git.linaro.org/people/shawnguo/linux-2.6 into clk-next

Rajendra Nayak (4):
      clk: Add support for power of two type dividers
      clk: Add support for rate table based dividers
      clk: Add CLK_IS_BASIC flag to identify basic clocks
      clk: cache parent clocks only for muxes

Richard Zhao (1):
      clk: mxs: clk_register_clkdev mx28 usb clocks

Rob Herring (3):
      dt: add clock binding doc to primecell bindings
      clk: add highbank clock support
      clk: fix compile for OF && !COMMON_CLK

Shawn Guo (2):
      clk: mxs: add clkdev lookup for pwm
      clk: fix clk_get on of_clk_get_by_name return check

 .../devicetree/bindings/arm/primecell.txt          |    6 +
 .../devicetree/bindings/clock/calxeda.txt          |   17 +
 .../devicetree/bindings/clock/clock-bindings.txt   |  117 ++
 .../devicetree/bindings/clock/fixed-clock.txt      |   21 +
 MAINTAINERS                                        |    1 +
 arch/arm/Kconfig                                   |   10 +-
 arch/arm/boot/dts/highbank.dts                     |   91 +-
 arch/arm/mach-highbank/Makefile                    |    2 +-
 arch/arm/mach-highbank/clock.c                     |   62 -
 arch/arm/mach-highbank/highbank.c                  |    7 +
 arch/arm/mach-integrator/core.c                    |   55 +-
 arch/arm/mach-integrator/include/mach/clkdev.h     |   26 -
 arch/arm/mach-integrator/integrator_ap.c           |    8 +-
 arch/arm/mach-integrator/integrator_cp.c           |   69 +-
 arch/arm/mach-u300/Makefile                        |    2 +-
 arch/arm/mach-u300/clock.c                         | 1504 --------------------
 arch/arm/mach-u300/clock.h                         |   50 -
 arch/arm/mach-u300/core.c                          |   21 +-
 arch/arm/mach-u300/timer.c                         |    2 +-
 arch/arm/plat-versatile/Kconfig                    |    3 +
 arch/arm/plat-versatile/Makefile                   |    2 +-
 drivers/clk/Kconfig                                |    7 +
 drivers/clk/Makefile                               |    8 +-
 drivers/clk/clk-divider.c                          |  189 ++-
 drivers/clk/clk-fixed-factor.c                     |    2 +-
 drivers/clk/clk-fixed-rate.c                       |   25 +-
 drivers/clk/clk-gate.c                             |    2 +-
 drivers/clk/clk-highbank.c                         |  346 +++++
 drivers/clk/clk-mux.c                              |    2 +-
 drivers/clk/clk-u300.c                             |  746 ++++++++++
 drivers/clk/clk-wm831x.c                           |  428 ++++++
 drivers/clk/clk.c                                  |  144 +-
 drivers/clk/clkdev.c                               |   77 +
 drivers/clk/mxs/clk-imx23.c                        |    3 +-
 drivers/clk/mxs/clk-imx28.c                        |   13 +-
 drivers/clk/versatile/Makefile                     |    3 +
 drivers/clk/versatile/clk-icst.c                   |  100 ++
 drivers/clk/versatile/clk-icst.h                   |   10 +
 drivers/clk/versatile/clk-integrator.c             |  111 ++
 include/linux/clk-private.h                        |   22 +-
 include/linux/clk-provider.h                       |   31 +-
 include/linux/clk.h                                |   20 +
 include/linux/platform_data/clk-integrator.h       |    1 +
 include/linux/platform_data/clk-u300.h             |    1 +
 44 files changed, 2542 insertions(+), 1825 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/calxeda.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt
 delete mode 100644 arch/arm/mach-highbank/clock.c
 delete mode 100644 arch/arm/mach-integrator/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-u300/clock.c
 delete mode 100644 arch/arm/mach-u300/clock.h
 create mode 100644 drivers/clk/clk-highbank.c
 create mode 100644 drivers/clk/clk-u300.c
 create mode 100644 drivers/clk/clk-wm831x.c
 create mode 100644 drivers/clk/versatile/Makefile
 create mode 100644 drivers/clk/versatile/clk-icst.c
 create mode 100644 drivers/clk/versatile/clk-icst.h
 create mode 100644 drivers/clk/versatile/clk-integrator.c
 create mode 100644 include/linux/platform_data/clk-integrator.h
 create mode 100644 include/linux/platform_data/clk-u300.h
