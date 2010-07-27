Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0G0St1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:49:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53263 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0G0StZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:49:25 -0400
Message-ID: <4C4F2A1E.7010600@oracle.com>
Date: Tue, 27 Jul 2010 11:49:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, greg@kroah.com
Subject: Re: [RESEND PATCH] max3107: Fix gpiolib support
References: <20100727071551.25761.146.stgit@localhost.localdomain>
In-Reply-To: <20100727071551.25761.146.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C4F2A31.028B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Because of the way gpiolib works we actually need to ifdef this in our
> header file
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> 
>  drivers/serial/max3107.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> 
> diff --git a/drivers/serial/max3107.h b/drivers/serial/max3107.h
> index 72b3041..7ab6323 100644
> --- a/drivers/serial/max3107.h
> +++ b/drivers/serial/max3107.h
> @@ -368,8 +368,10 @@ struct max3107_port {
>  	/* SPI device structure */
>  	struct spi_device *spi;
>  
> +#if defined(CONFIG_GPIOLIB)
>  	/* GPIO chip stucture */
>  	struct gpio_chip chip;
> +#endif
>  
>  	/* Workqueue that does all the magic */
>  	struct workqueue_struct *workqueue;
> 
> --

