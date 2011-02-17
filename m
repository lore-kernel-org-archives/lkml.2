Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1BQVzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:55:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755963Ab1BQVzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:55:46 -0500
MIME-Version: 1.0
In-Reply-To: <20110217.131702.112601300.davem@davemloft.net>
References: <AANLkTi=bgmRwGXEE_wriYo-5gmyaB43pMUzHf7idiK0k@mail.gmail.com>
 <20110217.130115.71101941.davem@davemloft.net> <AANLkTinA-OP69fqf5jLfedk=dL2vmwdUyzn5E6FHR=Zw@mail.gmail.com>
 <20110217.131702.112601300.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 13:54:57 -0800
Message-ID: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
To: David Miller <davem@davemloft.net>
Cc: dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 1:17 PM, David Miller <davem@davemloft.net> wrote:
>> EVERY SINGLE OF YOUR ARGUMENTS WORK FOR "pointer" TOO!
>
> It at least will not happen at the current time, because GCC only
> plays these games on aggregates.

So? Do they actually promise to never do it for pointers? What makes
aggregates so special? Rather than just happenstance?

I wouldn't be surprised if the structure alignment isn't even about
something even subtler and totally random, like size of structure (ie
"don't align small structures")

> Also, for exception tables, we've avoided this problem because
> we emit the exception tables by hand using inline asm and therefore
> explicitly control all aspects of the alignment and size.

.. and maybe that's the right thing to do here too.

> The GCC manual even documents the alignment attribute behavior.

The gcc manual is worthless. Every time some gcc person wants to
change behavior, they just change the manual. So you can't rely on it
anyway. We've seen that with inline asm before etc.

> Also, please don't shoot the messenger, I didn't make GCC behave this
> way but I doubt you'll have any luck undoing this behavior in the
> tools which therefore means as pragmatists we have to handle it one
> way or another.

I'm shooting not the messenger, but the people who make these kinds of
really ugly changes with bad changelogs that don't even explain what
the actual problem is. And apparently any gcc person is free to break
it in the future _anyway_.

Is there a -fdata-align or something? Or would __attribute__((packed))
help? Something that explicitly tells gcc "don't do this", instead of
"let's add indirection and hope gcc doesn't add alignment for _that_".
Especially as the extra pointer makes the code even uglier.

And if we do have to use the pointer thing, let's at least then do the
pointer with asms, so that gcc _really_ can't screw it up. Rather than
just move the potential bug around.

                            Linus
