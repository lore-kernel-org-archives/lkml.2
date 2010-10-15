Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab0JORqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:46:25 -0400
Received: from kroah.org ([198.145.64.141]:47889 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0JORqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:46:24 -0400
Date: Fri, 15 Oct 2010 10:12:17 -0700
From: Greg KH <greg@kroah.com>
To: T?nu Samuel <tonu@jes.ee>, linux-usb@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG: USB3.0 ?PD720200 complains about over-current
Message-ID: <20101015171217.GA22299@kroah.com>
References: <1286985669.4853.14.camel@x41.itrotid.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286985669.4853.14.camel@x41.itrotid.ee>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 07:01:09PM +0300, T?nu Samuel wrote:
> Hi!
> 
> I know, this is place where only Gods speak and others not. But I am
> sure there is something odd I found and someone here can take care of
> it.

For usb specific stuff like this, try using the
linux-usb@vger.kernel.org mailing list.

> In situation when nothing is connected to any USB ports Ubuntu 10.04.1
> stock kernel complains:
> spider@spider:~$ zcat /var/log/kern.log.2.gz | grep -i current | head
> Sep 29 23:30:12 spider kernel: [    9.048388] hub 8-0:1.0: over-current
> change on port 1
> Sep 29 23:30:12 spider kernel: [    9.152036] hub 8-0:1.0: over-current
> change on port 2
> Sep 29 23:30:12 spider kernel: [    9.256038] hub 8-0:1.0: over-current
> change on port 3
> Sep 29 23:30:12 spider kernel: [    9.360037] hub 8-0:1.0: over-current
> change on port 1
> Sep 29 23:30:12 spider kernel: [    9.464036] hub 8-0:1.0: over-current
> change on port 2
> Sep 29 23:30:12 spider kernel: [    9.570621] hub 8-0:1.0: over-current
> change on port 3
> Sep 29 23:30:12 spider kernel: [    9.672037] hub 8-0:1.0: over-current
> change on port 1
> Sep 29 23:30:12 spider kernel: [    9.776038] hub 8-0:1.0: over-current
> change on port 2
> Sep 29 23:30:12 spider kernel: [    9.880049] hub 8-0:1.0: over-current
> change on port 3
> Sep 29 23:30:13 spider kernel: [    9.984041] hub 8-0:1.0: over-current
> change on port 1
> spider@spider:~$ 
> 
> This runs forever and makes computer busy forever just running those
> messages. I verified same behavior exists with vanilla 2.6.35.7.
> Disabling USB3.0 in BIOS turns off problem and all USB2 ports remain to
> work. So probably this is xHCI driver who complains. I looked bit around
> in source and see it is copied from USB2 code and possibly USB3 has
> something different. I've read USB3 can supply more power, so possibly
> something here has changed.

Do you have the xhci driver loaded for the USB 3.0 controller?

> My hardware:
> 
> Motherboard ASUS M4A88T-I Deluxe
> http://www.asus.com/product.aspx?P_ID=jGAoIFEziW5sPYy7
> 
> it has USB3 chip "NEC D720200F1" on it:
> http://digi.physic.ut.ee/mw/images/d/de/20100926_digi_007.png
> 
> NEC is joined Renesas, so this is his link for datasheet etc:
> http://www2.renesas.com/usb/en/product/upd720200.html
> 
> If you propose patch, I can give him test run.

Any xhci developers have an idea?

thanks,

greg k-h
