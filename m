Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2DTLWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:22:04 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:14683 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485Ab2DTLWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:22:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAFJGkU95LdRK/2dsb2JhbABDsTyBCIIJAQEEATocFgoDEAsVAxwSFBgNJBOICgS7BpBnBJV4kD6CeQ
Date: Fri, 20 Apr 2012 21:21:49 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] brlocks/lglocks: turn into functions
Message-ID: <20120420112149.GH25458@amd.local0.net>
References: <87ehtf3lqh.fsf@rustcorp.com.au>
 <20120227155338.7b5110cd.akpm@linux-foundation.org>
 <20120228112422.GC11324@alboin.amr.corp.intel.com>
 <87ipijzfwn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipijzfwn.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This still not merged?

On Mon, Mar 05, 2012 at 05:35:28PM +1030, Rusty Russell wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> lglocks and brlocks are currently generated with some complicated macros
> in lglock.h.  But there's no reason to not just use common utility
> functions and put all the data into a common data structure.

There is a reason, which is performance. Extra function call, but also
IIRC the percpu accessor was not so fast doing it this way. Maybe
that's improved...

So what's the performance difference?

> 
> Since there are at least two users it makes sense to share this code in a
> library.  This is also easier maintainable than a macro forest.
> 
> This will also make it later possible to dynamically allocate lglocks and
> also use them in modules (this would both still need some additional, but
> now straightforward, code)

Yes, but let's not do either of those things :)

I was slightly crazy when committing that patch to the kernel, I'll
admit. So if performance isn't significantly affected, then definitely.
If it is... well, it's much easier to gain 1% performance by maintaining
100 self contained lines of hilarious code like this than to actually
use your brain to improve somewhere else!

Thanks,
Nick
