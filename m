Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0DSQMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab0DSQMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:12:22 -0400
Date: Mon, 19 Apr 2010 18:11:02 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>, r6144 <rainy6144@gmail.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       tglx <tglx@linutronix.de>, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
 infinite loop in 2.6.32.11; is this fixed now?
Message-ID: <20100419161102.GZ32034@random.random>
References: <1271432722.2564.16.camel@localhost.localdomain>
 <1271449668.1674.466.camel@laptop>
 <20100419114300.GT19264@csn.ul.ie>
 <1271677956.1674.922.camel@laptop>
 <20100419153245.GX19264@csn.ul.ie>
 <1271691905.1488.317.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271691905.1488.317.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 05:45:05PM +0200, Peter Zijlstra wrote:
> Wouldn't a longer poison be more recognisable? Also, shouldn't this use
> POISON_POINTER_DELTA?
> 
> Something like:
> 
> #define HUGETBL_POISON	((void *) 0x00300300 + POISON_POINTER_DELTA)
> 
> 0x2e5 isn't that high, I've had actual derefs in that range.

The default at kernel config time sets only 4k as unmapped (I think
it's a very bad default for 64bit archs), so above 4k userland can map
it and you can have actual derefs with 0x00300300 but not with Mel's
preferred <0x1000 address. So the address must be <0x1000.
