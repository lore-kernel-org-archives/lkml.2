Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1BOLhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:37:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37317 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754363Ab1BOLhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:37:21 -0500
Date: Tue, 15 Feb 2011 11:42:10 +0000
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
Message-ID: <20110215114210.1f1a8470@lxorguk.ukuu.org.uk>
In-Reply-To: <1297726502.965.6921.camel@petert>
References: <1294343654-20354-1-git-send-email-ptyser@xes-inc.com>
	<1297698493.965.5475.camel@petert>
	<20110214170812.6f54a4bb@lxorguk.ukuu.org.uk>
	<AANLkTimyD=U-+=HpXWmF2B9KjrDf8HMCZenAgW3SQgDK@mail.gmail.com>
	<20110214193502.101759d0@lxorguk.ukuu.org.uk>
	<1297726502.965.6921.camel@petert>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fails and the pin is not touched.  Seems like adding a well coded
> chip-specific request() function to drivers where necessary would
> resolve your concern about reconfiguring pins before checking ownership?

That seems sensible and it keeps the knowledge out of gpiolib.

> Also, in most cases I'd think that the BIOS/U-Boot/firmware should have
> configured the GPIO pins appropriately, which Linux should inherit in
> general.  Linux currently inherits GPIO states that were set in firmware
> when a GPIO is requested, but it doesn't properly report those values
> via sysfs - that's the only bug I'm trying to fix.

Yes - however you can't fix it unless you are prepared to admit that the
gpio has multiple states. At minimum you need to be able to report

	input/output/unknown/unavailable

if you want to generalise it. Otherwise you don't solve the problem
because you are asking a question that driver cannot answer correctly.

> Are there many cases where people need to swap a pin from GPIO to alt
> functionality, and back again in Linux?  I have never seen them used
> like that

Well I'm not surprised - you can't currently do it that way. The code
doesn't support it, instead such things are buried in arch code and
driver specific goo. I question whether it should be buried away like
that.

That's really about Grant's why do we need it comment rather than about
your bits. From the point of view of direction reporting (which I'm fully
in favour of) the only problem that matters is the fact a pin has a
minimum of four states to report. From that point of view  "unavailable"
is probably a better way to report it than alt_func as it covers all the
other "unavailable" cases that may exist and haven't yet been thought of.

Alan
