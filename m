Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0HXNgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:36:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0HXNgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:36:01 -0400
Date: Tue, 24 Aug 2010 06:22:59 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        alan@linux.intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100824132259.GB20031@suse.de>
References: <4C736AEA.70005@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C736AEA.70005@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 03:47:06PM +0900, Masayuki Ohtak wrote:
> Hi Greg,
> 
> We have modified our phub driver for your indication.
> Please check below.
> 
> Best Regards, Ohtake(OKISEMI).
> 
> ---
> Packet hub driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. Packet hub is
> a special converter device in Topcliff PCH that translate AMBA transactions
> to PCI Express transactions and vice versa. Thus packet hub helps present
> all IO peripherals in Topcliff PCH as PCIE devices to IA system.
> Topcliff PCH has MAC address and Option ROM data.
> These data are in SROM which is connected to PCIE bus.
> Packet hub driver of Topcliff PCH can access MAC address and Option ROM data in
> SROM via sysfs interface.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> ---
>  Documentation/ABI/testing/sysfs-module |   14 +
>  drivers/misc/Kconfig                   |    9 +
>  drivers/misc/Makefile                  |    1 +
>  drivers/misc/pch_phub.c                |  719 ++++++++++++++++++++++++++++++++
>  4 files changed, 743 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-module
>  create mode 100755 drivers/misc/pch_phub.c
> 
> diff --git a/Documentation/ABI/testing/sysfs-module b/Documentation/ABI/testing/sysfs-module
> new file mode 100644
> index 0000000..fe07ffa
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-module
> @@ -0,0 +1,14 @@
> +What:		/sys/module/pch_phub/drivers/pci:pch_phub/<dev>/pch_mac

Please don't put a ':' in your driver name.

> +Date:		August 2010
> +KernelVersion:	2.6.35
> +Contact:	masa-korg@dsn.okisemi.com
> +Description:	Write/read GbE MAC address.
> +Users:		masa-korg@dsn.okisemi.com

You are really going to be the only user of this file?

> +
> +What:		/sys/module/pch_phub/drivers/pci:pch_phub/<dev>/pch_firmware
> +Date:		August 2010
> +KernelVersion:	2.6.35
> +Contact:	masa-korg@dsn.okisemi.com
> +Description:	Write/read Option ROM data.
> +Users:		masa-korg@dsn.okisemi.com
> +
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 26386a9..756f832 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -353,6 +353,15 @@ config VMWARE_BALLOON
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called vmware_balloon.
>  
> +config PCH_PHUB
> +	tristate "PCH Packet Hub of Intel Topcliff"
> +	depends on PCI
> +	help
> +	  This driver is for PCH(Platform controller Hub) PHUB(Packet Hub) of
> +	  Intel Topcliff which is an IOH(Input/Output Hub) for x86 embedded
> +	  processor. The Topcliff has MAC address and Option ROM data in SROM.
> +	  This driver can access MAC address and Option ROM data in SROM.
> +

Please add the wording "To compile this driver..." here as well.

Your driver code looks much better, nice job.

thanks,

greg k-h
