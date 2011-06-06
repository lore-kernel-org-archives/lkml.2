Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1FFQEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:04:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62226 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1FFQED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110606084720.GZ23771@pengutronix.de>
References: <1307290075-7062-1-git-send-email-shawn.guo@linaro.org>
 <1307290075-7062-3-git-send-email-shawn.guo@linaro.org> <20110606075241.GD10410@ponder.secretlab.ca>
 <20110606081205.GC32632@pengutronix.de> <BANLkTinY44trVnt-XXaH85Vsj46put6N1Q@mail.gmail.com>
 <20110606084720.GZ23771@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 10:03:42 -0600
X-Google-Sender-Auth: fs5BrMglEPoLM45R3pLE1apoU00
Message-ID: <BANLkTi=1jMPLM3aW2wQo=yE5mEybVbV5PA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] gpio/mxc: Change gpio-mxc into an upstanding gpio driver
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, arnd@arndb.de, patches@linaro.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 2:47 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, Jun 06, 2011 at 02:18:29AM -0600, Grant Likely wrote:
>> On Mon, Jun 6, 2011 at 2:12 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>> > On Mon, Jun 06, 2011 at 01:52:41AM -0600, Grant Likely wrote:
>> >> On Mon, Jun 06, 2011 at 12:07:55AM +0800, Shawn Guo wrote:
>> >> > The patch makes necessary changes on gpio-mxc as below to turn it
>> >> > into an upstanding gpio driver.
>> >> >
>> >> >  * Add a list to save all mx2 ports references, so that
>> >> >    mx2_gpio_irq_handler can walk through all interrupt status
>> >> >    registers
>> >> >
>> >> >  * Use readl/writel to replace mach-specific accessors
>> >> >    __raw_readl/__raw_writel
>> >> >
>> >> >  * Change mxc_gpio_init into mxc_gpio_probe function
>> >> >
>> >> >  * Move "struct mxc_gpio_port" into gpio-mxc.c, as it needs not to
>> >> >    be public at all, and also make some other cleanup on
>> >> >    plat-mxc/include/mach/gpio.h at the same time
>> >> >
>> >> > And the patch then migrates mach-imx and mach-mx5 to the updated
>> >> > driver by adding corresponding platform devices.
>> >> >
>> >> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
>> >> > Acked-by: Olof Johansson <olof@lixom.net>
>> >>
>> >> Applied, thanks.
>> >
>> > I'm not completely happy with this patch going through your tree. It
>> > does massive changes to arch/arm/mach-*mx*, so expect merge conflicts
>> > here.
>>
>> There are also massive changes going on in drivers/gpio.  The solution
>> here is to probably put these changes into a new dedicated branch
>> based on Linus' tree, we both agree not to rebase that branch, and
>> both of us merge the branch into our trees.
>
> That can work. I just checked that atm there are no conflicts between my
> branch and Shawns patches. Can you set up such a branch? Otherwise I can
> just keep an eye on conflicts and we set up such a branch once a real
> conflict arises.

Done.  I'm assuming this constitutes an 'acked-by' for the mxs
patches.  I've already got your a-b for the mxc patches.  The whole
thing is based on 3.0-rc2, and is pushed out to the following branch.
If it looks good to you, then go ahead and merge it into your tree,
and I'll merge it into gpio/next.

The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:

  Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 gpio/next-mx

Grant Likely (1):
      gpio/mxs: Move Freescale mxs gpio driver to drivers/gpio

Shawn Guo (4):
      gpio/mxs: Change gpio-mxs into an upstanding gpio driver
      gpio/mxc: Move Freescale MXC gpio driver to drivers/gpio
      gpio/mxc: Change gpio-mxc into an upstanding gpio driver
      gpio/mxc: convert gpio-mxc to use basic_mmio_gpio library

 arch/arm/mach-imx/mach-apf9328.c                   |    2 +
 arch/arm/mach-imx/mach-armadillo5x0.c              |    2 +
 arch/arm/mach-imx/mach-bug.c                       |    2 +
 arch/arm/mach-imx/mach-cpuimx27.c                  |    2 +
 arch/arm/mach-imx/mach-cpuimx35.c                  |    2 +
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |    2 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    2 +
 arch/arm/mach-imx/mach-imx27ipcam.c                |    2 +
 arch/arm/mach-imx/mach-imx27lite.c                 |    2 +
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    2 +
 arch/arm/mach-imx/mach-mx1ads.c                    |    2 +
 arch/arm/mach-imx/mach-mx21ads.c                   |    2 +
 arch/arm/mach-imx/mach-mx25_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-mx27_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-mx27ads.c                   |    2 +
 arch/arm/mach-imx/mach-mx31_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-mx31ads.c                   |    2 +
 arch/arm/mach-imx/mach-mx31lilly.c                 |    2 +
 arch/arm/mach-imx/mach-mx31lite.c                  |    2 +
 arch/arm/mach-imx/mach-mx31moboard.c               |    2 +
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-mxt_td60.c                  |    2 +
 arch/arm/mach-imx/mach-pca100.c                    |    2 +
 arch/arm/mach-imx/mach-pcm037.c                    |    2 +
 arch/arm/mach-imx/mach-pcm038.c                    |    2 +
 arch/arm/mach-imx/mach-pcm043.c                    |    2 +
 arch/arm/mach-imx/mach-qong.c                      |    2 +
 arch/arm/mach-imx/mach-scb9328.c                   |    2 +
 arch/arm/mach-imx/mach-vpr200.c                    |    2 +
 arch/arm/mach-imx/mm-imx1.c                        |   17 +-
 arch/arm/mach-imx/mm-imx21.c                       |   21 +-
 arch/arm/mach-imx/mm-imx25.c                       |   16 +-
 arch/arm/mach-imx/mm-imx27.c                       |   21 +-
 arch/arm/mach-imx/mm-imx31.c                       |   15 +-
 arch/arm/mach-imx/mm-imx35.c                       |   15 +-
 arch/arm/mach-mx5/board-cpuimx51.c                 |    2 +
 arch/arm/mach-mx5/board-cpuimx51sd.c               |    2 +
 arch/arm/mach-mx5/board-mx50_rdp.c                 |    2 +
 arch/arm/mach-mx5/board-mx51_3ds.c                 |    2 +
 arch/arm/mach-mx5/board-mx51_babbage.c             |    2 +
 arch/arm/mach-mx5/board-mx51_efikamx.c             |    2 +
 arch/arm/mach-mx5/board-mx51_efikasb.c             |    2 +
 arch/arm/mach-mx5/board-mx53_evk.c                 |    2 +
 arch/arm/mach-mx5/board-mx53_loco.c                |    2 +
 arch/arm/mach-mx5/board-mx53_smd.c                 |    2 +
 arch/arm/mach-mx5/devices.c                        |   64 -----
 arch/arm/mach-mx5/mm-mx50.c                        |   21 +-
 arch/arm/mach-mx5/mm.c                             |   25 ++-
 arch/arm/mach-mxs/Makefile                         |    2 +-
 arch/arm/mach-mxs/devices.c                        |   11 +
 arch/arm/mach-mxs/devices/Makefile                 |    1 +
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c      |   53 ++++
 arch/arm/mach-mxs/gpio.h                           |   34 ---
 arch/arm/mach-mxs/include/mach/devices-common.h    |    2 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |    1 -
 arch/arm/mach-mxs/mm-mx23.c                        |    1 -
 arch/arm/mach-mxs/mm-mx28.c                        |    1 -
 arch/arm/plat-mxc/Makefile                         |    2 +-
 arch/arm/plat-mxc/devices.c                        |   11 +
 arch/arm/plat-mxc/devices/Makefile                 |    1 +
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |   32 +++
 arch/arm/plat-mxc/include/mach/common.h            |   12 +-
 arch/arm/plat-mxc/include/mach/devices-common.h    |    2 +
 arch/arm/plat-mxc/include/mach/gpio.h              |   27 --
 drivers/gpio/Kconfig                               |    9 +
 drivers/gpio/Makefile                              |    2 +
 .../arm/plat-mxc/gpio.c => drivers/gpio/gpio-mxc.c |  266 +++++++++++---------
 .../arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c |  227 ++++++++++-------
 68 files changed, 568 insertions(+), 422 deletions(-)
 create mode 100644 arch/arm/mach-mxs/devices/platform-gpio-mxs.c
 delete mode 100644 arch/arm/mach-mxs/gpio.h
 create mode 100644 arch/arm/plat-mxc/devices/platform-gpio-mxc.c
 rename arch/arm/plat-mxc/gpio.c => drivers/gpio/gpio-mxc.c (60%)
 rename arch/arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c (58%)


>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
