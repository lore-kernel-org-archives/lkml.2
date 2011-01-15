Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab1AOA1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:27:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1AOA1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:27:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IOlct5JtV5DF2T+DqssLDeajeBYyuFbs6zx7/dV7MNP3bUGbAyyyOwKrvReyFJ+EQh
         Rzj4w0TdUcl57S7jPVbZptYRTfnOtz1AMWxO6h8BofErnUjUfBDwCAnOnya830txOHAJ
         oJXTQafHwTExIsJmtXDI9w5SOg0QSbIPnLm1U=
MIME-Version: 1.0
In-Reply-To: <1294843150-6962-3-git-send-email-nicolas.ferre@atmel.com>
References: <1292435416-16927-1-git-send-email-nicolas.ferre@atmel.com>
	<1294843150-6962-3-git-send-email-nicolas.ferre@atmel.com>
Date: Fri, 14 Jan 2011 16:27:07 -0800
X-Google-Sender-Auth: 9Z7I_bOwoI8aK-SqpPTEihe6q5Y
Message-ID: <AANLkTikY53tOv1eCtMcTqrmy52WawLZdp3Vnq24ozHJ1@mail.gmail.com>
Subject: Re: [PATCH 4/6] dmaengine: at_hdmac: use subsys_initcall instead of module_init
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        hong.xu@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 6:39 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> From: Eric Xu <hong.xu@atmel.com>
>
> Use subsys_initcall instead of module_init in order to keep DMA engine rolling
> before other peripheral drivers.
>
> Signed-off-by: Eric Xu <hong.xu@atmel.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/dma/at_hdmac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index 4f83431..a1a0fc6 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1209,7 +1209,7 @@ static int __init at_dma_init(void)
>  {
>        return platform_driver_probe(&at_dma_driver, at_dma_probe);
>  }
> -module_init(at_dma_init);
> +subsys_initcall(at_dma_init);

If this matters shouldn't we also do this?

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 1b61d3a..4d14626 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -90,7 +90,7 @@ config DW_DMAC
          can be integrated in chips such as the Atmel AT32ap7000.

 config AT_HDMAC
-       tristate "Atmel AHB DMA support"
+       bool "Atmel AHB DMA support"
        depends on ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
        select DMA_ENGINE
        help
