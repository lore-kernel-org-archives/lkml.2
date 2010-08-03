Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0HCFfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:35:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:34137 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0HCFfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:35:43 -0400
Date: Tue, 3 Aug 2010 14:35:09 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, jeremy@goop.org,
        Ian.Campbell@citrix.com, albert_herranz@yahoo.es, x86@kernel.org,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100802164234.GC6961@phenom.dumpdata.com>
References: <4C56E8A9.1060004@zytor.com>
	<20100803010025R.fujita.tomonori@lab.ntt.co.jp>
	<20100802164234.GC6961@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100803143407J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 03 Aug 2010 14:35:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 12:42:34 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> > But his attempt to create "swiotlb iommu function array" and "hardware
> > iommu function array" looks like to makes the code more unreadable.
> 
> Let me go to my favorite coffee shop and think this one through.
> Can I get concession for putting the original patch in (the simple, dumb one),
> and then:
>  - start working on the IOMMU register interface without having to try
>    to get it done for 2.6.36, and
>  - do the driverization as a seperate cleanup.

We could simplify swiotlb initialization after 2.6.36. If we merge my
patches to expand swiotlb memory dynamically, we could initialize
swiotlb before any hw IOMMUs (see the commit
186a25026c44d1bfa97671110ff14dcd0c99678e).

If you can make Xen swiotlb initialized like HW iommu, the IOMMU
initialization could be cleaner.

As I wrote, I also want to simplify swiotlb's init memory
allocation. I'll see what I can do on the whole issue.
