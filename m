Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1CPMiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 08:38:15 -0400
Received: from waste.org ([173.11.57.241]:55496 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1CPMiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 08:38:11 -0400
Subject: Re: [PATCH 0/8] mm/slub: Add SLUB_RANDOMIZE support
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: George Spelvin <linux@horizon.com>, penberg@cs.helsinki.fi,
        herbert@gondor.hengli.com.au, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <AANLkTimZRnaf6C-vOkkM-uhVVzn8NO8_V9Xb16rN7BKK@mail.gmail.com>
References: <20110316022804.27676.qmail@science.horizon.com>
	 <1300244238.3128.420.camel@calx>
	 <AANLkTimZRnaf6C-vOkkM-uhVVzn8NO8_V9Xb16rN7BKK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 07:38:07 -0500
Message-ID: <1300279087.3128.467.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 08:23 +0200, Pekka Enberg wrote:
> Hi Matt,
> 
> On Sun, 2011-03-13 at 20:20 -0400, George Spelvin wrote:
> >> As a followup to the "[PATCH] Make /proc/slabinfo 0400" thread, this
> >> is a patch series to randomize the order of object allocations within
> >> a page.  It can be extended to SLAB and SLOB if desired.  Mostly it's
> >> for benchmarking and discussion.
> 
> On Wed, Mar 16, 2011 at 4:57 AM, Matt Mackall <mpm@selenic.com> wrote:
> > I've spent a while thinking about this over the past few weeks, and I
> > really don't think it's productive to try to randomize the allocators.
> > It provides negligible defense and just makes life harder for kernel
> > hackers.
> 
> If it's an optional feature and the impact on the code is low (as it
> seems to be), what's the downside?

We still haven't established an upside, so from where I'm sitting it's
all downside.

>  Combined with disabling SLUB's slab
> merging, randomization should definitely make it more difficult to
> have full control over a full slab.

Turning off slab merging will help for object types that use their own
slabs, kmalloced objects will still be vulnerable, independently of
randomization. Randomization won't prevent anything but the most naive
attack.

Again, we've already spent more time talking about this than it will
take for the exploit community to work around it.

> No, you can't but heap exploits like the one we discuss are slightly
> harder with SLOB anyway, no?

Only slightly, if at all.

-- 
Mathematics is the supreme nostalgia of our time.


