Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab1EYNDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:03:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47656 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab1EYNDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:03:10 -0400
Date: Wed, 25 May 2011 08:57:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Haid <d.haid@gogi.tv>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110525125752.GB3467@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08370791664f069624d25c757ed101c0@admin.gogi.tv>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090201.4DDCFCDD.004D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:00:33AM +0100, Daniel Haid wrote:
> >I added it originally. The VIA chipset seems to hang on most
> >DMAs through the IOMMU, so it was disabled.
> 
> I see. Now, maybe this will not work for some reason, but
> would it be possible to somehow disable both IOMMU and SWIOTLB
> and tell all drivers only to do DMA with the lower 4GB of memory?

Only if you allow 3GB or less in the machine. So you would have to do
mem=3G as well.

The reason is that (and you can see that yourself by looking at the
E820), is that 1GB is actually _above_ the 4GB.
> 
> Unfortunately simply turning "iommu=off" does not work for me
> as the sata and pata drivers stop working.

Right, no surprise there either - they are 32-bit and can't DMA to
memory above 4GB (2^32).
