Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0CYAqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:46:20 -0400
Received: from mail-px0-f181.google.com ([209.85.216.181]:37215 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0CYAqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iKRApGFHImojcuIecemw6CePYnKrwnAWnd2KEXfjXA12vCK2gMmAT2UKXEgip23mjA
         nlnRoONDhYtLqMy77obuP/zt16M8bVrYg2w8SJWZFmKygFCgAz8/Bkh8U8QLdMPgAR2I
         TdnmPzV34/YtJePcLRRwfMA1X8L/9Iu8DVvaA=
MIME-Version: 1.0
In-Reply-To: <1268843176-15269-1-git-send-email-steve@digidescorp.com>
References: <1268843176-15269-1-git-send-email-steve@digidescorp.com>
Date: Wed, 24 Mar 2010 17:46:17 -0700
X-Google-Sender-Auth: f0ec52871e65ef2a
Message-ID: <e9c3a7c21003241746r27c6d576oe35237429aef5aaf@mail.gmail.com>
Subject: Re: [PATCH 2/4] dmaengine: Xilinx MPMC Kconfig/make
From: Dan Williams <dan.j.williams@intel.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       monstr@monstr.eu, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 9:26 AM, Steven J. Magnani
<steve@digidescorp.com> wrote:
> Integrate xlldma drivers into the build.
>
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> --- a/drivers/dma/Kconfig       2010-03-16 13:27:42.000000000 -0500
> +++ b/drivers/dma/Kconfig       2010-03-17 11:11:57.000000000 -0500
> @@ -126,6 +126,28 @@ config AMCC_PPC440SPE_ADMA
>        help
>          Enable support for the AMCC PPC440SPe RAID engines.
>
> +config XLL_DMA
> +       tristate "Xilinx LocalLink DMA support"
> +       depends on XILINX_VIRTEX || MICROBLAZE
> +       select DMA_ENGINE
> +       ---help---
> +         Enable support for the Xilinx MPMC DMA controller.
> +         This requires at least one MPMC SDMA port wired as a "loopback".
> +
> +         If unsure, say N.
> +
> +config XLL_DMA_OF
> +        tristate "Xilinx LocalLink DMA OF device"
> +        depends on XLL_DMA && OF
> +        help
> +          OpenFirmware bus attachment for the Xilinx LocalLink DMA engine.
> +
> +config XLL_DMA_PLAT
> +        tristate "Xilinx LocalLink DMA platform device"
> +        depends on XLL_DMA
> +        help
> +          Platform bus attachment for the Xilinx LocalLink DMA engine.

I think these should be in the per-arch Kconfig, if at all.

> +
>  config ARCH_HAS_ASYNC_TX_FIND_CHANNEL
>        bool
>
> @@ -138,13 +160,13 @@ comment "DMA Clients"
>  config NET_DMA
>        bool "Network: TCP receive copy offload"
>        depends on DMA_ENGINE && NET
> -       default (INTEL_IOATDMA || FSL_DMA)
> +       default (INTEL_IOATDMA || FSL_DMA || XLL_DMA)

NET_DMA is actively harmful for platforms with a non-io-coherent
caches.  So it should not default to y on Microblaze.
