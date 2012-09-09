Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2IIVBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 17:01:22 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:53705 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192Ab2IIVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 17:01:21 -0400
Date: Sun, 9 Sep 2012 14:01:15 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Romain Francoise <romain@orebokech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Linux 3.6-rc5
Message-ID: <20120909210115.GB10293@gondor.apana.org.au>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com>
 <20120909155424.862635h7ncykg9s0@www.81.fi>
 <CA+55aFyM52LaD_fF+dwjF1aKKeVCpHpBVqAQeEAZLB+Mnrgsig@mail.gmail.com>
 <20120909185358.GA9782@gondor.apana.org.au>
 <20120909235404.747466tf3h2pbf48@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120909235404.747466tf3h2pbf48@www.81.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2012 at 11:54:04PM +0300, Jussi Kivilinna wrote:
>
> It seems that authenc is chaining empty assoc scatterlist, which causes
> BUG_ON(!sg->length) set off in crypto/scatterwalk.c.
> 
> Following fixes the bug and self-test passes, but not sure if it's correct
> (note, copy-paste to 'broken' email client, most likely does not apply etc):

Yes this should fix the crash.
 
> Also does crypto_authenc_iverify() need same fix?

Right it does too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
