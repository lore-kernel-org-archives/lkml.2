Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab1G3T3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:29:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572Ab1G3T3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <1312053234.20898.521.camel@calx>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
 <1311971867-25124-2-git-send-email-hpa@linux.intel.com> <1311974171.20898.393.camel@calx>
 <CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com>
 <1312047959.20898.489.camel@calx> <CA+55aFyhdSADSuc2Honu0HG4zLQ7JtovsiTonfA=Cu70jqrFRQ@mail.gmail.com>
 <1312053234.20898.521.camel@calx>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 09:29:18 -1000
Message-ID: <CA+55aFwjx=E5fpO=gfx0ugPE2Cgd_NOtw1Kx52pbg4aQEgshRg@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: Matt Mackall <mpm@selenic.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 9:13 AM, Matt Mackall <mpm@selenic.com> wrote:
>
> Well then rather than saying my NAK doesn't matter, you should say you
> also NAK it.

No, I don't think your NAK matters because your arguments were so insane.

Talking about electron microscopes and *expanding* on the patch just
makes me go "that NAK is not worth worrying about".

You comparing the rdrand to 'rdtsc' is more realistic, but it still
dismisses how powerful rdrand is.

The fact is, even if you worry about some back door for the NSA, or
some theoretical lack of perfect 32-bit randomness, we can pretty much
depend on it. We still do our own hashing on top of whatever entropy
we get out of rdrand, and we would still have all our other stuff.
Plus the instruction is public and testable - if Intel did something
wrong, they'll be *very* embarrassed.

In other words, there's absolutely no reason not to use it, and allow
us to get away from /dev/random running out of entropy. We absolutely
should use it for bootup randomness (where we currently are somewhat
weak), and I absolutely disagree that it should be made into more of a
driver abstraction.

I'd be willing to take Peter's patch *without* the abstraction, and
then just expect to cut it down.

But I'd be even more willing to just take something that just
introduces a per-arch interface to get a "unsigned long *" that is
random, and returning the number of bits of expected entropy in that
thing.  And for x86 CPU's with the RDRAND capability bit, I'd give
Intel the benefit of the doubt and just make it do a single "rdrand"
and return the full 64 bit (or is it a 32-bit interface? I should
know, but I didn't look it up).

Of course, if there are other known random interfaces that might give
more random bits, maybe "void *"+size is actually the right thing.
Probably a single word is the most reasonable and simple interface in
the absence of examples to the contrary, though.

                       Linus
