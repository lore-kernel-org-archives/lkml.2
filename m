Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0HSPWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:22:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:45372 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0HSPWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:22:12 -0400
Date: Thu, 19 Aug 2010 08:22:14 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        alan@linux.intel.com, margie.foster@intel.com,
        Morinaga <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100819152214.GD2562@suse.de>
References: <4C6BA385.80409@dsn.okisemi.com> <20100818131401.GA5861@suse.de> <000601cb3f99$8f5a0a20$66f8800a@maildom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601cb3f99$8f5a0a20$66f8800a@maildom.okisemi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 09:25:03PM +0900, Masayuki Ohtake wrote:
> Please find <MASA>

If someone takes the time to review your code and ask questions, it is
considered common courtesy to at least answer them all and not ignore
some of them.  Please do so.

> > >  drivers/misc/Kconfig    |    9 +
> > >  drivers/misc/Makefile   |    1 +
> > >  drivers/misc/pch_phub.c |  722 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 732 insertions(+), 0 deletions(-)
> > >  create mode 100755 drivers/misc/pch_phub.c
> >
> > You forgot to add documentation for your sysfs files in
> > Documentation/ABI/ which is a requiremend when you add new ones.
> 
> <MASA>
> Which folder should we put stable/ or testing/ ?

Which do you feel it should be in?

> > > +};
> > > +
> > > +/* SROM SPEC for MAC address assignment offset */
> > > +static const int pch_phub_mac_offset[ETH_ALEN] = {0x3, 0x2, 0x1, 0x0, 0xb, 0xa};
> > > +
> > > +static DEFINE_MUTEX(pch_phub_mutex);
> > > +static struct pch_phub_reg pch_phub_reg;
> >
> > So you can only have one of these devices in a system at the same time?
> > What happens when a machine ships with two of them?
> 
> <MASA>
> I can't understand the above questioin meaning.
> Give me more information, please.
> What's does the above "these devices" mean?

The device the driver is controlling.  What happens when this driver
runs on a system that has 2 of these devices?  You need to be able to
handle multiple devices, and that doesn't happen with a single variable,
right?  Please dynamically allocate it and make the lock associated to
the actual device, not the whole driver, if possible.

thanks,

greg k-h
