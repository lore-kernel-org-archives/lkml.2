Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0ETEuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 00:50:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab0ETEuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 00:50:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LNwlWCdjLhQ9jtIDhhRD3FED34qef6YygU2q4jW0p7LLjehnwfMLtdkY2oFC34Rn9g
         LwydR13t4Kq2gTv93chz5Y/70xpK7VYiNy+bmUNB5SGSG9Vbhpo1zOOeCS2lB/cRcvMN
         x+j1oBSjr3YrRanfdbpW9wbVtedOTH/zfbt0Y=
MIME-Version: 1.0
In-Reply-To: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1274325703-11092-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 20 May 2010 07:50:05 +0300
X-Google-Sender-Auth: M_GMzWL_dinH8N1K-vCy9fvC7-c
Message-ID: <AANLkTil7bciN2D_4cjROmONihRHQNpH3t_bJNSyz92UW@mail.gmail.com>
Subject: Re: [PATCH -mm 0/6] ARCH_KMALLOC_MINALIGN fixes
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davem@davemloft.net, dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 6:21 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> As DMA-API-HOWTO says, kmalloc'ed buffer must be DMA-safe. Drivers and
> subsystems depend on it.
>
> So architectures that handle DMA-non-coherent memory need to set
> ARCH_KMALLOC_MINALIGN: the kmalloc'ed buffer doesn't share a cache
> with the others. Otherwise, we hit memory corruption due to DMA.
>
> I had a quick look at all the architectures. Seems that some
> architectures that need to set ARCH_KMALLOC_MINALIGN don't do.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

for the whole series.

>
> =
>  arch/blackfin/include/asm/cache.h |    2 ++
>  arch/frv/include/asm/cache.h      |    2 ++
>  arch/m68k/include/asm/cache.h     |    2 ++
>  arch/mn10300/include/asm/cache.h  |    2 ++
>  arch/parisc/include/asm/cache.h   |    2 ++
>  arch/xtensa/include/asm/cache.h   |    1 +
>  6 files changed, 11 insertions(+), 0 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
