Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1ELFvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 01:51:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52526 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1ELFve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 01:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NnYxobSX0Krns+27hE1MiYWGlM5xJwDB8y83oJZ+W2J2MNH4JXVPpPLI5S3qiTGDqP
         CskpIigKFUBWvo7IzXgiwMW+IrHWsvPpBj/Uu1BVqNDkMKKNcLt2OrAAyY8l5HmJTbq+
         067IPdGjq/QUYCxtuKshW8pUIZoqgqM02JR5E=
MIME-Version: 1.0
In-Reply-To: <1305152704-4864-8-git-send-email-nacc@us.ibm.com>
References: <1305152704-4864-1-git-send-email-nacc@us.ibm.com>
	<1305152704-4864-8-git-send-email-nacc@us.ibm.com>
Date: Thu, 12 May 2011 07:51:32 +0200
X-Google-Sender-Auth: YCtI6BaBLd74v7nUVVQinlMZ1f8
Message-ID: <BANLkTi=eL9uwvNSdEnY4S=k1kjSgH4Q5xg@mail.gmail.com>
Subject: Re: [PATCH 7/8] powerpc: use the newly added get_required_mask
 dma_map_ops hook
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>, Milton Miller <miltonm@bga.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Will Schmidt <will_schmidt@vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        cbe-oss-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 00:25, Nishanth Aravamudan <nacc@us.ibm.com> wrote:
> diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
> index 23083c3..688141c 100644
> --- a/arch/powerpc/platforms/ps3/system-bus.c
> +++ b/arch/powerpc/platforms/ps3/system-bus.c
> @@ -695,12 +695,18 @@ static int ps3_dma_supported(struct device *_dev, u64 mask)
>        return mask >= DMA_BIT_MASK(32);
>  }
>
> +static u64 ps3_dma_get_required_mask(struct device *_dev)
> +{
> +       return DMA_BIT_MASK(32);

Why 32 and not 64?

> +}
> +
>  static struct dma_map_ops ps3_sb_dma_ops = {
>        .alloc_coherent = ps3_alloc_coherent,
>        .free_coherent = ps3_free_coherent,
>        .map_sg = ps3_sb_map_sg,
>        .unmap_sg = ps3_sb_unmap_sg,
>        .dma_supported = ps3_dma_supported,
> +       .get_required_mask = ps3_dma_get_required_mask,
>        .map_page = ps3_sb_map_page,
>        .unmap_page = ps3_unmap_page,
>  };
> @@ -711,6 +717,7 @@ static struct dma_map_ops ps3_ioc0_dma_ops = {
>        .map_sg = ps3_ioc0_map_sg,
>        .unmap_sg = ps3_ioc0_unmap_sg,
>        .dma_supported = ps3_dma_supported,
> +       .get_required_mask = ps3_dma_get_required_mask,
>        .map_page = ps3_ioc0_map_page,
>        .unmap_page = ps3_unmap_page,
>  };

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
