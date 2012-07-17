Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2GQCCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:02:24 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42761 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab2GQCCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:02:21 -0400
Date: Mon, 16 Jul 2012 19:02:15 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: devel@driverdev.osuosl.org, b-cousson@ti.com, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, kbaidarov@dev.rtsoft.ru,
        grant.likely@secretlab.ca
Subject: Re: [PATCHv4 1/4] staging: OMAP4+: thermal: introduce bandgap
 temperature sensor
Message-ID: <20120717020215.GA321@kroah.com>
References: <1342108952-12987-1-git-send-email-eduardo.valentin@ti.com>
 <1342108952-12987-2-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342108952-12987-2-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 07:02:29PM +0300, Eduardo Valentin wrote:
> In the System Control Module, OMAP supplies a voltage reference
> and a temperature sensor feature that are gathered in the band
> gap voltage and temperature sensor (VBGAPTS) module. The band
> gap provides current and voltage reference for its internal
> circuits and other analog IP blocks. The analog-to-digital
> converter (ADC) produces an output value that is proportional
> to the silicon temperature.
> 
> This patch provides a platform driver which expose this feature.
> It is moduled as a MFD child of the System Control Module core
> MFD driver.
> 
> This driver provides only APIs to access the device properties,
> like temperature, thresholds and update rate.
> 
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>  drivers/staging/Kconfig                       |    2 +
>  drivers/staging/Makefile                      |    1 +
>  drivers/staging/omap-thermal/Kconfig          |   11 +
>  drivers/staging/omap-thermal/Makefile         |    2 +
>  drivers/staging/omap-thermal/TODO             |   28 +
>  drivers/staging/omap-thermal/omap-bandgap.c   | 1167 +++++++++++++++++++++++++
>  drivers/staging/omap-thermal/omap-bandgap.h   |  425 +++++++++
>  drivers/staging/omap-thermal/omap_bandgap.txt |   30 +
>  8 files changed, 1666 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/omap-thermal/Kconfig
>  create mode 100644 drivers/staging/omap-thermal/Makefile
>  create mode 100644 drivers/staging/omap-thermal/TODO
>  create mode 100644 drivers/staging/omap-thermal/omap-bandgap.c
>  create mode 100644 drivers/staging/omap-thermal/omap-bandgap.h
>  create mode 100644 drivers/staging/omap-thermal/omap_bandgap.txt
> 
> Patch changelog:
> Change from V1 to V2:
> - Compilation fixes on Kconfig and Makefiles under drivers/staging
> Change from V2 to V3:
> - Removed empty line from end of Kconfig file, so git is happy while applying
> - Keerthy's SOB now matches Copyright notice found in files
> Change from V3 to V4:
> - Fixed -Werror-implicit-function-declaration compilation issues.
> - Limited driver compilation to OMAP4/5
> 
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index d3934d7..e3402d5 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -134,4 +134,6 @@ source "drivers/staging/gdm72xx/Kconfig"
>  
>  source "drivers/staging/csr/Kconfig"
>  
> +source "drivers/staging/omap-thermal/Kconfig"
> +
>  endif # STAGING
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index 5b2219a..dbbdbbc 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -59,3 +59,4 @@ obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
>  obj-$(CONFIG_USB_G_CCG)		+= ccg/
>  obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
>  obj-$(CONFIG_CSR_WIFI)		+= csr/
> +obj-y				+= omap-thermal/

Ick, no, why did you do that?  This should only be entered if the config
entry is selected, right?

Did I just miss this on your previous patches?  Sorry about that.  I'll
see if I can fix it up by hand...

greg k-h
