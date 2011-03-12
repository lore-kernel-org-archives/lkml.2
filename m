Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1CLJTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 04:19:53 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:54452 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1CLJTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 04:19:48 -0500
Date: Sat, 12 Mar 2011 02:19:46 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v5 2/4] gpiolib: Add ability to get GPIO direction
Message-ID: <20110312091946.GK9347@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
 <1299022100-14564-2-git-send-email-ptyser@xes-inc.com>
 <20110306073003.GA29325@angua.secretlab.ca>
 <1299467241.11719.145.camel@ptyser-laptop>
 <20110307070816.GC29999@angua.secretlab.ca>
 <20110308121309.36792441@lxorguk.ukuu.org.uk>
 <1299711236.6057.2125.camel@petert>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299711236.6057.2125.camel@petert>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 04:53:56PM -0600, Peter Tyser wrote:
> On Tue, 2011-03-08 at 12:13 +0000, Alan Cox wrote:
> > > I don't object to a callback hook.  My objection is how it is bodged
> > > on to work around limitations to the direction being cached in the
> > > flags variable.  I want to see a solution that either depends entirely
> > > on the callback, or completely fixes the problems with the cached
> > > value by allowing the driver to update it.
> > 
> > Doing it all by callback might actually fix a lot of the problems because
> > it can handle all kinds of 'unknowns'. If the callbacks for set/get
> > optionally pass a char buffer as well even the /proc interface just comes
> > out in the wash as the device can return a string to populate the status
> > or to be parsed (obviously with most h/w using the default method which
> > is in/out)
> 
> I like the callback-only implementation also.
> 
> > However who then does the enforcement of gpio_foo calls if the flag is
> > not cached, does that end up in each driver or is there still a cache of
> > some form ?
> 
> What enforcement are you referring to?  I was envisioning no cached
> directions at the gpiolib level,  eg replace all the current references
> that check desc->flag for direction with calls to chip->get_direction().
> If a GPIO chip's hardware didn't support reading the direction of a pin
> (eg the pcf857x chip), it would have to use its own caching to maintain
> an accurate representation of its pins directions.  Is this concept in
> line with what you were picturing?

I agree.  Trash the cache in gpiolib.  Make drivers do it (or use a
stock library function if they don't have the facility).

g.
