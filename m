Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1FWCkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:40:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:28735 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061Ab1FWCkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:40:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,410,1304319600"; 
   d="scan'208";a="17205884"
Date: Thu, 23 Jun 2011 10:47:56 +0800
From: Feng Tang <feng.tang@intel.com>
To: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 11/11] spi-dw: remove noop else clause
Message-ID: <20110623104756.1d1c8da4@feng-i7>
In-Reply-To: <1308794413-11069-12-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
	<1308794413-11069-12-git-send-email-dirk.brandewie@gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 10:00:13 +0800
"dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com> wrote:

> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> The value of spi->bits_per_word is checked on function entry to be 8
> or 16.  The else clause has no meaning since it can never be reached.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  drivers/spi/spi-dw.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
> index 7b3f607..5ddd45f 100644
> --- a/drivers/spi/spi-dw.c
> +++ b/drivers/spi/spi-dw.c
> @@ -667,17 +667,14 @@ static int spi_dw_setup(struct spi_device *spi)
>  		chip->enable_dma = chip_info->enable_dma;
>  	}
>  
> -	if (spi->bits_per_word <= 8) {
> +	if (spi->bits_per_word == 8) {
>  		chip->n_bytes = 1;
>  		chip->dma_width = 1;
> -	} else if (spi->bits_per_word <= 16) {
> +	} else if (spi->bits_per_word == 16) {
>  		chip->n_bytes = 2;
>  		chip->dma_width = 2;
> -	} else {
> -		/* Never take >16b case for DW SPIC */
> -		dev_err(&spi->dev, "invalid wordsize\n");
> -		return -EINVAL;
>  	}

These "else" case is used to ban the slave spi devices which
try to use 32 bits per word mode. This is like to tell those
spi devices with 32 bpw capability "we don't support 32b, pls
change"

> +
>  	chip->bits_per_word = spi->bits_per_word;
>  
>  	chip->speed_hz = spi->max_speed_hz;
