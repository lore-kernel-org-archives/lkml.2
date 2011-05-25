Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1EYXFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:05:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47286 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1EYXFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:05:46 -0400
Date: Thu, 26 May 2011 01:05:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Haid <d.haid@gogi.tv>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about iommu on x86_64 and radeon driver.
Message-ID: <20110525230544.GA4065@one.firstfloor.org>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv> <20110523220536.GB11961@dumpdata.com> <756073831c36e0404199a4e8239bcb70@admin.gogi.tv> <m2wrhf4sw5.fsf@firstfloor.org> <08370791664f069624d25c757ed101c0@admin.gogi.tv> <20110525125752.GB3467@dumpdata.com> <ae8450396be43e94c1ea724312428d4f@admin.gogi.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae8450396be43e94c1ea724312428d4f@admin.gogi.tv>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 09:21:21PM +0100, Daniel Haid wrote:
> >Only if you allow 3GB or less in the machine. So you would have to do
> >mem=3G as well.
> >
> >The reason is that (and you can see that yourself by looking at the
> >E820), is that 1GB is actually _above_ the 4GB.
> 
> Just another question on this one:
> 
> Why can a driver not simply ask for DMA-capable memory, is this not
> what memory zones are for?

In many cases the memory gets passed into the driver.

If it's not already in the right boundaries it would need to copy through
a bounce buffer. That is what swiotlb does, if there's no IOMMU.

-Andi
