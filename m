Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0K2Vvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:51:31 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24804 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab0K2Vva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:51:30 -0500
Date: Mon, 29 Nov 2010 13:49:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Mark Allyn <mark.a.allyn@intel.com>,
        Joe Perches <joe@perches.com>, Ben Hutchings <ben@decadent.org.uk>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 3/3] staging/sep: Fix sparse printk format warning
Message-Id: <20101129134943.4ef92448.randy.dunlap@oracle.com>
In-Reply-To: <1291066280-19126-3-git-send-email-peterhuewe@gmx.de>
References: <1291066280-19126-1-git-send-email-peterhuewe@gmx.de>
	<1291066280-19126-3-git-send-email-peterhuewe@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 22:31:20 +0100 Peter Huewe wrote:

> This patch fixes sparse's complaints about the wrong format string.

Are you sure?  I'm used to these being gcc warnings, not sparse.

Also, this fixes the warnings on x86_64 but not on x86_32/i386:

linux-next-20101126/drivers/staging/sep/sep_driver.c: In function 'sep_ioctl':
linux-next-20101126/drivers/staging/sep/sep_driver.c:3397: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
linux-next-20101126/drivers/staging/sep/sep_driver.c:3399: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
linux-next-20101126/drivers/staging/sep/sep_driver.c:3405: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
linux-next-20101126/drivers/staging/sep/sep_driver.c:3407: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
linux-next-20101126/drivers/staging/sep/sep_driver.c:3411: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
linux-next-20101126/drivers/staging/sep/sep_driver.c:3413: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'unsigned int'
linux-next-20101126/drivers/staging/sep/sep_driver.c:3415: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'unsigned int'


> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> LinuxVersion: linux-next-20101129
> 
>  drivers/staging/sep/sep_driver.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
> index cf5c897..86e676d 100644
> --- a/drivers/staging/sep/sep_driver.c
> +++ b/drivers/staging/sep/sep_driver.c
> @@ -112,7 +112,7 @@ static int sep_load_firmware(struct sep_device *sep)
>  		sep->resident_addr);
>  	dev_dbg(&sep->pdev->dev, "residnet bus is %lx\n",
>  		(unsigned long)sep->resident_bus);
> -	dev_dbg(&sep->pdev->dev, "resident size is %08x\n",
> +	dev_dbg(&sep->pdev->dev, "resident size is %08Zx\n",
>  		sep->resident_size);
>  
>  	/* set addresses for dcache (no loading needed) */
> @@ -146,7 +146,7 @@ static int sep_load_firmware(struct sep_device *sep)
>  		sep->cache_addr);
>  	dev_dbg(&sep->pdev->dev, "cache bus is %08lx\n",
>  		(unsigned long)sep->cache_bus);
> -	dev_dbg(&sep->pdev->dev, "cache size is %08x\n",
> +	dev_dbg(&sep->pdev->dev, "cache size is %08Zx\n",
>  		sep->cache_size);
>  
>  	/* set addresses and load extapp */
> @@ -167,7 +167,7 @@ static int sep_load_firmware(struct sep_device *sep)
>  		sep->extapp_addr);
>  	dev_dbg(&sep->pdev->dev, "extapp bus is %08llx\n",
>  		(unsigned long long)sep->extapp_bus);
> -	dev_dbg(&sep->pdev->dev, "extapp size is %08x\n",
> +	dev_dbg(&sep->pdev->dev, "extapp size is %08Zx\n",
>  		sep->extapp_size);
>  
>  	return error;
> @@ -210,7 +210,7 @@ static int sep_map_and_alloc_shared_area(struct sep_device *sep)
>  		return -ENOMEM;
>  	}
>  	dev_dbg(&sep->pdev->dev,
> -		"sep: shared_addr %x bytes @%p (bus %llx)\n",
> +		"sep: shared_addr %Zx bytes @%p (bus %llx)\n",
>  		sep->shared_size, sep->shared_addr,
>  			(unsigned long long)sep->shared_bus);
>  	return 0;
> @@ -3395,25 +3395,25 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	dev_dbg(&sep->pdev->dev,
>  		"SEP_IOCSENDSEPCOMMAND is %x\n", SEP_IOCSENDSEPCOMMAND);
>  	dev_dbg(&sep->pdev->dev,
> -		"SEP_IOCALLOCDATAPOLL is %x\n", SEP_IOCALLOCDATAPOLL);
> +		"SEP_IOCALLOCDATAPOLL is %lx\n", SEP_IOCALLOCDATAPOLL);
>  	dev_dbg(&sep->pdev->dev,
> -		"SEP_IOCCREATESYMDMATABLE is %x\n", SEP_IOCCREATESYMDMATABLE);
> +		"SEP_IOCCREATESYMDMATABLE is %lx\n", SEP_IOCCREATESYMDMATABLE);
>  	dev_dbg(&sep->pdev->dev,
>  		"SEP_IOCFREEDMATABLEDATA is %x\n", SEP_IOCFREEDMATABLEDATA);
>  	dev_dbg(&sep->pdev->dev,
>  		"SEP_IOCSEPSTART is %x\n", SEP_IOCSEPSTART);
>  	dev_dbg(&sep->pdev->dev,
> -		"SEP_IOCSEPINIT is %x\n", SEP_IOCSEPINIT);
> +		"SEP_IOCSEPINIT is %lx\n", SEP_IOCSEPINIT);
>  	dev_dbg(&sep->pdev->dev,
> -		"SEP_IOCGETSTATICPOOLADDR is %x\n", SEP_IOCGETSTATICPOOLADDR);
> +		"SEP_IOCGETSTATICPOOLADDR is %lx\n", SEP_IOCGETSTATICPOOLADDR);
>  	dev_dbg(&sep->pdev->dev,
>  		"SEP_IOCENDTRANSACTION is %x\n", SEP_IOCENDTRANSACTION);
>  	dev_dbg(&sep->pdev->dev,
> -		"SEP_IOCREALLOCEXTCACHE is %x\n", SEP_IOCREALLOCEXTCACHE);
> +		"SEP_IOCREALLOCEXTCACHE is %lx\n", SEP_IOCREALLOCEXTCACHE);
>  	dev_dbg(&sep->pdev->dev,
> -		"SEP_IOCRARPREPAREMESSAGE is %x\n", SEP_IOCRARPREPAREMESSAGE);
> +		"SEP_IOCRARPREPAREMESSAGE is %lx\n", SEP_IOCRARPREPAREMESSAGE);
>  	dev_dbg(&sep->pdev->dev,
> -		"SEP_IOCPREPAREDCB is %x\n", SEP_IOCPREPAREDCB);
> +		"SEP_IOCPREPAREDCB is %lx\n", SEP_IOCPREPAREDCB);
>  	dev_dbg(&sep->pdev->dev,
>  		"SEP_IOCFREEDCB is %x\n", SEP_IOCFREEDCB);
>  
> @@ -3736,7 +3736,7 @@ static int sep_callback(unsigned long sep_context_pointer)
>  	}
>  
>  	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
> -		" size is %x\n",
> +		" size is %Zx\n",
>  		sep->rar_addr, (unsigned long long)sep->rar_bus,
>  		sep->rar_size);
>  
> @@ -3864,7 +3864,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
>  		}
>  
>  		dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
> -			" size is %x\n", sep->rar_addr,
> +			" size is %Zx\n", sep->rar_addr,
>  			(unsigned long long)sep->rar_bus,
>  			sep->rar_size);
>  	}
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
