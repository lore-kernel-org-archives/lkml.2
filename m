Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab1FAWW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:22:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39442 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1FAWW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:22:27 -0400
Date: Thu, 2 Jun 2011 00:22:26 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Haid <d.haid@gogi.tv>
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, airlied@linux.ie,
        alexdeucher@gmail.com
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110601222226.GH27166@one.firstfloor.org>
References: <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv> <20110531134519.GC14641@dumpdata.com> <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv> <20110531160221.GA31659@dumpdata.com> <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv> <20110531190412.GA21245@dumpdata.com> <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv> <20110601132444.GA4081@dumpdata.com> <21491fcfb013e21177140326efc0ee66@admin.gogi.tv> <34fa3fe7780241e452b268fd5ecfdee9@admin.gogi.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34fa3fe7780241e452b268fd5ecfdee9@admin.gogi.tv>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 10:58:08PM +0100, Daniel Haid wrote:
> I have also found out the following. In
> 
> line 741 of drivers/gpu/drm/radeon/radeon_device.c
> 
> there is a comment "PCIE - can handle 40-bits." -
> I have a PCIE card - and then need_dma32 is not set.
> 
> So if I read it correctly the ttm allocation
> routines will allocate memory over 4GB.
> 
> But if PCIE can handle 40 bits, why does swiotlb
> give out a bounce buffer to the radeon driver at all?

swiotlb only does what the driver tells it

Also new drivers default to 4GB, so if a driver wants
something else it has to set it explicitely.

Also BTW the driver should work in any case, so likely
something else is wrong.

Really you need to discuss this with the radeon driver people.
Readded cc.



-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
