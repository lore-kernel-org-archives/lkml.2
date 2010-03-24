Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0CXQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:51:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab0CXQv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:51:56 -0400
Date: Wed, 24 Mar 2010 09:52:22 -0700
From: Greg KH <gregkh@suse.de>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Marcel Holtmann <marcel@holtmann.org>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324165222.GA9922@suse.de>
References: <20100324162616.GA9257@suse.de> <749404.60454.qm@web94909.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <749404.60454.qm@web94909.mail.in2.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:05:19PM +0530, Pavan Savoy wrote:
> --- On Wed, 24/3/10, Greg KH <gregkh@suse.de> wrote:
> 
> > From: Greg KH <gregkh@suse.de>
> > Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> > To: "Marcel Holtmann" <marcel@holtmann.org>
> > Cc: "Pavan Savoy" <pavan_savoy@yahoo.co.in>, "PavanSavoy" <pavan_savoy@ti.com>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> > Date: Wednesday, 24 March, 2010, 9:56 PM
> > On Wed, Mar 24, 2010 at 09:11:45AM
> > -0700, Marcel Holtmann wrote:
> > > > I wanted to somehow put this in staging because
> > then it would probably have a thorough architectural review
> > process.
> > > > Some details about this driver - 
> > > > 
> > > > 1. This driver will be used by
> > Bluetooth-BlueZ/FM-V4L2 and GPS (probably character device
> > driver) using the EXPORTED symbols (-register/_unregister).
> > > > 
> > > > 2. Much like the hciattach daemon which maintains
> > N_HCI bluetooth line discipline, this driver will also have
> > a User-Space? N_TI_WL Init manager (UIM) maintaining
> > the Line discipline.
> > > 
> > > can you explain why you think this is needed and we
> > can not interface
> > > this directly. If it is a serial port, what protocol
> > does it talk?
> > > 
> > > > 3. Because of the UIM should know when to
> > install/uninstall line discipline, the /sys entry is created
> > a root called UIM (a new kobject) and UIM daemon would write
> > it's PID to it.
> > > 
> > > I don't understand this. This sounds like a broken
> > concept to me.
> > 
> > I also agree, those sysfs files are not acceptable, and
> > will not work
> > as-designed due to the pid namespace issues :(
> 
> Ok, How do I then from kernel space, ask a user-space daemon to open the TTY port and do a tiocsetd on it ? 
> [i.e ask for a line discipline to be installed ?]

What would cause the kernel to want to tell userspace to do this?  Is it
an external event that happens somehow that userspace should know to
look for?

> Can't open the TTY and TIOCSETD upon boot, because BT, FM and GPS
> might be used or not used anytime.

What causes them to want to be used?  The user, right?

> And the idea of creating a device node, specifically for this and then
> doing an fasync/SIGIO was somehow rubbished.

Why?

thanks,

greg k-h
