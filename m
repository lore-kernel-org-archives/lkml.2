Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2B1PxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 10:53:25 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:59218 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751078Ab2B1PxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 10:53:23 -0500
Message-ID: <1330444410.8460.160.camel@deadeye>
Subject: Re: [PATCH v2] ARM: LPC32xx: Ethernet driver
From: Ben Hutchings <bhutchings@solarflare.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Roland Stigge <stigge@antcom.de>, David Laight <David.Laight@aculab.com>,
        <baruch@tkos.co.il>, <alexander.h.duyck@intel.com>,
        <ian.campbell@citrix.com>, <netdev@vger.kernel.org>,
        <eilong@broadcom.com>, Kevin Wells <kevin.wells@nxp.com>,
        Wolfram Sang <w.sang@pengutronix.de>, <jeffrey.t.kirsher@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Tue, 28 Feb 2012 15:53:30 +0000
In-Reply-To: <201202281341.01690.arnd@arndb.de>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E83@saturn3.aculab.com>
	 <4F4CD781.2090802@antcom.de> <201202281341.01690.arnd@arndb.de>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18740.005
X-TM-AS-Result: No--22.177500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 13:41 +0000, Arnd Bergmann wrote:
> On Tuesday 28 February 2012, Roland Stigge wrote:
> > Yes, that's why we previously had a cmdline param for it (but removed it
> > upon request from the netdev maintainer).
> > 
> > So if the hardware defaults to 00:00:00:00:00:00, what is the
> > "consistent policy we want to enforce in all drivers"?
> > 
> > A link or hint would be sufficient.
> 
> I think the most common strategy for platform drivers these days is
> 
> 1. use what the hardware provides
> 2. call of_get_mac_address(dev->of_node, ...)
> 3. use random_ether_addr

The 3rd option should now be eth_hw_addr_random().

Ben.

> in that order. of_get_mac_address just returns NULL when there
> is no device tree or no local-mac-address property, so you can
> put it into the driver right away.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

