Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1EDV7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:59:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42493 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab1EDV7u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GWHTOhkygNwLRU0mNmyDWVwC4UhJC1qaO6fGICtQ8KrWsIViTFsS/hQko/AZ6cl06R
         Y+o0kDMqKuZVLAnqjODiGIOHH/uQM2x/QmDq31OH8bYsEAFNHJxSED/Dwk+hU8BU4piV
         mf3JXb0meOHf2AA+n4BtYIxCzzXboSkwh9NBs=
MIME-Version: 1.0
In-Reply-To: <1304496817-7646-1-git-send-email-mcree@orcon.net.nz>
References: <1304496817-7646-1-git-send-email-mcree@orcon.net.nz>
From: Matt Turner <mattst88@gmail.com>
Date: Wed, 4 May 2011 17:59:29 -0400
Message-ID: <BANLkTiknKa8xq5UQYTWKZnGDqVyAjGhVmw@mail.gmail.com>
Subject: Re: [PATCH] alpha: Add DMA_ERROR_CODE defn to avert compiler error in drm
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 4:13 AM, Michael Cree <mcree@orcon.net.nz> wrote:
> The radeon drm code now relies on DMA_ERROR_CODE.  This defines
> it in alpha dma-mapping header to at least enable me to compile
> radeon drm/kms into kernel.
>
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
>  arch/alpha/include/asm/dma-mapping.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/alpha/include/asm/dma-mapping.h b/arch/alpha/include/asm/dma-mapping.h
> index 4567aca..644d9c3 100644
> --- a/arch/alpha/include/asm/dma-mapping.h
> +++ b/arch/alpha/include/asm/dma-mapping.h
> @@ -3,6 +3,8 @@
>
>  #include <linux/dma-attrs.h>
>
> +#define DMA_ERROR_CODE 0
> +
>  extern struct dma_map_ops *dma_ops;
>
>  static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> --
> 1.7.4.3
>
>

Other architectures define this differently.

arch/ia64/include/asm/dma-mapping.h:#define DMA_ERROR_CODE 0
arch/microblaze/include/asm/dma-mapping.h:#define DMA_ERROR_CODE
         (~(dma_addr_t)0x0)
arch/powerpc/include/asm/dma-mapping.h:#define DMA_ERROR_CODE
 (~(dma_addr_t)0x0)
arch/sparc/include/asm/dma-mapping.h:#define DMA_ERROR_CODE
(~(dma_addr_t)0x0)
arch/x86/include/asm/dma-mapping.h:#define DMA_ERROR_CODE       0

Any idea what the reason is?

Matt
