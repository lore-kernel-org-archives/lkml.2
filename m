Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2LMChw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:37:52 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51465 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab2LMCha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <20121212.212734.917363230032045212.davem@davemloft.net>
References: <20121212.151116.143443755590581447.davem@davemloft.net>
 <CA+55aFwzUgxQAze=mYbEx8b61V542tzm06Df=mR1BtYVbJy0mg@mail.gmail.com> <20121212.212734.917363230032045212.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 18:37:08 -0800
X-Google-Sender-Auth: 4K994HATcRYe-Qskk4LZ4bhZQO4
Message-ID: <CA+55aFxvHrNYB_J851XTkZ4EiwZ68Fb64DEU1JJmxPV-zB+9Vw@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 6:27 PM, David Miller <davem@davemloft.net> wrote:
>
> There are two SCTP HMAC cookie algorithms, MD5 and SHA1.
>
> What used to happen is that you had to choose one at build
> time, and then you were stuck with that decision and it was
> all that you could use.
>
> Now, it's selectable at run time.
>
> If there's anything you find particularly anti-social about
> this, I'm sure we can adjust it.

So I'd suggest doing the same thing that the new thermal throttling
Kconfig does: start off by asking for the default algorithm, then ask
about the others.

The "choice" part selects the one that is default (so it never gets
asked about and is obviously compiled in), and the rest default to no
like we should.

See drivers/thermal/Kconfig for an example of this. I think we do it
in other places too, but that one happens to be new so I picked it as
an example.

The rule should be that we *never* default anything to 'yes', unless
it's old functionality that we always compiled in before too, and now
it got made conditional. So if you see a "default y" on new options,
you should basically consider it broken.

We're already bloating too much, we should not encourage people to
make things more bloated than necessary.

Btw, that Kconfig option has basically no useful help text either.
What's the point of repeating the question as a "help" message?

If people can't explain why anybody should enable it, it sure as hell
shouldn't default to 'y'. Maybe it shouldn't exist at all?

            Linus
