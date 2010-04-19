Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0DSRRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:17:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0DSRRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:17:32 -0400
Date: Mon, 19 Apr 2010 18:32:17 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>, r6144 <rainy6144@gmail.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       tglx <tglx@linutronix.de>, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
 infinite loop in 2.6.32.11; is this fixed now?
Message-ID: <20100419163217.GB32034@random.random>
References: <1271432722.2564.16.camel@localhost.localdomain>
 <1271449668.1674.466.camel@laptop>
 <20100419114300.GT19264@csn.ul.ie>
 <1271677956.1674.922.camel@laptop>
 <20100419153245.GX19264@csn.ul.ie>
 <1271691905.1488.317.camel@laptop>
 <20100419161102.GZ32034@random.random>
 <1271693928.1676.18.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271693928.1676.18.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 06:18:48PM +0200, Peter Zijlstra wrote:
> Well, most poison values have that problem and still we have them. Also

That would better be fixed too to stay <4096 for higher chance of
bug-detection, it doesn't make this case correct ;).

> on 64bit machines you can use POISON_POINTER_DELTA to map it outside the
> virtual address range.

We've thousands of magic values there, I don't see much benefit from
POISON_POINTER_DELTA other than being able to call it
0xdeadbeef+POISON_POINTER_DELTA ;). We always look the assembly to
find the actual real raw pointer value (without the field offset) so I
think using a range between 0xaaa and 0xbbb for the error pointers, is
functional enough, but it's up to you as long as it is a address range
that can't be used by userland it's surely ok ;).
