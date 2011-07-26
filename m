Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1GZWYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:24:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab1GZWYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:24:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [GIT PULL] arm-soc new SOCs for 3.1
Date: Wed, 27 Jul 2011 00:24:23 +0200
Message-ID: <3057645.NjCAYUXHGt@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IVr6kD7bEfSWEb1LKsmM0tytlX4czu+yEnCHPSGR7Tr
 6hmI3HpcZPYI8Fm/bc5n7XJdI3KSHvP4sxGIYb4BfS2AVJRJOP
 DExvEnr1HOKDWOB1BVBgYqDdOfV4tYLF4J4dlurVKhX2sgfeiC
 BwNCr7XU0WO24MsdXn7ROaMK92EUwJjohK91CrUVIrKbwlqONV
 o1ILw2YJn5oDkecvy2l3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This adds support for two new platforms and a new OMAP SOC in the
ARM architecture. The new platforms, zynq and prima2, are about as
good as it gets in following the latest set of guidelines for how
to do a platform in ARM. We are working on improving that further,
getting rid of the need for platform specific include/mach/*.h files
one by one, and moving the clock and timer code into drivers.

The infrastructure required for those changes is not there yet, and
I see no reason to keep the new platforms out while waiting for it.
If everything goes well, they will become even cleaner in 3.2 and can
serve as examples for the other platforms in the meantime, showing
everyone where we are headed with the move to device trees instead
of board files.

The OMAP4460 is the current platform from TI, it still largely follows
the same basic pattern as other OMAP, which I think is the best
we can do for that right now. There is a small conflict in
cm-regbits-44xx.h, my solution was

  +/* Renamed from DELTAMSTEP Used by CM_SSC_DELTAMSTEP_DPLL_USB */
  +#define OMAP4460_DELTAMSTEP_0_20_SHIFT                                0
  +#define OMAP4460_DELTAMSTEP_0_20_MASK                         (0x1fffff << 0)
  +
 - /* Used by CM_SHADOW_FREQ_CONFIG1, CM_SHADOW_FREQ_CONFIG1_RESTORE */
 - #define OMAP4430_DLL_OVERRIDE_SHIFT                           2
 - #define OMAP4430_DLL_OVERRIDE_MASK                            (1 << 2)
 + /* Used by CM_DLL_CTRL */
 + #define OMAP4430_DLL_OVERRIDE_SHIFT                           0
 + #define OMAP4430_DLL_OVERRIDE_MASK                            (1 << 0)
  
 - /* Renamed from DLL_OVERRIDE Used by CM_DLL_CTRL */
 - #define OMAP4430_DLL_OVERRIDE_0_0_SHIFT                               0
 - #define OMAP4430_DLL_OVERRIDE_0_0_MASK                                (1 << 0)
 + /* Renamed from DLL_OVERRIDE Used by CM_SHADOW_FREQ_CONFIG1 */
 + #define OMAP4430_DLL_OVERRIDE_2_2_SHIFT                               2
 + #define OMAP4430_DLL_OVERRIDE_2_2_MASK                                (1 << 2)

All the branches I'm sending today are also merged in the for-next
branch of arm-soc, so you can also pull that one instead if you get
bored by the conflicts and just want to have it all.

The diffstat below is the one I generated post-merge, for reasons
I still need to understand better, git-request-pull would otherwise
add the diffstat for the omap/cleanup branch that you have already
pulled.

	Arnd

The following changes since commit ba5b56cb3e3d2cab73d4fee9a022bb69462a8cd9:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2011-07-26 13:38:50 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ next/soc

Aneesh V (2):
      OMAP: ID: introduce chip detection for OMAP4460
      OMAP4: ID: add omap_has_feature for max freq supported

Arnd Bergmann (3):
      ARM: Xilinx: merge board file into main platform code
      Merge branch 'zynq/master' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/soc
      Merge branch 'omap/4460' of git+ssh://master.kernel.org/.../arm/linux-arm-soc into next/soc

Barry Song (2):
      ARM: CSR: mapping early DEBUG_LL uart
      MAINTAINERS: add maintainer of CSR SiRFprimaII machine

Binghua Duan (1):
      ARM: CSR: Adding CSR SiRFprimaII board support

John Linn (1):
      ARM: Xilinx: Adding Xilinx board support

Rajendra Nayak (2):
      OMAP4: PRCM: OMAP4460 specific PRM and CM register bitshifts
      OMAP4: clocks: Update the clock tree with 4460 clock nodes

Rongjun Ying (1):
      ARM: CSR: initializing L2 cache

 Documentation/devicetree/bindings/arm/sirf.txt   |    3 +
 Documentation/devicetree/bindings/arm/xilinx.txt |    7 +
 MAINTAINERS                                      |    6 +
 arch/arm/Kconfig                                 |   26 ++
 arch/arm/Makefile                                |    3 +
 arch/arm/boot/dts/prima2-cb.dts                  |  416 ++++++++++++++++++
 arch/arm/boot/dts/zynq-ep107.dts                 |   52 +++
 arch/arm/mach-omap2/clock44xx_data.c             |   39 ++
 arch/arm/mach-omap2/cm-regbits-44xx.h            |   36 ++
 arch/arm/mach-omap2/id.c                         |   53 ++-
 arch/arm/mach-omap2/prm-regbits-44xx.h           |    8 +
 arch/arm/mach-prima2/Makefile                    |    7 +
 arch/arm/mach-prima2/Makefile.boot               |    3 +
 arch/arm/mach-prima2/clock.c                     |  509 ++++++++++++++++++++++
 arch/arm/mach-prima2/common.h                    |   26 ++
 arch/arm/mach-prima2/include/mach/clkdev.h       |   15 +
 arch/arm/mach-prima2/include/mach/debug-macro.S  |   29 ++
 arch/arm/mach-prima2/include/mach/entry-macro.S  |   29 ++
 arch/arm/mach-prima2/include/mach/hardware.h     |   15 +
 arch/arm/mach-prima2/include/mach/io.h           |   16 +
 arch/arm/mach-prima2/include/mach/irqs.h         |   17 +
 arch/arm/mach-prima2/include/mach/map.h          |   16 +
 arch/arm/mach-prima2/include/mach/memory.h       |   21 +
 arch/arm/mach-prima2/include/mach/system.h       |   29 ++
 arch/arm/mach-prima2/include/mach/timex.h        |   14 +
 arch/arm/mach-prima2/include/mach/uart.h         |   23 +
 arch/arm/mach-prima2/include/mach/uncompress.h   |   40 ++
 arch/arm/mach-prima2/include/mach/vmalloc.h      |   16 +
 arch/arm/mach-prima2/irq.c                       |   71 +++
 arch/arm/mach-prima2/l2x0.c                      |   59 +++
 arch/arm/mach-prima2/lluart.c                    |   25 +
 arch/arm/mach-prima2/prima2.c                    |   41 ++
 arch/arm/mach-prima2/rstc.c                      |   69 +++
 arch/arm/mach-prima2/timer.c                     |  217 +++++++++
 arch/arm/mach-zynq/Makefile                      |    6 +
 arch/arm/mach-zynq/Makefile.boot                 |    3 +
 arch/arm/mach-zynq/common.c                      |  118 +++++
 arch/arm/mach-zynq/common.h                      |   24 +
 arch/arm/mach-zynq/include/mach/clkdev.h         |   32 ++
 arch/arm/mach-zynq/include/mach/debug-macro.S    |   36 ++
 arch/arm/mach-zynq/include/mach/entry-macro.S    |   30 ++
 arch/arm/mach-zynq/include/mach/hardware.h       |   18 +
 arch/arm/mach-zynq/include/mach/io.h             |   33 ++
 arch/arm/mach-zynq/include/mach/irqs.h           |   21 +
 arch/arm/mach-zynq/include/mach/memory.h         |   22 +
 arch/arm/mach-zynq/include/mach/system.h         |   28 ++
 arch/arm/mach-zynq/include/mach/timex.h          |   23 +
 arch/arm/mach-zynq/include/mach/uart.h           |   25 +
 arch/arm/mach-zynq/include/mach/uncompress.h     |   51 +++
 arch/arm/mach-zynq/include/mach/vmalloc.h        |   20 +
 arch/arm/mach-zynq/include/mach/zynq_soc.h       |   48 ++
 arch/arm/mach-zynq/timer.c                       |  298 +++++++++++++
 arch/arm/mm/Kconfig                              |    3 +-
 arch/arm/plat-omap/include/plat/clkdev_omap.h    |    1 +
 arch/arm/plat-omap/include/plat/clock.h          |    2 +
 arch/arm/plat-omap/include/plat/cpu.h            |   35 ++-
 56 files changed, 2820 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/sirf.txt
 create mode 100644 Documentation/devicetree/bindings/arm/xilinx.txt
 create mode 100644 arch/arm/boot/dts/prima2-cb.dts
 create mode 100644 arch/arm/boot/dts/zynq-ep107.dts
 create mode 100644 arch/arm/mach-prima2/Makefile
 create mode 100644 arch/arm/mach-prima2/Makefile.boot
 create mode 100644 arch/arm/mach-prima2/clock.c
 create mode 100644 arch/arm/mach-prima2/common.h
 create mode 100644 arch/arm/mach-prima2/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-prima2/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-prima2/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-prima2/include/mach/hardware.h
 create mode 100644 arch/arm/mach-prima2/include/mach/io.h
 create mode 100644 arch/arm/mach-prima2/include/mach/irqs.h
 create mode 100644 arch/arm/mach-prima2/include/mach/map.h
 create mode 100644 arch/arm/mach-prima2/include/mach/memory.h
 create mode 100644 arch/arm/mach-prima2/include/mach/system.h
 create mode 100644 arch/arm/mach-prima2/include/mach/timex.h
 create mode 100644 arch/arm/mach-prima2/include/mach/uart.h
 create mode 100644 arch/arm/mach-prima2/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-prima2/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-prima2/irq.c
 create mode 100644 arch/arm/mach-prima2/l2x0.c
 create mode 100644 arch/arm/mach-prima2/lluart.c
 create mode 100644 arch/arm/mach-prima2/prima2.c
 create mode 100644 arch/arm/mach-prima2/rstc.c
 create mode 100644 arch/arm/mach-prima2/timer.c
 create mode 100644 arch/arm/mach-zynq/Makefile
 create mode 100644 arch/arm/mach-zynq/Makefile.boot
 create mode 100644 arch/arm/mach-zynq/board_dt.c
 create mode 100644 arch/arm/mach-zynq/common.c
 create mode 100644 arch/arm/mach-zynq/common.h
 create mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-zynq/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-zynq/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-zynq/include/mach/hardware.h
 create mode 100644 arch/arm/mach-zynq/include/mach/io.h
 create mode 100644 arch/arm/mach-zynq/include/mach/irqs.h
 create mode 100644 arch/arm/mach-zynq/include/mach/memory.h
 create mode 100644 arch/arm/mach-zynq/include/mach/system.h
 create mode 100644 arch/arm/mach-zynq/include/mach/timex.h
 create mode 100644 arch/arm/mach-zynq/include/mach/uart.h
 create mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-zynq/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h
 create mode 100644 arch/arm/mach-zynq/timer.c

