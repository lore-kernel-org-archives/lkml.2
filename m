Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1LaPdR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 10:33:17 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39126 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753130Ab1LaPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 10:33:13 -0500
Date: Sat, 31 Dec 2011 10:33:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
In-Reply-To: <20111231004015.GA23226@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1112311028270.22327-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Dec 2011, Matthew Garrett wrote:

> On Fri, Dec 30, 2011 at 04:22:06PM -0800, Linus Torvalds wrote:
> 
> > It's isight_firmware_load(), in the isight_firmware driver. The driver
> > doesn't actually do anything but load the firmware, and is apparently
> > not very good at that either.
> > 
> > It should either fake a disconnect and reconnect of the device (and
> > let the reconnect then load the firmware through udev or something) or
> > it should just save the firmware image in memory from the original
> > load, and make the resume just re-initialize it - not load it.
> 
> Mm. My recollection is that these devices retained their firmware over 
> suspend/resume, so wouldn't resume with a USB id that matched the driver 
> and so this code shouldn't be called. It seems that either I was 
> horribly wrong about that, or something's changed in the USB layer 
> that's resulting in them resetting themselves. Newer devices don't 
> require this, so I'll need to try to chase up some older hardware to 
> figure out what's going on.

Nothing has changed in the USB layer -- it has always been true that
devices could be reset during a suspend/resume cycle.  This isn't a
matter of how the stack is written or anything like that; some
motherboards simply do not provide suspend power to their USB
controllers.  Or the firmware reinitializes the controllers and
attached devices during resume, forcing Linux's USB core to reset
every device on the affected buses.

When it comes to suspend/resume, there are almost no guarantees.  :-(

Alan Stern

