Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1BOTmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:42:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45308 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755216Ab1BOTl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:41:59 -0500
Date: Tue, 15 Feb 2011 19:41:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] gpiolib: Add ability to get GPIO pin direction
Message-ID: <20110215194132.0784282e@lxorguk.ukuu.org.uk>
In-Reply-To: <1297792151.965.10259.camel@petert>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	<1297698493.965.5475.camel@petert>
	<20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	<AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
	<20110214193502.101759d0@lxorguk.ukuu.org.uk>
	<1297726502.965.6921.camel@petert>
	<20110215114210.1f1a8470@lxorguk.ukuu.org.uk>
	<1297789548.965.10101.camel@petert>
	<20110215171915.384223b6@lxorguk.ukuu.org.uk>
	<1297792151.965.10259.camel@petert>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My understanding is that currently if some platform wants to toggle pins
> back and forth between alt_func and GPIO, it needs to handle that logic
> itself.  If platform code is handling that toggling, I'd think the GPIO

Yes - which is broken as you can't abstract it to the drivers which is
the whole point of GPIO. Anyway put that bit aside - for the get method
it's not actually important since we need an unknown state anyway and
alt_func is unknown or similar.

> > That would fix that problem and at least allow the
> > reporting side of GPIO in use for something else to be handled as a
> > platform thing even though it can't be handled properly.
> 
> I don't follow.  I don't think I'm grasping what you want for alt_func
> pins in the short term.  Do you want them to be exported to the GPIO
> sysfs filesystem and shown as "unavailable"?  If so, what advantage does
> that have over not allowing them to be exported/reserved in the first
> place?

You can see what state they are in. Otherwise you have to clone the GPIO
sysfs to expose private platform specific magic to indicate that.

Anyway first step is to allow 'Unknown' to be reported by a get_direction
method. The direction of a pin in some magic platform owned state is
defacto 'unknown'.

Not having a get_direction method doesn't help as we don't support
changing the methods on the fly (which is horrid for locking and best
kept that way) so we need a way to return input/output/beats me
