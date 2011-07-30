Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab1G3RqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 13:46:09 -0400
Received: from waste.org ([173.11.57.241]:42935 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab1G3RqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 13:46:03 -0400
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, Jeff Garzik <jgarzik@pobox.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com>
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com>
	 <1311971867-25124-2-git-send-email-hpa@linux.intel.com>
	 <1311974171.20898.393.camel@calx>
	 <CA+55aFwMGwVsD1Gexahio2pWd0PpaHAbvFroB3w0=JOQf1zQ_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jul 2011 12:45:59 -0500
Message-ID: <1312047959.20898.489.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 23:20 -0700, Linus Torvalds wrote:
> On Fri, Jul 29, 2011 at 2:16 PM, Matt Mackall <mpm@selenic.com> wrote:
> >
> > I have already NAKed this approach in no uncertain terms.
> 
> Doesn't matter.

Good to know, feel free to drop me from MAINTAINERS.

> Talking about "standard hardware random number drivers" is just crazy
> talk, when the instruction is a single instruction that takes tens of
> nanoseconds to run. Any driver overhead would be just crazy, and no
> user would ever want that anyway.

Did you even look at these patches?

Here's Peter's interface:

+       ssize_t (*get_entropy_krnl)(void *buf, size_t nbytes);

Here's the hwrng interface:

	int (*read)(struct hwrng *rng, void *data, size_t max, bool wait);

The overhead on the kernel side for an "architectural random hook" and a
bog-standard HWRNG is basically the same. Here's a buffer, put N bytes
in it.

But then, the bulk of this patch is actually putting in a fast path to
pass this off to user space through /dev/urandom.

So here you are yammering on about "any driver overhead would be just
crazy" when the whole point of these patches is in fact CHARACTER
DRIVERS. We could already have a HWRNG interface that's just as fast in
the time we've spent debating this.

If you want to add a function get_fast_random_bytes() that turns into
inline assembly on Intel (and Via Padlock and whatever else shows up)
and falls back to get_random_bytes, great. That has nothing to do with
these patches.

-- 
Mathematics is the supreme nostalgia of our time.


