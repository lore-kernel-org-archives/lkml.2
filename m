Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2HSOfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 10:35:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39805 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab2HSOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 10:35:37 -0400
Date: Sun, 19 Aug 2012 07:35:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Ming Lei <tom.leiming@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Fengguang Wu <fengguang.wu@intel.com>, Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Message-ID: <20120819143532.GB1384@kroah.com>
References: <CACVXFVO0TYHP0=GZVo1cz_FdxXSbX-xQ8vwrwUrZ2Y0nj7yDzg@mail.gmail.com>
 <Pine.LNX.4.44L0.1208171031100.25520-100000@netrider.rowland.org>
 <20120817144253.GA12835@kroah.com>
 <CACVXFVMeUmLh=Tu3PHbgHQNX+c-z50_CoAkdJS_uCw=E3dO2dw@mail.gmail.com>
 <87a9xrmb85.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a9xrmb85.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 12:23:38PM +0200, Bjørn Mork wrote:
> Ming Lei <tom.leiming@gmail.com> writes:
> > On Fri, Aug 17, 2012 at 10:42 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> On Fri, Aug 17, 2012 at 10:38:16AM -0400, Alan Stern wrote:
> >>> On Fri, 17 Aug 2012, Ming Lei wrote:
> >>>
> >>> > But,  if HOTPLUG is not enabled, should device_add() trigger driver probe
> >>> > further after kernel init is completed?  Or even devices should be allowed
> >>> > to add into system?
> >>>
> >>> Indeed, does it make any sense to have USB support at all if HOTPLUG
> >>> isn't enabled?  Should USB select HOTPLUG?
> >>
> >> Well, a long time ago people wanted to use USB but not have HOTPLUG
> >> enabled in their systems for various (odd) embedded systems.  As it's
> >> pretty hard to even turn off HOTPLUG these days, I'd be more likely to
> >> just remove CONFIG_HOTPLUG entirely given the dynamic nature of almost
> >> all systems.
> >
> > It should make sense, otherwise all device id table should not use
> > __devinit* markings. There are lots of pci driver usage on it.
> 
> You might want to start here then:
> 
> /**
>  * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
>  * @_table: device table name
>  *
>  * This macro is used to create a struct pci_device_id array (a device table)
>  * in a generic manner.
>  */
> #define DEFINE_PCI_DEVICE_TABLE(_table) \
>         const struct pci_device_id _table[] __devinitconst
> 

That's not as big of a problem, as pci drivers are usually left as a
module, and very few people dynamically add and remove pci devices on
systems that do not have CONFIG_HOTPLUG enabled.

Not to say that it couldn't happen, just that it is rare.

And it shows again that __devinitconst just needs to be removed, I'll
work on that soon and see what happens...

greg k-h
