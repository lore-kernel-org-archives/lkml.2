Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0ELFe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 01:34:59 -0400
Received: from sh.osrg.net ([192.16.179.4]:43872 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914Ab0ELFe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 01:34:57 -0400
Date: Wed, 12 May 2010 14:28:51 +0900
To: vapier.adi@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, npiggin@suse.de, marc@tensilica.com,
       dmitry.torokhov@gmail.com, jw@emlix.com, cl@linux.com,
       penberg@cs.helsinki.fi, mpm@selenic.com, akpm@linux-foundation.org,
       os@emlix.com, Michael.Hennerich@analog.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dg@emlix.com, osw@emlix.com,
       rientjes@google.com, dbrownell@users.sourceforge.net,
       grant.likely@secretlab.ca, chris@zankel.net, Piet.Delaney@tensilica.com
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate 
	cache lines
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <AANLkTine8JmtsUo3_z6Cwdgm3LINCkJ9jL21r9eQWRm8@mail.gmail.com>
References: <20100512030350.GJ15903@laptop>
	<20100512122323J.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTine8JmtsUo3_z6Cwdgm3LINCkJ9jL21r9eQWRm8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100512142904Z.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 12 May 2010 14:28:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 00:35:45 -0400
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Tue, May 11, 2010 at 23:23, FUJITA Tomonori wrote:
> > Seems that kmalloc is not cacheline aligned on some architectures but
> > they works. Probably, we might be just lucky because in general they
> > allocate larger buffers than 64 for DMA via kmalloc and the buffers
> > are aligned on the size?
> 
> i think the magic combo is:
>  - DMA buffer is written to (receive)
>  - some driver state is in the same cacheline as the DMA buffer
>  - that driver state is used after the flush but before the DMA finishes
>  - only on arches that need software cache coherency
> 
> so i could see this not being an obvious issue for many people

Yeah, we don't hit such condition everyday. And as I said, SCSI
usually uses kmalloc'ed buffers rather than the cache size (buffers
are aligned on roundup_pow_of_two(the allocated size)). But I think
that we want to fix this issue explicitly. I guess that it would be
better to start a new thread about this issue.
