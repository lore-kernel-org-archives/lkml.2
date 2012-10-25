Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab2JYLVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:21:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59729 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab2JYLVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:21:22 -0400
Message-ID: <50892096.4090907@ti.com>
Date: Thu, 25 Oct 2012 16:50:54 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: [PATCH v5 7/7] ARM: davinci: da850 evm: register uio_pruss device
References: <1349456686-22736-1-git-send-email-mporter@ti.com> <1349456686-22736-8-git-send-email-mporter@ti.com> <20121008135442.GS11149@beef>
In-Reply-To: <20121008135442.GS11149@beef>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/2012 7:24 PM, Matt Porter wrote:
> Registers the uio_pruss platform device on the DA850 EVM.
> 
> Tested on AM180x-EVM using the PRU_memAccessPRUDataRam and
> PRU_memAccessL3andDDR examples from the PRU userspace tools
> available from http://www.ti.com/tool/sprc940
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 7359375..9e7f954 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -31,6 +31,7 @@
>  #include <linux/platform_data/mtd-davinci.h>
>  #include <linux/platform_data/mtd-davinci-aemif.h>
>  #include <linux/platform_data/spi-davinci.h>
> +#include <linux/platform_data/uio_pruss.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/regulator/tps6507x.h>
>  #include <linux/spi/spi.h>
> @@ -1339,6 +1340,11 @@ static __init void da850_evm_init(void)
>  		pr_warning("da850_evm_init: lcdcntl mux setup failed: %d\n",
>  				ret);
>  
> +	ret = da8xx_register_uio_pruss();
> +	if (ret)
> +		pr_warning("da850_evm_init: pruss initialization failed: %d\n",

So this gave a checkpatch warning asking you to use pr_warn() instead. I
fixed this locally.

Thanks,
Sekhar
