Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1CHMO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:14:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39611 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750818Ab1CHMO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:14:26 -0500
Date: Tue, 8 Mar 2011 12:13:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Peter Tyser <ptyser@xes-inc.com>, linux-kernel@vger.kernel.org,
        Alek Du <alek.du@intel.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?ISO-8859-14?B?S2xlaW5lLUv2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH v5 2/4] gpiolib: Add ability to get GPIO direction
Message-ID: <20110308121309.36792441@lxorguk.ukuu.org.uk>
In-Reply-To: <20110307070816.GC29999@angua.secretlab.ca>
References: <1299022100-14564-1-git-send-email-ptyser@xes-inc.com>
	<1299022100-14564-2-git-send-email-ptyser@xes-inc.com>
	<20110306073003.GA29325@angua.secretlab.ca>
	<1299467241.11719.145.camel@ptyser-laptop>
	<20110307070816.GC29999@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't object to a callback hook.  My objection is how it is bodged
> on to work around limitations to the direction being cached in the
> flags variable.  I want to see a solution that either depends entirely
> on the callback, or completely fixes the problems with the cached
> value by allowing the driver to update it.

Doing it all by callback might actually fix a lot of the problems because
it can handle all kinds of 'unknowns'. If the callbacks for set/get
optionally pass a char buffer as well even the /proc interface just comes
out in the wash as the device can return a string to populate the status
or to be parsed (obviously with most h/w using the default method which
is in/out)

However who then does the enforcement of gpio_foo calls if the flag is
not cached, does that end up in each driver or is there still a cache of
some form ?

Not sure updating the interface is that hard either - we've done it
before with other layers simply by starting off with

	if (foo->ops->method)
		foo->ops->method(foo, bar);
	else {
		old fixed method + glue
	}

(or by forcing foo->ops->method on init to point to a default handler,
but that breaks making ops const)

Alan
