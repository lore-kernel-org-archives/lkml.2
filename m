Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0ESLkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:40:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58308 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0ESLkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:40:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=o8vBtLTa9du2brtMgZn+ZgtvXCjw4FTOiUh1xETfgvAJEDwM3j0mtlPyXAa8a7s5Uv
         k8P1jsL6IWvzVfM7wGZSfz3A8j7mmSMYJ8eDijp+HW8BaQRg+j3diV1ry1sFIP1KNVQE
         JfatAiGuJ8c3RUGZpENF/GcKJf9FJ7R5WrM/M=
MIME-Version: 1.0
In-Reply-To: <1274253269.6930.9325.camel@macbook.infradead.org>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274253269.6930.9325.camel@macbook.infradead.org>
Date: Wed, 19 May 2010 13:32:41 +0200
X-Google-Sender-Auth: iRsXkRWEtt2976s3KZS7CCGnDxk
Message-ID: <AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 09:14, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2010-05-19 at 11:05 +1000, Herbert Xu wrote:
>> While this problem wouldn't have occurred, we would instead have
>> data corruption/alignment faults on architectures such as sparc32
>> or ARM that require 64-bit alignment for 64-bit objects.
>
> Yeah, but that's what ARCH_SLAB_MINALIGN is for.
>
> ARM gets this right, and Dave has already said he's going to fix sparc.

Instead of having (different) defaults in sl[aou]b, perhaps we should just
remove the defaults completely, to ensure all architectures set
ARCH_SLAB_MINALIGN to the correct value?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
