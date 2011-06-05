Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1FEQTE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:19:04 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:23878
	"EHLO CH1EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751552Ab1FEQTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:19:02 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz1447R1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 6 Jun 2011 00:23:14 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>
Subject: Re: [PATCH v3 1/3] gpio: gpio-mxs: copy mach-mxs/gpio.c into
 drivers/gpio
Message-ID: <20110605162313.GA20553@S2100-06.ap.freescale.net>
References: <1307184940-16291-1-git-send-email-shawn.guo@linaro.org>
 <1307184940-16291-2-git-send-email-shawn.guo@linaro.org>
 <20110604222946.GA31236@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110604222946.GA31236@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 04:29:46PM -0600, Grant Likely wrote:
> On Sat, Jun 04, 2011 at 06:55:38PM +0800, Shawn Guo wrote:
> > As the first patch of the series that moves mach-mxc gpio driver into
> > drivers/gpio, it copies arch/arm/mach-mxs/gpio.c into
> > drivers/gpio/gpio-mxs.c.  The later patches will make necessary
> > changes to the driver, migrate the existing users to it, and lastly
> > deletes mach-mxs gpio driver.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> >  drivers/gpio/gpio-mxs.c |  331 +++++++++++++++++++++++++++++++++++++++++++++++
> 
> [sigh]  I fear we are having a communication breakdown.  Since your
> /moving/ a file, you need to make it easy for readers to understand
> what has changed and why.  That means using 1 patch to move the file
> with only the changes absolutely necessary to ensure bisectability,
> and then followup patches for the clean up.
> 
> Adding a new copy in one patch, and then removing the old copy in the
> other patch does not make it easy for a reader to understand what
> changed.  Below is what you're first patch should look like (using the
> -M flag to show the actual changes which are only #include differences).
> 
Oops, I misunderstood your point.  But one thing I have been trying
hard is to keep changes for driver and subarch in separate patches,
which is something I was asked to do when I started working with
community.  As you will anyway pick up the patch set as a whole,
this is not a problem then.  I just sent the updates of gpio-mxs
and gpio-mxc with you approach.  As a side effect, you will see
patch #2 of gpio-mxc becomes a very big patch in term of number of
files it changes.

> I've build tested this patch and have it sitting in the gpio/next
> branch of git://git.secretlab.ca/git/linux-2.6 at the moment if you
> want to build the rest of your series on top of it.
> 
Thanks for the patch demonstrating.  I have one minor comment below.

> g.
> 
> ---
> 
> commit e084f5b06ca7f3d94d9d042d288a3311398e5c49
> Author: Grant Likely <grant.likely@secretlab.ca>
> Date:   Sat Jun 4 16:18:59 2011 -0600
> 
>     gpio/mxs: Move Freescale mxs gpio driver to drivers/gpio
>     
>     GPIO drivers are getting moved to drivers/gpio for cleanup and
>     consolidation.  This patch moves the mxs driver.  Follow up patches
>     will clean it up and make it a fine upstanding example of a gpio
>     driver.
>     
>     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> 
>  arch/arm/mach-mxs/Makefile                         |    2 +-
>  .../mach-mxs/{gpio.h => include/mach/gpio-mxs.h}   |    0
>  arch/arm/mach-mxs/mach-mx28evk.c                   |    2 +-
>  drivers/gpio/Kconfig                               |    4 ++++
>  drivers/gpio/Makefile                              |    1 +
>  .../arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c |    3 +--
>  6 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-mxs/Makefile b/arch/arm/mach-mxs/Makefile
> index 58e8923..6c38262 100644
> --- a/arch/arm/mach-mxs/Makefile
> +++ b/arch/arm/mach-mxs/Makefile
> @@ -1,5 +1,5 @@
>  # Common support
> -obj-y := clock.o devices.o gpio.o icoll.o iomux.o system.o timer.o
> +obj-y := clock.o devices.o icoll.o iomux.o system.o timer.o
>  
>  obj-$(CONFIG_MXS_OCOTP) += ocotp.o
>  obj-$(CONFIG_PM) += pm.o
> diff --git a/arch/arm/mach-mxs/gpio.h b/arch/arm/mach-mxs/include/mach/gpio-mxs.h
> similarity index 100%
> rename from arch/arm/mach-mxs/gpio.h
> rename to arch/arm/mach-mxs/include/mach/gpio-mxs.h
> diff --git a/arch/arm/mach-mxs/mach-mx28evk.c b/arch/arm/mach-mxs/mach-mx28evk.c
> index eacdc6b..347cf35 100644
> --- a/arch/arm/mach-mxs/mach-mx28evk.c
> +++ b/arch/arm/mach-mxs/mach-mx28evk.c
> @@ -24,9 +24,9 @@
>  
>  #include <mach/common.h>
>  #include <mach/iomux-mx28.h>
> +#include <mach/gpio-mxs.h>
>  
This is the problem of existing code.  The gpio.h (in turn gpio-mxs.h)
does not need to be included here.  So we can simply drop it in this
patch.  I have incorporated it when sending the patch within my series.

>  #include "devices-mx28.h"
> -#include "gpio.h"
>  
>  #define MX28EVK_FLEXCAN_SWITCH	MXS_GPIO_NR(2, 13)
>  #define MX28EVK_FEC_PHY_POWER	MXS_GPIO_NR(2, 15)
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 21271a5..afe44aa 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -94,6 +94,10 @@ config GPIO_EXYNOS4
>  	def_bool y
>  	depends on CPU_EXYNOS4210
>  
> +config GPIO_MXS
> +	def_bool y
> +	depends on ARCH_MXS
> +
>  config GPIO_PLAT_SAMSUNG
>  	def_bool y
>  	depends on SAMSUNG_GPIOLIB_4BIT
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index e6e5032..8733d02 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_GPIO_BASIC_MMIO_CORE)	+= basic_mmio_gpio.o
>  obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
>  obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
>  obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
> +obj-$(CONFIG_GPIO_MXS)		+= gpio-mxs.o
>  obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
>  obj-$(CONFIG_GPIO_S5PC100)	+= gpio-s5pc100.o
>  obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
> diff --git a/arch/arm/mach-mxs/gpio.c b/drivers/gpio/gpio-mxs.c
> similarity index 99%
> rename from arch/arm/mach-mxs/gpio.c
> rename to drivers/gpio/gpio-mxs.c
> index 2c950fe..bac7b6b 100644
> --- a/arch/arm/mach-mxs/gpio.c
> +++ b/drivers/gpio/gpio-mxs.c
> @@ -27,10 +27,9 @@
>  #include <linux/gpio.h>
>  #include <mach/mx23.h>
>  #include <mach/mx28.h>
> +#include <mach/gpio-mxs.h>
>  #include <asm-generic/bug.h>
>  
> -#include "gpio.h"
> -
>  static struct mxs_gpio_port *mxs_gpio_ports;
>  static int gpio_table_size;
>  

-- 
Regards,
Shawn

