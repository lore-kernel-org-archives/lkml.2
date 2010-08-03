Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0HCB42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:56:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:33432 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0HCB40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:56:26 -0400
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
References: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 11:41:34 +1000
Message-ID: <1280799694.1902.83.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 02:23 +1000, Stephen Rothwell wrote:
> 
> Lots (if not all) of the arm builds failed for next-20100802 with these
> errors:
> 
> arch/arm/mm/init.c: In function 'arm_bootmem_init':
> arch/arm/mm/init.c:184: error: implicit declaration of function 'memblock_start_pfn'
> arch/arm/mm/init.c:186: error: implicit declaration of function 'memblock_end_pfn'
> arch/arm/mm/init.c:188: error: implicit declaration of function 'memblock_size_bytes'
> 
> Caused by commit 53e16bfaf19346f59b3502e207aa66c61332075c ("memblock:
> Introduce for_each_memblock() and new accessors, and use it") interacting
> with commit 2778f62056ada442414392d7ccd41188bb631619 ("ARM: initial LMB
> trial") and some others from the arm tree.
> 
> Ben, is there no way to retain the old APIs while creating the new ones? 

I'll have a second look. It might be doable if it's only those 3
functions.

In any case, I'm happy to delay that, wait for ARM to go in, then sent a
new batch that also fixes ARM up.

Once those patches are in, we get some saner APIs to memblocks which
make it a lot easier to rewrite the core, which I think Peter want to do
(and I like his ideas of using a single list very much too).

Cheers,
Ben.


