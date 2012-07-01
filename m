Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751074Ab2GAUOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 16:14:48 -0400
Received: from gherkin.frus.com ([192.158.254.49]:36942 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab2GAUOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 16:14:47 -0400
Date: Sun, 1 Jul 2012 15:14:11 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Message-ID: <20120701201411.GB8603@gherkin.frus.com>
References: <20120628131651.GA14492@gherkin.frus.com> <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com> <20120629033600.GA3591@gherkin.frus.com> <20120630033519.GA4792@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120630033519.GA4792@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 11:35:19PM -0400, Greg KH wrote:
> On Thu, Jun 28, 2012 at 10:36:00PM -0500, Bob Tracy wrote:
> > On Thu, Jun 28, 2012 at 09:39:45PM +0800, Ming Lei wrote:
> > > On Thu, Jun 28, 2012 at 9:16 PM, Bob Tracy <rct@gherkin.frus.com> wrote:
> > > > With the removal of the deprecated usbfs feature in the 3.5 release
> > > > candidates, is there a way of getting USB devices working on a non-
> > > > embedded Linux system without udev (static "/dev")?
> > > 
> > > Please try to enable below options:
> > > 
> > > CONFIG_DEVTMPFS=y
> > > CONFIG_DEVTMPFS_MOUNT=y
> > > 
> > > and you need not the static dev nodes with devtmpfs.
> > 
> > It was worth a try, but it didn't help in my situation.
> 
> Why not?  What is using usbfs device nodes that can not find them in
> /dev/bus/usb/ that devtmpfs creates?

If I knew what was missing, I'd create it and be done with it.  Here's
the scenario...  Kernel built from the standard kernel.org tree.  All
drivers needed at boot time are built-in, except now there's probably
something missing on the USB side of things.  No initrd.  I'll attach my
config file on the good chance someone will spot the missing piece(s)
quickly.  Note that the DEVTMPFS options are disabled in this config,
but I'll reenable them if required.  When I said devtmpfs "didn't help,"
what I meant was, by itself relative to my current configuration, turning
on devtmpfs made no difference.

Per the syslog entries I included in my initial post on this thread, the
only difference between the pre- and post- usbfs removal cases seems to
be whatever is needed for the input subsystem to see the USB keyboard
and mouse.  I see the USB hubs and attached devices getting detected,
but whatever "glue" allows the keyboard and mouse to work isn't there,
and the input subsystem doesn't emit the expected messages at boot time.

I booted a recent Kubuntu distro on the same box and noted a few
differences as far as the /dev tree.  In particular, the modern way of
doing things has "hiddevX" directly under "/dev/usb" rather than under
"/dev/usb/hid".  There are some "by-path" and "by-id" symlinks under
"/dev/input" as well, pointing to entries in the sysfs tree.  Haven't
tried a boot yet with those differences accounted for, but plan to do
so soon.

--Bob
