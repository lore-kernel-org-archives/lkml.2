Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0ERTeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:34:07 -0400
Received: from waste.org ([173.11.57.241]:41922 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab0ERTd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:33:59 -0400
Subject: Re: [BUG] SLOB breaks Crypto
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.hengli.com.au, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
In-Reply-To: <20100518.122512.73694279.davem@davemloft.net>
References: <1274135869.11603.473.camel@calx> <4BF24D1F.6010005@codelabs.ch>
	 <20100518102701.GA7293@gondor.apana.org.au>
	 <20100518.122512.73694279.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 14:33:55 -0500
Message-ID: <1274211235.11603.1205.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 12:25 -0700, David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Tue, 18 May 2010 20:27:01 +1000
> 
> > I think the simplest fix is to revert this changeset.
> 
> If you revert then you'll break sparc.
> 
> Sparc needs long long alignment, so it's SLOB that needs to
> change if it isn't providing at least that much alignment
> by default.

SLOB honors ARCH_KMALLOC_MINALIGN. If your arch has alignment
requirements, I recommend you set it.

-- 
Mathematics is the supreme nostalgia of our time.


