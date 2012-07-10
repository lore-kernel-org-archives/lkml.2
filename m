Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2GJUQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:16:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33096 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab2GJUQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:16:31 -0400
MIME-Version: 1.0
Date: Tue, 10 Jul 2012 22:16:29 +0200
Message-ID: <CACRpkdYTKu8XVbnLom+VKp=2YGB+EX3Qnc5EX_ciqbaGndbROw@mail.gmail.com>
Subject: [GIT PULL] gpio fixes for v3.5
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Kevin Hilman <khilman@ti.com>,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Roland Stigge <stigge@antcom.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

yes, this is a *LATE* GPIO pull request with fixes for v3.5.

Grant moved across the planet and accidentally fell off the grid, so he asked
me to take over the GPIO merges for a while 10 days ago, refer to:
https://lkml.org/lkml/2012/7/1/220

Since then I went over the archives and collected this pile of fixes, and pulled
two of them from the TI maintainer Kevin Hilman. The waited for them to
atleast hit linux-next once or twice.

This is the info in the usual signed tag, which is more or less the same as
the commit messages but parsed through my head:

GPIO fixes for v3.5:
- Invalid context restore on bank 0 for OMAP driver in
  runtime suspend/resume cycle
- Check for NULL platform data in sta-2x11 driver
- Constrain selection of the V1 MSM GPIO driver to applicable
  platforms (Kconfig issue)
- Make sure the correct output value is set in the wm8994 driver
- Export devm_gpio_request_one() so it can be used in modules.
  Apparently some in-kernel modules can be configured to use this
  leading to breakage.
- Check that the GPIO is valid in the lantiq driver
- Fix the flag bits introduced for v3.5, so they don't overlap
- Fix a device tree intialization bug for imx21-compatible devices
- Carry over the OF node to the TPS65910 GPIO chip struct

Please pull it in.

Yours,
Linus Walleij

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio.git
tags/fixes-for-v3.5

Alessandro Rubini (1):
      gpio-sta2x11: don't use pdata if null

Christian Dietrich (1):
      gpio/msm_v1: CONFIG_GPIO_MSM_V1 is only available on three SoCs

Grazvydas Ignotas (1):
      gpio/omap: fix irq loss while in idle with debounce on

Jon Hunter (1):
      gpio/omap: fix invalid context restore of gpio bank-0

Laxman Dewangan (2):
      gpio: fix bits conflict for gpio flags
      gpio: tps65910: initialize of_node of gpio_chip

Linus Walleij (1):
      Merge branch 'kevin' into fixes

Mark Brown (1):
      gpiolib: wm8994: Pay attention to the value set when enabling as output

Roland Stigge (1):
      mips: pci-lantiq: Fix check for valid gpio

Stephen Warren (1):
      gpio: export devm_gpio_request_one

Uwe Kleine-König (1):
      gpio/mxc: make irqs work for fsl,imx21-gpio devices

 arch/mips/pci/pci-lantiq.c   |    4 ++--
 drivers/gpio/Kconfig         |    2 +-
 drivers/gpio/devres.c        |    1 +
 drivers/gpio/gpio-mxc.c      |   10 ++++++----
 drivers/gpio/gpio-omap.c     |   14 +++++++++++++-
 drivers/gpio/gpio-sta2x11.c  |    5 +++--
 drivers/gpio/gpio-tps65910.c |    1 +
 drivers/gpio/gpio-wm8994.c   |    5 ++++-
 include/linux/gpio.h         |    4 ++--
 9 files changed, 33 insertions(+), 13 deletions(-)
