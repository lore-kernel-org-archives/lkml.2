Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817Ab2KWHAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:00:05 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:58051 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab2KWHAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:00:03 -0500
Message-ID: <20655.7916.566188.590202@ipc1.ka-ro>
Date: Fri, 23 Nov 2012 07:59:56 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [BUGFIX PATCH] ASoC: fsl: fix miscompilation of snd-soc-imx-pcm
In-Reply-To: <20121123020517.GJ4385@opensource.wolfsonmicro.com>
References: <1353587470-11994-1-git-send-email-LW@KARO-electronics.de>
	<20121123020517.GJ4385@opensource.wolfsonmicro.com>
X-Mailer: VM 8.1.0 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mark Brown writes:
> On Thu, Nov 22, 2012 at 01:31:06PM +0100, Lothar Waßmann wrote:
> 
> >  obj-$(CONFIG_SND_SOC_IMX_PCM) += snd-soc-imx-pcm.o
> >  snd-soc-imx-pcm-y := imx-pcm.o
> > -snd-soc-imx-pcm-$(CONFIG_SND_SOC_IMX_PCM_FIQ) += imx-pcm-fiq.o
> > -snd-soc-imx-pcm-$(CONFIG_SND_SOC_IMX_PCM_DMA) += imx-pcm-dma.o
> > +ifneq ($(CONFIG_SND_SOC_IMX_PCM_FIQ),)
> > +	snd-soc-imx-pcm-objs += imx-pcm-fiq.o
> > +endif
> > +ifneq ($(CONFIG_SND_SOC_IMX_PCM_DMA),)
> > +	snd-soc-imx-pcm-objs += imx-pcm-dma.o
> > +endif
> 
> What is the actual bug here?  This fix doesn't look obviously right, and
> if we do need to move to -objs for some reason then the block ought to
> be in the -objs section of the Makefile.
>
As I mentioned in the part of my email that you didn't quote, if the
sound driver is being compiled as module, the files imx-pcm-fiq.c or
imx-pcm-dma.c which should be compiled as part of imx-pcm.o will not
be touched by the compiler:
CONFIG_SND_SOC_IMX_PCM=m
CONFIG_SND_SOC_IMX_PCM_DMA=m
CONFIG_SND_SOC_IMX_AUDMUX=m
CONFIG_SND_SOC_IMX_SGTL5000=m
  GEN     /usr/local/src/arm/projects/imx53/Release/rel-next/.build-snd-bugfix/Makefile
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig Kconfig
#
# configuration written to .config
#
  GEN     /projects/imx53/Release/rel-next/.build-snd-bugfix/Makefile
  CHK     include/generated/uapi/linux/version.h
  Using /usr/local/src/arm/projects/imx53/Release/rel-next/linux-next as source for kernel
  CHK     include/generated/utsrelease.h
make[2]: `include/generated/mach-types.h' is up to date.
  CALL    /usr/local/src/arm/projects/imx53/Release/rel-next/linux-next/scripts/checksyscalls.sh
  LD      sound/core/built-in.o
  CC [M]  sound/core/compress_offload.o
  LD      sound/soc/built-in.o
  CC [M]  sound/soc/soc-core.o
  CC [M]  sound/soc/soc-dapm.o
  CC [M]  sound/soc/soc-jack.o
  CC [M]  sound/core/memalloc.o
  CC [M]  sound/core/pcm.o
  CC [M]  sound/soc/soc-cache.o
  CC [M]  sound/core/pcm_native.o
  CC [M]  sound/core/pcm_lib.o
  CC [M]  sound/soc/soc-utils.o
  CC [M]  sound/core/pcm_timer.o
  CC [M]  sound/soc/soc-pcm.o
  CC [M]  sound/soc/soc-compress.o
  CC [M]  sound/soc/soc-io.o
  CC [M]  sound/soc/soc-dmaengine-pcm.o
  CC [M]  sound/core/pcm_misc.o
  CC [M]  sound/core/pcm_memory.o
  CC [M]  sound/core/timer.o
  LD      sound/soc/codecs/built-in.o
  CC [M]  sound/soc/codecs/sgtl5000.o
  LD      sound/soc/fsl/built-in.o
  CC [M]  sound/soc/fsl/fsl_ssi.o
  CC [M]  sound/soc/fsl/fsl_utils.o
  CC [M]  sound/soc/fsl/imx-audmux.o
  LD [M]  sound/soc/codecs/snd-soc-sgtl5000.o
  CC [M]  sound/soc/fsl/imx-pcm.o
  CC [M]  sound/soc/fsl/imx-sgtl5000.o
  LD [M]  sound/soc/snd-soc-core.o
  LD [M]  sound/core/snd-timer.o
  LD [M]  sound/core/snd-hrtimer.o
  LD [M]  sound/core/snd-pcm.o
  LD [M]  sound/core/snd-page-alloc.o
  LD [M]  sound/core/snd-compress.o
  LD [M]  sound/soc/fsl/snd-soc-fsl-ssi.o
  LD [M]  sound/soc/fsl/snd-soc-fsl-utils.o
  LD [M]  sound/soc/fsl/snd-soc-imx-audmux.o
  LD [M]  sound/soc/fsl/snd-soc-imx-pcm.o
  LD [M]  sound/soc/fsl/snd-soc-imx-sgtl5000.o
  LD      sound/built-in.o


With the following config:
CONFIG_SND_SOC_IMX_PCM=y
CONFIG_SND_SOC_IMX_PCM_DMA=y
CONFIG_SND_SOC_IMX_AUDMUX=y
CONFIG_SND_SOC_IMX_SGTL5000=y
  GEN     /usr/local/src/arm/projects/imx53/Release/rel-next/.build-snd-bugfix/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
  GEN     /usr/local/src/arm/projects/imx53/Release/rel-next/.build-snd-bugfix/Makefile
  CHK     include/generated/uapi/linux/version.h
  Using /usr/local/src/arm/projects/imx53/Release/rel-next/linux-next as source for kernel
  CHK     include/generated/utsrelease.h
make[2]: `include/generated/mach-types.h' is up to date.
  CALL    /usr/local/src/arm/projects/imx53/Release/rel-next/linux-next/scripts/checksyscalls.sh
  CC      sound/soc/soc-core.o
  CC      sound/soc/soc-dapm.o
  CC      sound/soc/soc-jack.o
  CC      sound/soc/soc-cache.o
  CC      sound/soc/soc-utils.o
  CC      sound/soc/soc-pcm.o
  CC      sound/soc/soc-compress.o
  CC      sound/soc/soc-io.o
  CC      sound/soc/soc-dmaengine-pcm.o
  LD      sound/soc/atmel/built-in.o
  LD      sound/soc/au1x/built-in.o
  LD      sound/soc/blackfin/built-in.o
  LD      sound/soc/cirrus/built-in.o
  CC      sound/soc/codecs/sgtl5000.o
  LD      sound/soc/davinci/built-in.o
  LD      sound/soc/dwc/built-in.o
  CC      sound/soc/fsl/fsl_ssi.o
  LD      sound/soc/generic/built-in.o
  LD      sound/soc/jz4740/built-in.o
  LD      sound/soc/kirkwood/built-in.o
  LD      sound/soc/mid-x86/built-in.o
  LD      sound/soc/mxs/built-in.o
  LD      sound/soc/nuc900/built-in.o
  LD      sound/soc/omap/built-in.o
  CC      sound/soc/fsl/fsl_utils.o
  LD      sound/soc/pxa/built-in.o
  LD      sound/soc/s6000/built-in.o
  LD      sound/soc/samsung/built-in.o
  LD      sound/soc/sh/built-in.o
  LD      sound/soc/tegra/built-in.o
  CC      sound/soc/fsl/imx-audmux.o
  LD      sound/soc/txx9/built-in.o
  CC      sound/soc/fsl/imx-pcm.o
  LD      sound/soc/ux500/built-in.o
  CC      sound/soc/fsl/imx-pcm-dma.o
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^
  LD      sound/soc/codecs/snd-soc-sgtl5000.o
  LD      sound/soc/codecs/built-in.o
  CC      sound/soc/fsl/imx-sgtl5000.o
  LD      sound/soc/snd-soc-core.o
  LD      sound/soc/fsl/snd-soc-fsl-ssi.o
  LD      sound/soc/fsl/snd-soc-fsl-utils.o
  LD      sound/soc/fsl/snd-soc-imx-audmux.o
  LD      sound/soc/fsl/snd-soc-imx-pcm.o
  LD      sound/soc/fsl/snd-soc-imx-sgtl5000.o
  LD      sound/soc/fsl/built-in.o
  LD      sound/soc/built-in.o


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
