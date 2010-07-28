Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0G1J0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:26:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:48984 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0G1J0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:26:44 -0400
Subject: Re: [PATCH 28/31] memblock: Export MEMBLOCK_ERROR again
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: hpa@zytor.com, yinghai@kernel.org, mingo@elte.hu, tglx@linutronix.de,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <20100727.230120.43037767.davem@davemloft.net>
References: <1280294128.1970.237.camel@pasglop>
	 <1280294376.1970.239.camel@pasglop> <4C4FC5D1.3070708@zytor.com>
	 <20100727.230120.43037767.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 19:25:31 +1000
Message-ID: <1280309131.1970.280.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 23:01 -0700, David Miller wrote:
> > On x86, physical address 0 contains the real-mode IVT and will thus be
> > reserved, at least for the forseeable future.  Other architectures may
> > very well have non-special RAM there.
> 
> 0 is very much possible on sparc64 

Yup, we need to fix that.

For now I made MEMBLOCK_ERROR 0 and added a blurb to prevent allocating
the first page since it would cause other problems with the current code
(0 is after all the normal error result from membloc_alloc(), ie, our
API wasn't quite consistent there).

So I don't think I'm introducing a regression here, on the contrary. But
if we are going to allow lmb_alloc() to return 0, we need to fix all
callers first and then we can look into turning MEMBLOCK_ERROR back to
~0

Cheers,
Ben.


