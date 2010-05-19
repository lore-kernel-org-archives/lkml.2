Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab0ESMUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:20:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:33458 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0ESMUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:20:10 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: geert@linux-m68k.org, herbert@gondor.hengli.com.au, davem@davemloft.net,
       penberg@cs.helsinki.fi, mpm@selenic.com, ken@codelabs.ch,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
In-Reply-To: <20100519210506U.fujita.tomonori@lab.ntt.co.jp>
References: <1274253269.6930.9325.camel@macbook.infradead.org>
	 <AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
	 <1274269236.6930.9930.camel@macbook.infradead.org>
	 <20100519210506U.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 13:19:45 +0100
Message-ID: <1274271585.6930.9983.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 21:02 +0900, FUJITA Tomonori wrote:
> On Wed, 19 May 2010 12:40:36 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Wed, 2010-05-19 at 13:32 +0200, Geert Uytterhoeven wrote:
> > > Instead of having (different) defaults in sl[aou]b, perhaps we should
> > > just remove the defaults completely, to ensure all architectures set
> > > ARCH_SLAB_MINALIGN to the correct value? 
> > 
> > What is 'correct'? The architecture sets it to the minimum value that it
> > can cope with, according to its own alignment constraints (and DMA/cache
> > constraints, in the case of ARCH_KMALLOC_MINALIGN).
> 
> IIRC, not all the architectures do that; ARCH_KMALLOC_MINALIGN doesn't
> mean "DMA-safe" alignment currently. 

Surely those architectures that have alignment constraints for DMA but
which don't set ARCH_KMALLOC_MINALIGN are just buggy -- it _does_ mean
that.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

