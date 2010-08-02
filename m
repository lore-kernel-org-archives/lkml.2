Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab0HBIbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:31:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:45133 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab0HBIbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:31:07 -0400
Date: Mon, 2 Aug 2010 17:30:26 +0900
To: benh@kernel.crashing.org
Cc: Joerg.Roedel@amd.com, arnd@arndb.de, fujita.tomonori@lab.ntt.co.jp,
        stepanm@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1280736182.1902.55.camel@pasglop>
References: <1280546124.1902.30.camel@pasglop>
	<20100802074812.GM24084@amd.com>
	<1280736182.1902.55.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100802172941C.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 02 Aug 2010 17:30:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 18:03:02 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2010-08-02 at 09:48 +0200, Roedel, Joerg wrote:
> > > Hrm, indeed I just noticed that. Pretty gross... it should definitly
> > be
> > > renamed, is will caused endless confusion with unrelated iommu.h and
> > > iommu_* interfaces which represent something different.
> > 
> > The first direction to go should be trying to unify all the different
> > iommu* interfaces into the iommu-api. The generic api will definitly
> > need to be extended for that, but since it is an in-kernel interface
> > thats no problem. 
> 
> Well, I suppose I'm the de-facto candidate to take care of the powerpc
> side then :-)

We already agreed that what the iommu-api looks like?

ARM's iommu code (arch/plat-omap/include/plat/iommu.h) is a library to
simplify the IOMMU implementations. It could be useful for all the
iommu implementations.

The current iommu-api (include/linux/iommu.h) provides the common
interface for specific purposes (for KVM).

I think that the current iommu-api can be a part of the former.

I also think that the IOMMU part of this new msm should be integrated
into the former.

Another question is how the above can work with the DMA-API.
