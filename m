Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab1KBCZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:25:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52482 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab1KBCXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 12/12] arm-soc new soc ports
Date: Wed, 2 Nov 2011 03:21:56 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111020321.56389.arnd@arndb.de>
X-Provags-ID: V02:K0:emJGpxMr9XiMCf+5xCif075cDWom0UdJbgYDhsXQuE9
 bCP8EuaT+xS+OfyR71qKdc6UXJk/jUG0hWbO5ITrhOcn1+V0r8
 PdZMt3GDtzwFkjmpMVUwAePkMmRtm3iMfKgy8xrNZP8lCP8CRz
 a+wMHeGPS6a7OHxJvUdq8YPMZNYtBx21tBRxEdAN0DzE+P34vo
 5g73frCSTyWCnHCncuCbcisvaNfIiqWGMCI3MsviOAHJSjd0eY
 rjfWqKxwUnu52UYWNBHAcgn93usnWILizvvcsKdkIevAc0ZLBm
 Ybhhu3UUf7h0uacPxYoMZHoY4PQ8Q3KSw+f6qNOvy9tvOvovX/
 rGNrnWwCKbwDHa0+BRPg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The final request for today, this adds two new subarchitectures (highbank
and picoxcell) and one new soc family in an existing subarchitecture (imx6q).
All of these use device tree based probing only so they will never require
board files in the platform directory.

The following changes since commit eed7041a509503610fd0ccb5042a14de5759bd6b:

  Merge branch 'next/dt' into for-linus (2011-11-01 17:14:14 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/soc

Arnd Bergmann (12):
      Merge branch 'depends/rmk/debug' into tmp
      Merge branch 'depends/rmk/smp' into tmp
      Merge branches 'depends/rmk/io', 'depends/rmk/l2x0' and 'depends/rmk/gpio' into highbank/soc
      Merge branch 'depends/rmk/debug' into highbank/soc
      Merge branch 'dt/gic' into highbank/soc
      Merge branch 'depends/rmk/devel-stable' into imx/imx6q
      Merge branch 'dt/gic' into imx/imx6q
      Merge branch 'imx/devel' into imx/imx6q
      Merge branch 'cross-platform/debug_ll' into imx/imx6q
      Merge branch 'highbank/soc' into next/soc
      Merge branch 'picoxcell/soc' into next/soc
      Merge branch 'imx/imx6q' into next/soc

Jamie Iles (5):
      picoxcell: support for Picochip picoxcell devices
      picoxcell: add the DTS for pc3x2 and pc3x3 devices
      picoxcell: add the DTS for the PC7302 board
      picoxcell: remove custom ioremap implementation
      picoxcell: add a definition of VMALLOC_END

Martin Bogomolni (1):
      ARM: highbank: Add cpu hotplug support

Rob Herring (6):
      ARM: l2x0: add empty l2x0_of_init
      ARM: highbank: add devicetree source
      ARM: add Highbank core platform support
      MAINTAINERS: add Calxeda Highbank ARM platform
      ARM: highbank: add SMP support
      ARM: highbank: add suspend support

Sascha Hauer (1):
      arm/imx: merge i.MX3 and i.MX6

Shawn Guo (8):
      arm/imx6q: add device tree source
      arm/imx6q: add core definitions and low-level debug uart
      arm/imx: add gic_handle_irq function
      arm/imx6q: add core drivers clock, gpc, mmdc and src
      arm/imx6q: add smp and cpu hotplug support
      arm/imx6q: add device tree machine support
      arm/imx6q: add suspend/resume support
      MAINTAINERS: add ARM/FREESCALE IMX6 entry

 Documentation/devicetree/bindings/arm/calxeda.txt  |    8 +
 Documentation/devicetree/bindings/arm/fsl.txt      |    7 +
 .../devicetree/bindings/arm/picoxcell.txt          |   24 +
 MAINTAINERS                                        |   13 +
 arch/arm/Kconfig                                   |   34 +-
 arch/arm/Kconfig.debug                             |   14 +
 arch/arm/Makefile                                  |    4 +-
 arch/arm/boot/dts/highbank.dts                     |  198 ++
 arch/arm/boot/dts/imx6q-sabreauto.dts              |   62 +
 arch/arm/boot/dts/imx6q.dtsi                       |  575 ++++++
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi             |  249 +++
 arch/arm/boot/dts/picoxcell-pc3x3.dtsi             |  365 ++++
 arch/arm/boot/dts/picoxcell-pc7302-pc3x2.dts       |   86 +
 arch/arm/boot/dts/picoxcell-pc7302-pc3x3.dts       |   92 +
 arch/arm/include/asm/hardware/cache-l2x0.h         |    9 +-
 arch/arm/mach-highbank/Makefile                    |    6 +
 arch/arm/mach-highbank/Makefile.boot               |    1 +
 arch/arm/mach-highbank/clock.c                     |   62 +
 arch/arm/mach-highbank/core.h                      |    9 +
 arch/arm/mach-highbank/highbank.c                  |  145 ++
 arch/arm/mach-highbank/hotplug.c                   |   56 +
 arch/arm/mach-highbank/include/mach/debug-macro.S  |   19 +
 arch/arm/mach-highbank/include/mach/entry-macro.S  |    7 +
 arch/arm/mach-highbank/include/mach/gpio.h         |    1 +
 arch/arm/mach-highbank/include/mach/io.h           |    7 +
 arch/arm/mach-highbank/include/mach/irqs.h         |    6 +
 arch/arm/mach-highbank/include/mach/memory.h       |    1 +
 arch/arm/mach-highbank/include/mach/system.h       |   26 +
 arch/arm/mach-highbank/include/mach/timex.h        |    6 +
 arch/arm/mach-highbank/include/mach/uncompress.h   |    9 +
 arch/arm/mach-highbank/include/mach/vmalloc.h      |    1 +
 arch/arm/mach-highbank/lluart.c                    |   34 +
 arch/arm/mach-highbank/localtimer.c                |   40 +
 arch/arm/mach-highbank/platsmp.c                   |   78 +
 arch/arm/mach-highbank/pm.c                        |   55 +
 arch/arm/mach-highbank/sysregs.h                   |   52 +
 arch/arm/mach-highbank/system.c                    |   33 +
 arch/arm/mach-imx/Kconfig                          |   30 +-
 arch/arm/mach-imx/Makefile                         |   11 +
 arch/arm/mach-imx/Makefile.boot                    |    4 +
 arch/arm/mach-imx/clock-imx6q.c                    | 2012 ++++++++++++++++++++
 arch/arm/mach-imx/gpc.c                            |  113 ++
 arch/arm/mach-imx/head-v7.S                        |   99 +
 arch/arm/mach-imx/hotplug.c                        |   44 +
 arch/arm/mach-imx/lluart.c                         |   32 +
 arch/arm/mach-imx/localtimer.c                     |   35 +
 arch/arm/mach-imx/mach-imx6q.c                     |   84 +
 arch/arm/mach-imx/mmdc.c                           |   72 +
 arch/arm/mach-imx/platsmp.c                        |   85 +
 arch/arm/mach-imx/pm-imx6q.c                       |   70 +
 arch/arm/mach-imx/src.c                            |   49 +
 arch/arm/mach-picoxcell/Makefile                   |    3 +
 arch/arm/mach-picoxcell/Makefile.boot              |    1 +
 arch/arm/mach-picoxcell/common.c                   |   55 +
 arch/arm/mach-picoxcell/common.h                   |   18 +
 arch/arm/mach-picoxcell/include/mach/debug-macro.S |   35 +
 arch/arm/mach-picoxcell/include/mach/entry-macro.S |   19 +
 arch/arm/mach-picoxcell/include/mach/gpio.h        |    1 +
 arch/arm/mach-picoxcell/include/mach/hardware.h    |   21 +
 arch/arm/mach-picoxcell/include/mach/io.h          |   22 +
 arch/arm/mach-picoxcell/include/mach/irqs.h        |   25 +
 arch/arm/mach-picoxcell/include/mach/map.h         |   25 +
 arch/arm/mach-picoxcell/include/mach/memory.h      |    1 +
 .../mach-picoxcell/include/mach/picoxcell_soc.h    |   25 +
 arch/arm/mach-picoxcell/include/mach/system.h      |   31 +
 arch/arm/mach-picoxcell/include/mach/timex.h       |   25 +
 arch/arm/mach-picoxcell/include/mach/uncompress.h  |   21 +
 arch/arm/mach-picoxcell/include/mach/vmalloc.h     |   14 +
 arch/arm/mach-picoxcell/io.c                       |   32 +
 arch/arm/mach-picoxcell/time.c                     |  132 ++
 arch/arm/mm/Kconfig                                |    4 +-
 arch/arm/plat-mxc/Kconfig                          |   11 +-
 arch/arm/plat-mxc/Makefile                         |    2 +-
 arch/arm/plat-mxc/gic.c                            |   48 +
 arch/arm/plat-mxc/include/mach/common.h            |   29 +
 arch/arm/plat-mxc/include/mach/debug-macro.S       |    2 +
 arch/arm/plat-mxc/include/mach/entry-macro.S       |    6 +
 arch/arm/plat-mxc/include/mach/hardware.h          |    6 +
 arch/arm/plat-mxc/include/mach/irqs.h              |   10 +-
 arch/arm/plat-mxc/include/mach/mx6q.h              |   33 +
 80 files changed, 5778 insertions(+), 13 deletions(-)

