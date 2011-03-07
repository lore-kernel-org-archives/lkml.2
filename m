Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1CGCti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:49:38 -0500
Received: from xes-mad.com ([216.165.139.218]:43161 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1CGCth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:49:37 -0500
Subject: Re: [PATCH v5 1/4] gpiolib: Add "unknown" direction support
From: Peter Tyser <ptyser@xes-inc.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexander Stein <alexander.stein@systec-electronic.com>
In-Reply-To: <4D73EC49.8030809@bluewatersys.com>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
	 <20110306072505.GC7467@angua.secretlab.ca>
	 <4D73EC49.8030809@bluewatersys.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 20:48:47 -0600
Message-ID: <1299466127.11719.127.camel@ptyser-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 09:19 +1300, Ryan Mallon wrote:
> On 03/06/2011 08:25 PM, Grant Likely wrote:
> 
> > Back to sysfs:  The sysfs gpio interface is useful for many reasons,
> > but it is dangerous much in the same way that /dev/mem is dangerous.
> > It gives userspace unfettered access to gpio resources without any
> > clues about how it should be used.  I consider it bad practice to
> > depend on the gpio sysfs interface for any real system/application.
> 
> In an embedded system, where both the kernel and the userspace are
> provided by the hardware vendor, it can be completely sensible to rely
> on gpio numbers in userspace (though I would also like to see the sysfs
> interface able to use named access). There are some existing kernel
> interfaces for common gpio functions such as leds and input devices, but
> there are also many other valid uses for gpios. There are many reasons
> for the access code to be in userspace too: It may be easier to write
> and debug, depending on the setup of the device it may be easier to do
> firmware upgrades of userspace than it is for the kernel, etc.
> 
> > gpio numbers could easily change or become unavailable if a kernel
> > driver decides to use them (heck, I'd like to be rid of gpio
> > numbers entirely, but that's a separate debate). I'd much rather see
> > real device drivers be written for gpio interfaces instead of bodging
> > things together from userspace.  Since the addition of an 'unknown'
> > direction is solely for benefit of the sysfs interface, I don't (yet)
> > see a valid argument for adding it.  *Who cares* if sysfs might report
> > direction as 'input' inaccurately?
> 
> Because it is incorrect? It may also be useful for a userspace debug
> tool to request all available gpios and show the current direction and
> value of them.
> 
> > It may be mildly inconvenient to a
> > human reader, but it doesn't change the usage model one iota because
> > the direction still must be explicitly set before using the gpio.
> 
> I agree that the usage model should be to request and then explicitly
> set the direction before use, but that isn't really an argument for
> exporting incorrect information to userspace. The ABI should attempt to
> prevent abuse of itself so that crappy userspace apps cannot be written.
> Either exporting the direction as "unknown" or making the direction file
> unreadable and the value file unreadable/unwritable until the direction
> has been explicitly set?
> 
> > So, I'm going to say no to this patch.
> 
> The patch is small (it adds 9 lines) and fixes an incorrect value being
> exported to userspace. By your argument we should actually remove the
> ability to read the direction file in sysfs, since userspace must
> explicitly set it, and therefore knows what the direction is?

+1 to all Ryan's points.  I hope this patch, or something like it, will
be accepted.

On a related note, I just noticed I need to update
Documentation/gpio.txt to document the 'unknown' direction, if this
patch is accepted.  I'll resubmit after waiting for feedback.

Best,
Peter

