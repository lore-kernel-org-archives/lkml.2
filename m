Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1AFWNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:13:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217Ab1AFWNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:13:44 -0500
MIME-Version: 1.0
In-Reply-To: <20110106213932.GA26538@gondor.apana.org.au>
References: <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au>
 <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au>
 <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au> <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
 <20110106211645.GA26184@gondor.apana.org.au> <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
 <20110106213932.GA26538@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 14:13:17 -0800
Message-ID: <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
Subject: Re: Crypto Update for 2.6.38
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 1:39 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> On Thu, Jan 06, 2011 at 01:23:19PM -0800, Linus Torvalds wrote:
>>
>> Explanations of interface. Code. Who uses it? What are the actual
>> performance benefits on real code?
>
> You snipped out the bit in my reply where I expanded on it:

You didn't expand on it AT ALL.

You just mentioned "the interface". I haven't seen WHAT THAT INTERFACE IS!

How hard is that to understand?

> Here is the original cover email for the patches:

Ok, this is more like it. This is roughly what I wanted to see:

> : Here is a sample hash program (note that these only illustrate
> : what the interface looks like and are not meant to be good examples
> : of coding :)

But I'm still missing the part where you show that there is any actual
use case that makes sense, and that actually improves performance.
Maybe it's been posted somewhere else, but the thing is, you're asking
_me_ to pull, and as a result you need to convince _me_ that this is a
good idea. So if it's been posted/discussed extensively elsewhere,
please point to those discussions.

I really don't like adding interfaces that don't have hard uses
associated with them. We've done it in the past, and it tends to be a
morass and a bad idea. That's been true even when the idea has been my
own, and thus obviously genius-level and clearly the RightThing(tm),
like "splice()". And it's why I push back on new interfaces when I see
them.

Btw, it doesn't have to be about performance per se. Does this allow
people to use keys without actually _seeing_ those keys? Your example
implies that that is not the case, but that's actually one of the few
reasons to actually support a kernel crypto interface - the ability to
have private personal keys around, but not having to actually let
possibly untrusted programs see them.

For example of why something like that matters, I can well see myself
using some program to encrypt things. But maybe I don't trust that
program enough to give it my actual private keys. In that case, kernel
support is a real feature.

But in your example, it looks like you just give it the key. Which to
me means that you're totally missing one of the major reasons for
having a separate protection domain.

And that makes me think that the interface is bad. And that's why it's
a big change to go from "internal kernel crypto interface" to "actual
user-space interface to the kernel crypto engine". The first one can
be fixed. The second one cannot.

So I'm not necessarily hung up on "performance", but I am hung up on
"there needs to be a point", and "the interface needs to be
-correct-". Performance would be one such point. Not just 'the
hardware is there'. I know the hardware exists, but I'm not at all
convinced that DMA with all the cacheflushing will ever actully be
faster the the CPU. And if it can, I want to hear about the real-world
situation where it actually is used.

                Linus
