Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab0ESMHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:07:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:48801 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab0ESMHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:07:47 -0400
Date: Wed, 19 May 2010 21:02:49 +0900
To: dwmw2@infradead.org
Cc: geert@linux-m68k.org, herbert@gondor.hengli.com.au, davem@davemloft.net,
       penberg@cs.helsinki.fi, mpm@selenic.com, ken@codelabs.ch,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1274269236.6930.9930.camel@macbook.infradead.org>
References: <1274253269.6930.9325.camel@macbook.infradead.org>
	<AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
	<1274269236.6930.9930.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100519210506U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 19 May 2010 21:02:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 12:40:36 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2010-05-19 at 13:32 +0200, Geert Uytterhoeven wrote:
> > Instead of having (different) defaults in sl[aou]b, perhaps we should
> > just remove the defaults completely, to ensure all architectures set
> > ARCH_SLAB_MINALIGN to the correct value? 
> 
> What is 'correct'? The architecture sets it to the minimum value that it
> can cope with, according to its own alignment constraints (and DMA/cache
> constraints, in the case of ARCH_KMALLOC_MINALIGN).

IIRC, not all the architectures do that; ARCH_KMALLOC_MINALIGN doesn't
mean "DMA-safe" alignment currently.
