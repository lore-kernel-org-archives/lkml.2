Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2CMER6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:17:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:7132 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab2CMER5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:17:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128221739"
Subject: Re: [PATCH] dma: imx-dma: Fix build by including <linux/module.h>
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>
In-Reply-To: <1331242005-15533-1-git-send-email-festevam@gmail.com>
References: <1331242005-15533-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Mar 2012 09:53:40 +0530
Message-ID: <1331612620.1727.13.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 18:26 -0300, Fabio Estevam wrote:
> commit 13ae246 (includecheck: delete any duplicate instances of module.) removed
> a duplicated module.h inclusion from imx-dma.c.
> 
> ,and commit 865d9438 (drivers/dma: linux/module.h included twice) did the same.
> 
> Let one linux/module.h be included so that it can be built again.
> 
> This fix the following error:
> 
> C      drivers/dma/imx-dma.o
> drivers/dma/imx-dma.c:658: error: expected declaration specifiers or '...' before string constant
> drivers/dma/imx-dma.c:658: warning: data definition has no type or storage class
> drivers/dma/imx-dma.c:658: warning: type defaults to 'int' in declaration of 'MODULE_AUTHOR'
> drivers/dma/imx-dma.c:658: warning: function declaration isn't a prototype
> drivers/dma/imx-dma.c:659: error: expected declaration specifiers or '...' before string constant
> drivers/dma/imx-dma.c:659: warning: data definition has no type or storage class
> drivers/dma/imx-dma.c:659: warning: type defaults to 'int' in declaration of 'MODULE_DESCRIPTION'
> drivers/dma/imx-dma.c:659: warning: function declaration isn't a prototype
> drivers/dma/imx-dma.c:660: error: expected declaration specifiers or '...' before string constant
> drivers/dma/imx-dma.c:660: warning: data definition has no type or storage class
> drivers/dma/imx-dma.c:660: warning: type defaults to 'int' in declaration of 'MODULE_LICENSE'
> drivers/dma/imx-dma.c:660: warning: function declaration isn't a prototype
I reverted the commit 865d9438 (drivers/dma: linux/module.h included
twice) afetr it was reported on linux-next. You should not see any
errors now. 
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/dma/imx-dma.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index ca78fca..7be8d1f 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -25,6 +25,7 @@
>  #include <linux/slab.h>
>  #include <linux/platform_device.h>
>  #include <linux/dmaengine.h>
> +#include <linux/module.h>
>  
>  #include <asm/irq.h>
>  #include <mach/dma-v1.h>


-- 
~Vinod

