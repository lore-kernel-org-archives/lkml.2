Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab0HBJUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:20:38 -0400
Received: from sh.osrg.net ([192.16.179.4]:39186 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846Ab0HBJUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:20:37 -0400
Date: Mon, 2 Aug 2010 18:20:01 +0900
To: linux@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org,
        dwalker@codeaurora.org, arnd@arndb.de, Joerg.Roedel@amd.com,
        linux-kernel@vger.kernel.org, stepanm@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100802090326.GA30670@n2100.arm.linux.org.uk>
References: <1280736182.1902.55.camel@pasglop>
	<20100802172941C.fujita.tomonori@lab.ntt.co.jp>
	<20100802090326.GA30670@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100802181919J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 02 Aug 2010 18:20:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 10:03:26 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Aug 02, 2010 at 05:30:26PM +0900, FUJITA Tomonori wrote:
> > ARM's iommu code (arch/plat-omap/include/plat/iommu.h) is a library to
> > simplify the IOMMU implementations. It could be useful for all the
> > iommu implementations.
> 
> ITYM OMAP's iommu code.

Yeah, I meant that we could extend it to make it useful for other
iommu implementations. At least, we could make something generic like
struct iommu_functions, I think. Then we can embed a generic iommu
structure into an iommu specific struct (like we do with inode).

The current iommu-api (include/linux/iommu.h) is just about domain and
mapping concept. We can implement it on the top of the above
infrastructure.

I'm still trying to figure out how the DMA-API can work well with
them.
