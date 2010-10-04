Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab0JDQD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:03:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31251 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab0JDQD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:03:58 -0400
Date: Mon, 4 Oct 2010 18:03:46 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Fix Kconfig dependencies
Message-ID: <20101004180346.59b10af7@endymion.delvare>
In-Reply-To: <1286199093-3576-1-git-send-email-mmarek@suse.cz>
References: <1286199093-3576-1-git-send-email-mmarek@suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon,  4 Oct 2010 15:31:33 +0200, Michal Marek wrote:
> drivers/i2c/algos/Kconfig makes all the algorithms dependent on
> !I2C_HELPER_AUTO, which triggers a Kconfig warning about broken
> dependencies when some driver selects one of the algorithms. Make only
> the prompts dependent on !I2C_HELPER_AUTO, not the complete symbols.
> This moves the entries out of the "I2C Algorithms" submenu, but most
> users do not unset I2C_HELPER_AUTO, so they will not see it anyway.

You have bad luck, I'm afraid. Sure, most users do not unset
I2C_HELPER_AUTO, so they will not see the extra entries in the main I2C
menu, however _I_ unset it and guess what, _I_ am the one deciding
whether your patch can be applied or not ;)

I don't want the algo drivers listed in the main I2C menu, sorry. It is
much clearer the way it is now.

> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> 
> Please consider for 2.6.36, as the warning is caused by a kconfig fix
> that I'm about to send to Linus for 2.6.36. And it is triggered by a
> simple 'make defconfig' in i386/x84_64:

You should reconsider then. Kernel 2.6.36 will be released in a few
days, is your fix so important that it has to go in, even when you have
evidence that it breaks other parts of the configuration, which in turn
will have to be fixed?

It would help if you could explain in detail what your fix is doing and
why it is urgently needed (if it really is.)

I borrowed the idea of I2C_HELPER_AUTO from
CONFIG_VIDEO_HELPER_CHIPS_AUTO, so that part will break too, and these
are a lot more configuration options and drivers.

Also look at I2C_SMBUS, I presume it needs a fix too if selecting
undeclared symbols is no longer allowed. 

> $ make defconfig
> *** Default configuration is based on 'x86_64_defconfig'
> warning: (IEEE1394_PCILYNX && (PCI || BROKEN) && PCI && IEEE1394 && I2C || SFC && NETDEVICES && NETDEV_10000 && PCI && INET || I2C_VIA && I2C && PCI && EXPERIMENTAL || I2C_HYDRA && I2C && PCI && PPC_CHRP && EXPERIMENTAL || I2C_GPIO && I2C && GENERIC_GPIO || I2C_IXP2000 && I2C && ARCH_IXP2000 || I2C_SIMTEC && I2C || I2C_VERSATILE && I2C && (ARCH_VERSATILE || ARCH_REALVIEW || ARCH_VEXPRESS) || I2C_PARPORT && I2C && PARPORT || I2C_PARPORT_LIGHT && I2C || I2C_ACORN && I2C && ARCH_ACORN || SCx200_I2C && I2C && SCx200_GPIO || VIDEO_BT848 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT && VIDEO_IR || VIDEO_CX88 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && VIDEO_DEV && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX23885 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE || VIDEO_AU0828 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && I2C && INPUT && DVB_CORE && USB && VI
>  DEO_V4L2 || VIDEO_IVTV && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && PCI && I2C && INPUT && VIDEO_IR || VIDEO_CX18 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL && INPUT && VIDEO_IR || VIDEO_SAA7164 && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && PCI && I2C || DVB_PLUTO2 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && PCI && I2C || DRM && HAS_IOMEM && (AGP || AGP=n) && !EMULATED_CMPXCHG && MMU || FB_DDC && HAS_IOMEM && FB || FB_VIA && HAS_IOMEM && FB && PCI && X86 || VIDEO_CX25821 && STAGING && !STAGING_EXCLUDE_BUILD && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT) selects I2C_ALGOBIT which has unmet direct dependencies (I2C && !I2C_HELPER_AUTO)
> [...]

This message is obscure. The actual problem is that I2C_ALGOBIT is
selected but doesn't exist, isn't it?.

> 
> ---
>  drivers/i2c/algos/Kconfig |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
> index 7b2ce4a..9ced1a0 100644
> --- a/drivers/i2c/algos/Kconfig
> +++ b/drivers/i2c/algos/Kconfig
> @@ -2,16 +2,15 @@
>  # I2C algorithm drivers configuration
>  #
>  
> -menu "I2C Algorithms"
> -	depends on !I2C_HELPER_AUTO
> -
>  config I2C_ALGOBIT
> -	tristate "I2C bit-banging interfaces"
> +	tristate
> +	prompt "I2C bit-banging interfaces" if !I2C_HELPER_AUTO
>  
>  config I2C_ALGOPCF
> -	tristate "I2C PCF 8584 interfaces"
> +	tristate
> +	prompt "I2C PCF 8584 interfaces" if !I2C_HELPER_AUTO
>  
>  config I2C_ALGOPCA
> -	tristate "I2C PCA 9564 interfaces"
> +	tristate
> +	prompt "I2C PCA 9564 interfaces" if !I2C_HELPER_AUTO
>  
> -endmenu

I would prefer the fix below, which seems to work for me (but I am no
Kconfig expert) and preserves the submenu for algo drivers. Only the
indentation is missing, would be nice to solve.

---
 drivers/i2c/Kconfig       |    3 ++-
 drivers/i2c/algos/Kconfig |   15 ++++++++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)

--- linux-2.6.36-rc6.orig/drivers/i2c/algos/Kconfig	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6.36-rc6/drivers/i2c/algos/Kconfig	2010-10-04 17:33:10.000000000 +0200
@@ -2,16 +2,25 @@
 # I2C algorithm drivers configuration
 #
 
+config I2C_ALGOBIT
+	tristate
+
+config I2C_ALGOPCF
+	tristate
+
+config I2C_ALGOPCA
+	tristate
+
 menu "I2C Algorithms"
 	depends on !I2C_HELPER_AUTO
 
 config I2C_ALGOBIT
-	tristate "I2C bit-banging interfaces"
+	prompt "I2C bit-banging interfaces"
 
 config I2C_ALGOPCF
-	tristate "I2C PCF 8584 interfaces"
+	prompt "I2C PCF 8584 interfaces"
 
 config I2C_ALGOPCA
-	tristate "I2C PCA 9564 interfaces"
+	prompt "I2C PCA 9564 interfaces"
 
 endmenu
--- linux-2.6.36-rc6.orig/drivers/i2c/Kconfig	2010-09-21 11:07:14.000000000 +0200
+++ linux-2.6.36-rc6/drivers/i2c/Kconfig	2010-10-04 17:54:29.000000000 +0200
@@ -75,7 +75,8 @@ config I2C_HELPER_AUTO
 	  In doubt, say Y.
 
 config I2C_SMBUS
-	tristate "SMBus-specific protocols" if !I2C_HELPER_AUTO
+	tristate
+	prompt "SMBus-specific protocols" if !I2C_HELPER_AUTO
 	help
 	  Say Y here if you want support for SMBus extensions to the I2C
 	  specification. At the moment, the only supported extension is



-- 
Jean Delvare
