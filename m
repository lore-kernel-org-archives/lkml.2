Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0ESBGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:06:24 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:59192 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752084Ab0ESBGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:06:22 -0400
Date: Wed, 19 May 2010 11:05:24 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
Message-ID: <20100519010524.GB18813@gondor.apana.org.au>
References: <1274211235.11603.1205.camel@calx> <20100518.135945.180391159.davem@davemloft.net> <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com> <20100518.142021.135951273.davem@davemloft.net> <1274224834.6930.8361.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274224834.6930.8361.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:20:34AM +0100, David Woodhouse wrote:
> 
> It would be better if the minimum alignment was exposed to generic code
> though -- you're right that the CPP tests in linux/crypto.h really
> shouldn't have to exist. If it wasn't for that, then the crypto problem
> wouldn't have occurred.

While this problem wouldn't have occurred, we would instead have
data corruption/alignment faults on architectures such as sparc32
or ARM that require 64-bit alignment for 64-bit objects.

So no getting rid of them isn't going to fix things either.  Of
course I have no objections to moving this into slab.h or a similar
location should anyone be willing to do the hard work.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
