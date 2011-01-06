Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1AFSGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:06:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370Ab1AFSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:06:08 -0500
MIME-Version: 1.0
In-Reply-To: <20110106000157.GA16089@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au>
 <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au>
 <20100226004914.GA20812@gondor.apana.org.au> <20100519020603.GA19654@gondor.apana.org.au>
 <20100521104404.GA29530@gondor.apana.org.au> <20100804140448.GA4042@gondor.apana.org.au>
 <20101024061625.GA23715@gondor.apana.org.au> <20110106000157.GA16089@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 10:05:46 -0800
Message-ID: <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
Subject: Re: Crypto Update for 2.6.38
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 4:01 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
>
> * Crypto API interface for user-space (hash + skcipher)

Is there really any point to this? And can we get more explanation of
what the interface is, and who would use it?

If you need crypto in user space, it's almost invariably better done
in user space. If the CPU can do crypto on its own, and doesn't expose
those instructions to user space, it's just a stupid CPU - and the
user/kernel transfer is likely going to make it slower than a pure
software approach for any but the biggest transfers.

And if the crypto engine is off-chip, the sw version is going to be
faster anyway except for possible async versions that are hard to
interface to user space.

So I really need more convincing about the whole user-space interface.
Adding new interfaces willy-nilly isn't a good idea. They need damn
good reasons.

                                      Linus
