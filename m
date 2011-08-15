Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1HOHPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:15:33 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:46797 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1HOHPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:15:31 -0400
Date: Mon, 15 Aug 2011 15:15:28 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aesni-intel - Add ivsize to ablk_ecb_alg
Message-ID: <20110815071528.GA29656@gondor.apana.org.au>
References: <20110811164040.GB2167@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811164040.GB2167@zod.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:40:41PM -0400, Josh Boyer wrote:
> The ablkcipher structure in ablk_ecb_alg is lacking an ivsize setting.
> This causes the algorithm to fail it's self-test when it's registered
> with the error message:
> 
> [    0.806920] alg: skcipher: Failed to load transform for ecb-aes-aesni: -2
> 
> crypto_lookup_skcipher doesn't like a missing ivsize.  Adding the ivsize
> allows the self-test lookup to pass.

That's not right.  ECB does not require an IV and therefore it
shouldn't have a non-zero IV size.

I'm not quite sure what you mean by crypto_lookup_skcipher not
liking a missing IV size.  It appears to handle that case just
fine by returning the algorithm as is.

Can you show me what your /proc/crypto contains after you get the
aformentioned error?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
