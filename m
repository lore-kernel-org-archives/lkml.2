Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1BWW5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:57:31 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:54527 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1BWW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:57:30 -0500
Date: Wed, 23 Feb 2011 17:57:28 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Timur Tabi <timur@freescale.com>
Cc: Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How important is it that tty_write_room doesn't lie?
Message-ID: <20110223225728.GR2924@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Timur Tabi <timur@freescale.com>, Greg KH <gregkh@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4D656679.90907@freescale.com>
 <20110223202915.GB9081@suse.de>
 <4D657292.6000106@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D657292.6000106@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 02:48:18PM -0600, Timur Tabi wrote:
> Greg KH wrote:
> > I think that people don't normally hit this as the console code isn't
> > used as a tty and a console at the same time, right?
> 
> That's another thing I never understood.  It's rare for a driver to
> support both the console and tty layers.  The serial core driver
> does that, but I can't find any other examples.  I would think that
> a driver would support both interfaces, because both are needed.
> Simplistically, printk --> console, and printf --> tty.  When would
> ever want user-space support but not kernel support?

When you are supporting a large bank of modems?  A number of the
serial cards were originally created to support 32, 64, 128 serial
ports per PCI board, specifically to drive modems, in the bad old days
of modems.  :-)

And I suspect many modern serial devices are just 8250/16550A based,
so they get the console and userspace serial for free.  A large number
of the more exotic boards were created because the 16550A uart isn't
ideal if you are driving vast number of modems at the same time.

> The FIFO can vary, but it's probably at least 2KB it size.  At
> least, we hope to able to set it to that size in the field.
> Currently, we set it to 4KB.

Wow, the FIFO has gotten a lot larger than I ever remember them
getting even when people were doing 460kbps.  I'm guessing this is
because you're trying to defer interrupts for power saving reasons,
yes?  I was used to seeing FIFO sizes more in the 32-128 bytes, tops.  :-)

      	    	    	   	      - Ted
