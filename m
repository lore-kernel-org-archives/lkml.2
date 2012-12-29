Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2L2Eim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 23:38:42 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:63478 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2L2Eik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 23:38:40 -0500
Date: Fri, 28 Dec 2012 20:38:45 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: arm-soc OMAP low-prio fixes
Message-ID: <20121229043845.GB11208@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I'll leave it up to you to decide if you want to pull this or not --
it can wait to 3.9 as well.

This branch came in from Tony at the start of the merge window, and I
wanted to give it a little time in -next (but it got more than expected
due to travel).

It's a mix of lowish priority fixes and a couple of cleanups to split
setup between OMAP1/2+, needed for multiplatform restructuring.

Said multiplatform restructuring is the main reason arm-soc saw so much
churn this release -- i.MX and OMAP platforms were reshuffled quite a
bit to make them ready for multiplatform. i.MX finished, OMAP is nearly
there with just a few more patches needed (for 3.9). It should slow down
again for next release.


Thanks,

-Olof

The following changes since commit 2b8318881ddbcb67c5e8d2178b42284749442222:

  Merge tag 'fbdev-for-3.8' of git://gitorious.org/linux-omap-dss2/linux (2012-12-15 13:03:48 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/omap-late-cleanups

for you to fetch changes up to f64d204b5cf21b282445ba2fa357d970028c9f52:

  arch/arm/mach-omap2/dpll3xxx.c: drop if around WARN_ON (2012-12-17 10:50:41 -0800)

----------------------------------------------------------------
ARM: arm-soc: late cleanups for omap

>From Tony Lindgren:
Here are few more patches to finish the omap changes for
multiplatform conversion that are not strictly fixes, but
were too complex to do with the dependencies during the
merge window. Those are to move of serial-omap.h to
platform_data, and the removal of remaining cpu_is_omap
macro usage outside mach-omap2.

Then there are several trivial fixes for typos and few
minimal omap2plus_defconfig updates.

----------------------------------------------------------------
AnilKumar Chimata (1):
      ARM: OMAP2+: omap2plus_defconfig: Add tps65217 support

Javier Martinez Canillas (2):
      ARM: OMAP2+: enable devtmpfs and devtmpfs automount
      ARM: OMAP2+: omap2plus_defconfig: enable twl4030 SoC audio

Jon Hunter (1):
      ARM: OMAP2+: PMU: Remove unused header

Julia Lawall (1):
      arch/arm/mach-omap2/dpll3xxx.c: drop if around WARN_ON

Peter Ujfalusi (1):
      ARM: OMAP2+: omap_twl: Change TWL4030_MODULE_PM_RECEIVER to TWL_MODULE_PM_RECEIVER

Srinivas Kandagatla (1):
      ARM/omap: use module_platform_driver macro

Tony Lindgren (3):
      MAINTAINERS: Add an entry for omap related .dts files
      ARM: OMAP: Split fb.c to remove last remaining cpu_is_omap usage
      ARM: OMAP2+: Drop plat/cpu.h for omap2plus

Wei Yongjun (1):
      ARM: OMAP4: remove duplicated include from omap_hwmod_44xx_data.c

YOSHIFUJI Hideaki (1):
      OMAP2: Fix a typo - replace regist with register.

 MAINTAINERS                                |  9 ++++
 arch/arm/configs/omap2plus_defconfig       |  5 ++
 arch/arm/mach-omap1/Makefile               |  2 +-
 arch/arm/mach-omap1/fb.c                   | 80 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/Makefile               |  2 +-
 arch/arm/mach-omap2/control.h              |  2 +-
 arch/arm/mach-omap2/dpll3xxx.c             |  3 +-
 arch/arm/mach-omap2/drm.c                  |  1 -
 arch/arm/mach-omap2/dss-common.c           |  3 +-
 arch/arm/{plat-omap => mach-omap2}/fb.c    | 50 +------------------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  1 -
 arch/arm/mach-omap2/omap_twl.c             |  8 +--
 arch/arm/mach-omap2/pmu.c                  |  2 -
 arch/arm/mach-omap2/prm2xxx.c              |  3 +-
 arch/arm/mach-omap2/prm3xxx.c              |  3 +-
 arch/arm/plat-omap/Makefile                |  2 +-
 arch/arm/plat-omap/dmtimer.c               | 13 +----
 arch/arm/plat-omap/include/plat/cpu.h      |  4 --
 drivers/media/platform/omap3isp/isp.c      |  2 -
 drivers/power/avs/smartreflex.c            |  2 -
 20 files changed, 109 insertions(+), 88 deletions(-)
 create mode 100644 arch/arm/mach-omap1/fb.c
 rename arch/arm/{plat-omap => mach-omap2}/fb.c (76%)
