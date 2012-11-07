Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2KGQyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:54:41 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:40909 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752539Ab2KGQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:54:40 -0500
Date: Wed, 7 Nov 2012 17:45:23 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Royer <nicolas@eukrea.com>
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net, eric@eukrea.com
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 2/5 v2] ARM: AT91SAM9G45: same platform data structure
 for all crypto peripherals
Message-ID: <20121107164523.GG4576@game.jcrosoft.org>
References: <20121107152615.GD4576@game.jcrosoft.org>
 <1352305675-21961-1-git-send-email-nicolas@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1352305675-21961-1-git-send-email-nicolas@eukrea.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10429210837164534548
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtugfgjggfsehtkefttddtredu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrgedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtugfgjggfsehtkefttddtredu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:27 Wed 07 Nov     , Nicolas Royer wrote:
> Only AES use DMA in AT91SAM9G45 (TDES and SHA use PDC).
> 
> However latest Atmel TDES and SHA IP releases use DMA instead of PDC.
>   --> Atmel TDES and SHA drivers need DMA platform data for those IP releases.
> 
> Goal of this patch is to use the same platform data structure for all Atmel
> crypto peripherals. This structure contains information about DMA interface.
> 
> Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Eric Bénard <eric@eukrea.com>
> Tested-by: Eric Bénard <eric@eukrea.com>
> ---
> v2 : check kzalloc return value.
> 
>  arch/arm/mach-at91/at91sam9g45_devices.c   |   10 ++++++----
>  include/linux/platform_data/atmel-aes.h    |   22 ----------------------
>  include/linux/platform_data/crypto-atmel.h |   22 ++++++++++++++++++++++
>  3 files changed, 28 insertions(+), 26 deletions(-)
>  delete mode 100644 include/linux/platform_data/atmel-aes.h
>  create mode 100644 include/linux/platform_data/crypto-atmel.h
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index fcd233c..c1631d1 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -18,7 +18,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/i2c-gpio.h>
>  #include <linux/atmel-mci.h>
> -#include <linux/platform_data/atmel-aes.h>
> +#include <linux/platform_data/crypto-atmel.h>
>  
>  #include <linux/platform_data/at91_adc.h>
>  
> @@ -1900,7 +1900,7 @@ static void __init at91_add_device_tdes(void) {}
>   * -------------------------------------------------------------------- */
>  
>  #if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DEV_ATMEL_AES_MODULE)
> -static struct aes_platform_data aes_data;
> +static struct crypto_platform_data aes_data;
>  static u64 aes_dmamask = DMA_BIT_MASK(32);
>  
>  static struct resource aes_resources[] = {
> @@ -1931,9 +1931,11 @@ static struct platform_device at91sam9g45_aes_device = {
>  static void __init at91_add_device_aes(void)
>  {
>  	struct at_dma_slave	*atslave;
> -	struct aes_dma_data	*alt_atslave;
> +	struct crypto_dma_data	*alt_atslave;
>  
> -	alt_atslave = kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
> +	alt_atslave = kzalloc(sizeof(struct crypto_dma_data), GFP_KERNEL);
I still not understand why we need to allocate it

just declare it as static

Best Regards,
J.
