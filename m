Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab1BKUYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:24:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085Ab1BKUYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:24:49 -0500
Date: Fri, 11 Feb 2011 21:24:31 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [mmotm] BUG: Bad page state in process khugepaged ?
Message-ID: <20110211202431.GJ3347@random.random>
References: <20110209151036.f24a36a6.kamezawa.hiroyu@jp.fujitsu.com>
 <20110209155001.0e369475.nishimura@mxp.nes.nec.co.jp>
 <20110209155246.69a7f3a1.kamezawa.hiroyu@jp.fujitsu.com>
 <20110209200728.GQ3347@random.random>
 <alpine.LSU.2.00.1102102243160.2331@sister.anvils>
 <20110211104906.GE3347@random.random>
 <alpine.LSU.2.00.1102111132560.3814@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1102111132560.3814@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 11:58:58AM -0800, Hugh Dickins wrote:
> Oh, I hadn't realized Fedora use it.  I wonder if that's wise, I thought
> Nick introduced it partly for the more expensive checks, and there might
> be one or two of those around - those bad_range()s in page_alloc.c?

I doubt the more expensive checks are very measurable.. benchmarks
usually run on enterprise distro. I'm sure when they enabled, they
were aware of having to run more expensive runtime checks.

> But the patch actually says -1024*1024: either would do.

I actually increased it to -1024*1024 after writing the email ;) sorry
the for the confusion.

> Yes, that's fine, 0xfff00000 looks unlikely enough (and my
> imagination for "deadbeef"-like magic is too drowsy today).

I used a negative power of two even if I doubt the compiler can make
much use of it.

> Okay I suppose: it seems rather laboured to me, I think I'd have just
> moved the VM_BUG_ON into rmv_page_order() if I'd done the patch; but
> since I was too lazy to do it, I'd better be grateful for yours!

Ok the reason I didn't move the VM_BUG_ON is to be stricter in case
there are more usages of __ClearPageBuddy in the future. I guess it's
not so important, but when I initially implemented it, it wasn't
entirely obvious it would work safe with memory hotplug, compaction
and all other bits using PageBuddy, so...
