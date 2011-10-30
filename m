Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934349Ab1J3Rsl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 13:48:41 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60582 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934230Ab1J3Rsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 13:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <1319996494.13597.69.camel@edumazet-laptop>
References: <1319772566.6759.27.camel@deadeye> <1319777025.23112.67.camel@edumazet-laptop>
 <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
 <1319803781.23112.113.camel@edumazet-laptop> <CA+55aFxzgc5pC1p6J8YADNDwmAjUYNRKLvir6OQMueWqUXOaEQ@mail.gmail.com>
 <CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com>
 <1319813252.23112.122.camel@edumazet-laptop> <CA+55aFxvcvUopBc-Q6Fp87asTuBohev8Xdm67jcKfy4Z4_BZRg@mail.gmail.com>
 <CA+55aFz=sxRjw6u-ww0P=9hhvWaZP=+QJZ68W+B9WtvQqj9Ogg@mail.gmail.com>
 <1319964754.13597.26.camel@edumazet-laptop> <20111030095918.GA19676@one.firstfloor.org>
 <1319987765.13597.60.camel@edumazet-laptop> <CA+55aFyGEhBMv31QXN7q9PJc36TVtHLOvdFYB1+6NTo+nKSkbQ@mail.gmail.com>
 <1319996494.13597.69.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 30 Oct 2011 10:48:17 -0700
X-Google-Sender-Auth: ad73TUFy17Vs_0H5qZaIX25GNVY
Message-ID: <CA+55aFz-mp8k7qdF3LaOjgX19TbzrCirGuCmGwqVMq9SwQ8yvw@mail.gmail.com>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 10:41 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Changing atomic_read(const atomic_t *v) prototype to
> atomic_read(atomic_t *v) is not an option.

Why not?

    #define atomic_read(v)     ACCESS_AT_MOST_ONCE((v)->counter)

seems to be the cleanest thing.

And if you don't think this is "an option", I really can't see why you
care about the extra instructions in the code stream either.

> 4) macro (I personnaly dont like it)
> #define atomic_read(v) ACCESS_AT_MOST_ONCE(*(int *)&(v)->counter)

Why the *hell* would you have that cast there?

If somebody passes "const atomic_t"'s around, then just shoot the
bastard. The concept makes no sense.

Grepping for "const atomic_t" shows absolutely *zero* users, except
for the crazy inline function declaration itself.

Stop the insanity already. Get rid of the f*cking "const".

                      Linus
