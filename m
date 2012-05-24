Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab2EXIgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:36:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2EXIgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:36:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: Crypto Update for 3.5
Date: Thu, 24 May 2012 08:36:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Westin <andreas.westin@stericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
References: <20101024061625.GA23715@gondor.apana.org.au> <CA+55aFwR=wZfpXPTn9e+ZbEB4srVOHVZFz_STg9jxngmhJxT=w@mail.gmail.com> <20120524002126.GA28104@gondor.apana.org.au>
In-Reply-To: <20120524002126.GA28104@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205240836.24845.arnd@arndb.de>
X-Provags-ID: V02:K0:yg00RVMloWjCR/TMTPBVKWlW0VYQgs2H7LHmQGzkPRi
 i8Hky30siXv6U59XH0JB+/IZ0jXh7rxP0CCBqSmlZgKyKYqyca
 tgRSh79h1pAQIHjoPAGUxQzJFjVaI8iukadrFW5jSQMMNvMmFd
 hvn5YU7KN4MlDupCFbwuZndDC4XHmtH8IPmOnJCvFj/tSKL7nP
 TMYAl/xxhyvqwzr0vhdHnLiKK2jx7brJrQ/H/EKozTyxnd8pxU
 3wS2W9j5rLthdkPaKsMCW4vwukTAijDcQ+Gg5RsPbyuaKUoLEB
 sUHRkCM+vKLlWrjXSPZZrGZRIQoS3c9QPcBApyKJjS7ad53eJR
 xMRYYOxDogHzCEs8341s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2012, Herbert Xu wrote:
> On Wed, May 23, 2012 at 04:06:35PM -0700, Linus Torvalds wrote:
> > On Tue, May 22, 2012 at 6:35 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > Here is the crypto update for 3.5:
> > 
> > I pulled this, but quite frankly, some of it looks like utter garbage.
> > 
> > There's a declaration for dbx500_add_platform_device_noirq() that does
> > not exist and is not used anywhere. Why? It was added in commit
> > 585d188f8072, and I see no rhyme or reason to it.
> 
> I can't see why that was added there either.
> 
> Adding Arnd/Linus Walleij to see if they can tell us whether
> it should go or stay.

It should go. For all I can tell, this was the result of Lee Jones
doing major cleanups to the ux500 platform for this merge window
in parallel with the crypto driver getting added following the
older code pattern. The crypto patch had to be reworked for this
and apparently a hunk from the older version survived.

The entire file in which it was added is going to be removed
in one of the next kernel versions once we can boot all ux500 machines
using only device tree definitions, so it will be taken care of.

	Arnd
