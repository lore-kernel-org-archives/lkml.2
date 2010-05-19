Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab0ESMc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:32:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:38491 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041Ab0ESMc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:32:27 -0400
Date: Wed, 19 May 2010 21:26:49 +0900
To: dwmw2@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, geert@linux-m68k.org,
       herbert@gondor.hengli.com.au, davem@davemloft.net,
       penberg@cs.helsinki.fi, mpm@selenic.com, ken@codelabs.ch,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1274271585.6930.9983.camel@macbook.infradead.org>
References: <1274269236.6930.9930.camel@macbook.infradead.org>
	<20100519210506U.fujita.tomonori@lab.ntt.co.jp>
	<1274271585.6930.9983.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100519212904N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 19 May 2010 21:26:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 13:19:45 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2010-05-19 at 21:02 +0900, FUJITA Tomonori wrote:
> > On Wed, 19 May 2010 12:40:36 +0100
> > David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > On Wed, 2010-05-19 at 13:32 +0200, Geert Uytterhoeven wrote:
> > > > Instead of having (different) defaults in sl[aou]b, perhaps we should
> > > > just remove the defaults completely, to ensure all architectures set
> > > > ARCH_SLAB_MINALIGN to the correct value? 
> > > 
> > > What is 'correct'? The architecture sets it to the minimum value that it
> > > can cope with, according to its own alignment constraints (and DMA/cache
> > > constraints, in the case of ARCH_KMALLOC_MINALIGN).
> > 
> > IIRC, not all the architectures do that; ARCH_KMALLOC_MINALIGN doesn't
> > mean "DMA-safe" alignment currently. 
> 
> Surely those architectures that have alignment constraints for DMA but
> which don't set ARCH_KMALLOC_MINALIGN are just buggy -- it _does_ mean
> that.

Well, I thought so but seems that there isn't such agreement:

http://kerneltrap.org/mailarchive/linux-kernel/2010/5/12/4568960

