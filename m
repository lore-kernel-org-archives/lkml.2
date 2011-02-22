Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1BVOtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:49:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34763 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754287Ab1BVOtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:49:41 -0500
Date: Tue, 22 Feb 2011 14:51:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
Message-ID: <20110222145131.00860d4a@lxorguk.ukuu.org.uk>
In-Reply-To: <20110222144426.GA1232@kroah.com>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
	<20110222144426.GA1232@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Currently it's unaccelerated but still pretty snappy even compositing with
> > the frame buffer X server.
> 
> So that's all that is needed on the userspace side?  Or is there a
> driver for X that also goes along with this patch that is available
> somewhere?

That's all that is needed.

There is an open source 2D X server but it relies upon the ttm working
an ancient libdrm and some chunks of the PVR driver blob. The actual 2D
command issue code is quite simple fortunately so the challenge is the
ttm/bo stuff.


> Can I also get a TODO file for this directory that lists what needs to
> be done to move it out of the staging tree, as well as an email to
> contact for patches and questions?

Ah I forgot to stg add that ;) it does exist.. Will send an updated
version.

> 
> > --- a/drivers/staging/Makefile
> > +++ b/drivers/staging/Makefile
> > @@ -62,12 +62,13 @@ obj-$(CONFIG_SOLO6X10)		+= solo6x10/
> >  obj-$(CONFIG_TIDSPBRIDGE)	+= tidspbridge/
> >  obj-$(CONFIG_ACPI_QUICKSTART)	+= quickstart/
> >  obj-$(CONFIG_WESTBRIDGE_ASTORIA)	+= westbridge/astoria/
> > -obj-$(CONFIG_SBE_2T3E3)	+= sbe-2t3e3/
> > +obj-$(CONFIG_SBE_2T3E3)		+= sbe-2t3e3/
> >  obj-$(CONFIG_ATH6K_LEGACY)	+= ath6kl/
> >  obj-$(CONFIG_USB_ENESTORAGE)	+= keucr/
> > -obj-$(CONFIG_BCM_WIMAX)	+= bcm/
> > +obj-$(CONFIG_BCM_WIMAX)		+= bcm/
> >  obj-$(CONFIG_FT1000)		+= ft1000/
> > -obj-$(CONFIG_SND_INTEL_SST)		+= intel_sst/
> > -obj-$(CONFIG_SPEAKUP)	+= speakup/
> > +obj-$(CONFIG_SND_INTEL_SST)	+= intel_sst/
> > +obj-$(CONFIG_SPEAKUP)		+= speakup/
> >  obj-$(CONFIG_TOUCHSCREEN_CLEARPAD_TM1217)	+= cptm1217/
> >  obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
> > +obj-$(CONFIG_DRM_PSB)		+= gma500/
> 
> What's with the formatting changes to this file?

It used to be all nicely lined up and was degrading so as I was touching
the end of it I thought I'd stop the rot.


