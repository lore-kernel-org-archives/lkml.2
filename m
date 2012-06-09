Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2FIR2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 13:28:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47497 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2FIR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 13:28:19 -0400
Date: Sat, 9 Jun 2012 10:27:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 24/24] TTY: use tty_port_register_device
Message-ID: <20120609172723.GB6244@kroah.com>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
 <1338809738-18967-25-git-send-email-jslaby@suse.cz>
 <20120604180027.66a29823@pyramind.ukuu.org.uk>
 <4FD364A3.9090104@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD364A3.9090104@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2012 at 04:58:43PM +0200, Jiri Slaby wrote:
> On 06/04/2012 07:00 PM, Alan Cox wrote:
> >> In this patch we modify most of the drivers to do the latter. When the
> >> drivers use tty_register_device and we have tty_port already, we
> >> switch to tty_port_register_device. So we have the tty_struct =>
> >> tty_port link for free for those.
> > 
> > Nice solution
> 
> Seems so on the first glance... But it is racy. There is a window since
> tty_register_driver to tty_(port_)register_device where a node may be
> opened already, but tty_port won't be set up yet.
> 
> The fix is to move cdev_add from tty_register_driver to
> tty_register_device, which makes sense anyway. Any objections?
> 
> For the time being, Greg, please ignore 24/24 from these series (I see
> you haven't applied any of the patches yet.)

Ok, I'll drop 24/24.  I should get to these this upcoming week as I am
finally going to be home from all of my crazy traveling.

greg k-h
