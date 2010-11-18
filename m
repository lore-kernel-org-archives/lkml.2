Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0KRCZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 21:25:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab0KRCZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 21:25:15 -0500
Date: Wed, 17 Nov 2010 18:24:34 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118022434.GA9833@suse.de>
References: <4CE44B1B.9040709@freescale.com> <20101117215147.GA26792@suse.de> <4CE452CD.3050001@freescale.com> <20101117221903.GA4066@suse.de> <4CE45A4E.70308@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE45A4E.70308@freescale.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 04:42:22PM -0600, Timur Tabi wrote:
> Greg KH wrote:
> > I think you are forgetting that your byte channel devices must be
> > "devices" in the system here, right?  There is a 'struct bus_id" for
> > your bus that these devices live on.
> 
> Do you mean "struct bus_type"?  I don't have any concept of a "bus" in my
> driver.  I didn't know I needed to create one, and I'm not sure how, either.

You need to create one as you really have a "bus" here, as you
described.

> I guess my real problem is that I'm not really sure what I should be doing.  I
> already have a plain character driver that creates devices for each byte
> channel.  First I call alloc_chrdev_region() to get a started dev_id.  Then I
> iterate over the byte channels and call device_create() for each one, with NULL
> for the parent.  At the end, I call cdev_init() and cdev_add().

Ick, no.

Please take a step back and go to your original message where you
described something like "we have a bus and devices we discover on the
bus and they have ids".  Because of that, you should just create a bus,
create the devices on the bus, and then, attach specific types of
drivers to those devices (like your tty driver.)

And your bus is automatically discoverable, right?  So you don't need
any interface for userspace to "create" devices, so you should be fine.

If it's not discoverable, go kick some firmware programmers butt and
make it so, as that is unforgivable in this age.  Seriously, that's flat
out broken and wrong, get it fixed first.

thanks,

greg k-h
