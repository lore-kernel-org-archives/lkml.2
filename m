Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2LERjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 12:39:11 -0500
Received: from smtp-out-241.synserver.de ([212.40.185.241]:1030 "EHLO
	smtp-out-241.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2LERjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 12:39:10 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21482
Message-ID: <50BF86B8.4020805@metafoo.de>
Date: Wed, 05 Dec 2012 18:39:04 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] spi: spi-xcomm: Fix wrong setting for SPI_XCOMM_SETTINGS_CPHA
References: <1354602461.3286.1.camel@phoenix>
In-Reply-To: <1354602461.3286.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 07:27 AM, Axel Lin wrote:
> The logic of setting SPI_XCOMM_SETTINGS_CPHA bit is reversed.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Lars,
> The logic of setting SPI_XCOMM_SETTINGS_CPHA bit looks wrong to me.
> Can you check if this patch works?
> 
> Thanks,
> Axel

Hi Axel,

Thanks for the patch. But the code is correct as it is. The CPHA definition
of the chip is inverted to that of Linux.

Thanks,
- Lars


> 
>  drivers/spi/spi-xcomm.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-xcomm.c b/drivers/spi/spi-xcomm.c
> index 266a847..c2a3e8f 100644
> --- a/drivers/spi/spi-xcomm.c
> +++ b/drivers/spi/spi-xcomm.c
> @@ -99,9 +99,9 @@ static int spi_xcomm_setup_transfer(struct spi_xcomm *spi_xcomm,
>  		*settings &= ~SPI_XCOMM_SETTINGS_CPOL;
>  
>  	if (spi->mode & SPI_CPHA)
> -		*settings &= ~SPI_XCOMM_SETTINGS_CPHA;
> -	else
>  		*settings |= SPI_XCOMM_SETTINGS_CPHA;
> +	else
> +		*settings &= ~SPI_XCOMM_SETTINGS_CPHA;
>  
>  	if (spi->mode & SPI_3WIRE)
>  		*settings |= SPI_XCOMM_SETTINGS_3WIRE;

