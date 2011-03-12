Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab1CLQAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 11:00:12 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41715 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753892Ab1CLQAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 11:00:10 -0500
Date: Sat, 12 Mar 2011 11:00:08 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: andy.green@linaro.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <20110311214406.GA29582@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1103121052430.25742-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Greg KH wrote:

> > Alright: is there a better invariant nomenclature to talk about "the
> > gadget / host that is running on a particular pair of pins"?  That's
> > the ultimate definition of what's wired to what.
> 
> For USB, there is no such thing, sorry.  You can see the "device
> connected to the 3rd port of the second hub" but that's a mess and those
> numbers can (and do) change randomly at boot time.

The situation isn't quite that bad.

For gadgets this issue doesn't really arise.  Until very recently it 
wasn't possible to have more that one gadget driver loaded at any time 
(in fact, it still may not be possible -- I don't recall whether the 
changes have been merged yet).  In any case, gadget drivers are usually 
build as modules, so any necessary information could be passed as a 
module parameter.

For USB devices, the topology path below the root hub _is_ fixed.  If
you know that a particular device is hardwired to port 2 of a
particular root hub, that's not going to change.  The problem is how to
identify the root hub.

This depends on the platform.  On PCs, USB host controllers are usually 
PCI devices.  The only way to identify them is by the PCI device name.  
Although these names don't change often, they _can_ change.  On an 
embedded system there usually are only a couple of host controllers and 
they have more or less fixed names.

Alan Stern

