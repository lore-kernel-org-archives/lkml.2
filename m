Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0FRVT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:19:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:27340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab0FRVT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,441,1272870000"; 
   d="scan'208";a="809401794"
Date: Fri, 18 Jun 2010 23:19:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] MFD: AB8500 mask off irrelevant bits from the SPI
 message
Message-ID: <20100618211905.GF3582@sortiz.org>
References: <1275008384-17285-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275008384-17285-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, May 28, 2010 at 02:59:44AM +0200, Linus Walleij wrote:
> The registers on the AB8500 are only 8 bits wide, so the content
> of the remaining bits is undefined. Let's mask off the undefined
> stuff when returning a register in an SPI read.
Patch applied, sorry for the delay.

Cheers,
Samuel.


> Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/mfd/ab8500-spi.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/ab8500-spi.c b/drivers/mfd/ab8500-spi.c
> index b81d4f7..e1c8b62 100644
> --- a/drivers/mfd/ab8500-spi.c
> +++ b/drivers/mfd/ab8500-spi.c
> @@ -68,7 +68,12 @@ static int ab8500_spi_read(struct ab8500 *ab8500, u16 addr)
>  
>  	ret = spi_sync(spi, &msg);
>  	if (!ret)
> -		ret = ab8500->rx_buf[0];
> +		/*
> +		 * Only the 8 lowermost bytes are
> +		 * defined with value, the rest may
> +		 * vary depending on chip/board noise.
> +		 */
> +		ret = ab8500->rx_buf[0] & 0xFFU;
>  
>  	return ret;
>  }
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
