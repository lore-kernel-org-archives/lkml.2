Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab0DWPFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:05:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:33161 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab0DWPE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:04:57 -0400
Date: Fri, 23 Apr 2010 08:03:55 -0700
From: Greg KH <gregkh@suse.de>
To: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add usb_add_bus() function for usb bus list
Message-ID: <20100423150355.GA7648@suse.de>
References: <4BD13409.5040003@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD13409.5040003@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 02:45:45PM +0900, Tomohiro Kusumi wrote:
> Hi,
> 
> This patch makes usbcore driver sort usb bus on the usb_bus_list by busnum when
> registering a new bus instance.

No one should care about this.

> In current implementation a new bus instance is simply added in front of existing busses.
> Although there is nothing wrong with it in kernel code, reloading HCD may break bus order
> of /proc/bus/usb/devices as it makes usbcore re-register the bus to the list as shown in
> the example below. and it doesn't look good or it may confuse some users.

How does it confuse anyone?  (also note that /proc/bus/usb/devices is
not used in modern distros, it's in a different location now.)

Why not fix your tools to report things in the correct order if you
really care about it?  The bus number means nothing except a unique id,
it does not matter if things are sorted or not in the debug file.

Actually, in the lsusb-rewrite I am doing, the userspace tool does the
sorting, no need to change the kernel.

So, sorry, I'm not going to accept this change.

greg k-h
