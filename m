Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0ERWj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:39:59 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:36129 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753896Ab0ERWj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:39:57 -0400
Date: Wed, 19 May 2010 08:39:37 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Cc: Matt Mackall <mpm@selenic.com>, Geert Uytterhoeven <geert@linux-m68k.org>,
       michael-dev@fami-braun.de, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [BUG] SLOB breaks Crypto
Message-ID: <20100518223937.GB17320@gondor.apana.org.au>
References: <4B9E38AF.70309@fami-braun.de> <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com> <4BA29A19.2050307@fami-braun.de> <20100319003351.GC20227@gondor.apana.org.au> <AANLkTilPEnh3ewTb-KDsReBpjcszh1wkbfZohIaPXBKe@mail.gmail.com> <4BF1BA0E.4010402@codelabs.ch> <1274135869.11603.473.camel@calx> <4BF24D1F.6010005@codelabs.ch> <20100518102701.GA7293@gondor.apana.org.au> <4BF2EB66.4020207@codelabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF2EB66.4020207@codelabs.ch>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 09:32:54PM +0200, Adrian-Ken Rueegsegger wrote:
>
> When doing the revert it is necessary to either have
> ARCH_KMALLOC_MINALIGN defined or explicitly define CRYPTO_MINALIGN in
> the case where it is not. Otherwise shash compilation fails because it
> needs CRYPTO_MINALIGN.

Thanks, I'll make sure that it gets replaced with
crypto_tfm_ctx_alignment().  CRYPTO_MINALIGN shouldn't
be used in running code.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
