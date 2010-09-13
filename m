Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0IMP6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:58:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:47906 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab0IMP6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:58:04 -0400
Date: Mon, 13 Sep 2010 08:56:08 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Slaby <jslaby@suse.cz>, phil@ipom.com, stable@kernel.org,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device
 events loss
Message-ID: <20100913155608.GA27853@suse.de>
References: <4C8E3C40.50808@suse.cz>
 <Pine.LNX.4.44L0.1009131118180.1315-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1009131118180.1315-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 11:37:49AM -0400, Alan Stern wrote:
> On Mon, 13 Sep 2010, Jiri Slaby wrote:
> 
> > On 09/13/2010 04:48 PM, Alan Stern wrote:
> > > On Mon, 13 Sep 2010, Jiri Slaby wrote:
> > >> In other words, what I could do is to add some printks into
> > >> hub_port_connect_change if that's called at all. If you need some
> > >> thorough debugging printks, please send me a patch to test instead.
> > > 
> > > Hmm.  I'd prefer to explain how it's all supposed to work and let you
> > > figure out where best to look.  Or try to debug it myself.  Does this
> > > happen with other sorts of USB devices as well, or just wacom?
> > 
> > With some sort of devices (I cannot reproduce myself). It's unrelated to
> > wacom -- people with wacom were unable to even start X with this kernel.
> > If you look at the bugreport, there are several examples:
> > ID 046d:c517 Logitech, Inc. LX710 Cordless Desktop Laser defunct
> > Microsoft USB keyboard defunct x Logitech mice OK
> > 046a:0021 Cherry GmbH keyboard defunct
> > logitech wireless laptop mouse defunct
> > A$Tech wireless laptop mouse defunct
> > TypeMatrix USB 2030 (ID : 1e54:2030) defunct
> 
> Okay, I see the problem.  By moving usb_detect_quirks earlier, we end 
> up calling usb_disable_autosuspend too soon -- before the 
> pm_runtime_enable call in usb_new_device.  In 2.6.35 this doesn't 
> matter because the implementation of usb_autosuspend_device has 
> changed.
> 
> So yes, in the end it looks like the best course is to revert this
> patch from 2.6.34.stable.  This is unfortunate but I don't see any way
> around it without making changes that aren't present in the current
> kernel. For example, the pm_runtime_set_active and pm_runtime_enable
> calls could also be moved from usb_new_device into
> hub_port_connect_change.

Ok, I'll go revert that from the .34-stable tree and do a new release,
as it's not nice to have a broken tree out there.

thanks,

greg k-h
