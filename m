Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2IJRSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:18:22 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:44576 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2IJRST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:18:19 -0400
From: Romain Francoise <romain@orebokech.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Mathias Krause <minipli@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Linux 3.6-rc5
Organization: orebokech dot com
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
	<87har7h84h.fsf@silenus.orebokech.com>
	<20120909191958.GB9782@gondor.apana.org.au>
	<20120909200910.GA11919@r00tworld.net>
	<20120909210000.GA10293@gondor.apana.org.au>
Date: Mon, 10 Sep 2012 19:18:17 +0200
In-Reply-To: <20120909210000.GA10293@gondor.apana.org.au> (Herbert Xu's
	message of "Sun, 9 Sep 2012 14:00:00 -0700")
Message-ID: <878vchdcfa.fsf@silenus.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> Thanks! I think this patch should fix the problem.  Can someone
> please confirm this?

Works for me as well, thanks!

> crypto: authenc - Fix crash with zero-length assoc data
>
> The authenc code doesn't deal with zero-length associated data
> correctly and ends up constructing a zero-length sg entry which
> causes a crash when it's fed into the crypto system.
>
> This patch fixes this by avoiding the code-path that triggers
> the SG construction if we have no associated data.
>
> This isn't the most optimal fix as it means that we'll end up
> using the fallback code-path even when we could still execute
> the digest function.  However, this isn't a big deal as nobody
> but the test path would supply zero-length associated data.
>
> Reported-by: Romain Francoise <romain@orebokech.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Feel free to change this to:

Reported-and-tested-by: Romain Francoise <romain@orebokech.com>
