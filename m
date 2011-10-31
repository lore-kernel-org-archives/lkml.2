Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab1JaRRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:17:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56688 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab1JaRRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:17:17 -0400
MIME-Version: 1.0
In-Reply-To: <4EAED00C.3010908@xenotime.net>
References: <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au>
 <20100519020603.GA19654@gondor.apana.org.au> <20100521104404.GA29530@gondor.apana.org.au>
 <20100804140448.GA4042@gondor.apana.org.au> <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au> <20110315145940.GA15373@gondor.apana.org.au>
 <20110520235409.GA1722@gondor.apana.org.au> <20110724011752.GA14373@gondor.apana.org.au>
 <20111031040952.GA19659@gondor.apana.org.au> <4EAED00C.3010908@xenotime.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 10:16:55 -0700
X-Google-Sender-Auth: 7R0oUYUhmVbyH2fD7oY5ClphLMA
Message-ID: <CA+55aFw=quU1bVR_AZ0OBW4DkPWMfxvWu7smx9VcDe81vaGu9Q@mail.gmail.com>
Subject: Re: Crypto Update for 3.2
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 9:42 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>
> Actually adds "select NET", a reverse dependency.  :(
>
> Linus was quite vocal about not allowing MD to select BLOCK.
> See https://lkml.org/lkml/2011/8/10/527
> and https://lkml.org/lkml/2011/8/10/533
>
> To me this is very similar.

I do agree.

"select" makes sense when it's a way for a user to not have to care
about some small helper thing that is really not obvious for a casual
user.

But darn it, if somebody has said "no networking", then some random
small feature shouldn't suddenly select it.

IOW, it's about "relative importance". We should use "select" when
some feature that should be user-visible selects some details. And we
should use "depends on" when there's a major subsystem that some small
detail depends on.

So classic and obvious uses where "select" is appropriate is when a
driver needs some helper library to work (eg "select FW_LOADER" or
"select CRC32").

And a classic and obvious case where "depends on" is the appropriate
choice is when it depends on a major subsystem ("depends on PCI" or
"depends on USB" or "depends on X86").

And I think "NET" definitely falls into that second category - exactly
the same way "BLOCK" fell into it. You don't "select" major subsystems
- if somebody turned off the subsystem, we turn off the stuff that
depends on it.

(Of course, in reality, pretty much nobody turns off NET, I suspect.
But if some embedded place really doesn't want it, then damn it, we
shouldn't ask about the odd crypto user interfaces, because they
really aren't major enough, and the embedded platform is clearly
trying very hard to run small).

                        Linus
