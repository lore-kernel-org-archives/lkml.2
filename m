Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0DSQS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:18:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab0DSQSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:18:54 -0400
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
 infinite loop in 2.6.32.11; is this fixed now?
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, r6144 <rainy6144@gmail.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       tglx <tglx@linutronix.de>, Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20100419161102.GZ32034@random.random>
References: <1271432722.2564.16.camel@localhost.localdomain>
	 <1271449668.1674.466.camel@laptop> <20100419114300.GT19264@csn.ul.ie>
	 <1271677956.1674.922.camel@laptop> <20100419153245.GX19264@csn.ul.ie>
	 <1271691905.1488.317.camel@laptop>  <20100419161102.GZ32034@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 18:18:48 +0200
Message-ID: <1271693928.1676.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 18:11 +0200, Andrea Arcangeli wrote:
> On Mon, Apr 19, 2010 at 05:45:05PM +0200, Peter Zijlstra wrote:
> > Wouldn't a longer poison be more recognisable? Also, shouldn't this use
> > POISON_POINTER_DELTA?
> > 
> > Something like:
> > 
> > #define HUGETBL_POISON	((void *) 0x00300300 + POISON_POINTER_DELTA)
> > 
> > 0x2e5 isn't that high, I've had actual derefs in that range.
> 
> The default at kernel config time sets only 4k as unmapped (I think
> it's a very bad default for 64bit archs), so above 4k userland can map
> it and you can have actual derefs with 0x00300300 but not with Mel's
> preferred <0x1000 address. So the address must be <0x1000.

Well, most poison values have that problem and still we have them. Also
on 64bit machines you can use POISON_POINTER_DELTA to map it outside the
virtual address range.


