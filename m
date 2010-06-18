Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0FRXPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 19:15:34 -0400
Received: from kroah.org ([198.145.64.141]:59220 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab0FRXPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 19:15:33 -0400
Date: Fri, 18 Jun 2010 16:15:13 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de, bzolnier@gmail.com,
       roel.kluin@gmail.com, devel@driverdev.osuosl.org
Subject: Re: [PATCH] remove pointless debug printk in rt_ioctl_giwscan()
Message-ID: <20100618231513.GB17831@kroah.com>
References: <1275712909.8509.25.camel@debian-hell>
 <201006051207.40040.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006051207.40040.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 12:07:39PM +0200, Arnd Bergmann wrote:
> On Saturday 05 June 2010, Giangiacomo Mariotti wrote:
> > This debug printk is only useful if you're debugging the staging drivers
> > 2860 e 2870, but, if you're just using them, it becomes really annoying, because
> > it uselessly clobbers the kernel log. I guess this patch shouldn't really get merged,
> > but it's more like a request to remove these annoying debugging messages for normal users.
> > If I get any suggestion on how to implement this in a way acceptable to get it merged, I'll
> > be happy to create the "good" version  of the patch.
> 
> Ideally, drivers should not have their own debugging macros like this, but
> instead use the kernel's own pr_debug() and (preferrably) dev_dbg() macros,
> which are disabled by default.
> For many of these debugging outputs, it's even better to kill them entirely
> instead of converting to dev_dbg().
> Do not put the line in comments though.

I agree, just use dev_dbg() instead.

thanks,

greg k-h
