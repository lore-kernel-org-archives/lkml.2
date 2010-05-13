Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab0EMBWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:22:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:49434 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758493Ab0EMBW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:22:27 -0400
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Saeed Bishara <saeed@marvell.com>, Nicolas Pitre <nico@marvell.com>,
       Jamie Lokier <jamie@shareable.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1273707708.15428.4.camel@mulgrave.site>
References: <1273569821.21352.19.camel@pasglop>
	 <1273575478.21352.29.camel@pasglop>
	 <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
	 <20100512222154.GA6841@shareable.org> <1273704431.21352.136.camel@pasglop>
	 <1273707708.15428.4.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 10:18:10 +1000
Message-ID: <1273709890.21352.141.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 18:41 -0500, James Bottomley wrote:
> > Which means that for coherent architectures that do not implement
> > the ops->sync_* hooks, we are probably missing a barrier here... 
> > 
> > Thus if the above is expected to be a memory barrier, it's broken on
> > cache coherent powerpc for example. On non-coherent powerpc, we do
> cache
> > flushes and those are implicit barriers.
> 
> Can you explain this a little more.  On a cache coherent machine, the
> sync is a nop ... why would you want a nop to be any type of barrier?

Well if the driver can peek at the data after the sync, and have any
kind of ordering guarantee that it doesn't get stale data (the load
isn't prefetched or speculated early), that would require an mb() or at
least rmb().

It would seem sensible for drivers to assume that something like
dma_cache_sync_for_cpu() thus has the semantics of an rmb() at least,
no ?

Cheers,
Ben.


