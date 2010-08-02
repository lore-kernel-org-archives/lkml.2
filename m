Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0HBPoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:44:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:53868 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0HBPoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:44:23 -0400
Date: Tue, 3 Aug 2010 00:43:52 +0900
To: hpa@zytor.com
Cc: konrad.wilk@oracle.com, fujita.tomonori@lab.ntt.co.jp, jeremy@goop.org,
        Ian.Campbell@citrix.com, albert_herranz@yahoo.es, x86@kernel.org,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C56E49E.6070102@zytor.com>
References: <20100729160557.GA4403@phenom.dumpdata.com>
	<20100802152552.GA4732@phenom.dumpdata.com>
	<4C56E49E.6070102@zytor.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100803004252B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 03 Aug 2010 00:43:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 08:30:38 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/02/2010 08:25 AM, Konrad Rzeszutek Wilk wrote:
> > hpa, are your concerns that a) inserting a sub-system call in the
> > generic code is not good. Or b) that we have five IOMMUs (counting SWIOTLB in that
> > category) and that we don't jettison from memory the ones we don't need
> > (that would be the primary goal of driverization of those IOMMUs,
> > right?). Or c) we should remove all sub-system detect calls (Calgary, AMD,
> > Intel, AGP) altogether from pci-dma.c and depend more on
> > x86_init.iommu structure (perhaps expend it?)
> 
> Sorry, had to deal with other stuff.
> 
> Basically, a) and c) are the issues, with a) being the more immediate;
> the amount of code left in memory is relatively small and as such I'm
> not too concerned with that aspect specifically.
> 
> With five IOMMUs we're well past the point where we need to have a clean
> and generic interface instead of having everything be ad hoc and
> interdependent.

That's the difficult part because IOMMUs are not
interdependent. Hardware IOMMUs are related with swiotlb. GART and
AMD-IOMMU are too.

We could invent sorta IOMMU register interface and driver-ize IOMMUs
but they can't be interdependent completely.
