Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1G3TOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:14:05 -0400
Received: from waste.org ([173.11.57.241]:56346 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab1G3TN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:13:58 -0400
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CA+55aFyhdSADSuc2Honu0HG4zLQ7JtovsiTonfA=Cu70jqrFRQ@mail.gmail.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
	 <1311971867-25124-2-git-send-email-hpa@linux.intel.com>
	 <1311974171.20898.393.camel@calx>
	 <CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com>
	 <1312047959.20898.489.camel@calx>
	 <CA+55aFyhdSADSuc2Honu0HG4zLQ7JtovsiTonfA=Cu70jqrFRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jul 2011 14:13:54 -0500
Message-ID: <1312053234.20898.521.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-30 at 08:20 -1000, Linus Torvalds wrote:
> On Sat, Jul 30, 2011 at 7:45 AM, Matt Mackall <mpm@selenic.com> wrote:
> >
> > Did you even look at these patches?
> 
> Umm. My exact point about the email was that we should if anything
> change Peter's patch *away* from some kind of abstracted driver
> interface.

Well then rather than saying my NAK doesn't matter, you should say you
also NAK it.

>  But that was what you were arguing for, and that was what I
> was dismissing.

Is there a reason you think making RDRAND available to userspace as a
HWRNG is a bad idea? Is there a reason it's not the most obviously
correct, least controversial first step to supporting this hardware?

No, there's not. Which is why I asked Peter to do this weeks ago.

> So when you argue for not taking the patches because you want a
> generic interface, I tell you that the argument is bogus.

It will only be bogus when Peter shows up with a patch that doesn't
touch /dev/urandom, which IS a generic interface.

> Now, if you now argue that we should make it closer, and not take
> Peter's patches for *that* reason, then I'd be in whole-hearted
> agreement with you.

There are two sets of possible consumers here, in-kernel and userspace.
Peter's patches are aimed squarely at the latter but you seem to be
talking exclusively about in-kernel users.

This is a lot like RDTSC. Sure, it makes sense to have an in-kernel
inline for this. I've even suggested a name. But when it comes to
gettimeofday(), we're going to insist on using a clocksource and we're
going to insist that it meets all the guarantees that gettimeofday()
normally makes.

-- 
Mathematics is the supreme nostalgia of our time.


