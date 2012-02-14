Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab2BNDfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:35:15 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:44002 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2BNDfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:35:10 -0500
Date: Tue, 14 Feb 2012 14:35:04 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Fixes for 3.3
Message-ID: <20120214033504.GA26895@gondor.apana.org.au>
References: <20100603100550.GA30681@gondor.apana.org.au> <20100716022648.GA28219@gondor.apana.org.au> <20100722055043.GA25689@gondor.apana.org.au> <20100903060055.GA28915@gondor.apana.org.au> <20100903110722.GA31826@gondor.apana.org.au> <20101215115035.GA25248@gondor.apana.org.au> <20110216053911.GA10999@gondor.apana.org.au> <20110328071322.GA6569@gondor.apana.org.au> <20110629235153.GA16559@gondor.apana.org.au> <20120126024342.GA12492@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126024342.GA12492@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push updates the sha512 fix so that it doesn't cause excessive
stack usage on i386.  This is done by reverting to the original
code, and avoiding the W duplication by moving its initialisation
into the loop.

As the underlying code is in fact the one that we have used for years,
I'm pushing this now instead of postponing to the next cycle.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (2):
      crypto: sha512 - Use binary and instead of modulus
      crypto: sha512 - Avoid stack bloat on i386

 crypto/sha512_generic.c |   70 ++++++++++++++++++++++-------------------------
 1 files changed, 33 insertions(+), 37 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
