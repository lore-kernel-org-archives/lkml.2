Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab1HSPse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 11:48:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:45562 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab1HSPsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 11:48:32 -0400
Message-ID: <4E4E85C1.9060405@windriver.com>
Date: Fri, 19 Aug 2011 11:48:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Anand Gadiyar <gadiyar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH linux-next] mfd: omap-usb-host: add module.h and export.h
 to fix build break
References: <1313767445-20033-1-git-send-email-gadiyar@ti.com>
In-Reply-To: <1313767445-20033-1-git-send-email-gadiyar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-19 11:24 AM, Anand Gadiyar wrote:
> linux-next as of 20110817 fails to build if these two headers
> are not included. Including module.h is sufficient for now,
> but add export.h for EXPORT_SYMBOL and THIS_MODULE in advance
> to avoid a later build break.

Thanks -- We won't need to add both, since module.h will source
the export.h itself.    And we can't add export.h to mainline just
yet, since it won't exist there (it is only in linux-next now.)

I'll just add the right one to this file in the existing mtd patch.

Thanks for the report.

Paul.

> 
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> Noticed this while testing another patch. I see similar
> changes to other files in drivers/mfd made by Paul recently.
> 
>  drivers/mfd/omap-usb-host.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/mfd/omap-usb-host.c
> ===================================================================
> --- linux-2.6.orig/drivers/mfd/omap-usb-host.c
> +++ linux-2.6/drivers/mfd/omap-usb-host.c
> @@ -20,6 +20,8 @@
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> +#include <linux/export.h>
> +#include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
