Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2GKGxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:53:05 -0400
Received: from smtp-out-150.synserver.de ([212.40.185.150]:1075 "EHLO
	smtp-out-150.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab2GKGxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:53:03 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13933
Message-ID: <4FFD23BA.8070502@metafoo.de>
Date: Wed, 11 Jul 2012 08:56:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Gerard Snitselaar <dev@snitselaar.org>
CC: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-iio@vger.kernel.org, jic23@cam.ac.uk, gregkh@linuxfoundation.org
Subject: Re: [PATCH] iio: dac: ad5064: fix section mismatch in ad5064_init()
 in linux-next
References: <1341979502-27440-1-git-send-email-dev@snitselaar.org>
In-Reply-To: <1341979502-27440-1-git-send-email-dev@snitselaar.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 06:05 AM, Gerard Snitselaar wrote:
> ad5064_init() calls ad5064_spi_unregister_driver() which is annotated
> __exit.
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

Thanks,

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  drivers/iio/dac/ad5064.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/dac/ad5064.c b/drivers/iio/dac/ad5064.c
> index aa739c4..6ec1319 100644
> --- a/drivers/iio/dac/ad5064.c
> +++ b/drivers/iio/dac/ad5064.c
> @@ -582,7 +582,7 @@ static int __init ad5064_spi_register_driver(void)
>  	return spi_register_driver(&ad5064_spi_driver);
>  }
>  
> -static void __exit ad5064_spi_unregister_driver(void)
> +static void ad5064_spi_unregister_driver(void)
>  {
>  	spi_unregister_driver(&ad5064_spi_driver);
>  }

