Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0ESLu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:50:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55899 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0ESLuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TD936oOaxQvUPTRmX0pzvL0iA1vECoXZsSeCUpwrk62Uio61fHPaPWbruTg8BGG2/l
         7Do7Hr0vxCV0NYmr3ndUhQBhjqIu7h5HfLD+fyCUgrR30Dmym4d+qwzrfKPySANdOgJ0
         ncvLWoQ4RXSKDQWaiESMrWEbEOhCiBUL5JR8w=
MIME-Version: 1.0
In-Reply-To: <1274269236.6930.9930.camel@macbook.infradead.org>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274253269.6930.9325.camel@macbook.infradead.org>
	 <AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
	 <1274269236.6930.9930.camel@macbook.infradead.org>
Date: Wed, 19 May 2010 13:50:52 +0200
X-Google-Sender-Auth: TVRGys4Na24QN-lPhkJ78CK3Qhg
Message-ID: <AANLkTikZyfxBjXdvNzuVT2N9XIyJmY6JDiKRMRtAykeC@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 13:40, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2010-05-19 at 13:32 +0200, Geert Uytterhoeven wrote:
>> Instead of having (different) defaults in sl[aou]b, perhaps we should
>> just remove the defaults completely, to ensure all architectures set
>> ARCH_SLAB_MINALIGN to the correct value?
>
> What is 'correct'? The architecture sets it to the minimum value that it
> can cope with, according to its own alignment constraints (and DMA/cache
> constraints, in the case of ARCH_KMALLOC_MINALIGN).
>
> Some architectures don't _have_ any minimum required alignment, so they
> have no need to set it. If the architecture _does_ specify a minimum,
> the allocators must honour it. Otherwise, they're free to do their own
> thing. And slob chooses to use a smaller alignment than slab and slub
> do, in accordance with its design and its raison d'être.

Currently 7 out of 20+ architectures set it.
Any bets on how many are missing, but should set it?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
