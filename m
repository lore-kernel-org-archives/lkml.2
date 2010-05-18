Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0ERVUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:20:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59292
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691Ab0ERVUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:20:13 -0400
Date: Tue, 18 May 2010 14:20:21 -0700 (PDT)
Message-Id: <20100518.142021.135951273.davem@davemloft.net>
To: penberg@cs.helsinki.fi
Cc: mpm@selenic.com, herbert@gondor.hengli.com.au, ken@codelabs.ch,
       geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
References: <1274211235.11603.1205.camel@calx>
	<20100518.135945.180391159.davem@davemloft.net>
	<AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 19 May 2010 00:15:46 +0300

> On Tue, May 18, 2010 at 11:59 PM, David Miller <davem@davemloft.net> wrote:
>> From: Matt Mackall <mpm@selenic.com>
>> Date: Tue, 18 May 2010 14:33:55 -0500
>>
>>> SLOB honors ARCH_KMALLOC_MINALIGN. If your arch has alignment
>>> requirements, I recommend you set it.
>>
>> I recommend that the alignment provided by the allocator is not
>> determined by which allocator I happen to have enabled.
>>
>> The values and ifdef'ery should be identical in all of our
>> allocators.
> 
> Why? It doesn't make much sense for SLOB, which tries to be as space
> efficient as possible, as a default. If things break on sparc, it
> really needs to set ARCH_KMALLOC_MINALIGN as slab default alignment is
> not something you really want to depend on.

I think it does make sense to expect that, whatever my architecture
defines or does not define, I can expect the allocators to provide the
same minimum alignment guarentee.  Otherwise it is no guarantee at all.

It's already obvious from these reports that such dependencies do
exist.

I'll add the define for sparc, but saying "sparc's fault" is bogus
because I defined what was necessary to get SLAB/SLUB to provide the
necessary alignment.  SLOB pays for choosing not to use the same
calculations for minimum alignment as the other allocators, and
therefore pays for being different in this regard.

And in fact I do know that the ifdef'ery in SLAB/SLUB is derived from
a change long ago that was specifically added to handle platforms like
sparc.

So one of two things should happen:

1) SLOB conforms to SLAB/SLUB in it's test

2) SLAB/SLUB conforms to SLOB in it's test

And yes this is an either-or, you can't say they are both valid.
