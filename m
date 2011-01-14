Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab1ANTjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:39:24 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17203 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab1ANTjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:39:20 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 24.130.172.179
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18cjQYAKDElF2NyK0gAHsBW
Date: Fri, 14 Jan 2011 11:39:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [GIT PULL] omap-fixes and minor board updates
Message-ID: <20110114193911.GL4957@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap fixes and some minor board updates from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

This is mostly to deal with the build and boot issues after merging
with the arm and usb trees. The series also fixes some sparse issues.
It would be nice to get these in before -rc1.

Regards,

Tony


The following changes since commit 891cc2283216bf76f387546f0e220caf8ce9fbf9:

  Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel (2011-01-14 10:30:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Aaro Koskinen (1):
      arm: mach-omap2: mux: fix buffer overrun

Anand Gadiyar (1):
      arm: omap4: pandaboard: turn on PHY reference clock at init

Catalin Marinas (1):
      ARM: Do not enable SWP emulation if CPU_V6 && CPU_V7

Enric Balletbo i Serra (4):
      omap3: igep3: Add USB EHCI support for IGEP module
      omap3: igep3: Fix IGEP module second MMC channel power supply
      omap3: igep2: Add keypad support
      omap3: igep3: Add omap_reserve functionality

Felipe Balbi (1):
      arm: omap: gpio: don't access irq_desc array directly

Koen Kooi (3):
      omap3: beaglexm: fix EHCI power up GPIO dir
      omap3: beaglexm: fix DVI reset GPIO
      omap3: beaglexm: fix power on of DVI

Mika Westerberg (1):
      OMAP: GPIO: fix _set_gpio_triggering() for OMAP2+

Nishanth Menon (8):
      omap3|4: mux: make local structures static
      omap3: zoom: use static for pointer passing
      omap3: igep3: make igep3_flash_init static
      omap2+: wdt: trivial sparse fixes
      OMAP3+: sr_device: include pm header
      OMAP2+: TWL: make conversion routines static
      OMAP2+: TWL: include pm header for init protos
      omap2+: pm_bus: make functions used as pointers as static

Santosh Shilimkar (6):
      omap2plus: clockdomain: Trivial fix for build break because of clktrctrl_mask
      omap2plus: voltage: Trivial warning fix 'no return statement'
      omap2plus: voltage: Trivial linking fix 'undefined reference'
      omap2plus: voltage: Trivial linking fix for 'EINVAL' undeclared
      omap2plus: prm: Trvial build break fix for undefined reference to 'omap2_prm_read_mod_reg'
      omap3: clocks: Fix build error 'CK_3430ES2' undeclared here

Tony Lindgren (2):
      Merge branch 'ehci-omap-clock' into omap-fixes
      omap4: Fix ULPI PHY init for ES1.0 SDP

 arch/arm/mach-omap2/board-4430sdp.c          |   10 ++-
 arch/arm/mach-omap2/board-igep0020.c         |   33 ++++++++++
 arch/arm/mach-omap2/board-igep0030.c         |   85 ++++++++++++++++++++++----
 arch/arm/mach-omap2/board-omap3beagle.c      |   60 ++++++++++++++++--
 arch/arm/mach-omap2/board-omap4panda.c       |   10 +++
 arch/arm/mach-omap2/board-zoom-peripherals.c |    4 +-
 arch/arm/mach-omap2/clock3xxx_data.c         |    2 +-
 arch/arm/mach-omap2/clockdomain.h            |    2 -
 arch/arm/mach-omap2/devices.c                |    2 +-
 arch/arm/mach-omap2/mux.c                    |    2 +-
 arch/arm/mach-omap2/mux34xx.c                |    4 +-
 arch/arm/mach-omap2/mux44xx.c                |    6 +-
 arch/arm/mach-omap2/omap_twl.c               |   10 ++-
 arch/arm/mach-omap2/pm_bus.c                 |    4 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.h           |   63 +++++++++++++++++++-
 arch/arm/mach-omap2/sr_device.c              |    1 +
 arch/arm/mach-omap2/wd_timer.c               |    2 +
 arch/arm/mm/Kconfig                          |    2 +-
 arch/arm/plat-omap/gpio.c                    |   12 +++-
 arch/arm/plat-omap/include/plat/voltage.h    |   17 ++++-
 20 files changed, 280 insertions(+), 51 deletions(-)
