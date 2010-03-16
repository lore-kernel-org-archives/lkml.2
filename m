Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0CPVzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:55:00 -0400
Received: from kroah.org ([198.145.64.141]:53347 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab0CPVy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:54:57 -0400
Date: Tue, 16 Mar 2010 14:46:46 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 4/5] usb-hcd,usb-console: poll hcd device to force usb
	console writes
Message-ID: <20100316214646.GB14896@kroah.com>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com> <1268773546-12457-2-git-send-email-jason.wessel@windriver.com> <1268773546-12457-3-git-send-email-jason.wessel@windriver.com> <1268773546-12457-4-git-send-email-jason.wessel@windriver.com> <1268773546-12457-5-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268773546-12457-5-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 04:05:45PM -0500, Jason Wessel wrote:
> This patch tries to solve the problem that data is lost because there
> are too many outstanding transmit urb's while trying to execute
> printk's to a console.  The same is true if you try something like
> "echo t > /proc/sysrq-trigger".
> 
> This patch takes the route of forcibly polling the hcd device to drain
> the urb queue in order to initiate the bulk write call backs.  This
> only happens if the device is a usb serial console device that sets
> the max_in_flight_urbs to a non zero value in the serial device
> structure.
> 
> A few millisecond penalty will get incurred to allow the hcd controller
> to complete a write urb, else the console data is thrown away.
> 
> The max_in_flight_urbs was reduced in the usb_debug driver because it
> is highly desired to push things out to the console in a timely
> fashion and there is no need to have a queue that large for the
> interrupt driven mode of operation when used through the tty
> interface.

Will this new interface also be the same one that the usb debugger will
need to tie into the hcd drivers?

Either way, I'd like to get Alan Stern's ack on this before accepting it.

thanks,

greg k-h
