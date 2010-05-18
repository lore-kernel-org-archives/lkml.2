Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0ERXVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:21:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:60105 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0ERXVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:21:16 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: penberg@cs.helsinki.fi, mpm@selenic.com, herbert@gondor.hengli.com.au,
       ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
In-Reply-To: <20100518.142021.135951273.davem@davemloft.net>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 00:20:34 +0100
Message-ID: <1274224834.6930.8361.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 14:20 -0700, David Miller wrote:
> I think it does make sense to expect that, whatever my architecture
> defines or does not define, I can expect the allocators to provide the
> same minimum alignment guarentee.

In a sense, they do. The minimum alignment guarantee is sizeof(long).
You are guaranteed that no allocator will return memory blocks which are
aligned to anything less than that.

Some allocators may sometimes return memory blocks which are
better-aligned than that -- but that's not guaranteed behaviour. If you
_depend_ on that behaviour and it happens to vary with the phase of the
moon, that's your problem.

It would be better if the minimum alignment was exposed to generic code
though -- you're right that the CPP tests in linux/crypto.h really
shouldn't have to exist. If it wasn't for that, then the crypto problem
wouldn't have occurred.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

