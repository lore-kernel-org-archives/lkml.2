Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab0ESLlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:41:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:45446 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0ESLk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:40:57 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: David Woodhouse <dwmw2@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
In-Reply-To: <AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274253269.6930.9325.camel@macbook.infradead.org>
	 <AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 12:40:36 +0100
Message-ID: <1274269236.6930.9930.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 13:32 +0200, Geert Uytterhoeven wrote:
> Instead of having (different) defaults in sl[aou]b, perhaps we should
> just remove the defaults completely, to ensure all architectures set
> ARCH_SLAB_MINALIGN to the correct value? 

What is 'correct'? The architecture sets it to the minimum value that it
can cope with, according to its own alignment constraints (and DMA/cache
constraints, in the case of ARCH_KMALLOC_MINALIGN).

Some architectures don't _have_ any minimum required alignment, so they
have no need to set it. If the architecture _does_ specify a minimum,
the allocators must honour it. Otherwise, they're free to do their own
thing. And slob chooses to use a smaller alignment than slab and slub
do, in accordance with its design and its raison d'être.

-- 
dwmw2

