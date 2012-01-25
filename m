Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2AYAHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:07:07 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35429 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369Ab2AYAHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:07:00 -0500
X-Sasl-enc: fk7BAiORy0VVdF+gJcw9Tg7VfXBrnLP2Y5lXx+tXC2kV 1327450019
Date: Tue, 24 Jan 2012 16:06:34 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Buesch <m@bues.ch>, Joerg Roedel <joerg.roedel@amd.com>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        linux-s390@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        xen-devel@lists.xensource.com,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Get rid of get_driver() and put_driver()
Message-ID: <20120125000634.GA1178@kroah.com>
References: <Pine.LNX.4.44L0.1201241158540.1200-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201241158540.1200-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:33:37PM -0500, Alan Stern wrote:
> Greg:
> 
> This patch series removes the get_driver() and put_driver() routines
> from the kernel.
> 
> Those routines don't do anything useful.  Their comments say that they
> increment and decrement the driver's reference count, just like
> get_device()/put_device() and a lot of other utility routines.  But a
> struct driver is _not_ like a struct device!  It resembles a piece of
> code more than a piece of data -- it acts as an encapsulation of a
> driver.  Incrementing its refcount doesn't have much meaning because a
> driver's lifetime isn't determined by the structure's refcount; it's
> determined by when the driver's module gets unloaded.
> 
> What really matters for a driver is whether or not it is registered.  
> Drivers expect, for example, that none of their methods will be called
> after driver_unregister() returns.  It doesn't matter if some other
> thread still holds a reference to the driver structure; that reference
> mustn't be used for accessing the driver code after unregistration.  
> get_driver() does not do any checking for this.
> 
> People may have been misled by the kerneldoc into thinking that the
> references obtained by get_driver() do somehow pin the driver structure
> in memory.  This simply isn't true; all it pins is the associated
> private structure.  Code that needs to pin a driver must do it some
> other way (probably by calling try_module_get()).
> 
> In short, these routines don't do anything useful and they can actively 
> mislead people.  Removing them won't introduce any bugs that aren't 
> already present.  There is no reason to keep them.

Very nice work, all now applied, thanks for doing this.

greg k-h
