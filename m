Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1GAHPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 03:15:09 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:50490 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755183Ab1GAHPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 03:15:08 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/SfiaXBfiDYzH53kbi+HV2
Date: Fri, 1 Jul 2011 00:15:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/10] arch/arm/mach-omap2/clock.c: add missing clk_put
Message-ID: <20110701071505.GB23145@atomide.com>
References: <1306948213-20767-9-git-send-email-julia@diku.dk>
 <alpine.DEB.2.00.1106021526220.26852@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1106021526220.26852@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [110602 14:22]:
> On Wed, 1 Jun 2011, Julia Lawall wrote:
> 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Add missing call to clk_put.
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
> Acked-by: Paul Walmsley <paul@pwsan.com>

Adding this into devel-fixes branch.

Tony
