Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1HSVTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:19:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18279 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1HSVTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:19:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6443"; a="111656859"
Date: Fri, 19 Aug 2011 14:19:02 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, David Miller <davem@davemloft.net>,
        davidb@codeaurora.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: of_iomap() matched with plan iounmap()
Message-ID: <20110819211902.GA19702@huya.qualcomm.com>
References: <20110818170226.GA16721@huya.qualcomm.com>
 <20110818.203447.462383652600224162.davem@davemloft.net>
 <201108191426.19152.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108191426.19152.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 02:26:18PM +0200, Arnd Bergmann wrote:
> On Friday 19 August 2011, David Miller wrote:
> > From: David Brown <davidb@codeaurora.org>
> > Date: Thu, 18 Aug 2011 10:02:26 -0700
> > 
> > > The SPARC target contains of_ioremap() and of_iounmap(), which various
> > > drivers use (generally inside of CONFIG_SBUS).
> > > 
> > > include/linux/of_address.h contains a definition for of_iomap(), but
> > > not corresponding unmap call.  Code using this calls the regular
> > > iounmap().
> > > 
> > > Is it safe to assume that of_iomap() will always be based on ioremap()
> > > and therefore it is safe to use iounmap(), or would it be better to
> > > define another name for drivers to use as the inverse of of_iomap().
> > > I'm not sure what to call it, since of_iounmap() is already taken by
> > > SPARC.
> > 
> > It's better to define a matching of_iounmap() interface, even if for
> > now it is exactly iounmap()
> 
> But the problem is that we need conflicting prototypes for of_iounmap.

What if we left the SPARC calls alone, and changed of_iomap() into
of_dt_iomap() and could then make of_dt_iounmap().  Or, it could just
be of_dt_map(), and of_dt_unmap().

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
