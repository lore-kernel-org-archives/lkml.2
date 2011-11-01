Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1KBCXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:23:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339Ab1KBCW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:22:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 5/13] arm-soc power management updates
Date: Tue, 1 Nov 2011 04:21:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111010421.50368.arnd@arndb.de>
X-Provags-ID: V02:K0:BQ8hvnWy0Qv5tWrgDaFzryPFzu4bh1d3M79aF79/8Sm
 6MxGuG24dzWOk8sCEcNlYE+leO0GX/+/qn4pApTyx9MBXXb8hR
 RH/9fNPRnZlEPUoXrQFx39GlFeh5hLO/PtFXn2KlzuEaHt5Z2R
 cGn2nffklda0DQs5bDdSDtbFHRsPnaVsG022V5VY1P4N+zNo8I
 A/NUgqfnEKx9WwOHWL6w/HI+N9XpD9bvq9a5SFtVhIq1moheoj
 69pfw19229OHvknt5TI1tVR3oZA0PJW+PrqX0gOfL/zNXNBwrz
 Z+o+kyK7hhqqO4PtJkqPr3gP11/9F8McZdeu2ftNg4fk8gjKZj
 m3zkyQZUe5rOdN3EzO2E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power management related changes are mostly voltage regulator cleanup
patches for omap that make the code more sensible, plus some unrelated
sirf-prima2 PM updates.

	Arnd

The following changes since commit 272c49c77acee0b6975b7a4164adaf517cf3cd3d:

  Merge branch 'next/driver' into for-next (2011-11-01 00:37:15 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/pm

Arnd Bergmann (2):
      Merge branch 'for_3.2/voltage-cleanup' of git://gitorious.org/khilman/linux-omap-pm into omap/voltage
      Merge branch 'omap/voltage' into next/pm

Barry Song (8):
      ARM: CSR: add lost Resource Sharing Control(RSC) node in dts
      ARM: CSR: extend the compatibility of gpio controller to pinmux in dts
      ARM: CSR: IRQ: add simple irq_domain so that hw irq can map to Linux
      ARM: CSR: PM: save/restore timer status in suspend cycle
      ARM: CSR: PM: save/restore irq status in suspend cycle
      Merge branch 'l2x0' of rmk tree into prima2-l2x0
      ARM: CSR: call l2x0_of_init to init L2 cache of SiRFprimaII
      ARM: CSR: PM: use outer_resume to resume L2 cache

Benoit Cousson (1):
      OMAP4: powerdomain data: add voltage domains

Kevin Hilman (49):
      OMAP2+: hwmod: remove unused voltagedomain pointer
      OMAP2+: voltage: move PRCM mod offets into VC/VP structures
      OMAP2+: voltage: move prm_irqst_reg from VP into voltage domain
      OMAP2+: voltage: start towards a new voltagedomain layer
      OMAP3: voltage: rename "mpu" voltagedomain to "mpu_iva"
      OMAP3: voltagedomain data: add wakeup domain
      OMAP3+: voltage: add scalable flag to voltagedomain
      OMAP2+: powerdomain: add voltagedomain to struct powerdomain
      OMAP2: add voltage domains and connect to powerdomains
      OMAP3: powerdomain data: add voltage domains
      OMAP2+: powerdomain: add voltage domain lookup during register
      OMAP2+: voltage: keep track of powerdomains in each voltagedomain
      OMAP2+: voltage: split voltage controller (VC) code into dedicated layer
      OMAP2+: voltage: move VC into struct voltagedomain, misc. renames
      OMAP2+: voltage: enable VC bypass scale method when VC is initialized
      OMAP2+: voltage: split out voltage processor (VP) code into new layer
      OMAP2+: VC: support PMICs with separate voltage and command registers
      OMAP2+: add PRM VP functions for checking/clearing VP TX done status
      OMAP3+ VP: replace transaction done check/clear with VP ops
      OMAP2+: PRM: add register access functions for VC/VP
      OMAP3+: voltage: convert to PRM register access functions
      OMAP3+: VC: cleanup i2c slave address configuration
      OMAP3+: VC: cleanup PMIC register address configuration
      OMAP3+: VC bypass: use fields from VC struct instead of PMIC info
      OMAP3+: VC: cleanup voltage setup time configuration
      OMAP3+: VC: move on/onlp/ret/off command configuration into common init
      OMAP3+: VC: abstract out channel configuration
      OMAP3+: voltage domain: move PMIC struct from vdd_info into struct voltagedomain
      OMAP3+: VC: make I2C config programmable with PMIC-specific settings
      OMAP3+: PM: VC: handle mutant channel config for OMAP4 MPU channel
      OMAP3+: VC: use last nominal voltage setting to get current_vsel
      OMAP3+: VP: cleanup: move VP instance into voltdm, misc. renames
      OMAP3+: voltage: remove unneeded debugfs interface
      OMAP3+: VP: struct omap_vp_common: replace shift with __ffs(mask)
      OMAP3+: VP: move SoC-specific sys clock rate retreival late init
      OMAP3+: VP: move timing calculation/config into VP init
      OMAP3+: VP: create VP helper function for updating error gain
      OMAP3+: VP: remove omap_vp_runtime_data
      OMAP3+: VP: move voltage scale function pointer into struct voltagedomain
      OMAP3+: VP: update_errorgain(): return error if VP
      OMAP3+: VP: remove unused omap_vp_get_curr_volt()
      OMAP3+: VP: combine setting init voltage into common function
      OMAP3+: voltage: rename scale and reset functions using voltdm_ prefix
      OMAP3+: voltage: move/rename curr_volt from vdd_info into struct voltagedomain
      OMAP3+: voltdm: final removal of omap_vdd_info
      OMAP3+: voltage: rename omap_voltage_get_nom_volt -> voltdm_get_voltage
      OMAP3+: voltage: update nominal voltage in voltdm_scale() not VC post-scale
      OMAP2+: VC: more registers are per-channel starting with OMAP5
      ARM: OMAP: voltage: voltage layer present, even when CONFIG_PM=n

Nishanth Menon (3):
      OMAP4: PM: TWL6030: fix uv to voltage for >0x39
      OMAP4: PM: TWL6030: address 0V conversions
      OMAP4: PM: TWL6030: add cmd register

Patrick Titiano (2):
      OMAP4: PM: TWL6030: fix voltage conversion formula
      OMAP4: PM: TWL6030: fix ON/RET/OFF voltages

Rongjun Ying (1):
      ARM: CSR: PM: add sleep entry for SiRFprimaII

Tero Kristo (1):
      omap: voltage: add a stub header file for external/regulator use

Todd Poynor (1):
      OMAP: VP: Explicitly mask VPVOLTAGE field

Tony Lindgren (1):
      Merge branch 'for_3.2/voltage-cleanup' of git://gitorious.org/khilman/linux-omap-pm into voltage

Zhiwu Song (1):
      ARM: CSR: add rtc i/o bridge interface for SiRFprimaII

 arch/arm/boot/dts/prima2-cb.dts                  |   14 +-
 arch/arm/mach-omap2/Makefile                     |   88 +-
 arch/arm/mach-omap2/board-2430sdp.c              |    9 +-
 arch/arm/mach-omap2/board-3430sdp.c              |    9 +-
 arch/arm/mach-omap2/board-3630sdp.c              |   11 +-
 arch/arm/mach-omap2/board-4430sdp.c              |    9 +-
 arch/arm/mach-omap2/board-am3517crane.c          |    9 +-
 arch/arm/mach-omap2/board-am3517evm.c            |    8 +-
 arch/arm/mach-omap2/board-apollon.c              |    9 +-
 arch/arm/mach-omap2/board-cm-t35.c               |   13 +-
 arch/arm/mach-omap2/board-cm-t3517.c             |    9 +-
 arch/arm/mach-omap2/board-devkit8000.c           |   12 +-
 arch/arm/mach-omap2/board-generic.c              |    2 +-
 arch/arm/mach-omap2/board-h4.c                   |    9 +-
 arch/arm/mach-omap2/board-igep0020.c             |   13 +-
 arch/arm/mach-omap2/board-ldp.c                  |    9 +-
 arch/arm/mach-omap2/board-n8x0.c                 |   13 +-
 arch/arm/mach-omap2/board-omap3beagle.c          |    4 +-
 arch/arm/mach-omap2/board-omap3evm.c             |    9 +-
 arch/arm/mach-omap2/board-omap3logic.c           |   11 +-
 arch/arm/mach-omap2/board-omap3pandora.c         |   11 +-
 arch/arm/mach-omap2/board-omap3stalker.c         |    9 +-
 arch/arm/mach-omap2/board-omap3touchbook.c       |   11 +-
 arch/arm/mach-omap2/board-omap4panda.c           |    9 +-
 arch/arm/mach-omap2/board-overo.c                |   11 +-
 arch/arm/mach-omap2/board-rm680.c                |   17 +-
 arch/arm/mach-omap2/board-rx51.c                 |   17 +-
 arch/arm/mach-omap2/board-ti8168evm.c            |    9 +-
 arch/arm/mach-omap2/board-zoom.c                 |   23 +-
 arch/arm/mach-omap2/clock3xxx_data.c             |   13 +-
 arch/arm/mach-omap2/clock44xx_data.c             |   10 +-
 arch/arm/mach-omap2/clockdomain.c                |  151 ++-
 arch/arm/mach-omap2/clockdomain.h                |   22 +-
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c       |    4 -
 arch/arm/mach-omap2/clockdomain44xx.c            |    2 -
 arch/arm/mach-omap2/clockdomains2420_data.c      |  154 +++
 arch/arm/mach-omap2/clockdomains2430_data.c      |  181 ++++
 arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c |  803 +----------------
 arch/arm/mach-omap2/clockdomains3xxx_data.c      |  398 ++++++++
 arch/arm/mach-omap2/clockdomains44xx_data.c      |  409 ++-------
 arch/arm/mach-omap2/id.c                         |  191 +---
 arch/arm/mach-omap2/io.c                         |   57 +-
 arch/arm/mach-omap2/omap_hwmod.c                 |    3 -
 arch/arm/mach-omap2/omap_hwmod_2420_data.c       |   37 -
 arch/arm/mach-omap2/omap_hwmod_2430_data.c       |   46 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c       |  173 ++--
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c       |   82 --
 arch/arm/mach-omap2/omap_twl.c                   |  107 ++-
 arch/arm/mach-omap2/pm.c                         |    8 +-
 arch/arm/mach-omap2/powerdomain-common.c         |    7 +-
 arch/arm/mach-omap2/powerdomain.c                |  109 ++-
 arch/arm/mach-omap2/powerdomain.h                |   19 +-
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c       |    2 +-
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c |   21 +-
 arch/arm/mach-omap2/powerdomains2xxx_data.c      |   48 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c      |   97 ++-
 arch/arm/mach-omap2/powerdomains44xx_data.c      |   36 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c               |   56 ++
 arch/arm/mach-omap2/prm2xxx_3xxx.h               |   12 +
 arch/arm/mach-omap2/prm44xx.c                    |   71 ++
 arch/arm/mach-omap2/prm44xx.h                    |   12 +
 arch/arm/mach-omap2/smartreflex-class3.c         |    4 +-
 arch/arm/mach-omap2/smartreflex.c                |   29 +-
 arch/arm/mach-omap2/sr_device.c                  |    2 +-
 arch/arm/mach-omap2/vc.c                         |  367 ++++++++
 arch/arm/mach-omap2/vc.h                         |   88 ++-
 arch/arm/mach-omap2/vc3xxx_data.c                |   31 +-
 arch/arm/mach-omap2/vc44xx_data.c                |   44 +-
 arch/arm/mach-omap2/voltage.c                    | 1088 ++++------------------
 arch/arm/mach-omap2/voltage.h                    |  150 ++--
 arch/arm/mach-omap2/voltagedomains2xxx_data.c    |   32 +
 arch/arm/mach-omap2/voltagedomains3xxx_data.c    |   83 +-
 arch/arm/mach-omap2/voltagedomains44xx_data.c    |   99 ++-
 arch/arm/mach-omap2/vp.c                         |  278 ++++++
 arch/arm/mach-omap2/vp.h                         |  133 ++--
 arch/arm/mach-omap2/vp3xxx_data.c                |   35 +-
 arch/arm/mach-omap2/vp44xx_data.c                |   47 +-
 arch/arm/mach-prima2/Makefile                    |    2 +
 arch/arm/mach-prima2/clock.c                     |    1 +
 arch/arm/mach-prima2/irq.c                       |   44 +
 arch/arm/mach-prima2/l2x0.c                      |   46 +-
 arch/arm/mach-prima2/pm.c                        |  150 +++
 arch/arm/mach-prima2/pm.h                        |   29 +
 arch/arm/mach-prima2/rstc.c                      |    1 +
 arch/arm/mach-prima2/rtciobrg.c                  |  139 +++
 arch/arm/mach-prima2/sleep.S                     |   64 ++
 arch/arm/mach-prima2/timer.c                     |   35 +
 arch/arm/plat-omap/include/plat/clock.h          |    2 -
 arch/arm/plat-omap/include/plat/common.h         |    9 +
 arch/arm/plat-omap/include/plat/cpu.h            |  108 +--
 arch/arm/plat-omap/include/plat/io.h             |    2 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h     |    3 -
 arch/arm/plat-omap/include/plat/voltage.h        |   20 +
 include/linux/rtc/sirfsoc_rtciobrg.h             |   18 +
 94 files changed, 3549 insertions(+), 3362 deletions(-)
 create mode 100644 arch/arm/mach-omap2/clockdomains2420_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains2430_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains3xxx_data.c
 create mode 100644 arch/arm/mach-omap2/vc.c
 create mode 100644 arch/arm/mach-omap2/voltagedomains2xxx_data.c
 create mode 100644 arch/arm/mach-omap2/vp.c
 create mode 100644 arch/arm/mach-prima2/pm.c
 create mode 100644 arch/arm/mach-prima2/pm.h
 create mode 100644 arch/arm/mach-prima2/rtciobrg.c
 create mode 100644 arch/arm/mach-prima2/sleep.S
 create mode 100644 arch/arm/plat-omap/include/plat/voltage.h
 create mode 100644 include/linux/rtc/sirfsoc_rtciobrg.h

