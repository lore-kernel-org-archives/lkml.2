Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1CIWyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:54:45 -0500
Received: from xes-mad.com ([216.165.139.218]:3542 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1CIWyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:54:44 -0500
Subject: Re: [PATCH v5 2/4] gpiolib: Add ability to get GPIO direction
From: Peter Tyser <ptyser@xes-inc.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
In-Reply-To: <20110308121309.36792441@lxorguk.ukuu.org.uk>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
	 <1299022100-14564-2-git-send-email-ptyser@xes-inc.com>
	 <20110306073003.GA29325@angua.secretlab.ca>
	 <1299467241.11719.145.camel@ptyser-laptop>
	 <20110307070816.GC29999@angua.secretlab.ca>
	 <20110308121309.36792441@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 16:53:56 -0600
Message-ID: <1299711236.6057.2125.camel@petert>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 12:13 +0000, Alan Cox wrote:
> > I don't object to a callback hook.  My objection is how it is bodged
> > on to work around limitations to the direction being cached in the
> > flags variable.  I want to see a solution that either depends entirely
> > on the callback, or completely fixes the problems with the cached
> > value by allowing the driver to update it.
> 
> Doing it all by callback might actually fix a lot of the problems because
> it can handle all kinds of 'unknowns'. If the callbacks for set/get
> optionally pass a char buffer as well even the /proc interface just comes
> out in the wash as the device can return a string to populate the status
> or to be parsed (obviously with most h/w using the default method which
> is in/out)

I like the callback-only implementation also.

> However who then does the enforcement of gpio_foo calls if the flag is
> not cached, does that end up in each driver or is there still a cache of
> some form ?

What enforcement are you referring to?  I was envisioning no cached
directions at the gpiolib level,  eg replace all the current references
that check desc->flag for direction with calls to chip->get_direction().
If a GPIO chip's hardware didn't support reading the direction of a pin
(eg the pcf857x chip), it would have to use its own caching to maintain
an accurate representation of its pins directions.  Is this concept in
line with what you were picturing?

Best,
Peter

