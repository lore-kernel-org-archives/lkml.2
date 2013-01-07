Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3AGFiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:38:52 -0500
Received: from mail-gg0-f179.google.com ([209.85.161.179]:54716 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3AGFiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:38:50 -0500
Date: Sun, 6 Jan 2013 21:35:19 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 1/2] power_supply: Add charge control struct in power
 supply class
Message-ID: <20130107053519.GA24341@lizard.gateway.2wire.net>
References: <1354002423-24587-1-git-send-email-ramakrishna.pallala@intel.com>
 <1354002423-24587-2-git-send-email-ramakrishna.pallala@intel.com>
 <20130106025024.GC6919@lizard.sbx05280.losalca.wayport.net>
 <D854C92F57B1B347B57E531E78D05EAD245CAF83@BGSMSX102.gar.corp.intel.com>
 <20ADAB092842284E95860F279283C564E70A93@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C564E70A93@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 05:23:36AM +0000, Tc, Jenny wrote:
> > 
> > > > +struct power_supply_charger_control {
> > > > +	const char *name;
> > > > +	/* get charging status */
> > > > +	int (*is_charging_enabled)(void);
> > > > +	int (*is_charger_enabled)(void);
> > > > +
> > > > +	/* set charging parameters */
> > > > +	int (*set_in_current_limit)(int uA);
> > > > +	int (*set_charge_current)(int uA);
> > > > +	int (*set_charge_voltage)(int uV);
> > > > +
> > > > +	/* control battery charging */
> > > > +	int (*enable_charging)(void);
> > > > +	int (*disable_charging)(void);
> > > > +
> > > > +	/* control VSYS or system supply */
> > > > +	int (*turnon_charger)(void);
> > > > +	int (*turnoff_charger)(void);
> > > > +};
> > > > +
> > >
> > > I'm all for this patch, but why do you need to place it into
> > > power_supply.h and power_supply_core.c? :) I see nothing generic here,
> > > it's pure charger-manager stuff. So, place everything into charger-
> > manager.{c,h}.
> > 
> > Hi Anton,
> > 
> > The main reason for keeping this stuff in power_supply.h and
> > power_supply_core.c is to make these interfaces uniform Across multiple
> > charger frameworks and to avoid each charger framework define it's own
> > interfaces. If there is need for new callback They can add to the existing struct
> > defined above and it will available to all the frameworks. Also the work
> > required to support a new Framework will be reduced if the driver already
> > support any one of the existing frameworks.
> > 
> 
> Rama,
> 
> The similar functionalities are exposed by patch https://lkml.org/lkml/2012/10/18/219.
> As per Anton's review comments on this patch, I'll be moving the macros to power_supply.h.
> Wouldn't that be enough ?

Btw, how do these two sets relate to each other? Both seem to control
chargers in some way... But yours approach uses properties, which I like
more.

I guess you should coordinate on this?

Thanks,
Anton
