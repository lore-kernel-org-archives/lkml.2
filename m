Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab2IKTWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 15:22:50 -0400
Received: from mo5.mail-out.ovh.net ([178.32.228.5]:35093 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488Ab2IKTWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 15:22:49 -0400
Date: Tue, 11 Sep 2012 15:20:59 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 01/16] ARM: at91: move platform_data definitions
Message-ID: <20120911132059.GG31430@game.jcrosoft.org>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347368390-31252-1-git-send-email-arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4293619295861582596
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrheeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehtddrheeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:59 Tue 11 Sep     , Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the at91 include directories
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> ---
>  arch/arm/mach-at91/at91sam9g45_devices.c                             |    2 +-
>  arch/arm/mach-at91/at91sam9rl_devices.c                              |    2 +-
>  arch/arm/mach-at91/include/mach/atmel-mci.h                          |    2 +-
>  drivers/dma/at_hdmac_regs.h                                          |    2 +-
>  include/linux/platform_data/atmel-aes.h                              |    2 +-
>  .../mach/at_hdmac.h => include/linux/platform_data/dma-atmel.h       |    0
>  6 files changed, 5 insertions(+), 5 deletions(-)
>  rename arch/arm/mach-at91/include/mach/at_hdmac.h => include/linux/platform_data/dma-atmel.h (100%)
> 
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 0607399..0aa9bdb 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -31,7 +31,7 @@
>  #include <mach/at91sam9g45_matrix.h>
>  #include <mach/at91_matrix.h>
>  #include <mach/at91sam9_smc.h>
> -#include <mach/at_hdmac.h>
> +#include <linux/platform_data/dma-atmel.h>
>  #include <mach/atmel-mci.h>
>  
>  #include <media/atmel-isi.h>
> diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
> index f09fff9..e4da717 100644
> --- a/arch/arm/mach-at91/at91sam9rl_devices.c
> +++ b/arch/arm/mach-at91/at91sam9rl_devices.c
> @@ -22,7 +22,7 @@
>  #include <mach/at91sam9rl_matrix.h>
>  #include <mach/at91_matrix.h>
>  #include <mach/at91sam9_smc.h>
> -#include <mach/at_hdmac.h>
> +#include <linux/platform_data/dma-atmel.h>
I prefer to have all of them in atmel.h

as I started

Best Regards,
J.
>  
>  #include "generic.h"
>  
> diff --git a/arch/arm/mach-at91/include/mach/atmel-mci.h b/arch/arm/mach-at91/include/mach/atmel-mci.h
> index 998cb0c..cd580a1 100644
> --- a/arch/arm/mach-at91/include/mach/atmel-mci.h
> +++ b/arch/arm/mach-at91/include/mach/atmel-mci.h
> @@ -1,7 +1,7 @@
>  #ifndef __MACH_ATMEL_MCI_H
>  #define __MACH_ATMEL_MCI_H
>  
> -#include <mach/at_hdmac.h>
> +#include <linux/platform_data/dma-atmel.h>
>  
>  /**
>   * struct mci_dma_data - DMA data for MCI interface
> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> index 8a6c8e8..116e4ad 100644
> --- a/drivers/dma/at_hdmac_regs.h
> +++ b/drivers/dma/at_hdmac_regs.h
> @@ -11,7 +11,7 @@
>  #ifndef AT_HDMAC_REGS_H
>  #define	AT_HDMAC_REGS_H
>  
> -#include <mach/at_hdmac.h>
> +#include <linux/platform_data/dma-atmel.h>
>  
>  #define	AT_DMA_MAX_NR_CHANNELS	8
>  
> diff --git a/include/linux/platform_data/atmel-aes.h b/include/linux/platform_data/atmel-aes.h
> index e7a1949..ab68082 100644
> --- a/include/linux/platform_data/atmel-aes.h
> +++ b/include/linux/platform_data/atmel-aes.h
> @@ -1,7 +1,7 @@
>  #ifndef __LINUX_ATMEL_AES_H
>  #define __LINUX_ATMEL_AES_H
>  
> -#include <mach/at_hdmac.h>
> +#include <linux/platform_data/dma-atmel.h>
>  
>  /**
>   * struct aes_dma_data - DMA data for AES
> diff --git a/arch/arm/mach-at91/include/mach/at_hdmac.h b/include/linux/platform_data/dma-atmel.h
> similarity index 100%
> rename from arch/arm/mach-at91/include/mach/at_hdmac.h
> rename to include/linux/platform_data/dma-atmel.h
> -- 
> 1.7.10
> 
