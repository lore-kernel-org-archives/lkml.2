Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab1BIR04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:26:56 -0500
Received: from kroah.org ([198.145.64.141]:35541 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab1BIR0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:26:55 -0500
Date: Wed, 9 Feb 2011 09:20:37 -0800
From: Greg KH <greg@kroah.com>
To: Anoop P A <anoop.pa@gmail.com>
Cc: gregkh@suse.de, dbrownell@users.sourceforge.net, ust@denx.de,
        pkondeti@codeaurora.org, stern@rowland.harvard.edu, gadiyar@ti.com,
        alek.du@intel.com, jacob.jun.pan@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org
Subject: Re: [PATCH v3] EHCI bus glue for on-chip PMC MSP USB controller.
Message-ID: <20110209172037.GA30950@kroah.com>
References: <AANLkTimu_gzsd3NY+HDp7jV+EMtrHGZq7qNc3OedyT3C@mail.gmail.com>
 <1296127736-28208-1-git-send-email-anoop.pa@gmail.com>
 <20110204195624.GA27680@kroah.com>
 <1297260753.29250.20.camel@paanoop1-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297260753.29250.20.camel@paanoop1-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 07:42:33PM +0530, Anoop P A wrote:
> > > +#ifdef CONFIG_MSP_HAS_DUAL_USB
> > > +	gpio_direction_output(MSP_PIN_USB1_HOST_DEV, 1);
> > > +#endif
> > 
> > Please don't put #defines in .c files.
> You mean #ifdef ???

Yes, sorry.

> > > +static int ehci_msp_suspend(struct device *dev)
> > > +{
> > > +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> > > +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> > > +	unsigned long flags;
> > > +	int rc;
> > > +
> > > +	return 0;
> > > +	rc = 0;
> > > +
> > > +	if (time_before(jiffies, ehci->next_statechange))
> > > +		msleep(10);
> > 
> > Short sleep, why?
> I am not very sure. Person who originally wrote this driver is
> unreachable.Any potential issues??

Yes, suspend/resume time delays are not nice for some systems.  I would
verify that this really is necessary, and, as you are going to be the one
maintaining and responsible for the code, it would be good for you to
figure out exactly what it is doing, and why.


> > > +static int ehci_msp_resume(struct device *dev)
> > > +{
> > > +	struct usb_hcd *hcd = dev_get_drvdata(dev);
> > > +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> > > +
> > > +
> > > +	/* maybe restore FLADJ */
> > 
> > Don't you know?
> Not really :)

Heh, you should.

> > > +/* may be called without controller electrically present */
> > > +/* may be called with controller, bus, and devices active */
> > > +
> > 
> > What may be called?
> may be usb_hcd_msp_remove :)

Then put it in the comment block for that function, not above it, with
an extra space between it, that just causes confusion.

thanks,

greg k-h
