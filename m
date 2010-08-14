Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab0HNSqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 14:46:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46956 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0HNSqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 14:46:19 -0400
Date: Sat, 14 Aug 2010 19:46:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: khc@pm.waw.pl, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: ARM: 2.6.3[45] PCI regression (IXP4xx and PXA?)
Message-ID: <20100814184605.GA1999@n2100.arm.linux.org.uk>
References: <20100811072532.GA21511@n2100.arm.linux.org.uk> <20100813152224H.fujita.tomonori@lab.ntt.co.jp> <20100813215413.GA21607@n2100.arm.linux.org.uk> <20100814181306U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100814181306U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 06:30:37PM +0900, FUJITA Tomonori wrote:
> On Fri, 13 Aug 2010 22:54:13 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> >  This means that when dmabounce comes to allocate the replacement
> > buffer, it gets a buffer which won't be accessible to the DMA
> > controller
> 
> Really? looks like dmabounce does nothing for coherent memory that
> dma_alloc_coherent() allocates.
> 
> The following very hacky patch works?

So what happens if you use a driver which uses dma_alloc_coherent()
directly?  Should the driver really be passed memory which is
inaccessible to the device because its outside the host bridge PCI
window?

No, this is clearly wrong, so this patch doesn't fix anything.  It's
a bodge, nothing more.  The real solution is to have _both_ masks
both reduced down according to the host bridge, as we used to do.

So I suggest 6fee48c is reverted so that these platforms don't regress
for -rc1.

As I said when you sent the originally patch, it _looked_ okay, but I
don't have any way to test it.  It seems from testing (which
unfortunately only seems to only happen after patches hit mainline)
that it is not okay after all.
