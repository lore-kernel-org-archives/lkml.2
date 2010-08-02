Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0HBWwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:52:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:56587 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab0HBWwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:52:38 -0400
Date: Mon, 2 Aug 2010 15:47:18 -0700
From: Greg KH <gregkh@suse.de>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        nm127@freemail.hu, linux-kernel@vger.kernel.org, maxinbjohn@gmail.com,
        forest.bond@outpostembedded.com, vijaykumar@zilogic.com
Subject: Re: [PATCH] USB-serial dummy cable driver
Message-ID: <20100802224718.GC28821@suse.de>
References: <1280728807-20296-1-git-send-email-marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280728807-20296-1-git-send-email-marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 08:00:07AM +0200, Marek Vasut wrote:
> This driver is used to implement USB-serial like behaviour over dummy
> USB cables. These are used in the following devices:
> 	Funsoft Serial USB driver
> 	Genesys Logic GL620USB USB Laplink cable
> 	HP4x (48/49) Serial cable
> 	Motorola phones
> 	Siemens USB-MPI Serial USB driver
> 	ViVOpay USB Serial Driver
> 	ZIO Motherboard USB driver

I like the idea, but not the name :)

Ideally, all of these would be able to be handled by the usb-serial
generic driver directly.

But really, having these multiple drivers is a good thing, they properly
convey to the user what the device is, and it gives these developers and
companies a sense of ownership over the code, and that matters at times.

So you lost the names of the devices with this patch, which isn't good.

It's my end-goal to move the usb-serial layer to be more like libata,
where it is dirt-simple to make a new disk driver, only a few fields to
fill in, what you want to override.  So, any work toward simplification
of the generic layer would be appreciated to make these individual
drivers even smaller in the end.

So don't delete them, but try to consolidate the code, or just make it
so that it can be deleted, and you only need a simple module init/exit
function that registeres a single structure, like libata.

Sound reasonable?

thanks,

greg k-h
