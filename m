Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2IOSjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 14:39:43 -0400
Received: from smtp1.newsguy.com ([74.209.136.71]:50921 "EHLO
	smtp1.newsguy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2IOSjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 14:39:42 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2012 14:39:41 EDT
Message-ID: <5054C7A5.5010308@newsguy.com>
Date: Sat, 15 Sep 2012 11:23:33 -0700
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120606 Thunderbird/10.0.4
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <b32955@freescale.com>,
        linux-mtd@lists.infradead.org, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: Re: [PATCH] mtd/nand/docg4: Add missing HAS_IOMEM dependency
References: <1347662469-1604-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1347662469-1604-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mike Dunn <mikedunn@newsguy.com>

Sorry for the oversight.

Mike


On 09/14/2012 03:41 PM, Peter Huewe wrote:
> While building an allyesconfig for UML I received this error message(s):
>  drivers/mtd/nand/docg4.c: In function 'probe_docg4':
>  drivers/mtd/nand/docg4.c:1272:2: error: implicit declaration of function
>  'ioremap' [-Werror=implicit-function-declaration]
>  drivers/mtd/nand/docg4.c:1272:10: warning: assignment makes pointer from
>  integer without a cast [enabled by default]
>  drivers/mtd/nand/docg4.c:1327:2: error: implicit declaration of function
>  'iounmap' [-Werror=implicit-function-declaration]
> 
> which is caused by the missing implementations on UML.
> 
> This patch adds this missing HAS_IOMEM dependency and prevents the driver from
> being build on platforms with no HAS_IOMEM
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/mtd/nand/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 8ca4176..3e2f75d 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -356,7 +356,7 @@ config MTD_NAND_DISKONCHIP_BBTWRITE
>  
>  config MTD_NAND_DOCG4
>  	tristate "Support for DiskOnChip G4 (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	depends on EXPERIMENTAL && HAS_IOMEM
>  	select BCH
>  	select BITREVERSE
>  	help

