Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1E3JxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:53:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:47087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab1E3JxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:53:04 -0400
Date: Mon, 30 May 2011 17:46:34 +0800
From: Greg KH <gregkh@suse.de>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: "'Alan Cox'" <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH] 8250_pci: add -ENODEV code for Intel EG20T PCH
Message-ID: <20110530094634.GA8815@suse.de>
References: <1306741324-4562-1-git-send-email-tomoya-linux@dsn.okisemi.com>
 <20110530074722.GA7947@suse.de>
 <346D35FD8BD841329CFDA7803DDB899E@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <346D35FD8BD841329CFDA7803DDB899E@hacdom.okisemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 05:17:19PM +0900, Tomoya MORINAGA wrote:
> On Monday, May 30, 2011 4:47 PM,  Greg KH wrote:
> 
> > Why put this with an #if around it? 
> > Why not just always not 
> > bind to this driver as we have a "correct" driver for the 
> > hardware now?
> 
> Let me clarify your saying.
> Which does your saying mean,  (1) or (2) or else?
> 
> (1)
> > +#if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
> > +		return -ENODEV;
> > +#endif
> 
> (2)
> > +	if ((dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8811) ||
> > +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8812) ||
> > +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8813) ||
> > +	   (dev->vendor == PCI_VENDOR_ID_INTEL && dev->device == 0x8814) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x8027) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x8028) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x8029) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x800C) ||
> > +	   (dev->vendor == 0x10DB && dev->device == 0x800D))
> > +		return -ENODEV;

(2)

Just don't put the #if check in the .c file at all, and always compile
in the "quirk" table.

Even better yet, use the proper quirk table structure in the driver
already to cause the driver to not be bound to these devices, that's
what it is there for, right?

thanks,

greg k-h
