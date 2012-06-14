Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2FNCQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:16:24 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:56393 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755129Ab2FNCQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:16:22 -0400
Date: Thu, 14 Jun 2012 10:16:12 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Subject: Re: linux-next: Tree for Jun 13 (crypto)
Message-ID: <20120614021612.GA29544@gondor.apana.org.au>
References: <20120613155440.14672516ffaf5b01f91bb0a2@canb.auug.org.au>
 <4FD8BB95.4000307@xenotime.net>
 <20120613200317.20733xjrnmv47y04@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613200317.20733xjrnmv47y04@www.81.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 08:03:17PM +0300, Jussi Kivilinna wrote:
> 
> Reverting commit e2f4d85d5b2049a90859aa10de914ed31a4f17a4, "crypto:
> serpent - add common glue code for avx and sse2 implementation",
> should help for most.
> 
> >arch/x86/crypto/serpent-avx-x86_64.o: In function `serpent_dec_blk_8way':
> >(.text+0x3d70): multiple definition of `serpent_dec_blk_8way'
> >arch/x86/crypto/serpent-avx-x86_64.o: In function `__serpent_enc_blk_8way':
> >(.text+0x0): multiple definition of `__serpent_enc_blk_8way'
> 
> Attached patch should solve these (patch depends on above revert).
> 
> -Jussi

> crypto: serpent-sse2/avx - allow both to be built into kernel
> 
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> 
> Rename serpent-avx assembler functions so that they do not collide with
> serpent-sse2 assembler functions when linking both versions in to same
> kernel image.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

OK I have reverted e2f4d85d and applied your patch.  In the process
I have rebased all patches on top of the original one so watch out if
you're pulling my tree.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
