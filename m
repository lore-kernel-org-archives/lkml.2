Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1FHNBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:01:40 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:59961 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab1FHNBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:01:39 -0400
Date: Wed, 8 Jun 2011 21:01:15 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/10] drivers/char/hw_random/nomadik-rng.c: add missing
	clk_put
Message-ID: <20110608130115.GB4582@gondor.apana.org.au>
References: <1306948213-20767-6-git-send-email-julia@diku.dk> <1306948846.4204.573.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306948846.4204.573.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 12:20:46PM -0500, Matt Mackall wrote:
> On Wed, 2011-06-01 at 19:10 +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Jump to the end of the function for the clk_disable and clk_put rather than
> > returning directly.
> > 
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @r exists@
> > expression e1,e2;
> > statement S;
> > @@
> > 
> > e1 = clk_get@p1(...);
> > ... when != e1 = e2
> >     when != clk_put(e1)
> >     when any
> > if (...) { ... when != clk_put(e1)
> >                when != if (...) { ... clk_put(e1) ... }
> > * return@p3 ...;
> >  } else S
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> This one also looks good to me.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
