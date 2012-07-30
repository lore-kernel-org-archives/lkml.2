Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab2G3ToX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:44:23 -0400
Received: from mail2.shareable.org ([80.68.89.115]:51591 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab2G3ToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:44:21 -0400
X-Greylist: delayed 1351 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2012 15:44:20 EDT
Date: Mon, 30 Jul 2012 20:21:40 +0100
From: Jamie Lokier <jamie@shareable.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] page-table walkers vs memory order
Message-ID: <20120730192140.GU25459@jl-vm1.vm.bytemark.co.uk>
References: <1343064870.26034.23.camel@twins>
 <alpine.LSU.2.00.1207241356350.2094@eggly.anvils>
 <20120725175628.GH2378@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1207251313180.1942@eggly.anvils>
 <20120725211217.GR2378@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725211217.GR2378@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> > Does some version of gcc, under the options which we insist upon,
> > make such optimizations on any of the architectures which we support?
> 
> Pretty much any production-quality compiler will do double-fetch
> and old-value-reuse optimizations, the former especially on 32-bit
> x86.  I don't know of any production-quality compilers that do value
> speculation, which would make the compiler act like DEC Alpha hardware,
> and I would hope that if this does appear, (1) we would have warning
> and (2) it could be turned off.  But there has been a lot of work on
> this topic, so we would be foolish to rule it out.

GCC documentation for IA-64:

   -msched-ar-data-spec
   -mno-sched-ar-data-spec
     (En/Dis)able data speculative scheduling after reload. This results
     in generation of ld.a instructions and the corresponding check
     instructions (ld.c / chk.a). The default is 'enable'.

I don't know if that results in value speculation of the relevant kind.

-- Jamie
