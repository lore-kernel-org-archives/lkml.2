Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab0HCSus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:50:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:46056 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab0HCSuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:50:24 -0400
Date: Tue, 3 Aug 2010 11:37:55 -0700
From: Greg KH <gregkh@suse.de>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        nm127@freemail.hu, linux-kernel@vger.kernel.org, maxinbjohn@gmail.com,
        forest.bond@outpostembedded.com, vijaykumar@zilogic.com
Subject: Re: [PATCH] USB-serial dummy cable driver
Message-ID: <20100803183755.GA5281@suse.de>
References: <1280728807-20296-1-git-send-email-marek.vasut@gmail.com>
 <201008031936.39556.marek.vasut@gmail.com>
 <20100803174912.GA2190@suse.de>
 <201008032021.07504.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201008032021.07504.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 08:21:07PM +0200, Marek Vasut wrote:
> Dne Út 3. srpna 2010 19:49:12 Greg KH napsal(a):
> > On Tue, Aug 03, 2010 at 07:36:39PM +0200, Marek Vasut wrote:
> > > Dne Út 3. srpna 2010 18:38:26 Greg KH napsal(a):
> > > > On Tue, Aug 03, 2010 at 06:14:15PM +0200, Marek Vasut wrote:
> > > > > Dne Út 3. srpna 2010 00:47:18 Greg KH napsal(a):
> > > > > > On Mon, Aug 02, 2010 at 08:00:07AM +0200, Marek Vasut wrote:
> > > > > > > This driver is used to implement USB-serial like behaviour over
> > > > > > > dummy
> > > > > > > 
> > > > > > > USB cables. These are used in the following devices:
> > > > > > > 	Funsoft Serial USB driver
> > > > > > > 	Genesys Logic GL620USB USB Laplink cable
> > > > > > > 	HP4x (48/49) Serial cable
> > > > > > > 	Motorola phones
> > > > > > > 	Siemens USB-MPI Serial USB driver
> > > > > > > 	ViVOpay USB Serial Driver
> > > > > > > 	ZIO Motherboard USB driver
> > > > > > 
> > > > > > I like the idea, but not the name :)
> > > > > 
> > > > > Please don't expect miracles from me after 26 hours without sleep ;-)
> > > > > 
> > > > > > Ideally, all of these would be able to be handled by the usb-serial
> > > > > > generic driver directly.
> > > > > 
> > > > > I just noticed that one. Stupid me.
> > > > > 
> > > > > > But really, having these multiple drivers is a good thing, they
> > > > > > properly convey to the user what the device is, and it gives these
> > > > > > developers and companies a sense of ownership over the code, and
> > > > > > that matters at times.
> > > > > > 
> > > > > > So you lost the names of the devices with this patch, which isn't
> > > > > > good.
> > > > > 
> > > > > Sheesh ... that's true, but having pile of copies of the same code is
> > > > > not good either.
> > > > 
> > > > I agree, that's why I said it should be reduced.
> > > > 
> > > > > Can't we then just deprecate all these drivers and set correct udev
> > > > > rules?
> > > > 
> > > > udev can not change the name of the device in sysfs, or the name in the
> > > > kernel of the device.
> > > 
> > > That's right, but it can bind the generic driver with the hardware. And
> > > who would care about the driver name, really ? The interface just
> > > appears and that's what matters (to me and probably to users) ...
> > 
> > There are persistant device links in /dev/serial/ that might care about
> > the driver name.  We don't want to break them, right?
> 
> We can start a slow migration though. Eg. push the serial-generic as a way-to-go 
> so the distro teams can pick this change and incorporate it into their stuff.
> 
> Maybe just mark all those drivers as "DEPRECATED" and add a note there "use 
> generic-serial".

{sigh}

No, the goal is to provide a way for the generic driver to be able to
specify a "name" so that you don't have to worry about ever breaking
userspace like this.

thanks,

greg k-h
