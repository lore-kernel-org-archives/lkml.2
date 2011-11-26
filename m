Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1KZOY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 09:24:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55673 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1KZOYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 09:24:24 -0500
MIME-Version: 1.0
In-Reply-To: <1322313979.6001.5.camel@phoenix>
References: <1322313979.6001.5.camel@phoenix>
Date: Sat, 26 Nov 2011 16:24:23 +0200
X-Google-Sender-Auth: HAgDdZnyX778xUcUdV81Yy1KTQM
Message-ID: <CAMW3pwanEdL-thXV=bkFWzMx0n97Bypauib-wpAdGbt8oU6ieg@mail.gmail.com>
Subject: Re: [PATCH] crypto: convert drivers/crypto/* to use module_platform_driver()
From: Vladimir Zapolskiy <vzapolskiy@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, James Hsiao <jhsiao@amcc.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Jamie Iles <jamie@jamieiles.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.11.2011 15:26, Axel Lin wrote:
> This patch converts the drivers in drivers/crypto/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: James Hsiao<jhsiao@amcc.com>
> Cc: Sebastian Andrzej Siewior<sebastian@breakpoint.cc>
> Cc: Vladimir Zapolskiy<vzapolskiy@gmail.com>
> Cc: Jamie Iles<jamie@jamieiles.com>
> Cc: Kim Phillips<kim.phillips@freescale.com>
> Cc: Herbert Xu<herbert@gondor.apana.org.au>
> Cc: "David S. Miller"<davem@davemloft.net>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/crypto/amcc/crypto4xx_core.c |   13 +------------
>   drivers/crypto/caam/ctrl.c           |   13 +------------
>   drivers/crypto/mv_cesa.c             |   12 +-----------
>   drivers/crypto/picoxcell_crypto.c    |   12 +-----------
>   drivers/crypto/s5p-sss.c             |   13 +------------
>   drivers/crypto/talitos.c             |   12 +-----------
>   6 files changed, 6 insertions(+), 69 deletions(-)
>
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index 1d103f9..13f8e1a 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -1292,18 +1292,7 @@ static struct platform_driver crypto4xx_driver = {
>   	.remove		= crypto4xx_remove,
>   };
>
> -static int __init crypto4xx_init(void)
> -{
> -	return platform_driver_register(&crypto4xx_driver);
> -}
> -
> -static void __exit crypto4xx_exit(void)
> -{
> -	platform_driver_unregister(&crypto4xx_driver);
> -}
> -
> -module_init(crypto4xx_init);
> -module_exit(crypto4xx_exit);
> +module_platform_driver(crypto4xx_driver);
>
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("James Hsiao<jhsiao@amcc.com>");
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 73988bb..048bb23 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -253,18 +253,7 @@ static struct platform_driver caam_driver = {
>   	.remove      = __devexit_p(caam_remove),
>   };
>
> -static int __init caam_base_init(void)
> -{
> -	return platform_driver_register(&caam_driver);
> -}
> -
> -static void __exit caam_base_exit(void)
> -{
> -	return platform_driver_unregister(&caam_driver);
> -}
> -
> -module_init(caam_base_init);
> -module_exit(caam_base_exit);
> +module_platform_driver(caam_driver);
>
>   MODULE_LICENSE("GPL");
>   MODULE_DESCRIPTION("FSL CAAM request backend");
> diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
> index dcd8bab..597235a 100644
> --- a/drivers/crypto/mv_cesa.c
> +++ b/drivers/crypto/mv_cesa.c
> @@ -1128,17 +1128,7 @@ static struct platform_driver marvell_crypto = {
>   };
>   MODULE_ALIAS("platform:mv_crypto");
>
> -static int __init mv_crypto_init(void)
> -{
> -	return platform_driver_register(&marvell_crypto);
> -}
> -module_init(mv_crypto_init);
> -
> -static void __exit mv_crypto_exit(void)
> -{
> -	platform_driver_unregister(&marvell_crypto);
> -}
> -module_exit(mv_crypto_exit);
> +module_platform_driver(marvell_crypto);
>
>   MODULE_AUTHOR("Sebastian Andrzej Siewior<sebastian@breakpoint.cc>");
>   MODULE_DESCRIPTION("Support for Marvell's cryptographic engine");
> diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
> index a2b553e..9b1571c 100644
> --- a/drivers/crypto/picoxcell_crypto.c
> +++ b/drivers/crypto/picoxcell_crypto.c
> @@ -1854,17 +1854,7 @@ static struct platform_driver spacc_driver = {
>   	.id_table	= spacc_id_table,
>   };
>
> -static int __init spacc_init(void)
> -{
> -	return platform_driver_register(&spacc_driver);
> -}
> -module_init(spacc_init);
> -
> -static void __exit spacc_exit(void)
> -{
> -	platform_driver_unregister(&spacc_driver);
> -}
> -module_exit(spacc_exit);
> +module_platform_driver(spacc_driver);
>
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("Jamie Iles");
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 8115417..3376bca 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -683,18 +683,7 @@ static struct platform_driver s5p_aes_crypto = {
>   	},
>   };
>
> -static int __init s5p_aes_mod_init(void)
> -{
> -	return  platform_driver_register(&s5p_aes_crypto);
> -}
> -
> -static void __exit s5p_aes_mod_exit(void)
> -{
> -	platform_driver_unregister(&s5p_aes_crypto);
> -}
> -
> -module_init(s5p_aes_mod_init);
> -module_exit(s5p_aes_mod_exit);
> +module_platform_driver(s5p_aes_crypto);
>
>   MODULE_DESCRIPTION("S5PV210 AES hw acceleration support.");
>   MODULE_LICENSE("GPL v2");

As for me the change looks good, thanks.

Acked-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>

> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 92c0ca7..230509e 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -2894,17 +2894,7 @@ static struct platform_driver talitos_driver = {
>   	.remove = talitos_remove,
>   };
>
> -static int __init talitos_init(void)
> -{
> -	return platform_driver_register(&talitos_driver);
> -}
> -module_init(talitos_init);
> -
> -static void __exit talitos_exit(void)
> -{
> -	platform_driver_unregister(&talitos_driver);
> -}
> -module_exit(talitos_exit);
> +module_platform_driver(talitos_driver);
>
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("Kim Phillips<kim.phillips@freescale.com>");
