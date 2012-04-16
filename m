Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2DPQMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:12:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:64816 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2DPQMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:12:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="133080592"
Date: Mon, 16 Apr 2012 18:21:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH 1/1] lpc_sch: Add Intel Centerton Multifunction Device
 support
Message-ID: <20120416162102.GM24130@sortiz-mobl>
References: <1332349191-8068-1-git-send-email-seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332349191-8068-1-git-send-email-seth.heasley@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Wed, Mar 21, 2012 at 09:59:51AM -0700, Seth Heasley wrote:
> This patch adds the DeviceIDs for the Intel Centerton Legacy Block.  The Legacy Block includes SMBus, GPIO, and Watchdog functionality.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> ---
>  drivers/mfd/lpc_sch.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> index abc4213..778af13 100644
> --- a/drivers/mfd/lpc_sch.c
> +++ b/drivers/mfd/lpc_sch.c
> @@ -36,10 +36,13 @@
>  
>  #define GPIOBASE	0x44
>  #define GPIO_IO_SIZE	64
> +#define GPIO_IO_SIZE_128	128
>  
>  #define WDTBASE		0x84
>  #define WDT_IO_SIZE	64
>  
> +#define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60
> +
So we're not going to need this ID anywhere else ? In the GPIO driver for
example ?
If we do need it there, this ID should move to pci_ids.h


>  static struct resource smbus_sch_resource = {
>  		.flags = IORESOURCE_IO,
>  };
> @@ -68,7 +71,7 @@ static struct resource wdt_sch_resource = {
>  
>  static struct mfd_cell tunnelcreek_cells[] = {
>  	{
> -		.name = "tunnelcreek_wdt",
> +		.name = "ie6xx_wdt",
What do we need this change for ?

The rest of the patch looks good.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
