Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab0EGP1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:27:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32730 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab0EGP1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:27:53 -0400
Date: Fri, 7 May 2010 08:26:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCHv2 1/7] HSI: Introducing HSI framework
Message-Id: <20100507082629.3bdf0b17.randy.dunlap@oracle.com>
In-Reply-To: <1273245517-30712-2-git-send-email-carlos.chinea@nokia.com>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
	<1273245517-30712-2-git-send-email-carlos.chinea@nokia.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090208.4BE43176.01B7:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 May 2010 18:18:31 +0300 Carlos Chinea wrote:

> Adds HSI framework in to the linux kernel.
> 
> High Speed Synchronous Serial Interface (HSI) is a
> serial interface mainly used for connecting application
> engines (APE) with cellular modem engines (CMT) in cellular
> handsets.
> 
> HSI provides multiplexing for up to 16 logical channels,
> low-latency and full duplex communication.
> 
> Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
> ---
>  drivers/Kconfig         |    2 +
>  drivers/Makefile        |    1 +
>  drivers/hsi/Kconfig     |   13 ++
>  drivers/hsi/Makefile    |    4 +
>  drivers/hsi/hsi.c       |  489 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/hsi/hsi.h |  369 +++++++++++++++++++++++++++++++++++
>  6 files changed, 878 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hsi/Kconfig
>  create mode 100644 drivers/hsi/Makefile
>  create mode 100644 drivers/hsi/hsi.c
>  create mode 100644 include/linux/hsi/hsi.h
> 
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index a2b902f..4fe39f9 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -50,6 +50,8 @@ source "drivers/i2c/Kconfig"
>  
>  source "drivers/spi/Kconfig"
>  
> +source "drivers/hsi/Kconfig"
> +
>  source "drivers/pps/Kconfig"
>  
>  source "drivers/gpio/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 2c4f277..24ca5bd 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -45,6 +45,7 @@ obj-$(CONFIG_SCSI)		+= scsi/
>  obj-$(CONFIG_ATA)		+= ata/
>  obj-$(CONFIG_MTD)		+= mtd/
>  obj-$(CONFIG_SPI)		+= spi/
> +obj-$(CONFIG_HSI)		+= hsi/
>  obj-y				+= net/
>  obj-$(CONFIG_ATM)		+= atm/
>  obj-$(CONFIG_FUSION)		+= message/
> diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
> new file mode 100644
> index 0000000..5af62ce
> --- /dev/null
> +++ b/drivers/hsi/Kconfig
> @@ -0,0 +1,13 @@
> +#
> +# HSI driver configuration
> +#
> +menuconfig HSI
> +	bool "HSI support"

Why is this bool instead of tristate?
IOW, why can it not be built as a loadable module?


> +	---help---
> +	  The "High speed synchronous Serial Interface" is
> +	  synchronous serial interface used mainly to connect
> +	  application engines and cellular modems.
> +
> +if HSI
> +
> +endif # HSI
> diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
> new file mode 100644
> index 0000000..b42b6cf
> --- /dev/null
> +++ b/drivers/hsi/Makefile
> @@ -0,0 +1,4 @@
> +#
> +# Makefile for HSI
> +#
> +obj-$(CONFIG_HSI)	+= hsi.o


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
