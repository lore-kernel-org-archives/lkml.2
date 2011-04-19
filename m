Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1DSOxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:53:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43083 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751399Ab1DSOxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:53:14 -0400
Date: Tue, 19 Apr 2011 15:54:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for the Intel 82801 (ICH) GPIO pins
Message-ID: <20110419155406.1da0e7fb@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
References: <20110419145303.111aead7@endymion.delvare>
	<BANLkTinbO_p=sKtFJtjgpo4yrEVopq9vrw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not at all concerned about this.  Users *must* know what a pin is
> when they start fiddling with it.  If you ask a pin to do something
> that it cannot do, then it just isn't going to work.  There's no real
> point in trying to enforce any behaviour in the API.

Disagree 8) - errors are better than silently and undetectably failing.
That might not be an error code but ideally it would WARN() or
similar so that errors get caught and fixed and you don't instead find
out something was poking the wrong pin and worked by chance a year later.

> In this particular case, you've got a PCI device which looks to be
> going into config space to get some information about how the chip is
> layed out.  What I would do is keep your existing pci probe & remove
> hooks, but use them to create and register child basic_mmio_gpio
> platform_devices for each gpio bank.

That means more devices, weird sysfs heirarchies and lots of mess with
runtime power management in the general case.

If the basic_mmio_gpio code is properly abstracted it ought not to need
magic extra platform devices.

That aside it'll be less code to keep it separate than do all the messing
around with platform devices so it seems to be a gross overdoing of 'lets
make everything use the same code however big a hammer is needed'

If it was a platform device it might make sense, if the config was
platform config to create a device it would certainly make sense, in the
PCI case it's smaller, cleaner and saner not to add insane layers of glue
and indirection IMHO.

Alan
