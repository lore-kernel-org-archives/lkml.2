Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2EIEgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:36:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41336 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2EIEgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:36:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com> <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 May 2012 21:36:16 -0700
X-Google-Sender-Auth: whiFlXyCd6RuxYKaHwcFlajT9rk
Message-ID: <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Kay Sievers <kay@vrfy.org>, Greg Kroah-Hartmann <greg@kroah.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 9:27 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So think of KERN_CONT as a "quoting safety" thing. And in 99% of all
> cases it is obviously not actually needed. So in general, KERN_CONT is
> useless and should not be used, but that doesn't mean that it can be
> removed as a _concept_.

Btw, KERN_DEFAULT is the exact same thing for the "I start a new line,
but I don't really have a special priority level".

And it's *way* overused. At one point we used to have the policy that
all new printk()'s should have a priority level, presumably so that we
at some point could have just made it a real argument instead (ie
'printk(prio, "fmt", arg)').

However, that turned out to be just stupid (the same way encouraging
people to always use KERN_CONT was/is stupid). It turns out that a lot
of printk's really don't have a good priority level, there's no reason
to force them to use KERN_DEFAULT, and it doesn't actually add *any*
value what-so-ever.

But again, it can be useful for the special case where you start a new
printk() with a string that could be mistaken for the priority marker.
So exactly like KERN_CONT, KERN_DEFAULT can be used for "quoting"
purposes.

Of course, if you print out random strings with odd random crap in the
first few characters, you're probably doing something really really
wrong. So 99% of the time, you should never need KERN_DEFAULT or
KERN_CONT. They exist for the rare exceptional case, and they do
*need* to exist, but they should not generally need to be *used*.

So it's like a defibrillator: it is good to *have* one, but it's
really bad to have to *use* one.

                       Linus
