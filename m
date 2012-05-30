Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab2E3V3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:29:36 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:42906 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756123Ab2E3V3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:29:33 -0400
Date: Thu, 31 May 2012 07:29:11 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?Q?M=FCller?= 
	<Tilo.Mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: serpent - add x86_64/avx assembler
 implementation
Message-ID: <20120530212911.GA14884@gondor.apana.org.au>
References: <20120527145112.GF17705@kronos.redsun>
 <m2396il7xc.fsf@firstfloor.org>
 <20120530103025.19252e1urui8sfb4@www.81.fi>
 <20120530113235.GO17705@kronos.redsun>
 <20120530153949.GS27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530153949.GS27374@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 05:39:49PM +0200, Andi Kleen wrote:
> > I agree with that. Currently when I boot my PC with a new 3.4 kernel all the
> > ciphers from the intel-aesni module get loaded whether I need them or not. As
> > Jussi stated most people using distros probably won't need the
> > serpent-avx-x86_64 module get loaded automatically, so it's probably better to
> > leave it that way.
> 
> That means you got a 50% chance to use the wrong serpent.

You should always get the best one available.  For example, when
you request for "aes" all implementations of it will be loaded by
modprobe.

> This was a continuous problem with AESNI and the accelerated CRC,
> that is why the cpuid probing was implemented.

The only case where it doesn't work is if you have some variants
built-in and the faster ones built as modules.  But then the answer
is to either build all of them as modules or all of them built-in
so that priority-based selection can work.

Can you provide an example where it doesn't work as intended?

What we could do is to use the cpuid-based probing when an algorithm
is needed to selectively load the relevant implementations instead
of all of them.  However, for most algorithms it won't make that
big a difference since all the available ones will be loaded anyway.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
