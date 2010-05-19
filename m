Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0ESHLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:11:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57998 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0ESHLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:11:50 -0400
Date: Wed, 19 May 2010 08:10:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: albert_herranz@yahoo.es, konrad.wilk@oracle.com,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions
	visible in the header file.
Message-ID: <20100519071057.GB22212@n2100.arm.linux.org.uk>
References: <4BEB884B.7030402@yahoo.es> <20100518123010G.fujita.tomonori@lab.ntt.co.jp> <4BF2C5C1.2020807@yahoo.es> <20100519123626P.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519123626P.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:34:18PM +0900, FUJITA Tomonori wrote:
> On Tue, 18 May 2010 18:52:17 +0200
> Albert Herranz <albert_herranz@yahoo.es> wrote:
> > Every single KB counts on the Wii. It has just 24MB of MEM1 and 64MB of MEM2 (discontiguous memory ranges).
> > I'm using 1MB for the SWIOTLB for now, but of course that can be further tweaked down.
> 
> You can decrease the swiotlb memory however you can't fix the root
> problems of swiotlb:
> 
> - it needs pre-allocated memory
> - it can't handle the out-of-pre-allocated memory situation.

That's actually the advantage of swiotlb over dmabounce.  dmabounce's
dynamic allocation results in OOMs under some IO activity patterns.
dmabounce also produces the occasional WARN_ON() from the dma coherent
allocator depending on the driver.

We really need to kill off dmabounce.
