Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1AGDEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 22:04:00 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57256 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab1AGDD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 22:03:59 -0500
Date: Fri, 7 Jan 2011 14:03:49 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Pavel Roskin <proski@gnu.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
Message-ID: <20110107030349.GA845@gondor.apana.org.au>
References: <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com> <20110106211645.GA26184@gondor.apana.org.au> <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com> <20110106213932.GA26538@gondor.apana.org.au> <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com> <20110106223042.GA27080@gondor.apana.org.au> <AANLkTinbH8i8rjUxACV5PkdLuVc9YccT+E5x=ZBWunyU@mail.gmail.com> <20110106225301.GA27358@gondor.apana.org.au> <20110106213928.jd36vdlpcgsgcwss-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106213928.jd36vdlpcgsgcwss-cebfxv@webmail.spamcop.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 09:39:28PM -0500, Pavel Roskin wrote:
>
> By the way, is it a good idea to use setsockopt() this way?  Some keys  
> may be large.  And if AEAD is supported, will it use setsockopt() for  
> the unencrypted authenticated data?

For large keys (i.e., asymmetric key crypto) the kernel keyring API
would be the obvious way of passing them around.

For AEAD the AD would be passed around through send/splice.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
