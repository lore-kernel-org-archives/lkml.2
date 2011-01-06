Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1AFVQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:16:53 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:43515 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1AFVQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:16:52 -0500
Date: Fri, 7 Jan 2011 08:16:46 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
Message-ID: <20110106211645.GA26184@gondor.apana.org.au>
References: <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 10:05:46AM -0800, Linus Torvalds wrote:
>
> Is there really any point to this? And can we get more explanation of
> what the interface is, and who would use it?

I think you've answered it yourself in the third paragraph :)

> If you need crypto in user space, it's almost invariably better done
> in user space. If the CPU can do crypto on its own, and doesn't expose
> those instructions to user space, it's just a stupid CPU - and the
> user/kernel transfer is likely going to make it slower than a pure
> software approach for any but the biggest transfers.

I agree completely.

> And if the crypto engine is off-chip, the sw version is going to be
> faster anyway except for possible async versions that are hard to
> interface to user space.
> 
> So I really need more convincing about the whole user-space interface.
> Adding new interfaces willy-nilly isn't a good idea. They need damn
> good reasons.

Right.  This purpose of this interface is to access the async
hardware crypto drivers that we have added over the past years.

For a modern x86-64 CPU it isn't interesting at all.  It's mainly
for other architectures where the CPU may not be able to keep up
with say 10Gb/s IPsec traffic and the encryption and/or hashing
must be offloaded.

This is also why only hash and skcipher are supported as they
are the main algorithm types supported by teh current async
drivers in the kernel.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
