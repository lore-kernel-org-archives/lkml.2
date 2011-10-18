Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab1JROrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:47:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab1JROrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:47:05 -0400
Date: Tue, 18 Oct 2011 07:44:16 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        jamie@jamieiles.com, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Message-ID: <20111018144416.GD19561@suse.de>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
 <2152965.Ns7xt0yLIG@wuerfel>
 <20111017182542.GB14416@suse.de>
 <201110181600.03834.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201110181600.03834.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 04:00:03PM +0200, Arnd Bergmann wrote:
> On Monday 17 October 2011, Greg KH wrote:
> > > You also commented that the argument to soc_device_unregister should
> > > be a soc_device (as, consequently, the return type of soc_device_register).
> > > Agree with that comment, but it means that the definition of struct
> > > soc_device needs to remain visible in order to be used as the parent
> > > for other devices.
> > 
> > No it doesn't:
> >         struct device * soc_device_to_device(struct soc device *soc);
> 
> Right, that works of course. I believe the more common way is to
> expose the derived type to its users, and it also simplifies the
> interface.
> 
> > Anyway, what are you using this soc device to be the parent of?
> 
> Basically everything. The SoC is probably about 90% of the system in
> modern embedded systems. Typically, there are on-chip buses like
> AMBA or PLB that contain dozens of internal devices (interrupt
> controller, serial, dmaengine, rtc, timer, watchdog, ...) as well
> as buses (i2c, spi, mmc, usb, pci, ...) that have off-chip child
> devices. You can think of an soc device as a kind of über-MFD
> that holds all of these together.
> 
> If you remember the early discussions about this patch set, I
> specifically asked for making the soc_device be a representation
> of the whole soc with a hierarchical view of its child devices
> under it, as opposed to having an artificial device node that only
> serves to export strings along the lines of /proc/cpuinfo.
> 
> See patch 5/6 for the one that moves all platform devices that
> are part of the dbx500 soc below the soc_device.

Ah, ok, that's nicer, and makes sense.

So yes, you can leave the structure here, or use a helper function, but
either way, you shouldn't be returning a struct device * from the
register function, that doesn't make sense.

greg k-h
