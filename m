Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab0K3D1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:27:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:33771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab0K3D1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:27:51 -0500
Date: Mon, 29 Nov 2010 19:26:25 -0800
From: Greg KH <gregkh@suse.de>
To: Benjamin Poirier <benjamin.poirier@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Johan Hovold <jhovold@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>,
        Daniel Sangorrin <daniel.sangorrin@gmail.com>,
        linux-usb@vger.kernel.org
Subject: Re: BUG, regression. usb-serial adapter broken by PM?
Message-ID: <20101130032625.GB12851@suse.de>
References: <4CF458CE.2050603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF458CE.2050603@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 08:52:14PM -0500, Benjamin Poirier wrote:
> Hello,
> 
> Recently, my usb-serial converter has become unusable. Attempts to open
> the device always fail with:
> open("/dev/ttyUSB0", O_RDONLY)          = -1 EAGAIN (Resource temporarily unavailable)
> 
> The device is a:
> ID 0c52:2101 Sealevel Systems, Inc. Serial Converter
> and uses the ftdi_sio driver.
> 
> I've bisected this problem to
> commit 1bfee5bc86fdaecc912e06080583eddab7263df2
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Sat Sep 25 23:35:00 2010 +0200
> 
>     PM / Runtime: Merge synchronous and async runtime routines
> 
> I have other usb-serial converters that use other drivers and that are
> unaffected. I have noticed the problem on a x86_64 machine (.config
> here: http://pastebin.ca/2006414) and can reproduce it in kvm (with usb
> passthrough, .config here: http://pastebin.ca/2006416).
> 
> I'll be glad to provide more info or try patches.

A patch to resolve this was sent to linux-usb@vger.kernel.org yesterday,
can you try that one out (sorry, can't dig it out at the moment...)

thanks,

greg k-h
