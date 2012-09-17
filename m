Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2IQVZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 17:25:14 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:50982 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752532Ab2IQVZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 17:25:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1858XUOwrG6VkDKH8T3j2DI
Date: Mon, 17 Sep 2012 14:25:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH 17/24] ARM: OMAP: use __iomem pointers for MMIO
Message-ID: <20120917212506.GB11762@atomide.com>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-18-git-send-email-arnd@arndb.de>
 <20120915181057.GH4521@atomide.com>
 <201209152014.37989.arnd@arndb.de>
 <20120916203850.GI4521@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120916203850.GI4521@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [120916 13:39]:
> * Arnd Bergmann <arnd@arndb.de> [120915 13:15]:
> > On Saturday 15 September 2012, Tony Lindgren wrote:
> > > With my patches, this is now all omap1 specific and
> > > moved to arch/arm/mach-omap1/include/mach/hardware.h.
> > > It's probably easiest to just update this patch on
> > > top of the hardware.h changes I've done.
> > 
> > Yes, sounds good. Do you want to send a patch for that
> > and let me drop this one then?
> 
> Yes I can pick this one and update it against one of my
> branches to avoid merge conflicts.

This applies against mach-omap1/include/mach/hardware.h
with some fuzz so no issues there.

But I think we should not apply it as these are physical
addresses, not virtual addresses for omap1.

We have IOMEM already in use for omap_read/write because of:

#define OMAP1_IO_ADDRESS(pa)	IOMEM((pa) - OMAP1_IO_OFFSET)

I think the right solution is to eventually get rid of
omap_read/write for omap1 also and replace them with ioremap
+ readl/writel.

Or am I missing something?

Regards,

Tony
