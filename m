Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab1CWJrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:47:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54314 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752338Ab1CWJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:47:17 -0400
Date: Wed, 23 Mar 2011 09:47:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: andy.green@linaro.org
Cc: andy@warmcat.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
In-Reply-To: <4D89BDE2.60907@linaro.org>
References: <4D79F068.2080009@linaro.org>
	<AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>
	<1300828125.2402.300.camel@pasglop>
	<4D8924B6.8040403@linaro.org>
	<1300842219.2402.309.camel@pasglop>
	<alpine.LFD.2.00.1103222138320.11889@xanadu.home>
	<1300850595.2402.320.camel@pasglop>
	<4D89BDE2.60907@linaro.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no udev solution for what is being done currently by the async 
> platform_data patchset with SDIO WLAN.  The patches are out there and in 
> use already.  The only reason I don't post them here as round 2 of the 
> RFC yet is because Grant wanted a couple of days and politically it's 
> expedient for me to agree to that.

Kernel policy has always been that just because some vendor has deployed
an interface doesn't mean we care one iota about it or consider it an
argument for the solution. In some cases in fact it bcomes the working
demo of why it was a bad idea.

> But there are a huge number of users of platform_data in mainline 
> already we can agree.  Are you talking about a mass conversion of those 
> to eliminating platform_data so they use your preferred token query model?

Ultimately that will probably be worth doing once we have some kind of
meaningful model. We've actually been slowly beating platform devices
into making more use of the resource data it does have when possible, and
we have various parsers between platform data and device specific
platform data structs that are horrible glue-together jobs that it would
be nice to stomp on.

> I think the first additional effort needs to start at home on that one 
> and think through Device Tree and kernel policy on interoperation with 
> existing driver implementations using platform_data.  Just being sniffy 
> about platform_data for reasons you can't back up when challenged won't 
> cut it IMO.

Much of this depends upon what the data is and what it changes. Things
like interface names for example shouldn't be kernel mangled on the whim
of random board vendors. They follow a unified behaviour *across*
platforms, which is what matters most in the bigger picture.

Other stuff is to all intents and purposes sometimes hard coded into
drivers because while they are USB drivers they are checking specific
vendor id fields and changing behaviour on them. In some cases those
vendor id fields are actually a specific hardwired device.

Alan
