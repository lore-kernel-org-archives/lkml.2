Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2AaWn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:43:27 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab2AaWn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:43:26 -0500
Message-ID: <4F286F29.2010605@nod.at>
Date: Tue, 31 Jan 2012 23:46:01 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: dwmw2@infradead.org, kyungmin.park@samsung.com,
        artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MTD: Refine HAS_IOMEM dependency
References: <1327512102-22447-1-git-send-email-richard@nod.at>
In-Reply-To: <1327512102-22447-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.01.2012 18:21, schrieb Richard Weinberger:
> Making the entire mtd subsystem depend on HAS_IOMEM is a bit overkill.
> HAS_IOMEM is only needed for real devices drivers.
> nandsim and friends are perfectly usable on systems without IO memory.
>
> I'm my case I'm using nandsim on UML to do some UBI and JFFS2 development.
>
> Signed-off-by: Richard Weinberger<richard@nod.at>
> ---
>   drivers/mtd/Kconfig         |    1 -
>   drivers/mtd/devices/Kconfig |    1 +
>   drivers/mtd/maps/Kconfig    |    1 +
>   drivers/mtd/nand/Kconfig    |    2 ++
>   drivers/mtd/onenand/Kconfig |    1 +
>   5 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
> index 1be6218..bfbd62c 100644
> --- a/drivers/mtd/Kconfig
> +++ b/drivers/mtd/Kconfig
> @@ -1,6 +1,5 @@
>   menuconfig MTD
>   	tristate "Memory Technology Device (MTD) support"
> -	depends on HAS_IOMEM
>   	help
>   	  Memory Technology Devices are flash, RAM and similar chips, often
>   	  used for solid state file systems on embedded devices. This option
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index 37b05c3..8d3dac4 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -1,5 +1,6 @@
>   menu "Self-contained MTD device drivers"
>   	depends on MTD!=n
> +	depends on HAS_IOMEM
>
>   config MTD_PMC551
>   	tristate "Ramix PMC551 PCI Mezzanine RAM card support"
> diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> index 6c5c431..8af67cf 100644
> --- a/drivers/mtd/maps/Kconfig
> +++ b/drivers/mtd/maps/Kconfig
> @@ -1,5 +1,6 @@
>   menu "Mapping drivers for chip access"
>   	depends on MTD!=n
> +	depends on HAS_IOMEM
>
>   config MTD_COMPLEX_MAPPINGS
>   	bool "Support non-linear mappings of flash chips"
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 31b034b..80de7b3 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -246,6 +246,7 @@ config MTD_NAND_BCM_UMI_HWCS
>   config MTD_NAND_DISKONCHIP
>   	tristate "DiskOnChip 2000, Millennium and Millennium Plus (NAND reimplementation) (EXPERIMENTAL)"
>   	depends on EXPERIMENTAL
> +	depends on HAS_IOMEM
>   	select REED_SOLOMON
>   	select REED_SOLOMON_DEC16
>   	help
> @@ -431,6 +432,7 @@ config MTD_NAND_GPMI_NAND
>
>   config MTD_NAND_PLATFORM
>   	tristate "Support for generic platform NAND driver"
> +	depends on HAS_IOMEM
>   	help
>   	  This implements a generic NAND driver for on-SOC platform
>   	  devices. You will need to provide platform-specific functions
> diff --git a/drivers/mtd/onenand/Kconfig b/drivers/mtd/onenand/Kconfig
> index 772ad29..91467bb 100644
> --- a/drivers/mtd/onenand/Kconfig
> +++ b/drivers/mtd/onenand/Kconfig
> @@ -1,6 +1,7 @@
>   menuconfig MTD_ONENAND
>   	tristate "OneNAND Device Support"
>   	depends on MTD
> +	depends on HAS_IOMEM
>   	help
>   	  This enables support for accessing all type of OneNAND flash
>   	  devices. For further information see

Ping?

Thanks,
//richard
