Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1FBV0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 17:26:41 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:60388 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1FBV0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 17:26:40 -0400
Date: Thu, 2 Jun 2011 15:26:39 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Julia Lawall <julia@diku.dk>
cc: kernel-janitors@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/10] arch/arm/mach-omap2/clock.c: add missing clk_put
In-Reply-To: <1306948213-20767-9-git-send-email-julia@diku.dk>
Message-ID: <alpine.DEB.2.00.1106021526220.26852@utopia.booyaka.com>
References: <1306948213-20767-9-git-send-email-julia@diku.dk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Add missing call to clk_put.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression e1,e2;
> statement S;
> @@
> 
> e1 = clk_get@p1(...);
> ... when != e1 = e2
>     when != clk_put(e1)
>     when any
> if (...) { ... when != clk_put(e1)
>                when != if (...) { ... clk_put(e1) ... }
> * return@p3 ...;
>  } else S
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Paul Walmsley <paul@pwsan.com>


- Paul
