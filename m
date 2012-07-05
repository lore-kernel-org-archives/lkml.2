Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2GEMkn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:40:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60037 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2GEMkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:40:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: ARM: SoC fixes for 3.5-rc
Date: Thu, 5 Jul 2012 12:40:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201207051240.32157.arnd@arndb.de>
X-Provags-ID: V02:K0:9rhC18FrKUAXEiENY0xjP0WGRCu1oPJqRBIHR1/X+bm
 l3MscFmvsmrEWl/i6Wtiwk6/c/eTALVVQ9HuwsS+flGDMdiJRP
 n+B0mnOgDfKzUa6OYN75e3B1fZqyEQfKUuc9GvH+qvxxVmWnV8
 rJtgwXQBQCzsiNBL0eRJJRx1Qpi5sZq5c86980IHkSEvNfsdXq
 IGVpH8hnC5okSioRhXDhscoveFAm9mq/+ceB5LuszlRGovZpwb
 NqFV3+APSdF6MIzoVaupbzWnkRgJLjwIojPTE3xKzp73KRLjK/
 4erUrkKhLCnEKFnXTHsPFAFXaOJz1X7hvlw4kVaIL49SJCnCU8
 LmUaGNwEXhPnpiaTKJQw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I've taken over from Olof again for the next few weeks, here are the
bug fixes that came in since rc5.

	Arnd

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to e15ebe05cce44c5164dbf8489841c18a887bcfc2:

  Merge tag 'omap-fixes-for-v3.5-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into fixes (2012-07-05 12:16:13 +0200)

----------------------------------------------------------------

Small fixes on multiple ARM platforms
* A build regression from a previous fix on dove and mv78xx0
* Two fixes for recently (3.5-rc1) changed mmp/pxa code
* multiple omap2+ bug fixes
* two trivial fixes for i.MX
* one v3.5 regression for mxs

----------------------------------------------------------------
Andrew Lunn (1):
      ARM: Orion: Fix WDT compile for Dove and MV78xx0

Arnd Bergmann (5):
      Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes
      Merge tag 'v3.5-imx-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes
      Merge branch 'mxs/fixes-for-3.5' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'omap-fixes-for-v3.5-rc5' of git://git.kernel.org/.../tmlind/linux-omap into fixes

Benoit Cousson (1):
      ARM: OMAP2+: hwmod data: Fix wrong McBSP clock alias on OMAP4

Fabio Estevam (1):
      ARM: imx27_visstrim_m10: Do not include <asm/system.h>

Kevin Hilman (2):
      ARM: OMAP2: Overo: init I2C before MMC to fix MMC suspend/resume failure
      ARM: OMAP4: TWL6030: ensure sys_nirq1 is mux'd and wakeup enabled

Lauri Hintsala (1):
      ARM: apx4devkit: fix FEC enabling PHY clock

Paul Bolle (1):
      ARM: mmp: remove mach/gpio-pxa.h

Paul Parsons (1):
      ARM: pxa: hx4700: Fix basic suspend/resume

Paul Walmsley (1):
      ARM: OMAP4: hwmod data: temporarily comment out data for the usb_host_fs and aess IP blocks

Tony Lindgren (1):
      Merge tag 'omap-fixes-b-for-3.5rc' of git://git.kernel.org/.../pjw/omap-pending into fixes

Uwe Kleine-König (1):
      ARM: imx: assert SCC gate stays enabled

 arch/arm/mach-dove/include/mach/bridge-regs.h    |    1 +
 arch/arm/mach-dove/include/mach/dove.h           |    1 +
 arch/arm/mach-imx/clk-imx35.c                    |    9 ++++++-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c      |    2 +-
 arch/arm/mach-mmp/include/mach/gpio-pxa.h        |   29 ----------------------
 arch/arm/mach-mv78xx0/include/mach/bridge-regs.h |    1 +
 arch/arm/mach-mv78xx0/include/mach/mv78xx0.h     |    2 ++
 arch/arm/mach-mxs/mach-apx4devkit.c              |   11 ++++++++
 arch/arm/mach-omap2/board-overo.c                |    2 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c       |   28 ++++++++++-----------
 arch/arm/mach-omap2/twl-common.c                 |    2 ++
 arch/arm/mach-pxa/hx4700.c                       |   15 ++++++++++-
 12 files changed, 56 insertions(+), 47 deletions(-)
 delete mode 100644 arch/arm/mach-mmp/include/mach/gpio-pxa.h
