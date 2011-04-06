Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1DFRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 13:16:56 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:2661 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab1DFRQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 13:16:54 -0400
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
In-Reply-To: <20110406170537.GB2757@sortiz-mobl>
References: <20110331230522.GI437@ponder.secretlab.ca>
	 <20110401112030.GA3447@sortiz-mobl> <20110401104756.2f5c6f7a@debxo>
	 <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
	 <20110401235239.GE29397@sortiz-mobl>
	 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
	 <20110404100314.GC2751@sortiz-mobl>
	 <20110405030428.GB29522@ponder.secretlab.ca>
	 <20110406152322.GA2757@sortiz-mobl> <20110406155805.GA20095@suse.de>
	 <20110406170537.GB2757@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 06 Apr 2011 18:16:49 +0100
Message-ID: <1302110209.2840.20.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2011 17:16:53.0956 (UTC) FILETIME=[6CDB5040:01CBF47E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18056.005
X-TM-AS-Result: No--23.293400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 19:05 +0200, Samuel Ortiz wrote:
> Hi Greg,
> 
> On Wed, Apr 06, 2011 at 08:58:05AM -0700, Greg KH wrote:
> > On Wed, Apr 06, 2011 at 05:23:23PM +0200, Samuel Ortiz wrote:
> > > --- a/include/linux/device.h
> > > +++ b/include/linux/device.h
> > > @@ -33,6 +33,7 @@ struct class;
> > >  struct subsys_private;
> > >  struct bus_type;
> > >  struct device_node;
> > > +struct mfd_cell;
> > >  
> > >  struct bus_attribute {
> > >  	struct attribute	attr;
> > > @@ -444,6 +445,8 @@ struct device {
> > >  	struct device_node	*of_node; /* associated device tree node */
> > >  	const struct of_device_id *of_match; /* matching of_device_id from driver */
> > >  
> > > +	struct mfd_cell	*mfd_cell; /* MFD cell pointer */
> > > +
> > 
> > What is a "MFD cell pointer" and why is it needed in struct device?
> An MFD cell is an MFD instantiated device.
> MFD (Multi Function Device) drivers instantiate platform devices. Those
> devices drivers sometimes need a platform data pointer, sometimes an MFD
> specific pointer, and sometimes both. Also, some of those drivers have been
> implemented as MFD sub drivers, while others know nothing about MFD and just
> expect a plain platform_data pointer.
> 
> We've been faced with the problem of being able to pass both MFD related data
> and a platform_data pointer to some of those drivers. Squeezing the MFD bits
> in the sub driver platform_data pointer doesn't work for drivers that know
> nothing about MFDs. It also adds an additional dependency on the MFD API to
> all MFD sub drivers. That prevents any of those drivers to eventually be used
> as plain platform device drivers.
> So, adding an MFD cell pointer to the device structure allows us to cleanly
> pass both pieces of information, while keeping all the MFD sub drivers
> independant from the MFD core if they want/can.

Why isn't an MFD the parent of its component devices?

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

