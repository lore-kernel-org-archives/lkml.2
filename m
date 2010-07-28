Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0G1Ga2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:30:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:35151 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0G1Ga0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:30:26 -0400
Subject: Re: [PATCH 28/31] memblock: Export MEMBLOCK_ERROR again
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <4C4FC5D1.3070708@zytor.com>
References: <1279822864-17154-1-git-send-email-yinghai@kernel.org>
	 <1279822864-17154-29-git-send-email-yinghai@kernel.org>
	 <1280294128.1970.237.camel@pasglop> <1280294376.1970.239.camel@pasglop>
	 <4C4FC5D1.3070708@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 16:29:52 +1000
Message-ID: <1280298592.1970.248.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 22:53 -0700, H. Peter Anvin wrote:
> On 07/27/2010 10:19 PM, Benjamin Herrenschmidt wrote:
> > 
> > Screw it, I don't like it but I'll just split your patch in two for now
> > and keep 0. It's a bit fishy but memblock does mostly top-down
> > allocations and so shouldn't hit 0, and in practice the region at 0 is,
> > I beleive, reserved, but we need to be extra careful and might need to
> > revisit that a bit.
> > 
> > That's an area where I don't completely agree with Linus, ie, 0 is a
> > perfectly valid physical address for memblock to return :-)
> > 
> 
> On x86, physical address 0 contains the real-mode IVT and will thus be
> reserved, at least for the forseeable future.  Other architectures may
> very well have non-special RAM there.

Right, that's my point. Anyways, I'm making 0 special for now and adding
a wart to prevent the allocator from returning something below
PAGE_SIZE. If we want to revisit that later we can.

Cheers,
Ben.


