Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab1D1Mpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 08:45:44 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:57769 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab1D1Mpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 08:45:43 -0400
Subject: Re: [PATCH 2.6.38.4] mii: add support of pause frames in mii_get_an
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: artpol <artpol84@gmail.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
In-Reply-To: <20110427214902.0826a4d1@nehalam>
References: <1303962554.15395.1.camel@artpol-thinkpad>
	 <20110427214902.0826a4d1@nehalam>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Thu, 28 Apr 2011 13:45:38 +0100
Message-ID: <1303994738.3032.455.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2011 12:45:41.0994 (UTC) FILETIME=[2F1974A0:01CC05A2]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18102.003
X-TM-AS-Result: No--17.831100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 21:49 -0700, Stephen Hemminger wrote:
> On Thu, 28 Apr 2011 10:49:14 +0700
> artpol <artpol84@gmail.com> wrote:
> 
> > Add support of pause frames advertise in mii_get_an. This provides all drivers 
> > that use mii_ethtool_gset to represent their own and Link partner flow control
> > abilities in ethtool.
> > 
> > Signed-off-by: Artem Polyakov <artpol84@gmail.com>
> > 
> > ---
> > 
> > --- linux-2.6.38.4/drivers/net/mii.c.orig	2011-04-28 08:46:13.000000000 +0700
> > +++ linux-2.6.38.4/drivers/net/mii.c	2011-04-25 23:04:20.694981968 +0700
> > @@ -49,6 +49,10 @@ static u32 mii_get_an(struct mii_if_info
> >  		result |= ADVERTISED_100baseT_Half;
> >  	if (advert & ADVERTISE_100FULL)
> >  		result |= ADVERTISED_100baseT_Full;
> > +	if (advert & ADVERTISE_PAUSE_CAP)
> > +		result |= ADVERTISED_Pause;
> > +	if (advert & ADVERTISE_PAUSE_ASYM)
> > +		result |= ADVERTISED_Asym_Pause;
> >  
> >  	return result;
> >  }
> 
> One common driver problem is that auto negotiation of pause
> is really a separate operation from negotiation of speed.
> It should be possible to force no flow-control but still negotiate
> speed and vice-versa.

If you want to force flow control then turn off pause autoneg.
If you want to force speed then turn off advertising of other speeds.

> The ethtool api breaks this into two operations
> but many drivers munge them together.

There is some interaction between set_pauseparam and set_settings if
pause autoneg is enabled, which is why we have the
mii_advertise_flowctrl() function.

Anyway, this patch covers reporting only.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

