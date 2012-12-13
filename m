Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2LMDWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:22:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33554 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2LMDWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:22:40 -0500
Date: Wed, 12 Dec 2012 22:22:39 -0500 (EST)
Message-Id: <20121212.222239.1677083852440112819.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nhorman@tuxdriver.com,
        vyasevich@gmail.com
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFxvHrNYB_J851XTkZ4EiwZ68Fb64DEU1JJmxPV-zB+9Vw@mail.gmail.com>
References: <CA+55aFwzUgxQAze=mYbEx8b61V542tzm06Df=mR1BtYVbJy0mg@mail.gmail.com>
	<20121212.212734.917363230032045212.davem@davemloft.net>
	<CA+55aFxvHrNYB_J851XTkZ4EiwZ68Fb64DEU1JJmxPV-zB+9Vw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 18:37:08 -0800

> On Wed, Dec 12, 2012 at 6:27 PM, David Miller <davem@davemloft.net> wrote:
>>
>> There are two SCTP HMAC cookie algorithms, MD5 and SHA1.
>>
>> What used to happen is that you had to choose one at build
>> time, and then you were stuck with that decision and it was
>> all that you could use.
>>
>> Now, it's selectable at run time.
>>
>> If there's anything you find particularly anti-social about
>> this, I'm sure we can adjust it.
> 
> So I'd suggest doing the same thing that the new thermal throttling
> Kconfig does: start off by asking for the default algorithm, then ask
> about the others.
> 
> The "choice" part selects the one that is default (so it never gets
> asked about and is obviously compiled in), and the rest default to no
> like we should.
> 
> See drivers/thermal/Kconfig for an example of this. I think we do it
> in other places too, but that one happens to be new so I picked it as
> an example.
> 
> The rule should be that we *never* default anything to 'yes', unless
> it's old functionality that we always compiled in before too, and now
> it got made conditional. So if you see a "default y" on new options,
> you should basically consider it broken.
> 
> We're already bloating too much, we should not encourage people to
> make things more bloated than necessary.
> 
> Btw, that Kconfig option has basically no useful help text either.
> What's the point of repeating the question as a "help" message?
> 
> If people can't explain why anybody should enable it, it sure as hell
> shouldn't default to 'y'. Maybe it shouldn't exist at all?

Neil and Vlad, please take care of this.

Thanks.
