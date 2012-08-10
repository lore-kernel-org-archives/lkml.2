Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2HJGre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:47:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51816 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab2HJGrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:47:31 -0400
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 08:47:30 +0200
Message-ID: <CACRpkdaixT=Zn69x9_b9G2nQFm4cu2S5Uo23ww909MJFH2yWwQ@mail.gmail.com>
Subject: [GIT PULL] gpio fixes for v3.6-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Shawn Guo <shawn.guo@linaro.org>, Daniel Mack <zonque@gmail.com>,
        Axel Lin <axel.lin@gmail.com>, Alan Cox <alan@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>, Julia Lawall <Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

these are some accumulated GPIO fixes I've collected for the -rc1.
Description of fixes are in the tag below. All tested in linux-next.

Please pull them in!

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/gpio-fixes-v3.6-rc1

for you to fetch changes up to d6a2b7ba67334a7e72cd153c142c449831557cb9:

  drivers/gpio/gpio-langwell.c: fix error return code (2012-08-07
08:55:52 +0200)

----------------------------------------------------------------
gpio fixes for v3.6-rc1
- Fix a resource leak in the SCH driver
- Fix the register address calculation in the MSIC driver
- Fix the PXA driver's devicetree functions
- Delete redundant shadow variable leftovers in the MXC driver
- Specify the GPIO base for the device tree probe in the MXC driver
- Add a modalias for the i.MX driver
- Fix off-by-one bug in the Samsung driver
- Fix erroneous errorpath in the Langwell driver

----------------------------------------------------------------
Alan Cox (1):
      gpio-sch: Fix leak of resource

Axel Lin (1):
      gpio: msic: Fix calculating register address in msic_gpio_to_oreg()

Daniel Mack (1):
      GPIO: gpio-pxa: fix devicetree functions

Julia Lawall (1):
      drivers/gpio/gpio-langwell.c: fix error return code

Sean Paul (1):
      gpio: samsung: Fix off-by-one bug in gpio addresses

Shawn Guo (3):
      gpio/mxc: remove redundant shadow variables initialization
      gpio/mxc: specify gpio base for device tree probe
      ARM: dts: imx: add alias for gpio

 arch/arm/boot/dts/imx27.dtsi |  6 ++++++
 arch/arm/boot/dts/imx51.dtsi |  4 ++++
 arch/arm/boot/dts/imx53.dtsi |  7 +++++++
 arch/arm/boot/dts/imx6q.dtsi |  7 +++++++
 drivers/gpio/gpio-langwell.c |  7 +++++--
 drivers/gpio/gpio-msic.c     |  2 +-
 drivers/gpio/gpio-mxc.c      |  5 ++---
 drivers/gpio/gpio-pxa.c      | 26 ++++++++++++++++++++++++++
 drivers/gpio/gpio-samsung.c  | 14 +++++++-------
 drivers/gpio/gpio-sch.c      |  3 ++-
 10 files changed, 67 insertions(+), 14 deletions(-)

Yours,
Linus Walleij
