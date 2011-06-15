Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1FOVkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:40:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64321 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1FOVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:40:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6378"; a="97767849"
Date: Wed, 15 Jun 2011 14:39:58 -0700
From: Larry Bassel <lbassel@codeaurora.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Zach Pfeffer'" <zach.pfeffer@linaro.org>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Daniel Stone'" <daniels@collabora.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory
 Allocator added
Message-ID: <20110615213958.GB28032@labbmf-linux.qualcomm.com>
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
 <20110614170158.GU2419@fooishbar.org>
 <BANLkTi=cJisuP8=_YSg4h-nsjGj3zsM7sg@mail.gmail.com>
 <201106142242.25157.arnd@arndb.de>
 <000901cc2b37$4c21f030$e465d090$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000901cc2b37$4c21f030$e465d090$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jun 11 10:36, Marek Szyprowski wrote:
> Hello,
> 
> On Tuesday, June 14, 2011 10:42 PM Arnd Bergmann wrote:
> 
> > On Tuesday 14 June 2011 20:58:25 Zach Pfeffer wrote:
> > > I've seen this split bank allocation in Qualcomm and TI SoCs, with
> > > Samsung, that makes 3 major SoC vendors (I would be surprised if
> > > Nvidia didn't also need to do this) - so I think some configurable
> > > method to control allocations is necessarily. The chips can't do
> > > decode without it (and by can't do I mean 1080P and higher decode is
> > > not functionally useful). Far from special, this would appear to be
> > > the default.

We at Qualcomm have some platforms that have memory of different
performance characteristics, some drivers will need a way of
specifying that they need fast memory for an allocation (and would prefer
an error if it is not available rather than a fallback to slower
memory). It would also be bad if allocators who don't need fast
memory got it "accidentally", depriving those who really need it.

> > 
> > Thanks for the insight, that's a much better argument than 'something
> > may need it'. Are those all chips without an IOMMU or do we also
> > need to solve the IOMMU case with split bank allocation?
> > 
> > I think I'd still prefer to see the support for multiple regions split
> > out into one of the later patches, especially since that would defer
> > the question of how to do the initialization for this case and make
> > sure we first get a generic way.
> > 
> > You've convinced me that we need to solve the problem of allocating
> > memory from a specific bank eventually, but separating it from the
> > one at hand (contiguous allocation) should help getting the important
> > groundwork in at first.
> >
> > The possible conflict that I still see with per-bank CMA regions are:
> > 
> > * It completely destroys memory power management in cases where that
> >   is based on powering down entire memory banks.
> 
> I don't think that per-bank CMA regions destroys memory power management
> more than the global CMA pool. Please note that the contiguous buffers
> (or in general dma-buffers) right now are unmovable so they don't fit
> well into memory power management.

We also have platforms where a well-defined part of the memory
can be powered off, and other parts can't (or won't). We need a way
to steer the place allocations come from to the memory that won't be
turned off (so that CMA allocations are not an obstacle to memory
hotremove).

> 
> Best regards
> -- 
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 
> 
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig

Larry Bassel

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
