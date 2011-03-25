Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1CYXbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:31:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:37569 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab1CYXbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:31:49 -0400
Date: Fri, 25 Mar 2011 16:28:47 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        vapier@gentoo.org
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Message-ID: <20110325232847.GA5551@suse.de>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <201103252112.22520.arnd@arndb.de>
 <20110325211246.GA8741@suse.de>
 <201103252301.56718.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103252301.56718.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 11:01:56PM +0100, Arnd Bergmann wrote:
> On Friday 25 March 2011 22:12:46 Greg KH wrote:
> > > Why is this a bus? You don't have any device matching code or similar,
> > > and the devices typically are on an existing bus_type (e.g. platform_bus).
> > > I think it would make more sense to do this as a class.
> > 
> > No, for new things, we want to use busses instead of classes please.
> > Especially as this does create devices, which are best put on a bus
> > somewhere.
> 
> I don't understand. Isn't that rather inconsistent?
> 
> I realize the same thing came up with the IIO subsystem, where I also
> didn't understand it.
> 
> In my mental model of Linux drivers, a bus is something that physically
> connects devices and the bus code matches devices with drivers, while a
> class groups logical devices that get created by the driver itself.

Yes, that is how it used to be, but then it turns out that both of them
are really just "subsystems" as far as it all goes.  They are just ways
that devices are bound to drivers in a logical manner.  We have patches
floating around that get rid of both busses and classes to merge them
together, which is the end goal here.  I know Kay has posted detailed
reasons for why this all is on lkml in the past, and had working code
about 5 years ago, it's just been slow going...

So we recommend all new subsystems use the bus code, it's simple and
works well.

thanks,

greg k-h
