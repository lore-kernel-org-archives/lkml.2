Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab1AFXOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:14:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab1AFXOq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:14:46 -0500
MIME-Version: 1.0
In-Reply-To: <20110106223042.GA27080@gondor.apana.org.au>
References: <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au>
 <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
 <20110106211645.GA26184@gondor.apana.org.au> <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
 <20110106213932.GA26538@gondor.apana.org.au> <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
 <20110106223042.GA27080@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 14:43:35 -0800
Message-ID: <AANLkTinbH8i8rjUxACV5PkdLuVc9YccT+E5x=ZBWunyU@mail.gmail.com>
Subject: Re: Crypto Update for 2.6.38
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 2:30 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
>
> The main use-case is bulk encryption/hashing in user-space.  For
> example, on Sparc Niagara2 you need to use SPU (Stream Processing
> Unit) in order to do crypto at 10Gb/s over the network.

Umm. But doesn't that require that the data then be sent to the network?

Why would a user-space -> crypto engine -> user space -> network chip
thing ever be good enough? Niagara is so slow that the whole bounce
thing will totally negate all the SPU advantages.

Your interface doesn't seem to support the use case that you actually
want, which is to avoid the bouncing back and forth between user space
buffers.

And if you bounce back and forth, I bet you can't get that 10Gb/s anyway.

Can you do the "bypass directly to the TCP stream" with the interface
you added? It isn't at all obvious how it would work.

So let me repeat ONE MORE TIME:

 - I understand that your interface can use the hw that exists

 - but I still want real-world use cases to show that it actually
works and makes sense in practice.

Don't give me "we could use the SPU" crap. Give me "this program
actually uses the SPU and gets better performance thanks to it, and
here are the numbers".

                         Linus
