Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab2HVPbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:31:36 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57276 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604Ab2HVPbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:31:31 -0400
Date: Wed, 22 Aug 2012 11:31:28 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] [RFC] ARM: multiplatform: rename all mach headers
In-Reply-To: <201208221300.10798.arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1208221129510.1754@xanadu.home>
References: <201208221253.07278.arnd@arndb.de> <201208221300.10798.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Arnd Bergmann wrote:

> While converting all machine specific headers from
> automatically detect the right machine and platform
> name in most cases. This script uses a number of
> information sources for this:
> 
> * any arch/arm/mach-*/ directory uses its own headers,
>   with a few exceptions, same for plat-*/
> * each mach-*/ directory belongs to at most one plat-*
>   directory holding header files
> * for any header below mach/* that exists in only one
>   machine, we know that the users belong to that machine
> * some driver directories or files are manually listed
>   here.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Nicolas Pitre <nico@linaro.org>

I think that would be a good idea if you do keep your scripts in the 
commit log like it is done here.

> ===========================================================
> 
> fixup()
> {
>  echo fixup "$1 $2 $3"
>  git ls-files $1 | xargs sed -i "s:^\(#.*include <\)$2/:\1$3/:g"
> }
> 
> fixup arch/arm/mach-s3c2410 mach mach-s3c24xx
> fixup arch/arm/mach-s3c2412 mach mach-s3c24xx
> fixup arch/arm/mach-s3c2440 mach mach-s3c24xx
> 
> fixup arch/arm/plat-mxc mach mach-imx
> fixup arch/arm/plat-s3c24xx mach mach-s3c24xx
> fixup arch/arm/plat-s3c24xx plat plat-samsung
> 
> for i in arch/arm/mach-*; do
>         fixup "$i" mach "${i##*/}"
> done
> 
> for i in arch/arm/plat-* ; do
>         fixup "$i" plat "${i##*/}"
> done
> 
> fixup arch/arm/mach-spear3xx plat plat-spear
> fixup arch/arm/mach-spear6xx plat plat-spear
> fixup arch/arm/mach-spear13xx plat plat-spear
> fixup arch/arm/mach-pxa plat plat-pxa
> fixup arch/arm/mach-mmp plat plat-pxa
> fixup arch/arm/mach-orion5x plat plat-orion
> fixup arch/arm/mach-kirkwood plat plat-orion
> fixup arch/arm/mach-mv78xx0 plat plat-orion
> fixup arch/arm/mach-dove plat plat-orion
> fixup arch/arm/mach-nomadik plat plat-nomadik
> fixup arch/arm/mach-ux500 plat plat-nomadik
> fixup arch/arm/mach-s3c2410 plat plat-samsung
> fixup arch/arm/mach-s3c2412 plat plat-samsung
> fixup arch/arm/mach-s3c2440 plat plat-samsung
> fixup arch/arm/mach-s3c24xx plat plat-samsung
> fixup arch/arm/mach-s3c64xx plat plat-samsung
> fixup arch/arm/mach-s5p64x0 plat plat-samsung
> fixup arch/arm/mach-s5pc100 plat plat-samsung
> fixup arch/arm/mach-s5pv210 plat plat-samsung
> fixup arch/arm/mach-exynos plat plat-samsung
> fixup arch/arm/mach-omap1 plat plat-omap
> fixup arch/arm/mach-omap2 plat plat-omap
> fixup arch/arm/mach-versatile plat plat-versatile
> fixup arch/arm/mach-integrator plat plat-versatile
> fixup arch/arm/mach-realview plat plat-versatile
> fixup arch/arm/mach-vexpress plat plat-versatile
> fixup arch/arm/mach-zynq plat plat-versatile
> 
> fixup drivers/video/omap plat plat-omap
> fixup drivers/video/omap2 plat plat-omap
> fixup drivers/video/exynos plat plat-samsung
> fixup drivers/char/hw_random/omap\* plat plat-omap
> fixup drivers/cpufreq/omap\* plat plat-omap
> fixup drivers/crypto/omap\* plat plat-omap
> fixup drivers/media/video/omap\* plat plat-omap
> fixup drivers/input/keyboard/omap\* plat plat-omap
> fixup drivers/mmc/host/omap\* plat plat-omap
> fixup drivers/mtd/*nand/omap\* plat plat-omap
> fixup drivers/spi/spi-omap\* plat plat-omap
> fixup drivers/tty/serial/omap\* plat plat-omap
> fixup drivers/usb/gadget/omap\* plat plat-omap
> fixup drivers/usb/musb/*omap\* plat plat-omap
> fixup drivers/dma/omap-dma.c plat plat-omap
> fixup drivers/staging/omapdrm plat plat-omap
> fixup drivers/staging/tidspbridge/ plat plat-omap
> fixup drivers/input/keyboard/spear-keyboard.c plat plat-spear
> fixup drivers/cpufreq/exynos-cpufreq.c plat plat-samsung
> fixup drivers/crypto/s5p-sss.c plat plat-samsung
> fixup drivers/i2c/busses/i2c-nomadik.c plat plat-nomadik
> fixup drivers/mtd/nand/s3c2410.c plat plat-samsung
> fixup drivers/tty/serial/samsung.c plat plat-samsung
> fixup drivers/usb/gadget/s3c-hsotg.c plat plat-samsung
> fixup drivers/gpio/gpio-samsung.c plat plat-samsung
> fixup sound/soc/samsung plat plat-samsung
> fixup sound/soc/omap plat plat-omap
> fixup sound/soc/pxa plat plat-pxa
> fixup sound/soc/kirkwood/ plat plat-orion
> fixup sound/soc/fsl/imx*.[ch] plat plat-mxc
> 
> fixup drivers/video/omap mach mach-omap1
> fixup drivers/video/omap2 mach mach-omap2
> fixup drivers/video/exynos mach mach-exynos
> fixup drivers/media/video/davinci mach mach-davinci
> 
> fixup sound/soc/omap/osk5912.c mach mach-omap1
> fixup sound/soc/omap mach mach-omap2
> fixup sound/soc/pxa mach mach-pxa
> fixup sound/soc/davinci mach mach-davinci
> fixup sound/soc/ep93xx mach mach-ep93xx
> fixup sound/soc/kirkwood/ mach mach-kirkwood
> fixup sound/soc/fsl/imx*.[ch] mach mach-imx
> fixup sound/soc/mxs mach mach-mxs
> fixup sound/soc/tegra mach mach-tegra
> fixup sound/soc/nuc900 mach mach-w90x900
> fixup sound/arm/pxa\* mach mach-pxa
> fixup sound/atmel/ac97c.c mach mach-at91
> fixup sound/oss/waveartist.c mach mach-footbridge
> fixup sound/oss/vidc\* mach mach-rpc
> fixup sound/soc/atmel/ mach mach-at91
> fixup sound/soc/ux500/ mach mach-ux500
> 
> fixup include/linux/spi/pxa2xx_spi.h mach mach-pxa
> fixup include/linux/mfd/dbx500-prcmu.h mach mach-ux500
> 
> find_unique_mach()
> {
>   {
>     # find files in other architectures using mach/*.h
>     git ls-files | grep /mach/[^/]*.h | while read i ;
>         do echo ${i##*/}
>     done
>     # find files we've already renamed in ARM
>     for i in arch/arm/mach-*/include/mach-*/ ; do
>         git ls-files "$i" | sed -e "s:^$i::g"
>     done
>   } | sort | uniq -c | grep -w 1  | cut -f 2- -d\1
> }
> rename_unique_mach()
> {
>   ALLFILES=`git grep -l "^#include.*<mach/"`
>   ALLINCLUDES=`git grep "^#include.*<mach/" ${ALLFILES}`
>   find_unique_mach | while read i ; do
>     echo "$ALLINCLUDES" | if grep -q "#include.*<mach/$i>" &&
>                 [ -e arch/arm/mach-*/include/mach-*/"$i" ] ; then
>        MACH=`ls arch/arm/mach-*/include/mach-*/$i | cut -f 3 -d /`
>        THESEFILES=`git grep -l "^#include.*<mach/$i>" ${ALLFILES}`
>        echo mach/$i
>        for j in ${THESEFILES} ; do
>           fixup $j mach ${MACH}
>        done
>     fi
>   done
> }
> 
> find_unique_plat()
> {
>   {
>     # all plat/*.h files are already renamed
>     for i in arch/arm/plat-*/include/plat-*/ ; do
>         git ls-files "$i" | sed -e "s:^$i::g"
>     done
>   } | sort | uniq -c | grep -w 1  | cut -f 2- -d\1
> }
> rename_unique_plat()
> {
>   ALLFILES=`git grep -l "#include.*<plat/"`
>   if [ "" != "${ALLFILES}" ] ; then
>     find_unique_plat | while read i ; do
>       PLAT=`ls arch/arm/plat-*/include/plat-*/$i | cut -f 3 -d /`
>       THESEFILES=`git grep -l "^#include.*<plat/$i>" ${ALLFILES}`
>       echo plat/$i
>        for j in ${THESEFILES} ; do
>           fixup $j plat ${PLAT}
>        done
>     done
>   fi
> }
> 
> rename_unique_mach
> rename_unique_plat
> ---
>    0.0% Documentation/spi/
>    0.0% arch/arm/boot/compressed/
>    0.3% arch/arm/mach-at91/include/mach-at91/
>    4.7% arch/arm/mach-at91/
>    0.1% arch/arm/mach-bcmring/csp/chipc/
>    0.1% arch/arm/mach-bcmring/csp/dmac/
>    0.0% arch/arm/mach-bcmring/csp/tmr/
>    0.0% arch/arm/mach-bcmring/include/csp/
>    0.3% arch/arm/mach-bcmring/include/mach-bcmring/csp/
>    0.1% arch/arm/mach-bcmring/include/mach-bcmring/
>    0.4% arch/arm/mach-bcmring/
>    0.0% arch/arm/mach-clps711x/include/mach-clps711x/
>    0.1% arch/arm/mach-clps711x/
>    0.0% arch/arm/mach-cns3xxx/include/mach-cns3xxx/
>    0.1% arch/arm/mach-cns3xxx/
>    0.3% arch/arm/mach-davinci/include/mach-davinci/
>    3.3% arch/arm/mach-davinci/
>    0.0% arch/arm/mach-dove/include/mach-dove/
>    0.3% arch/arm/mach-dove/
>    0.0% arch/arm/mach-ebsa110/
>    0.0% arch/arm/mach-ep93xx/include/mach-ep93xx/
>    0.5% arch/arm/mach-ep93xx/
>    0.2% arch/arm/mach-exynos/include/mach-exynos/
>    3.9% arch/arm/mach-exynos/
>    0.0% arch/arm/mach-footbridge/include/mach-footbridge/
>    0.0% arch/arm/mach-footbridge/
>    0.1% arch/arm/mach-gemini/include/mach-gemini/
>    0.1% arch/arm/mach-gemini/
>    0.0% arch/arm/mach-h720x/include/mach-h720x/
>    0.1% arch/arm/mach-h720x/
>    0.6% arch/arm/mach-imx/include/mach-imx/
>    5.0% arch/arm/mach-imx/
>    0.5% arch/arm/mach-integrator/
>    0.0% arch/arm/mach-iop13xx/include/mach-iop13xx/
>    0.2% arch/arm/mach-iop13xx/
>    0.0% arch/arm/mach-iop32x/include/mach-iop32x/
>    0.1% arch/arm/mach-iop32x/
>    0.0% arch/arm/mach-iop33x/include/mach-iop33x/
>    0.1% arch/arm/mach-iop33x/
>    0.1% arch/arm/mach-ixp4xx/include/mach-ixp4xx/
>    0.3% arch/arm/mach-ixp4xx/
>    0.0% arch/arm/mach-kirkwood/include/mach-kirkwood/
>    1.1% arch/arm/mach-kirkwood/
>    0.1% arch/arm/mach-ks8695/include/mach-ks8695/
>    0.4% arch/arm/mach-ks8695/
>    0.0% arch/arm/mach-lpc32xx/include/mach-lpc32xx/
>    0.3% arch/arm/mach-lpc32xx/
>    0.4% arch/arm/mach-mmp/include/mach-mmp/
>    1.5% arch/arm/mach-mmp/
>    0.1% arch/arm/mach-msm/include/mach-msm/
>    1.2% arch/arm/mach-msm/
>    0.0% arch/arm/mach-mv78xx0/include/mach-mv78xx0/
>    0.3% arch/arm/mach-mv78xx0/
>    0.0% arch/arm/mach-mvebu/include/mach-mvebu/
>    0.0% arch/arm/mach-mvebu/
>    0.5% arch/arm/mach-mxs/devices/
>    0.1% arch/arm/mach-mxs/include/mach-mxs/
>    0.5% arch/arm/mach-mxs/
>    0.3% arch/arm/mach-netx/
>    0.0% arch/arm/mach-nomadik/include/mach-nomadik/
>    0.1% arch/arm/mach-nomadik/
>    0.2% arch/arm/mach-omap1/include/mach-omap1/
>    3.3% arch/arm/mach-omap1/
>    0.1% arch/arm/mach-omap2/include/mach-omap2/
>    8.1% arch/arm/mach-omap2/
>    0.1% arch/arm/mach-orion5x/include/mach-orion5x/
>    0.7% arch/arm/mach-orion5x/
>    0.0% arch/arm/mach-picoxcell/include/mach-picoxcell/
>    0.0% arch/arm/mach-picoxcell/
>    0.0% arch/arm/mach-pnx4008/include/mach-pnx4008/
>    0.4% arch/arm/mach-pnx4008/
>    0.1% arch/arm/mach-prima2/include/mach-prima2/
>    0.0% arch/arm/mach-prima2/
>    0.7% arch/arm/mach-pxa/include/mach-pxa/
>    7.6% arch/arm/mach-pxa/
>    0.3% arch/arm/mach-realview/include/mach-realview/
>    0.4% arch/arm/mach-realview/
>    0.0% arch/arm/mach-rpc/include/mach-rpc/
>    0.1% arch/arm/mach-rpc/
>    0.1% arch/arm/mach-s3c2410/
>    0.1% arch/arm/mach-s3c2412/
>    0.2% arch/arm/mach-s3c2440/
>    0.3% arch/arm/mach-s3c24xx/include/mach-s3c24xx/
>   10.9% arch/arm/mach-s3c24xx/
>    0.1% arch/arm/mach-s3c64xx/include/mach-s3c64xx/
>    3.9% arch/arm/mach-s3c64xx/
>    0.2% arch/arm/mach-s5p64x0/include/mach-s5p64x0/
>    2.1% arch/arm/mach-s5p64x0/
>    0.2% arch/arm/mach-s5pc100/include/mach-s5pc100/
>    1.0% arch/arm/mach-s5pc100/
>    0.2% arch/arm/mach-s5pv210/include/mach-s5pv210/
>    2.1% arch/arm/mach-s5pv210/
>    0.1% arch/arm/mach-sa1100/include/mach-sa1100/
>    1.1% arch/arm/mach-sa1100/
>    0.0% arch/arm/mach-shmobile/include/mach-shmobile/
>    1.9% arch/arm/mach-shmobile/
>    0.0% arch/arm/mach-spear13xx/include/mach-spear13xx/
>    0.1% arch/arm/mach-spear13xx/
>    0.0% arch/arm/mach-spear3xx/include/mach-spear3xx/
>    0.2% arch/arm/mach-spear3xx/
>    0.0% arch/arm/mach-spear6xx/include/mach-spear6xx/
>    0.0% arch/arm/mach-spear6xx/
>    0.0% arch/arm/mach-tegra/include/mach-tegra/
>    1.0% arch/arm/mach-tegra/
>    0.0% arch/arm/mach-u300/include/mach-u300/
>    0.2% arch/arm/mach-u300/
>    0.1% arch/arm/mach-ux500/include/mach-ux500/
>    0.9% arch/arm/mach-ux500/
>    0.0% arch/arm/mach-versatile/include/mach-versatile/
>    0.1% arch/arm/mach-versatile/
>    0.1% arch/arm/mach-vexpress/
>    0.1% arch/arm/mach-vt8500/
>    0.1% arch/arm/mach-w90x900/include/mach-w90x900/
>    0.4% arch/arm/mach-w90x900/
>    0.0% arch/arm/mach-zynq/include/mach-zynq/
>    0.0% arch/arm/mach-zynq/
>    0.0% arch/arm/mm/
>    1.0% arch/arm/plat-mxc/devices/
>    0.4% arch/arm/plat-mxc/
>    0.4% arch/arm/plat-omap/include/plat-omap/
>    0.6% arch/arm/plat-omap/
>    0.1% arch/arm/plat-orion/
>    0.0% arch/arm/plat-pxa/
>    0.6% arch/arm/plat-s3c24xx/
>    0.2% arch/arm/plat-samsung/include/plat-samsung/
>    1.4% arch/arm/plat-samsung/
>    0.0% arch/arm/plat-spear/
>    0.0% arch/arm/plat-versatile/
>    0.1% drivers/ata/
>    0.0% drivers/char/hw_random/
>    0.0% drivers/char/
>    0.0% drivers/clk/mxs/
>    0.0% drivers/clk/
>    0.0% drivers/clocksource/
>    0.0% drivers/cpufreq/
>    0.0% drivers/crypto/ux500/cryp/
>    0.0% drivers/crypto/ux500/hash/
>    0.1% drivers/crypto/
>    0.0% drivers/devfreq/
>    0.0% drivers/dma/ipu/
>    0.2% drivers/dma/
>    0.4% drivers/gpio/
>    0.0% drivers/gpu/drm/exynos/
>    0.0% drivers/hwmon/
>    0.0% drivers/i2c/busses/
>    0.0% drivers/iio/adc/
>    0.3% drivers/input/keyboard/
>    0.0% drivers/input/mouse/
>    0.0% drivers/input/serio/
>    0.1% drivers/input/touchscreen/
>    0.2% drivers/iommu/
>    0.0% drivers/leds/
>    0.1% drivers/media/video/davinci/
>    0.0% drivers/media/video/omap/
>    0.1% drivers/media/video/omap3isp/
>    0.0% drivers/media/video/s5p-fimc/
>    0.0% drivers/media/video/s5p-tv/
>    0.1% drivers/media/video/
>    0.1% drivers/mfd/
>    0.3% drivers/mmc/host/
>    0.0% drivers/mtd/maps/
>    0.4% drivers/mtd/nand/
>    0.0% drivers/mtd/onenand/
>    0.0% drivers/net/ethernet/cadence/
>    0.0% drivers/net/ethernet/micrel/
>    0.0% drivers/net/ethernet/smsc/
>    0.0% drivers/net/ethernet/xscale/
>    0.0% drivers/net/ethernet/
>    0.0% drivers/net/wan/
>    0.6% drivers/pcmcia/
>    0.0% drivers/pinctrl/
>    0.0% drivers/power/
>    0.0% drivers/ptp/
>    0.0% drivers/pwm/
>    0.0% drivers/remoteproc/
>    0.0% drivers/rtc/
>    0.2% drivers/spi/
>    0.0% drivers/staging/nvec/
>    0.0% drivers/staging/omapdrm/
>    0.0% drivers/staging/tidspbridge/core/
>    0.0% drivers/staging/tidspbridge/include/dspbridge/
>    0.0% drivers/staging/tidspbridge/rmgr/
>    0.1% drivers/tty/serial/
>    0.2% drivers/usb/gadget/
>    0.4% drivers/usb/host/
>    0.1% drivers/usb/musb/
>    0.0% drivers/usb/otg/
>    0.1% drivers/video/backlight/
>    0.0% drivers/video/exynos/
>    0.2% drivers/video/msm/
>    0.1% drivers/video/omap/
>    0.1% drivers/video/omap2/dss/
>    0.0% drivers/video/omap2/omapfb/
>    0.0% drivers/video/omap2/
>    0.4% drivers/video/
>    0.0% drivers/watchdog/
>    0.0% include/linux/mfd/
>    0.0% include/linux/platform_data/
>    0.0% include/linux/power/
>    0.0% include/linux/spi/
>    0.0% include/linux/
>    0.1% sound/arm/
>    0.0% sound/atmel/
>    0.0% sound/oss/
>    0.0% sound/soc/atmel/
>    0.1% sound/soc/davinci/
>    0.1% sound/soc/ep93xx/
>    0.0% sound/soc/fsl/
>    0.0% sound/soc/kirkwood/
>    0.0% sound/soc/mxs/
>    0.0% sound/soc/nuc900/
>    0.6% sound/soc/omap/
>    0.5% sound/soc/pxa/
>    0.2% sound/soc/samsung/
>    0.0% sound/soc/tegra/
>    0.1% sound/soc/ux500/
> 
> diff --git a/Documentation/spi/ep93xx_spi b/Documentation/spi/ep93xx_spi
> index d8eb01c..f088b4b 100644
> --- a/Documentation/spi/ep93xx_spi
> +++ b/Documentation/spi/ep93xx_spi
> @@ -26,7 +26,7 @@ arch/arm/mach-ep93xx/ts72xx.c:
>  #include <linux/gpio.h>
>  #include <linux/spi/spi.h>
>  
> -#include <mach/ep93xx_spi.h>
> +#include <mach-ep93xx/ep93xx_spi.h>
>  
>  /* this is our GPIO line used for chip select */
>  #define MMC_CHIP_SELECT_GPIO EP93XX_GPIO_LINE_EGPIO9
> diff --git a/arch/arm/boot/compressed/head-shmobile.S b/arch/arm/boot/compressed/head-shmobile.S
> index fe3719b..4bcb9c7 100644
> --- a/arch/arm/boot/compressed/head-shmobile.S
> +++ b/arch/arm/boot/compressed/head-shmobile.S
> @@ -23,7 +23,7 @@
>         .section        ".start", "ax"
>  
>         /* load board-specific initialization code */
> -#include <mach/zboot.h>
> +#include <mach-shmobile/zboot.h>
>  
>  #if defined(CONFIG_ZBOOT_ROM_MMCIF) || defined(CONFIG_ZBOOT_ROM_SH_MOBILE_SDHI)
>         /* Load image from MMC/SD */
> diff --git a/arch/arm/boot/compressed/sdhi-shmobile.c b/arch/arm/boot/compressed/sdhi-shmobile.c
> index bd3d469..ff0aa20 100644
> --- a/arch/arm/boot/compressed/sdhi-shmobile.c
> +++ b/arch/arm/boot/compressed/sdhi-shmobile.c
> @@ -18,7 +18,7 @@
>  #include <linux/mmc/mmc.h>
>  #include <linux/mmc/sd.h>
>  #include <linux/mmc/tmio.h>
> -#include <mach/sdhi.h>
> +#include <mach-shmobile/sdhi.h>
>  
>  #define OCR_FASTBOOT           (1<<29)
>  #define OCR_HCS                        (1<<30)
> diff --git a/arch/arm/mach-at91/at91rm9200.c b/arch/arm/mach-at91/at91rm9200.c
> index 6f50c67..fd81ffe 100644
> --- a/arch/arm/mach-at91/at91rm9200.c
> +++ b/arch/arm/mach-at91/at91rm9200.c
> @@ -16,11 +16,11 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> -#include <mach/at91rm9200.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/at91_st.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/at91rm9200.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/at91_st.h>
> +#include <mach-at91/cpu.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
> index 01fb732..2b63b60 100644
> --- a/arch/arm/mach-at91/at91rm9200_devices.c
> +++ b/arch/arm/mach-at91/at91rm9200_devices.c
> @@ -18,10 +18,10 @@
>  #include <linux/platform_device.h>
>  #include <linux/i2c-gpio.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91rm9200.h>
> -#include <mach/at91rm9200_mc.h>
> -#include <mach/at91_ramc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91rm9200.h>
> +#include <mach-at91/at91rm9200_mc.h>
> +#include <mach-at91/at91_ramc.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
> index 104ca40..aec1da4 100644
> --- a/arch/arm/mach-at91/at91rm9200_time.c
> +++ b/arch/arm/mach-at91/at91rm9200_time.c
> @@ -27,7 +27,7 @@
>  
>  #include <asm/mach/time.h>
>  
> -#include <mach/at91_st.h>
> +#include <mach-at91/at91_st.h>
>  
>  static unsigned long last_crtr;
>  static u32 irqmask;
> diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
> index 30c7f26..e84bddb 100644
> --- a/arch/arm/mach-at91/at91sam9260.c
> +++ b/arch/arm/mach-at91/at91sam9260.c
> @@ -17,12 +17,12 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> -#include <mach/cpu.h>
> -#include <mach/at91_dbgu.h>
> -#include <mach/at91sam9260.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/at91_rstc.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/at91_dbgu.h>
> +#include <mach-at91/at91sam9260.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/at91_rstc.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> index 7b9c2ba..cb364af 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -19,13 +19,13 @@
>  
>  #include <linux/platform_data/at91_adc.h>
>  
> -#include <mach/board.h>
> -#include <mach/cpu.h>
> -#include <mach/at91sam9260.h>
> -#include <mach/at91sam9260_matrix.h>
> -#include <mach/at91_matrix.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91_adc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/at91sam9260.h>
> +#include <mach-at91/at91sam9260_matrix.h>
> +#include <mach-at91/at91_matrix.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91_adc.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/at91sam9261.c b/arch/arm/mach-at91/at91sam9261.c
> index f40762c..58c830b 100644
> --- a/arch/arm/mach-at91/at91sam9261.c
> +++ b/arch/arm/mach-at91/at91sam9261.c
> @@ -17,11 +17,11 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> -#include <mach/cpu.h>
> -#include <mach/at91sam9261.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/at91_rstc.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/at91sam9261.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/at91_rstc.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
> index 8df5c1b..f2e6805 100644
> --- a/arch/arm/mach-at91/at91sam9261_devices.c
> +++ b/arch/arm/mach-at91/at91sam9261_devices.c
> @@ -21,11 +21,11 @@
>  #include <linux/fb.h>
>  #include <video/atmel_lcdc.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91sam9261.h>
> -#include <mach/at91sam9261_matrix.h>
> -#include <mach/at91_matrix.h>
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91sam9261.h>
> +#include <mach-at91/at91sam9261_matrix.h>
> +#include <mach-at91/at91_matrix.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
> index 84b3810..51f4f7e 100644
> --- a/arch/arm/mach-at91/at91sam9263.c
> +++ b/arch/arm/mach-at91/at91sam9263.c
> @@ -17,10 +17,10 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> -#include <mach/at91sam9263.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/at91_rstc.h>
> +#include <mach-at91/at91sam9263.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/at91_rstc.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
> index eb6bbf8..26dc600 100644
> --- a/arch/arm/mach-at91/at91sam9263_devices.c
> +++ b/arch/arm/mach-at91/at91sam9263_devices.c
> @@ -20,11 +20,11 @@
>  #include <linux/fb.h>
>  #include <video/atmel_lcdc.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91sam9263.h>
> -#include <mach/at91sam9263_matrix.h>
> -#include <mach/at91_matrix.h>
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91sam9263.h>
> +#include <mach-at91/at91sam9263_matrix.h>
> +#include <mach-at91/at91_matrix.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/at91sam926x_time.c b/arch/arm/mach-at91/at91sam926x_time.c
> index ffc0957..e3b0d36 100644
> --- a/arch/arm/mach-at91/at91sam926x_time.c
> +++ b/arch/arm/mach-at91/at91sam926x_time.c
> @@ -20,7 +20,7 @@
>  
>  #include <asm/mach/time.h>
>  
> -#include <mach/at91_pit.h>
> +#include <mach-at91/at91_pit.h>
>  
>  
>  #define PIT_CPIV(x)    ((x) & AT91_PIT_CPIV)
> diff --git a/arch/arm/mach-at91/at91sam9_alt_reset.S b/arch/arm/mach-at91/at91sam9_alt_reset.S
> index 7af2e10..6d8da98 100644
> --- a/arch/arm/mach-at91/at91sam9_alt_reset.S
> +++ b/arch/arm/mach-at91/at91sam9_alt_reset.S
> @@ -14,9 +14,9 @@
>   */
>  
>  #include <linux/linkage.h>
> -#include <mach/hardware.h>
> -#include <mach/at91_ramc.h>
> -#include <mach/at91_rstc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/at91_ramc.h>
> +#include <mach-at91/at91_rstc.h>
>  
>                         .arm
>  
> diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
> index ef6cedd..45c79b4 100644
> --- a/arch/arm/mach-at91/at91sam9g45.c
> +++ b/arch/arm/mach-at91/at91sam9g45.c
> @@ -17,10 +17,10 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> -#include <mach/at91sam9g45.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/at91sam9g45.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/cpu.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 0607399..242c850 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -25,14 +25,14 @@
>  #include <linux/fb.h>
>  #include <video/atmel_lcdc.h>
>  
> -#include <mach/at91_adc.h>
> -#include <mach/board.h>
> -#include <mach/at91sam9g45.h>
> -#include <mach/at91sam9g45_matrix.h>
> -#include <mach/at91_matrix.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at_hdmac.h>
> -#include <mach/atmel-mci.h>
> +#include <mach-at91/at91_adc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91sam9g45.h>
> +#include <mach-at91/at91sam9g45_matrix.h>
> +#include <mach-at91/at91_matrix.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at_hdmac.h>
> +#include <mach-at91/atmel-mci.h>
>  
>  #include <media/atmel-isi.h>
>  
> diff --git a/arch/arm/mach-at91/at91sam9g45_reset.S b/arch/arm/mach-at91/at91sam9g45_reset.S
> index 9d45718..0726dad 100644
> --- a/arch/arm/mach-at91/at91sam9g45_reset.S
> +++ b/arch/arm/mach-at91/at91sam9g45_reset.S
> @@ -11,9 +11,9 @@
>   */
>  
>  #include <linux/linkage.h>
> -#include <mach/hardware.h>
> -#include <mach/at91_ramc.h>
> -#include <mach/at91_rstc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/at91_ramc.h>
> +#include <mach-at91/at91_rstc.h>
>  
>                         .arm
>  
> diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
> index 0849466..b5f4e1d 100644
> --- a/arch/arm/mach-at91/at91sam9n12.c
> +++ b/arch/arm/mach-at91/at91sam9n12.c
> @@ -12,10 +12,10 @@
>  #include <asm/irq.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> -#include <mach/at91sam9n12.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/cpu.h>
> -#include <mach/board.h>
> +#include <mach-at91/at91sam9n12.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/board.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
> index 72ce50a..3c17719 100644
> --- a/arch/arm/mach-at91/at91sam9rl.c
> +++ b/arch/arm/mach-at91/at91sam9rl.c
> @@ -16,12 +16,12 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> -#include <mach/cpu.h>
> -#include <mach/at91_dbgu.h>
> -#include <mach/at91sam9rl.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/at91_rstc.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/at91_dbgu.h>
> +#include <mach-at91/at91sam9rl.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/at91_rstc.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
> index f09fff9..cf41235 100644
> --- a/arch/arm/mach-at91/at91sam9rl_devices.c
> +++ b/arch/arm/mach-at91/at91sam9rl_devices.c
> @@ -17,12 +17,12 @@
>  #include <linux/fb.h>
>  #include <video/atmel_lcdc.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91sam9rl.h>
> -#include <mach/at91sam9rl_matrix.h>
> -#include <mach/at91_matrix.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at_hdmac.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91sam9rl.h>
> +#include <mach-at91/at91sam9rl_matrix.h>
> +#include <mach-at91/at91_matrix.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at_hdmac.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
> index 477cf9d..d919d0e 100644
> --- a/arch/arm/mach-at91/at91sam9x5.c
> +++ b/arch/arm/mach-at91/at91sam9x5.c
> @@ -12,10 +12,10 @@
>  #include <asm/irq.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> -#include <mach/at91sam9x5.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/cpu.h>
> -#include <mach/board.h>
> +#include <mach-at91/at91sam9x5.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/board.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/at91x40.c b/arch/arm/mach-at91/at91x40.c
> index 46090e6..e3224b1 100644
> --- a/arch/arm/mach-at91/at91x40.c
> +++ b/arch/arm/mach-at91/at91x40.c
> @@ -17,10 +17,10 @@
>  #include <asm/proc-fns.h>
>  #include <asm/system_misc.h>
>  #include <asm/mach/arch.h>
> -#include <mach/at91x40.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91_st.h>
> -#include <mach/timex.h>
> +#include <mach-at91/at91x40.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91_st.h>
> +#include <mach-at91/timex.h>
>  #include "generic.h"
>  
>  /*
> diff --git a/arch/arm/mach-at91/at91x40_time.c b/arch/arm/mach-at91/at91x40_time.c
> index 6ca680a..478fa8a 100644
> --- a/arch/arm/mach-at91/at91x40_time.c
> +++ b/arch/arm/mach-at91/at91x40_time.c
> @@ -24,9 +24,9 @@
>  #include <linux/irq.h>
>  #include <linux/time.h>
>  #include <linux/io.h>
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/mach/time.h>
> -#include <mach/at91_tc.h>
> +#include <mach-at91/at91_tc.h>
>  
>  #define at91_tc_read(field) \
>         __raw_readl(AT91_TC + field)
> diff --git a/arch/arm/mach-at91/board-1arm.c b/arch/arm/mach-at91/board-1arm.c
> index 22d8856..bbfe99a 100644
> --- a/arch/arm/mach-at91/board-1arm.c
> +++ b/arch/arm/mach-at91/board-1arm.c
> @@ -25,7 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -34,9 +34,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/cpu.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
> index de7be19..ae1469e 100644
> --- a/arch/arm/mach-at91/board-afeb-9260v1.c
> +++ b/arch/arm/mach-at91/board-afeb-9260v1.c
> @@ -34,7 +34,7 @@
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -43,8 +43,8 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
> index 477e708..8e3b25a 100644
> --- a/arch/arm/mach-at91/board-cam60.c
> +++ b/arch/arm/mach-at91/board-cam60.c
> @@ -29,7 +29,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/spi/flash.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -38,9 +38,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-carmeva.c b/arch/arm/mach-at91/board-carmeva.c
> index a5b002f..b2f21fc 100644
> --- a/arch/arm/mach-at91/board-carmeva.c
> +++ b/arch/arm/mach-at91/board-carmeva.c
> @@ -34,9 +34,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-cpu9krea.c b/arch/arm/mach-at91/board-cpu9krea.c
> index ecbc13b..2d5334c 100644
> --- a/arch/arm/mach-at91/board-cpu9krea.c
> +++ b/arch/arm/mach-at91/board-cpu9krea.c
> @@ -39,12 +39,12 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91sam9260_matrix.h>
> -#include <mach/at91_matrix.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91sam9260_matrix.h>
> +#include <mach-at91/at91_matrix.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-cpuat91.c b/arch/arm/mach-at91/board-cpuat91.c
> index 2e6d043..73934ef 100644
> --- a/arch/arm/mach-at91/board-cpuat91.c
> +++ b/arch/arm/mach-at91/board-cpuat91.c
> @@ -27,7 +27,7 @@
>  #include <linux/mtd/physmap.h>
>  #include <linux/mtd/plat-ram.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -36,11 +36,11 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91rm9200_mc.h>
> -#include <mach/at91_ramc.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91rm9200_mc.h>
> +#include <mach-at91/at91_ramc.h>
> +#include <mach-at91/cpu.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-csb337.c b/arch/arm/mach-at91/board-csb337.c
> index 462bc31..40f5e99 100644
> --- a/arch/arm/mach-at91/board-csb337.c
> +++ b/arch/arm/mach-at91/board-csb337.c
> @@ -37,9 +37,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-csb637.c b/arch/arm/mach-at91/board-csb637.c
> index 872871a..df54c811 100644
> --- a/arch/arm/mach-at91/board-csb637.c
> +++ b/arch/arm/mach-at91/board-csb637.c
> @@ -34,9 +34,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-dt.c b/arch/arm/mach-at91/board-dt.c
> index e8f45c4..346b427 100644
> --- a/arch/arm/mach-at91/board-dt.c
> +++ b/arch/arm/mach-at91/board-dt.c
> @@ -15,8 +15,8 @@
>  #include <linux/of_irq.h>
>  #include <linux/of_platform.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include <asm/setup.h>
>  #include <asm/irq.h>
> diff --git a/arch/arm/mach-at91/board-eb01.c b/arch/arm/mach-at91/board-eb01.c
> index 01f66e9..5a0365d 100644
> --- a/arch/arm/mach-at91/board-eb01.c
> +++ b/arch/arm/mach-at91/board-eb01.c
> @@ -24,11 +24,11 @@
>  #include <linux/platform_device.h>
>  #include <linux/irq.h>
>  #include <asm/mach-types.h>
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  #include "generic.h"
>  
>  static void __init at91eb01_init_irq(void)
> diff --git a/arch/arm/mach-at91/board-eb9200.c b/arch/arm/mach-at91/board-eb9200.c
> index d1e1f3f..3ae9f49 100644
> --- a/arch/arm/mach-at91/board-eb9200.c
> +++ b/arch/arm/mach-at91/board-eb9200.c
> @@ -26,7 +26,7 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -35,8 +35,8 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
> index 9c24cb2..f9d2da7 100644
> --- a/arch/arm/mach-at91/board-ecbat91.c
> +++ b/arch/arm/mach-at91/board-ecbat91.c
> @@ -28,7 +28,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/spi/flash.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -37,9 +37,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/cpu.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-eco920.c b/arch/arm/mach-at91/board-eco920.c
> index 82bdfde..814756e 100644
> --- a/arch/arm/mach-at91/board-eco920.c
> +++ b/arch/arm/mach-at91/board-eco920.c
> @@ -24,11 +24,11 @@
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91rm9200_mc.h>
> -#include <mach/at91_ramc.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91rm9200_mc.h>
> +#include <mach-at91/at91_ramc.h>
> +#include <mach-at91/cpu.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
> index 6cc83a8..d5315ef 100644
> --- a/arch/arm/mach-at91/board-flexibity.c
> +++ b/arch/arm/mach-at91/board-flexibity.c
> @@ -32,9 +32,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
> index 69ab124..43b5fc2 100644
> --- a/arch/arm/mach-at91/board-foxg20.c
> +++ b/arch/arm/mach-at91/board-foxg20.c
> @@ -32,7 +32,7 @@
>  #include <linux/clk.h>
>  #include <linux/w1-gpio.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -41,9 +41,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-gsia18s.c b/arch/arm/mach-at91/board-gsia18s.c
> index a9d5e78..b6d0d6f 100644
> --- a/arch/arm/mach-at91/board-gsia18s.c
> +++ b/arch/arm/mach-at91/board-gsia18s.c
> @@ -30,11 +30,11 @@
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/gsia18s.h>
> -#include <mach/stamp9g20.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/gsia18s.h>
> +#include <mach-at91/stamp9g20.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-kafa.c b/arch/arm/mach-at91/board-kafa.c
> index 64c1dbf..7e98f65 100644
> --- a/arch/arm/mach-at91/board-kafa.c
> +++ b/arch/arm/mach-at91/board-kafa.c
> @@ -25,7 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -34,9 +34,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/cpu.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
> index 5d96cb8..5b1bf97 100644
> --- a/arch/arm/mach-at91/board-kb9202.c
> +++ b/arch/arm/mach-at91/board-kb9202.c
> @@ -26,7 +26,7 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -35,11 +35,11 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/cpu.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91rm9200_mc.h>
> -#include <mach/at91_ramc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91rm9200_mc.h>
> +#include <mach-at91/at91_ramc.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-neocore926.c b/arch/arm/mach-at91/board-neocore926.c
> index 18103c5d..c9e9d89 100644
> --- a/arch/arm/mach-at91/board-neocore926.c
> +++ b/arch/arm/mach-at91/board-neocore926.c
> @@ -43,10 +43,10 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-pcontrol-g20.c b/arch/arm/mach-at91/board-pcontrol-g20.c
> index 9ca3e32..f809d33 100644
> --- a/arch/arm/mach-at91/board-pcontrol-g20.c
> +++ b/arch/arm/mach-at91/board-pcontrol-g20.c
> @@ -29,10 +29,10 @@
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/stamp9g20.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/stamp9g20.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-picotux200.c b/arch/arm/mach-at91/board-picotux200.c
> index 1270655..469000d 100644
> --- a/arch/arm/mach-at91/board-picotux200.c
> +++ b/arch/arm/mach-at91/board-picotux200.c
> @@ -28,7 +28,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/mtd/physmap.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -37,10 +37,10 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91rm9200_mc.h>
> -#include <mach/at91_ramc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91rm9200_mc.h>
> +#include <mach-at91/at91_ramc.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-qil-a9260.c b/arch/arm/mach-at91/board-qil-a9260.c
> index bf351e2..0364e46 100644
> --- a/arch/arm/mach-at91/board-qil-a9260.c
> +++ b/arch/arm/mach-at91/board-qil-a9260.c
> @@ -39,11 +39,11 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91_shdwc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91_shdwc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
> index cc2bf97..9769e97 100644
> --- a/arch/arm/mach-at91/board-rm9200dk.c
> +++ b/arch/arm/mach-at91/board-rm9200dk.c
> @@ -38,11 +38,11 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91rm9200_mc.h>
> -#include <mach/at91_ramc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91rm9200_mc.h>
> +#include <mach-at91/at91_ramc.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-rm9200ek.c b/arch/arm/mach-at91/board-rm9200ek.c
> index 62e19e6..2311b39 100644
> --- a/arch/arm/mach-at91/board-rm9200ek.c
> +++ b/arch/arm/mach-at91/board-rm9200ek.c
> @@ -38,11 +38,11 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91rm9200_mc.h>
> -#include <mach/at91_ramc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91rm9200_mc.h>
> +#include <mach-at91/at91_ramc.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/board-rsi-ews.c b/arch/arm/mach-at91/board-rsi-ews.c
> index c3b43ae..5dfc434 100644
> --- a/arch/arm/mach-at91/board-rsi-ews.c
> +++ b/arch/arm/mach-at91/board-rsi-ews.c
> @@ -24,9 +24,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
>  
>  #include <linux/gpio.h>
>  
> diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
> index 7bf6da7..39546b8 100644
> --- a/arch/arm/mach-at91/board-sam9-l9260.c
> +++ b/arch/arm/mach-at91/board-sam9-l9260.c
> @@ -28,7 +28,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/spi/spi.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -37,9 +37,9 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
> index 889c1bf..27865bc 100644
> --- a/arch/arm/mach-at91/board-sam9260ek.c
> +++ b/arch/arm/mach-at91/board-sam9260ek.c
> @@ -40,12 +40,12 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91_shdwc.h>
> -#include <mach/system_rev.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91_shdwc.h>
> +#include <mach-at91/system_rev.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
> index 2269be5..e37f30f 100644
> --- a/arch/arm/mach-at91/board-sam9261ek.c
> +++ b/arch/arm/mach-at91/board-sam9261ek.c
> @@ -44,12 +44,12 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91_shdwc.h>
> -#include <mach/system_rev.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91_shdwc.h>
> +#include <mach-at91/system_rev.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
> index 82adf58..b149347 100644
> --- a/arch/arm/mach-at91/board-sam9263ek.c
> +++ b/arch/arm/mach-at91/board-sam9263ek.c
> @@ -43,12 +43,12 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91_shdwc.h>
> -#include <mach/system_rev.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91_shdwc.h>
> +#include <mach-at91/system_rev.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
> index 4ea4ee0..cd48ea7 100644
> --- a/arch/arm/mach-at91/board-sam9g20ek.c
> +++ b/arch/arm/mach-at91/board-sam9g20ek.c
> @@ -34,7 +34,7 @@
>  
>  #include <linux/platform_data/at91_adc.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  #include <asm/irq.h>
> @@ -43,10 +43,10 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/system_rev.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/system_rev.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
> index 3d48ec1..4222519 100644
> --- a/arch/arm/mach-at91/board-sam9m10g45ek.c
> +++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
> @@ -29,7 +29,7 @@
>  
>  #include <linux/platform_data/at91_adc.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <video/atmel_lcdc.h>
>  #include <media/soc_camera.h>
>  #include <media/atmel-isi.h>
> @@ -42,11 +42,11 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91_shdwc.h>
> -#include <mach/system_rev.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91_shdwc.h>
> +#include <mach-at91/system_rev.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
> index e7dc3ea..80f805c 100644
> --- a/arch/arm/mach-at91/board-sam9rlek.c
> +++ b/arch/arm/mach-at91/board-sam9rlek.c
> @@ -29,11 +29,11 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91_shdwc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91_shdwc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
> index a4e031a..dada12c 100644
> --- a/arch/arm/mach-at91/board-snapper9260.c
> +++ b/arch/arm/mach-at91/board-snapper9260.c
> @@ -31,10 +31,10 @@
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-stamp9g20.c b/arch/arm/mach-at91/board-stamp9g20.c
> index 29eae16..64c7010 100644
> --- a/arch/arm/mach-at91/board-stamp9g20.c
> +++ b/arch/arm/mach-at91/board-stamp9g20.c
> @@ -25,9 +25,9 @@
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-usb-a926x.c b/arch/arm/mach-at91/board-usb-a926x.c
> index c1476b9..dacfc5b 100644
> --- a/arch/arm/mach-at91/board-usb-a926x.c
> +++ b/arch/arm/mach-at91/board-usb-a926x.c
> @@ -40,11 +40,11 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/at91_shdwc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91sam9_smc.h>
> +#include <mach-at91/at91_shdwc.h>
>  
>  #include "sam9_smc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
> index 516d340..fed4f0a 100644
> --- a/arch/arm/mach-at91/board-yl-9200.c
> +++ b/arch/arm/mach-at91/board-yl-9200.c
> @@ -42,12 +42,12 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/board.h>
> -#include <mach/at91_aic.h>
> -#include <mach/at91rm9200_mc.h>
> -#include <mach/at91_ramc.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/board.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91rm9200_mc.h>
> +#include <mach-at91/at91_ramc.h>
> +#include <mach-at91/cpu.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index de2ec6b..c5789a1 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -25,9 +25,9 @@
>  #include <linux/io.h>
>  #include <linux/of_address.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/cpu.h>
>  
>  #include <asm/proc-fns.h>
>  
> diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
> index 0c63815..6d03dc6 100644
> --- a/arch/arm/mach-at91/cpuidle.c
> +++ b/arch/arm/mach-at91/cpuidle.c
> @@ -21,7 +21,7 @@
>  #include <linux/export.h>
>  #include <asm/proc-fns.h>
>  #include <asm/cpuidle.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/cpu.h>
>  
>  #include "pm.h"
>  
> diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
> index be42cf0..ce21de2 100644
> --- a/arch/arm/mach-at91/gpio.c
> +++ b/arch/arm/mach-at91/gpio.c
> @@ -28,8 +28,8 @@
>  
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/at91_pio.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/at91_pio.h>
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/include/mach-at91/at91_ramc.h b/arch/arm/mach-at91/include/mach-at91/at91_ramc.h
> index d8aeb27..c871a14 100644
> --- a/arch/arm/mach-at91/include/mach-at91/at91_ramc.h
> +++ b/arch/arm/mach-at91/include/mach-at91/at91_ramc.h
> @@ -25,8 +25,8 @@ extern void __iomem *at91_ramc_base[];
>  #define AT91_MEMCTRL_SDRAMC    1
>  #define AT91_MEMCTRL_DDRSDR    2
>  
> -#include <mach/at91rm9200_sdramc.h>
> -#include <mach/at91sam9_ddrsdr.h>
> -#include <mach/at91sam9_sdramc.h>
> +#include <mach-at91/at91rm9200_sdramc.h>
> +#include <mach-at91/at91sam9_ddrsdr.h>
> +#include <mach-at91/at91sam9_sdramc.h>
>  
>  #endif /* __AT91_RAMC_H__ */
> diff --git a/arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h b/arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h
> index 175e1fd..2f6393e 100644
> --- a/arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h
> +++ b/arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h
> @@ -16,7 +16,7 @@
>  #ifndef AT91SAM9_SMC_H
>  #define AT91SAM9_SMC_H
>  
> -#include <mach/cpu.h>
> +#include <mach-at91/cpu.h>
>  
>  #ifndef __ASSEMBLY__
>  struct sam9_smc_config {
> diff --git a/arch/arm/mach-at91/include/mach-at91/atmel-mci.h b/arch/arm/mach-at91/include/mach-at91/atmel-mci.h
> index 998cb0c..d8f4109 100644
> --- a/arch/arm/mach-at91/include/mach-at91/atmel-mci.h
> +++ b/arch/arm/mach-at91/include/mach-at91/atmel-mci.h
> @@ -1,7 +1,7 @@
>  #ifndef __MACH_ATMEL_MCI_H
>  #define __MACH_ATMEL_MCI_H
>  
> -#include <mach/at_hdmac.h>
> +#include <mach-at91/at_hdmac.h>
>  
>  /**
>   * struct mci_dma_data - DMA data for MCI interface
> diff --git a/arch/arm/mach-at91/include/mach-at91/debug-macro.S b/arch/arm/mach-at91/include/mach-at91/debug-macro.S
> index c6bb9e2..8a1599c 100644
> --- a/arch/arm/mach-at91/include/mach-at91/debug-macro.S
> +++ b/arch/arm/mach-at91/include/mach-at91/debug-macro.S
> @@ -11,8 +11,8 @@
>   *
>  */
>  
> -#include <mach/hardware.h>
> -#include <mach/at91_dbgu.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/at91_dbgu.h>
>  
>  #if defined(CONFIG_AT91_DEBUG_LL_DBGU0)
>  #define AT91_DBGU AT91_BASE_DBGU0
> diff --git a/arch/arm/mach-at91/include/mach-at91/hardware.h b/arch/arm/mach-at91/include/mach-at91/hardware.h
> index 09242b6..caef81c 100644
> --- a/arch/arm/mach-at91/include/mach-at91/hardware.h
> +++ b/arch/arm/mach-at91/include/mach-at91/hardware.h
> @@ -23,16 +23,16 @@
>  #define AT91_BASE_DBGU1        0xffffee00
>  
>  #if defined(CONFIG_ARCH_AT91X40)
> -#include <mach/at91x40.h>
> +#include <mach-at91/at91x40.h>
>  #else
> -#include <mach/at91rm9200.h>
> -#include <mach/at91sam9260.h>
> -#include <mach/at91sam9261.h>
> -#include <mach/at91sam9263.h>
> -#include <mach/at91sam9rl.h>
> -#include <mach/at91sam9g45.h>
> -#include <mach/at91sam9x5.h>
> -#include <mach/at91sam9n12.h>
> +#include <mach-at91/at91rm9200.h>
> +#include <mach-at91/at91sam9260.h>
> +#include <mach-at91/at91sam9261.h>
> +#include <mach-at91/at91sam9263.h>
> +#include <mach-at91/at91sam9rl.h>
> +#include <mach-at91/at91sam9g45.h>
> +#include <mach-at91/at91sam9x5.h>
> +#include <mach-at91/at91sam9n12.h>
>  
>  /*
>   * On all at91 except rm9200 and x40 have the System Controller starts
> diff --git a/arch/arm/mach-at91/include/mach-at91/memory.h b/arch/arm/mach-at91/include/mach-at91/memory.h
> index 401c207..88c06fd 100644
> --- a/arch/arm/mach-at91/include/mach-at91/memory.h
> +++ b/arch/arm/mach-at91/include/mach-at91/memory.h
> @@ -21,6 +21,6 @@
>  #ifndef __ASM_ARCH_MEMORY_H
>  #define __ASM_ARCH_MEMORY_H
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  
>  #endif
> diff --git a/arch/arm/mach-at91/include/mach-at91/timex.h b/arch/arm/mach-at91/include/mach-at91/timex.h
> index 5e917a6..f4e72e2 100644
> --- a/arch/arm/mach-at91/include/mach-at91/timex.h
> +++ b/arch/arm/mach-at91/include/mach-at91/timex.h
> @@ -21,7 +21,7 @@
>  #ifndef __ASM_ARCH_TIMEX_H
>  #define __ASM_ARCH_TIMEX_H
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  
>  #ifdef CONFIG_ARCH_AT91X40
>  
> diff --git a/arch/arm/mach-at91/include/mach-at91/uncompress.h b/arch/arm/mach-at91/include/mach-at91/uncompress.h
> index 6f6118d..914feb7 100644
> --- a/arch/arm/mach-at91/include/mach-at91/uncompress.h
> +++ b/arch/arm/mach-at91/include/mach-at91/uncompress.h
> @@ -24,10 +24,10 @@
>  
>  #include <linux/io.h>
>  #include <linux/atmel_serial.h>
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  
> -#include <mach/at91_dbgu.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/at91_dbgu.h>
> +#include <mach-at91/cpu.h>
>  
>  void __iomem *at91_uart;
>  
> diff --git a/arch/arm/mach-at91/irq.c b/arch/arm/mach-at91/irq.c
> index 1e02c0e..eeddbec 100644
> --- a/arch/arm/mach-at91/irq.c
> +++ b/arch/arm/mach-at91/irq.c
> @@ -33,7 +33,7 @@
>  #include <linux/err.h>
>  #include <linux/slab.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-at91/hardware.h>
>  #include <asm/irq.h>
>  #include <asm/setup.h>
>  
> @@ -42,7 +42,7 @@
>  #include <asm/mach/irq.h>
>  #include <asm/mach/map.h>
>  
> -#include <mach/at91_aic.h>
> +#include <mach-at91/at91_aic.h>
>  
>  void __iomem *at91_aic_base;
>  static struct irq_domain *at91_aic_domain;
> diff --git a/arch/arm/mach-at91/leds.c b/arch/arm/mach-at91/leds.c
> index 8dfafe7..f921b1e 100644
> --- a/arch/arm/mach-at91/leds.c
> +++ b/arch/arm/mach-at91/leds.c
> @@ -15,7 +15,7 @@
>  #include <linux/init.h>
>  #include <linux/platform_device.h>
>  
> -#include <mach/board.h>
> +#include <mach-at91/board.h>
>  
>  
>  /* ------------------------------------------------------------------------- */
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index 2c2d865..a5b940e 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -25,9 +25,9 @@
>  #include <asm/mach/time.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/at91_aic.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/cpu.h>
> +#include <mach-at91/at91_aic.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/cpu.h>
>  
>  #include "generic.h"
>  #include "pm.h"
> @@ -36,8 +36,8 @@
>   * Show the reason for the previous system reset.
>   */
>  
> -#include <mach/at91_rstc.h>
> -#include <mach/at91_shdwc.h>
> +#include <mach-at91/at91_rstc.h>
> +#include <mach-at91/at91_shdwc.h>
>  
>  static void __init show_reset_status(void)
>  {
> diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
> index 38f467c..529072a 100644
> --- a/arch/arm/mach-at91/pm.h
> +++ b/arch/arm/mach-at91/pm.h
> @@ -11,8 +11,8 @@
>  #ifndef __ARCH_ARM_MACH_AT91_PM
>  #define __ARCH_ARM_MACH_AT91_PM
>  
> -#include <mach/at91_ramc.h>
> -#include <mach/at91rm9200_sdramc.h>
> +#include <mach-at91/at91_ramc.h>
> +#include <mach-at91/at91rm9200_sdramc.h>
>  
>  /*
>   * The AT91RM9200 goes into self-refresh mode with this command, and will
> diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
> index 098c28d..8f263c6 100644
> --- a/arch/arm/mach-at91/pm_slowclock.S
> +++ b/arch/arm/mach-at91/pm_slowclock.S
> @@ -13,9 +13,9 @@
>   */
>  
>  #include <linux/linkage.h>
> -#include <mach/hardware.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/at91_ramc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/at91_ramc.h>
>  
>  
>  #ifdef CONFIG_SOC_AT91SAM9263
> diff --git a/arch/arm/mach-at91/sam9_smc.c b/arch/arm/mach-at91/sam9_smc.c
> index 99a0a1d..be40bf2 100644
> --- a/arch/arm/mach-at91/sam9_smc.c
> +++ b/arch/arm/mach-at91/sam9_smc.c
> @@ -14,7 +14,7 @@
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  
> -#include <mach/at91sam9_smc.h>
> +#include <mach-at91/at91sam9_smc.h>
>  
>  #include "sam9_smc.h"
>  
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 944bffb..0fe58d5 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -14,11 +14,11 @@
>  #include <asm/system_misc.h>
>  #include <asm/mach/map.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/cpu.h>
> -#include <mach/at91_dbgu.h>
> -#include <mach/at91_pmc.h>
> -#include <mach/at91_shdwc.h>
> +#include <mach-at91/hardware.h>
> +#include <mach-at91/cpu.h>
> +#include <mach-at91/at91_dbgu.h>
> +#include <mach-at91/at91_pmc.h>
> +#include <mach-at91/at91_shdwc.h>
>  
>  #include "soc.h"
>  #include "generic.h"
> diff --git a/arch/arm/mach-bcmring/arch.c b/arch/arm/mach-bcmring/arch.c
> index 45c97b1..f7469da 100644
> --- a/arch/arm/mach-bcmring/arch.c
> +++ b/arch/arm/mach-bcmring/arch.c
> @@ -32,11 +32,11 @@
>  #include <asm/pmu.h>
>  
>  #include <asm/mach/arch.h>
> -#include <mach/dma.h>
> -#include <mach/hardware.h>
> -#include <mach/csp/mm_io.h>
> -#include <mach/csp/chipcHw_def.h>
> -#include <mach/csp/chipcHw_inline.h>
> +#include <mach-bcmring/dma.h>
> +#include <mach-bcmring/hardware.h>
> +#include <mach-bcmring/csp/mm_io.h>
> +#include <mach-bcmring/csp/chipcHw_def.h>
> +#include <mach-bcmring/csp/chipcHw_inline.h>
>  
>  #include <cfg_global.h>
>  
> diff --git a/arch/arm/mach-bcmring/clock.c b/arch/arm/mach-bcmring/clock.c
> index ad237a4..108845f 100644
> --- a/arch/arm/mach-bcmring/clock.c
> +++ b/arch/arm/mach-bcmring/clock.c
> @@ -22,10 +22,10 @@
>  #include <linux/clk.h>
>  #include <linux/spinlock.h>
>  #include <linux/clkdev.h>
> -#include <mach/csp/hw_cfg.h>
> -#include <mach/csp/chipcHw_def.h>
> -#include <mach/csp/chipcHw_reg.h>
> -#include <mach/csp/chipcHw_inline.h>
> +#include <mach-bcmring/csp/hw_cfg.h>
> +#include <mach-bcmring/csp/chipcHw_def.h>
> +#include <mach-bcmring/csp/chipcHw_reg.h>
> +#include <mach-bcmring/csp/chipcHw_inline.h>
>  
>  #include "clock.h"
>  
> diff --git a/arch/arm/mach-bcmring/clock.h b/arch/arm/mach-bcmring/clock.h
> index 5e0b981..2e01614 100644
> --- a/arch/arm/mach-bcmring/clock.h
> +++ b/arch/arm/mach-bcmring/clock.h
> @@ -11,7 +11,7 @@
>  * license other than the GPL, without Broadcom's express prior written
>  * consent.
>  *****************************************************************************/
> -#include <mach/csp/chipcHw_def.h>
> +#include <mach-bcmring/csp/chipcHw_def.h>
>  
>  #define CLK_TYPE_PRIMARY         1     /* primary clock must NOT have a parent */
>  #define CLK_TYPE_PLL1            2     /* PPL1 */
> diff --git a/arch/arm/mach-bcmring/core.c b/arch/arm/mach-bcmring/core.c
> index adbfb19..4d089b3 100644
> --- a/arch/arm/mach-bcmring/core.c
> +++ b/arch/arm/mach-bcmring/core.c
> @@ -29,8 +29,8 @@
>  #include <linux/amba/bus.h>
>  #include <linux/clkdev.h>
>  
> -#include <mach/csp/mm_addr.h>
> -#include <mach/hardware.h>
> +#include <mach-bcmring/csp/mm_addr.h>
> +#include <mach-bcmring/hardware.h>
>  #include <linux/io.h>
>  #include <asm/irq.h>
>  #include <asm/hardware/arm_timer.h>
> @@ -48,9 +48,9 @@
>  #include "clock.h"
>  
>  #include <csp/secHw.h>
> -#include <mach/csp/secHw_def.h>
> -#include <mach/csp/chipcHw_inline.h>
> -#include <mach/csp/tmrHw_reg.h>
> +#include <mach-bcmring/csp/secHw_def.h>
> +#include <mach-bcmring/csp/chipcHw_inline.h>
> +#include <mach-bcmring/csp/tmrHw_reg.h>
>  
>  static AMBA_APB_DEVICE(uartA, "uartA", 0, MM_ADDR_IO_UARTA, {IRQ_UARTA}, NULL);
>  static AMBA_APB_DEVICE(uartB, "uartB", 0, MM_ADDR_IO_UARTB, {IRQ_UARTB}, NULL);
> diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
> index 96273ff..270689d 100644
> --- a/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
> +++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
> @@ -30,8 +30,8 @@
>  #include <csp/stdint.h>
>  #include <csp/module.h>
>  
> -#include <mach/csp/chipcHw_def.h>
> -#include <mach/csp/chipcHw_inline.h>
> +#include <mach-bcmring/csp/chipcHw_def.h>
> +#include <mach-bcmring/csp/chipcHw_inline.h>
>  
>  #include <csp/reg.h>
>  #include <csp/delay.h>
> diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
> index 367df75..48e5977 100644
> --- a/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
> +++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
> @@ -30,8 +30,8 @@
>  #include <csp/stdint.h>
>  #include <csp/module.h>
>  
> -#include <mach/csp/chipcHw_def.h>
> -#include <mach/csp/chipcHw_inline.h>
> +#include <mach-bcmring/csp/chipcHw_def.h>
> +#include <mach-bcmring/csp/chipcHw_inline.h>
>  
>  #include <csp/reg.h>
>  #include <csp/delay.h>
> diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
> index 2671d88..0aee4f2 100644
> --- a/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
> +++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
> @@ -14,8 +14,8 @@
>  
>  /* ---- Include Files ---------------------------------------------------- */
>  #include <csp/stdint.h>
> -#include <mach/csp/chipcHw_def.h>
> -#include <mach/csp/chipcHw_inline.h>
> +#include <mach-bcmring/csp/chipcHw_def.h>
> +#include <mach-bcmring/csp/chipcHw_inline.h>
>  #include <csp/intcHw.h>
>  #include <csp/cache.h>
>  
> diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
> index 54ad964..d466c49 100644
> --- a/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
> +++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
> @@ -23,7 +23,7 @@
>  
>  /* ---- Include Files ---------------------------------------------------- */
>  
> -#include <mach/csp/chipcHw_inline.h>
> +#include <mach-bcmring/csp/chipcHw_inline.h>
>  
>  /* ---- Private Constants and Types --------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
> index 6b9be2e..4a9675a 100644
> --- a/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
> +++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
> @@ -30,9 +30,9 @@
>  #include <stddef.h>
>  
>  #include <csp/dmacHw.h>
> -#include <mach/csp/dmacHw_reg.h>
> -#include <mach/csp/dmacHw_priv.h>
> -#include <mach/csp/chipcHw_inline.h>
> +#include <mach-bcmring/csp/dmacHw_reg.h>
> +#include <mach-bcmring/csp/dmacHw_priv.h>
> +#include <mach-bcmring/csp/chipcHw_inline.h>
>  
>  /* ---- External Function Prototypes ------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
> index a1f3283..f4e883a 100644
> --- a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
> +++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
> @@ -30,8 +30,8 @@
>  #include <stddef.h>
>  
>  #include <csp/dmacHw.h>
> -#include <mach/csp/dmacHw_reg.h>
> -#include <mach/csp/dmacHw_priv.h>
> +#include <mach-bcmring/csp/dmacHw_reg.h>
> +#include <mach-bcmring/csp/dmacHw_priv.h>
>  
>  extern dmacHw_CBLK_t dmacHw_gCblk[dmacHw_MAX_CHANNEL_COUNT];   /* Declared in dmacHw.c */
>  
> diff --git a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
> index 16225e4..220e314 100644
> --- a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
> +++ b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
> @@ -30,7 +30,7 @@
>  #include <csp/stdint.h>
>  
>  #include <csp/tmrHw.h>
> -#include <mach/csp/tmrHw_reg.h>
> +#include <mach-bcmring/csp/tmrHw_reg.h>
>  
>  #define tmrHw_ASSERT(a)                     if (!(a)) *(char *)0 = 0
>  #define tmrHw_MILLISEC_PER_SEC              (1000)
> diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
> index e5fd241..e90cfdf 100644
> --- a/arch/arm/mach-bcmring/dma.c
> +++ b/arch/arm/mach-bcmring/dma.c
> @@ -31,11 +31,11 @@
>  #include <linux/proc_fs.h>
>  #include <linux/slab.h>
>  
> -#include <mach/timer.h>
> +#include <mach-bcmring/timer.h>
>  
>  #include <linux/pfn.h>
>  #include <linux/atomic.h>
> -#include <mach/dma.h>
> +#include <mach-bcmring/dma.h>
>  
>  /* ---- Public Variables ------------------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/include/csp/dmacHw.h b/arch/arm/mach-bcmring/include/csp/dmacHw.h
> index e6a1dc4..97d8a04 100644
> --- a/arch/arm/mach-bcmring/include/csp/dmacHw.h
> +++ b/arch/arm/mach-bcmring/include/csp/dmacHw.h
> @@ -26,7 +26,7 @@
>  #include <stddef.h>
>  
>  #include <csp/stdint.h>
> -#include <mach/csp/dmacHw_reg.h>
> +#include <mach-bcmring/csp/dmacHw_reg.h>
>  
>  /* Define DMA Channel ID using DMA controller number (m) and channel number (c).
>  
> diff --git a/arch/arm/mach-bcmring/include/csp/intcHw.h b/arch/arm/mach-bcmring/include/csp/intcHw.h
> index 1c639c8..eb7d3ae 100644
> --- a/arch/arm/mach-bcmring/include/csp/intcHw.h
> +++ b/arch/arm/mach-bcmring/include/csp/intcHw.h
> @@ -28,7 +28,7 @@
>  #define _INTCHW_H
>  
>  /* ---- Include Files ---------------------------------------------------- */
> -#include <mach/csp/intcHw_reg.h>
> +#include <mach-bcmring/csp/intcHw_reg.h>
>  
>  /* ---- Public Constants and Types --------------------------------------- */
>  /* ---- Public Variable Externs ------------------------------------------ */
> diff --git a/arch/arm/mach-bcmring/include/csp/reg.h b/arch/arm/mach-bcmring/include/csp/reg.h
> index 56654d2..23ac669 100644
> --- a/arch/arm/mach-bcmring/include/csp/reg.h
> +++ b/arch/arm/mach-bcmring/include/csp/reg.h
> @@ -69,7 +69,7 @@
>  /*  */
>  
>  #if defined(__KERNEL__) && !defined(STANDALONE)
> -#include <mach/hardware.h>
> +#include <mach-bcmring/hardware.h>
>  #include <linux/interrupt.h>
>  
>  #define REG_LOCAL_IRQ_SAVE      HW_DECLARE_SPINLOCK(reg32) \
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h
> index 933ce68..4a1ecfa 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h
> @@ -16,7 +16,7 @@
>  #define CAP_INLINE_H
>  
>  /* ---- Include Files ---------------------------------------------------- */
> -#include <mach/csp/cap.h>
> +#include <mach-bcmring/csp/cap.h>
>  #include <cfg_global.h>
>  
>  /* ---- Public Constants and Types --------------------------------------- */
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h
> index 1619733..fe57b08 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h
> @@ -20,7 +20,7 @@
>  #include <csp/stdint.h>
>  #include <csp/errno.h>
>  #include <csp/reg.h>
> -#include <mach/csp/chipcHw_reg.h>
> +#include <mach-bcmring/csp/chipcHw_reg.h>
>  
>  /* ---- Public Constants and Types ---------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h
> index 03238c2..108209c 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h
> @@ -19,8 +19,8 @@
>  
>  #include <csp/errno.h>
>  #include <csp/reg.h>
> -#include <mach/csp/chipcHw_reg.h>
> -#include <mach/csp/chipcHw_def.h>
> +#include <mach-bcmring/csp/chipcHw_reg.h>
> +#include <mach-bcmring/csp/chipcHw_def.h>
>  
>  /* ---- Private Constants and Types --------------------------------------- */
>  typedef enum {
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h
> index b162448..85b13d7 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h
> @@ -23,9 +23,9 @@
>  #ifndef CHIPCHW_REG_H
>  #define CHIPCHW_REG_H
>  
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  #include <csp/reg.h>
> -#include <mach/csp/ddrcReg.h>
> +#include <mach-bcmring/csp/ddrcReg.h>
>  
>  #define chipcHw_BASE_ADDRESS    MM_IO_BASE_CHIPC
>  
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h
> index f1b68e2..462c099 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h
> @@ -33,7 +33,7 @@ extern "C" {
>  #include <csp/reg.h>
>  #include <csp/stdint.h>
>  
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>  /* ---- Public Constants and Types --------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h
> index f1ecf96..1f5263f 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h
> @@ -25,7 +25,7 @@
>  #define _DMACHW_REG_H
>  
>  #include <csp/stdint.h>
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>  /* Data type for 64 bit little endian register */
>  typedef struct {
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h
> index cfa91be..aad4e17 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h
> @@ -19,10 +19,10 @@
>  /* ---- Include Files ---------------------------------------------------- */
>  
>  #include <cfg_global.h>
> -#include <mach/csp/cap_inline.h>
> +#include <mach-bcmring/csp/cap_inline.h>
>  
>  #if defined(__KERNEL__)
> -#include <mach/memory_settings.h>
> +#include <mach-bcmring/memory_settings.h>
>  #else
>  #include <hw_cfg.h>
>  #endif
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h
> index 0aeb6a6..0770d7d 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h
> @@ -29,7 +29,7 @@
>  /* ---- Include Files ---------------------------------------------------- */
>  #include <csp/stdint.h>
>  #include <csp/reg.h>
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>  /* ---- Public Constants and Types --------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h
> index de92ec6..dcb1eae 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h
> @@ -27,7 +27,7 @@
>  #define _MM_IO_H
>  
>  /* ---- Include Files ---------------------------------------------------- */
> -#include <mach/csp/mm_addr.h>
> +#include <mach-bcmring/csp/mm_addr.h>
>  
>  #if !defined(CSP_SIMULATION)
>  #include <cfg_global.h>
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h
> index d15f5f3..18279ce 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h
> @@ -26,7 +26,7 @@
>  #ifndef SECHW_DEF_H
>  #define SECHW_DEF_H
>  
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>  /* Bit mask for various secure device */
>  #define secHw_BLK_MASK_CHIP_CONTROL     0x00000001
> @@ -95,6 +95,6 @@ static inline void secHw_setUnsecure(uint32_t mask    /*  mask of type secHw_BLK_MA
>  /****************************************************************************/
>  static inline uint32_t secHw_getStatus(void);
>  
> -#include <mach/csp/secHw_inline.h>
> +#include <mach-bcmring/csp/secHw_inline.h>
>  
>  #endif /* SECHW_DEF_H */
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h b/arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h
> index 3080ac7..e6069f5 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h
> @@ -23,8 +23,8 @@
>  #ifndef _TMRHW_REG_H
>  #define _TMRHW_REG_H
>  
> -#include <mach/csp/mm_io.h>
> -#include <mach/csp/hw_cfg.h>
> +#include <mach-bcmring/csp/mm_io.h>
> +#include <mach-bcmring/csp/hw_cfg.h>
>  /* Base address */
>  #define tmrHw_MODULE_BASE_ADDR          MM_IO_BASE_TMR
>  
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/dma.h b/arch/arm/mach-bcmring/include/mach-bcmring/dma.h
> index 7254378..366caa3 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/dma.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/dma.h
> @@ -28,7 +28,7 @@
>  #include <linux/kernel.h>
>  #include <linux/semaphore.h>
>  #include <csp/dmacHw.h>
> -#include <mach/timer.h>
> +#include <mach-bcmring/timer.h>
>  
>  /* ---- Constants and Types ---------------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S b/arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S
> index 2f316f0..8967896 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S
> @@ -17,9 +17,9 @@
>   * Low-level IRQ helper macros for BCMRing-based platforms
>   *
>   */
> -#include <mach/irqs.h>
> -#include <mach/hardware.h>
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/irqs.h>
> +#include <mach-bcmring/hardware.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>                 .macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
>                 ldr     \base, =(MM_IO_BASE_INTC0)
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/hardware.h b/arch/arm/mach-bcmring/include/mach-bcmring/hardware.h
> index 6ae20a6..c708efd 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/hardware.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/hardware.h
> @@ -23,7 +23,7 @@
>  
>  #include <asm/sizes.h>
>  #include <cfg_global.h>
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>  /* Hardware addresses of major areas.
>   *  *_START is the physical address
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h b/arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h
> index 387376f..ec773c2 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h
> @@ -31,7 +31,7 @@
>  
>  /* ---- Include Files ---------------------------------------------------- */
>  #include <csp/reg.h>
> -#include <mach/reg_umi.h>
> +#include <mach-bcmring/reg_umi.h>
>  
>  /* ---- Constants and Types ---------------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h b/arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h
> index 0992842..f659cc1 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h
> @@ -31,7 +31,7 @@
>  
>  /* ---- Include Files ---------------------------------------------------- */
>  #include <csp/reg.h>
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>  /* ---- Constants and Types ---------------------------------------------- */
>  
> diff --git a/arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h b/arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h
> index 9c9821b..b11fb3f 100644
> --- a/arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h
> +++ b/arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h
> @@ -11,7 +11,7 @@
>  * license other than the GPL, without Broadcom's express prior written
>  * consent.
>  *****************************************************************************/
> -#include <mach/csp/mm_addr.h>
> +#include <mach-bcmring/csp/mm_addr.h>
>  
>  #define BCMRING_UART_0_DR (*(volatile unsigned int *)MM_ADDR_IO_UARTA)
>  #define BCMRING_UART_0_FR (*(volatile unsigned int *)(MM_ADDR_IO_UARTA + 0x18))
> diff --git a/arch/arm/mach-bcmring/irq.c b/arch/arm/mach-bcmring/irq.c
> index 437fa68..aa88cac 100644
> --- a/arch/arm/mach-bcmring/irq.c
> +++ b/arch/arm/mach-bcmring/irq.c
> @@ -22,12 +22,12 @@
>  #include <linux/timer.h>
>  #include <linux/io.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-bcmring/hardware.h>
>  #include <asm/irq.h>
>  
>  #include <asm/mach/irq.h>
> -#include <mach/csp/intcHw_reg.h>
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/csp/intcHw_reg.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>  static void bcmring_mask_irq0(struct irq_data *d)
>  {
> diff --git a/arch/arm/mach-bcmring/mm.c b/arch/arm/mach-bcmring/mm.c
> index 1adec78e..411fa2b 100644
> --- a/arch/arm/mach-bcmring/mm.c
> +++ b/arch/arm/mach-bcmring/mm.c
> @@ -17,8 +17,8 @@
>  #include <asm/page.h>
>  #include <asm/mach/map.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/csp/mm_io.h>
> +#include <mach-bcmring/hardware.h>
> +#include <mach-bcmring/csp/mm_io.h>
>  
>  #define IO_DESC(va, sz) { .virtual = va, \
>         .pfn = __phys_to_pfn(HW_IO_VIRT_TO_PHYS(va)), \
> diff --git a/arch/arm/mach-bcmring/timer.c b/arch/arm/mach-bcmring/timer.c
> index af9c3d7..ba9754d 100644
> --- a/arch/arm/mach-bcmring/timer.c
> +++ b/arch/arm/mach-bcmring/timer.c
> @@ -16,7 +16,7 @@
>  #include <linux/module.h>
>  #include <csp/tmrHw.h>
>  
> -#include <mach/timer.h>
> +#include <mach-bcmring/timer.h>
>  /* The core.c file initializes timers 1 and 3 as a linux clocksource. */
>  /* The real time clock should probably be the real linux clocksource. */
>  /* In the meantime, this file should agree with core.c as to the */
> diff --git a/arch/arm/mach-clps711x/autcpu12.c b/arch/arm/mach-clps711x/autcpu12.c
> index 3fb79a1..82ec281 100644
> --- a/arch/arm/mach-clps711x/autcpu12.c
> +++ b/arch/arm/mach-clps711x/autcpu12.c
> @@ -24,7 +24,7 @@
>  #include <linux/mm.h>
>  #include <linux/io.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-clps711x/hardware.h>
>  #include <asm/sizes.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
> @@ -33,7 +33,7 @@
>  #include <asm/page.h>
>  
>  #include <asm/mach/map.h>
> -#include <mach/autcpu12.h>
> +#include <mach-clps711x/autcpu12.h>
>  
>  #include "common.h"
>  
> diff --git a/arch/arm/mach-clps711x/cdb89712.c b/arch/arm/mach-clps711x/cdb89712.c
> index c314f49..6693600 100644
> --- a/arch/arm/mach-clps711x/cdb89712.c
> +++ b/arch/arm/mach-clps711x/cdb89712.c
> @@ -24,7 +24,7 @@
>  #include <linux/mm.h>
>  #include <linux/io.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-clps711x/hardware.h>
>  #include <asm/pgtable.h>
>  #include <asm/page.h>
>  #include <asm/setup.h>
> diff --git a/arch/arm/mach-clps711x/ceiva.c b/arch/arm/mach-clps711x/ceiva.c
> index a70147e..177fb74 100644
> --- a/arch/arm/mach-clps711x/ceiva.c
> +++ b/arch/arm/mach-clps711x/ceiva.c
> @@ -27,7 +27,7 @@
>  
>  #include <linux/kernel.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-clps711x/hardware.h>
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
>  #include <asm/sizes.h>
> diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
> index f15293b..5b4fa62 100644
> --- a/arch/arm/mach-clps711x/common.c
> +++ b/arch/arm/mach-clps711x/common.c
> @@ -28,7 +28,7 @@
>  #include <linux/sched.h>
>  
>  #include <asm/sizes.h>
> -#include <mach/hardware.h>
> +#include <mach-clps711x/hardware.h>
>  #include <asm/irq.h>
>  #include <asm/leds.h>
>  #include <asm/pgtable.h>
> diff --git a/arch/arm/mach-clps711x/edb7211-mm.c b/arch/arm/mach-clps711x/edb7211-mm.c
> index 4372f06..6d3e94e 100644
> --- a/arch/arm/mach-clps711x/edb7211-mm.c
> +++ b/arch/arm/mach-clps711x/edb7211-mm.c
> @@ -23,7 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/bug.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-clps711x/hardware.h>
>  #include <asm/page.h>
>  #include <asm/sizes.h>
>   
> diff --git a/arch/arm/mach-clps711x/fortunet.c b/arch/arm/mach-clps711x/fortunet.c
> index 3a3f0b7..12a1368 100644
> --- a/arch/arm/mach-clps711x/fortunet.c
> +++ b/arch/arm/mach-clps711x/fortunet.c
> @@ -23,7 +23,7 @@
>  #include <linux/init.h>
>  #include <linux/initrd.h>
>  
> -#include <mach/hardware.h>
> +#include <mach-clps711x/hardware.h>
>  #include <asm/setup.h>
>  #include <asm/mach-types.h>
>  
> diff --git a/arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S b/arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S
> index 118b3d9..52bd3ef 100644
> --- a/arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S
> +++ b/arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S
> @@ -11,7 +11,7 @@
>   *
>  */
>  
> -#include <mach/hardware.h>
> +#include <mach-clps711x/hardware.h>
>  
>                 .macro  addruart, rp, rv, tmp
>  #ifndef CONFIG_DEBUG_CLPS711X_UART2
> diff --git a/arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S b/arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S
> index 56e5c2c..889521e 100644
> --- a/arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S
> +++ b/arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S
> @@ -7,7 +7,7 @@
>   * License version 2. This program is licensed "as is" without any
>   * warranty of any kind, whether express or implied.
>   */
> -#include <mach/hardware.h>
> +#include <mach-clps711x/hardware.h>
>  
>                 .macro  get_irqnr_preamble, base, tmp
>                 .endm
> diff --git a/arch/arm/mach-clps711x/include/mach-clps711x/hardware.h b/arch/arm/mach-clps711x/include/mach-clps711x/hardware.h
> index 13a64fc..29f3409 100644
> --- a/arch/arm/mach-clps711x/include/mach-clps711x/hardware.h
> +++ b/arch/arm/mach-clps711x/include/mach-clps711x/hardware.h
> @@ -22,7 +22,7 @@
>  #ifndef __MACH_HARDWARE_H
>  #define __MACH_HARDWARE_H
>  
> -#include <mach/clps711x.h>
> +#include <mach-clps711x/clps711x.h>
>  
>  #define CLPS711X_VIRT_BASE     IOMEM(0xff000000)
>  
> ---
> Intentionally cut off for review. If you managed to read this far, you
> get the idea. See the rest at
> http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=commit;h=d59d6b49ed5287dd0131acda9428fdc0bb0a7365
> 
> 
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel
> 
