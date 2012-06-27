Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2F0L3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:29:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44126 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2F0L3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:29:43 -0400
Date: Wed, 27 Jun 2012 12:29:40 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: jonghwa3.lee@samsung.com
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] Exynos : Add support for Exynos random number
 generator
Message-ID: <20120627112940.GF4132@page>
References: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120627110703.GE4132@page>
 <4FEAECCE.3050006@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FEAECCE.3050006@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 08:21:50PM +0900, jonghwa3.lee@samsung.com wrote:
> On 2012년 06월 27일 20:07, Jamie Iles wrote:
> > On Wed, Jun 27, 2012 at 07:31:01PM +0900, Jonghwa Lee wrote:
> >> diff --git a/drivers/char/hw_random/Kconfig 
> >> b/drivers/char/hw_random/Kconfig
> >> index f45dad3..a9e3806 100644
> >> --- a/drivers/char/hw_random/Kconfig
> >> +++ b/drivers/char/hw_random/Kconfig
> >> @@ -263,3 +263,15 @@ config HW_RANDOM_PSERIES
> >>  	  module will be called pseries-rng.
> >>  
> >>  	  If unsure, say Y.
> >> +
> >> +config HW_RANDOM_EXYNOS
> >> +	tristate "EXYNOS HW random number generator support"
> >> +	depends on HW_RANDOM && ARCH_EXYNOS && HAS_IOMEM && PM_RUNTIME
> > 
> > I don't think this needs an ARCH_EXYNOS dependency does it?  I think you 
> > do need a dependency on HAVE_CLK though then it can be built for other 
> > platforms.
> > 
> This random number generator driver is only for Exynos SOC. And why
> should I add HAVE_CLK dependency since there is no relation with?

Well if you remove the ARCH_EXYNOS dependency then you should get higher 
build coverage which is a nice thing to have.

Anything using the clk API should have a dependency on HAVE_CLK as 
clk_*() doesn't have stubs for platforms that don't implement the API.

Jamie
