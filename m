Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0ERXQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:16:23 -0400
Received: from waste.org ([173.11.57.241]:46355 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0ERXQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:16:21 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: lethal@linux-sh.org, penberg@cs.helsinki.fi, herbert@gondor.hengli.com.au,
       ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
In-Reply-To: <20100518.154059.139137292.davem@davemloft.net>
References: <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <20100518223507.GB5933@linux-sh.org>
	 <20100518.154059.139137292.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 18:16:15 -0500
Message-ID: <1274224575.11603.1248.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 15:40 -0700, David Miller wrote:
> All of the CPP tests like the one used by linux/crypto.h are
> ludicrious.  It should absolutely be not necessary for any code to
> duplicate this kind of calculation.
> 
> Instead, this sequence should be in linux/slab.h, and be used
> universally by slab, slub, slob and anything that wants to know the
> allocators alignment guarentees.

Agreed. However, every arch should -also- set ARCH_KMALLOC_MINALIGN
appropriately so that we have documentation of the hardware requirements
on each platform.

> I don't even know of a 32-bit chip outside of x86 that doesn't
> potentially emit alignment requiring 64-bit memory operations for
> 64-bit objects.  So what SLOB is doing with a different default is
> even more strange.  And I bet you that even without the requirement,
> x86 runs faster with 64-bit alignment of 64-bit objects.

No doubt but SLOB explicitly trades faster for smaller.

-- 
Mathematics is the supreme nostalgia of our time.


