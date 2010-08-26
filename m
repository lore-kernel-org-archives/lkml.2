Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0HZRtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 13:49:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49277 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0HZRtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 13:49:43 -0400
Date: Thu, 26 Aug 2010 18:49:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: g.liakhovetski@gmx.de, mitov@issp.bas.bg, linux-sh@vger.kernel.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        u.kleine-koenig@pengutronix.de, jkrzyszt@tis.icnet.pl,
        philippe.retornaz@epfl.ch, akpm@linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC][PATCH] add
	dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Message-ID: <20100826174909.GA13224@n2100.arm.linux.org.uk>
References: <Pine.LNX.4.64.1008261100150.14167@axis700.grange> <20100826182915S.fujita.tomonori@lab.ntt.co.jp> <Pine.LNX.4.64.1008261140390.14167@axis700.grange> <20100826185102I.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100826185102I.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 06:51:48PM +0900, FUJITA Tomonori wrote:
> On Thu, 26 Aug 2010 11:45:58 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Thu, 26 Aug 2010, FUJITA Tomonori wrote:
> > 
> > > Why can't you revert a commit that causes the regression?
> > 
> > See this reply, and the complete thread too.
> > 
> > http://marc.info/?l=linux-sh&m=128130485208262&w=2
> > 
> > > The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> > > responsible for the regression. And the patchset even exnteds the
> > > definition of the DMA API (dma_declare_coherent_memory). Such change
> > > shouldn't applied after rc1. I think that DMA-API.txt says that
> > > dma_declare_coherent_memory() handles coherent memory for a particular
> > > device. It's not for the API that reserves coherent memory that can be
> > > used for any device for a single device.
> > 
> > Anyway, we need a way to fix the regression.
> 
> Needs to find a different way.

No.  ioremap on memory mapped by the kernel is just plain not permitted
with ARMv6 and ARMv7 architectures.

It's not something you can say "oh, need to find another way" because there
is _no_ software solution to having physical regions mapped multiple times
with different attributes.  It's an architectural restriction.

We can't unmap the kernel's memory mapping either, as I've already explained
several times this month - and I'm getting frustrated at having to keep
on explaining that point.

Just accept the plain fact that multiple mappings of the same physical
regions have become illegal.

What we need is another alternative other than using ioremap on memory
already mapped by the kernel - eg, by reserving a certain chunk of
memory for this purpose at boot time which his _never_ mapped by the
kernel, except via ioremap.
