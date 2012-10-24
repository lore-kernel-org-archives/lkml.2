Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829Ab2JXNmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:42:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40991 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934681Ab2JXNmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:42:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 24 Oct 2012 15:41:41 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/1] staging: Add firewire-serial driver
Message-ID: <20121024154141.3029ad92@stein>
In-Reply-To: <20121022224505.GD24489@kroah.com>
References: <1350565015.23730.4.camel@thor>
	<20121022224505.GD24489@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 22 Greg Kroah-Hartman wrote:
> On Thu, Oct 18, 2012 at 08:56:55AM -0400, Peter Hurley wrote:
> > Please consider this serial driver for review for submission to staging.
> > The firewire-serial driver implements TTY over IEEE 1394. In its default
> > configuration, it creates 4 TTY devices and one loopback device per
> > firewire card (respectively, named fwtty<n>~fwtty<n+3> and fwloop<n>).
> > 
> > Currently, the TTY devices auto-connect to every cabled peer (the TODO
> > list includes plans for providing a sysfs interface to control virtual
> > cabling with whitelist/blacklist support per GUID).
> > 
> > Efforts are still ongoing for a companion console driver, with plans to
> > eventually add early_printk & kgdb support (via additional drivers).
> > 
> > Some issues did arise with both the TTY and Firewire subsystems which
> > are noted in the TODO file. Please review these workarounds.
> > 
> > Peter Hurley (1):
> >   staging: fwserial: Add TTY-over-Firewire serial driver
> 
> I'd like to get an Ack from Stefan here, before I'll add this to the
> staging tree.

I have not formed an opinion yet, and have not taken the time to look over
the code yet.  Personally, I am entirely unfamiliar with the application
domain of tty drivers in general and with the tty-over-"high"speed-bus
application domain in particular.  IOW, I don't know who is going to use
this for which purposes.

On the FireWire side, this driver implements an own transport protocol.
AFAIK a standardized serial-over-1394 does not exist.  This means that
interoperability of this driver will initially be limited to
Linux-to-Linux.  Devices or other operating systems which implement this
do not exist.

Apart from that aspect, the proposed fwserial driver looks to have
requirements similar to the existing IPv4-over-1394 and SBP target-mode
drivers (drivers/firewire/net.* and drivers/target/sbp/*).  This means that
(a) fw-serial motivated changes to the firewire subsystem and (b) firewire
subsystem motivated changes to fwserial could quite possibly also be
interesting for or required by those other drivers as well, meaning that
maintenance overhead should not increase much.

> >  drivers/staging/fwserial/dma_fifo.c |  310 ++++
> >  drivers/staging/fwserial/dma_fifo.h |  130 ++
> >  drivers/staging/fwserial/fwserial.c | 2885 +++++++++++++++++++++++++++++++++++
> >  drivers/staging/fwserial/fwserial.h |  355 +++++

drivers/firewire/net.c is 1721 lines, sbp_target is 2868 lines.
Why is fwserial bigger?
-- 
Stefan Richter
-=====-===-- =-=- ==---
http://arcgraph.de/sr/
