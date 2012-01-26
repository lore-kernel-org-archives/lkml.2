Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2AZEHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 23:07:12 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:51093 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2AZEHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 23:07:10 -0500
Date: Thu, 26 Jan 2012 15:07:04 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 3.3
Message-ID: <20120126040704.GA13369@gondor.apana.org.au>
References: <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au> <20120126024342.GA12492@gondor.apana.org.au> <CA+55aFzFecPSQverH7VQBDZY+gS7_RALwh3W4oqWLbWBcBzLqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzFecPSQverH7VQBDZY+gS7_RALwh3W4oqWLbWBcBzLqg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 07:35:19PM -0800, Linus Torvalds wrote:
>
> Ugh. This once more has the crazy signed integer modulus operator,
> which can be quite expensive depending on whether the compiler can
> tell whether it is always positive or not.

Oops, I had incorrectly applied the first patch in the thread.

I've fixed it in the tree now.

> We also avoid the problem with absolutely horrible gcc register usage
> by having an arch-specific "accessor macro":

We could certainly do something like that.  Although I'd be
more comfortable with pushing this through linux-next, OK?


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alexey Dobriyan (2):
      crypto: sha512 - make it work, undo percpu message schedule
      crypto: sha512 - reduce stack usage to safe number

Herbert Xu (1):
      crypto: sha512 - Use binary and instead of modulus

 crypto/sha512_generic.c |   62 +++++++++++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 28 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
